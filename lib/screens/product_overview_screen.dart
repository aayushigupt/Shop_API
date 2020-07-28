import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/product.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/badge.dart';
import 'package:shop/widgets/products_grid.dart';
import '../Provider/Product.dart';

enum FilterOptions {
  favorites,
  all,
}

class Product_Overview_Screen extends StatefulWidget {
  @override
  _Product_Overview_ScreenState createState() =>
      _Product_Overview_ScreenState();
}

class _Product_Overview_ScreenState extends State<Product_Overview_Screen> {
  var _isInit = true;
 var _isLoading = false;
  void initState() {
    super.initState();
  }

  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      
      Provider.of<Products>(context).fetchAndGetProduct().then((_){
         setState(() {
      _isLoading = false;
    });
      });
    }
   
    
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final productContainer = Provider.of<Products>(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Shop"),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (FilterOptions selectValue) {
                if (selectValue == FilterOptions.favorites) {
                  productContainer.showFavoritesOnly();
                } else {
                  productContainer.showAll();
                }
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text("Only Favourites"),
                      value: FilterOptions.favorites,
                    ),
                    PopupMenuItem(
                      child: Text("Show All"),
                      value: FilterOptions.all,
                    ),
                  ]),
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
              child: ch,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading ? Center(child: CircularProgressIndicator(),) : ProductsGrid(),
    );
  }
}
