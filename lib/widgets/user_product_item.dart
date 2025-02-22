import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Provider/Product.dart';
import 'package:shop/screens/edit_product_screen.dart';

class User_Item extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  User_Item(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    // TODO: implement build
    return ListTile(
        title: Text(title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.routeName, arguments: id);
                },
              ),
              IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).errorColor,
                  ),
                  onPressed: () async{
                    try {
                     await Provider.of<Products>(context, listen: false)
                          .deleteProduct(id);
                    } catch (error) {
                      scaffold.showSnackBar(SnackBar(
                        content: Text("Unable to delete item!!"),
                      ));
                    }
                  })
            ],
          ),
        ));
  }
}
