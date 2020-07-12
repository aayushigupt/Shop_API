import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Provider/orders.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("YOUR ORDERS"),
      ),
      body: ListView.builder(
        itemCount: orderData.items.length,
        itemBuilder: (ctx, i) => Order_Items(orderData.items[i]),
      ),
      drawer: AppDrawer(),
    );
  }
}
