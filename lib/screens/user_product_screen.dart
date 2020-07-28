import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Provider/Product.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/user_product_item.dart';

class User_Screen extends StatelessWidget {

  Future<void> getRefresh(BuildContext context) async{
  await Provider.of<Products>(context).fetchAndGetProduct();
  }
  static const routeName = '/user-screen';
  @override
  Widget build(BuildContext context) {
    var productData = Provider.of<Products>(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh : () => getRefresh(context),
              child: Padding(
          padding: EdgeInsets.all(10.0),
          child: ListView.builder(
            itemCount: productData.items.length,
            itemBuilder: (_, i) => User_Item(
              productData.items[i].id,
              productData.items[i].title,
              productData.items[i].imageUrl,
            ),
          ),
        ),
      ),
    );
  }
}
