import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'Its a red shirt, smart one',
      price: 25.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_960_720.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Red Skirt',
      description: 'Its a red skirt, pretty one',
      price: 50.00,
      imageUrl:
          'https://cdn.pixabay.com/photo/2017/08/06/08/01/people-2590092_960_720.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Jeans',
      description: 'Its a Jeans, ruptured one',
      price: 40.78,
      imageUrl:
          'https://cdn.pixabay.com/photo/2015/07/02/10/18/jeans-828693_960_720.jpg',
    ),
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

  void addProduct() {
    // _items.add(value);
    notifyListeners();
  }
}
