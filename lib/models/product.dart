import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  @required
  final String id;
  @required
  final String title;
  @required
  final String description;
  @required
  final double price;
  @required
  final String imageUrl;

  bool isFavourite;
  Product(
      {this.id,
      this.title,
      this.description,
      this.imageUrl,
      this.price,
      this.isFavourite = false});

  void _setFav(bool newValue) {
    isFavourite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavourite(String authToken, String userId) async {
    final oldStatus = isFavourite;
    final url = 'https://shop-api-98b4f.firebaseio.com/userFavourite/$userId/$id.json?auth=$authToken';
    isFavourite = !isFavourite;
    notifyListeners();
    try {
      var response = await http.put(url,
          body: json.encode(
             isFavourite,
          ));
      if (response.statusCode >= 400) {
        _setFav(oldStatus);
      }
    } catch (error) {
      _setFav(oldStatus);
    }
  }
}
