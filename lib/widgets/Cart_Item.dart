import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/product.dart';

class Cart_Item extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;
  final String imageUrl;

  Cart_Item(this.id, this.productId, this.price, this.quantity, this.title,
      this.imageUrl);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 8.0),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 8,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Are you sure?'),
                  content: Text('Do you want to remove item from the cart'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                    )
                  ],
                ));
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
            ),
            title: Text(title),
            subtitle: Text('Total :\$${price * quantity}'),
            trailing: Text("$quantity x"),
          ),
        ),
      ),
    );
  }
}
