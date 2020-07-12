import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Provider/orders.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/widgets/Cart_Item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '\cart';
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15.0),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    onPressed: () {
                      Provider.of<Orders>(context).addProduct(
                          cart.items.values.toList(), cart.totalAmount);
                      cart.remove();
                    },
                    child: Text('ORDER NOW'),
                    textColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (ctx, i) => Cart_Item(
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].title,
                cart.items.values.toList()[i].imageUrl),
          )),
        ],
      ),
    );
  }
}
