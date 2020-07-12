import 'package:flutter/foundation.dart';

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

  void toggleFavourite() {
    isFavourite = !isFavourite;
    notifyListeners();
  }
}
