import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/models/http_exception.dart';
import 'package:shop/models/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'Its a red shirt, smart one',
    //   price: 25.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_960_720.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Red Skirt',
    //   description: 'Its a red skirt, pretty one',
    //   price: 50.00,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2017/08/06/08/01/people-2590092_960_720.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Jeans',
    //   description: 'Its a Jeans, ruptured one',
    //   price: 40.78,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2015/07/02/10/18/jeans-828693_960_720.jpg',
    // ),
  ];

  var _showFavoritesOnly = false;

  List<Product> get items {
    if (_showFavoritesOnly) {
      return _items.where((prodItem) => prodItem.isFavourite).toList();
    }
    return [..._items];
  }

  void showFavoritesOnly() {
    _showFavoritesOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoritesOnly = false;
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProduct(Product product) async {
    const url = 'https://shop-api-98b4f.firebaseio.com/products.json';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'isFavourite': product.isFavourite,
            'imageUrl': product.imageUrl,
            
          }));

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        isFavourite: product.isFavourite,
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchAndGetProduct() async {
    const url = 'https://shop-api-98b4f.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      print(json.decode(response.body));
      var extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<Product> loadedProduct = [];
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((prodId, prodData) {
        loadedProduct.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavourite: prodData['isFavourite'],
        ));
      });
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = 'https://shop-api-98b4f.firebaseio.com/products/$id.json';

      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          }));

      _items[prodIndex] = newProduct;
      notifyListeners();
    }
    //here the existing product will be overwritten by new product
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://shop-api-98b4f.firebaseio.com/products/$id.json';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    var response = await http.delete(url);
    print(response.statusCode);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could Not delete Product!');
    }

    existingProduct = null;

    // _items.removeWhere((prod) => prod.id == id);
  }
}
