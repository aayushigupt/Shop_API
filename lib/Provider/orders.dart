import 'package:flutter/foundation.dart';
import 'package:shop/models/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop/widgets/order_item.dart';

class Order {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  Order({
    this.id,
    this.amount,
    this.products,
    this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<Order> _items = [];
  List<Order> get items {
    return [..._items];
  }

  Future<void> fetchAndSetProduct() async {
    const url = 'https://shop-api-98b4f.firebaseio.com/orders.json';
    var response = await http.get(url);
    print(json.decode(response.body));
    final List<Order> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(Order(
        id: orderId,
        amount: orderData['amount'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>)
            .map((item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ))
            .toList(),
      ));
    });
    _items = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addProduct(List<CartItem> cartProducts, double total) async {
    final url = 'https://shop-api-98b4f.firebaseio.com/orders.json';
    final timeStamp = DateTime.now();
    var response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
        }));
    _items.insert(
        0,
        Order(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            dateTime: timeStamp));
    notifyListeners();
  }
}
