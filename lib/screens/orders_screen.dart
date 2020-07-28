import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Provider/orders.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // var _isLoading = false;
  // void initState() {
  //   Future.delayed(Duration.zero).then((_) async{
  //     setState(() {
  //       _isLoading = true;
  //     });
  //   await Provider.of<Orders>(context, listen: false).fetchAndSetProduct();
  //    setState(() {
  //     _isLoading = false;
  //   });
  //   });

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("YOUR ORDERS"),
      ),
      body: FutureBuilder(
        future:
            Provider.of<Orders>(context, listen: false).fetchAndSetProduct(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (dataSnapshot.error != null) {
            return Center(
              child: Text("Oops! An error Occured"),
            );
          } else {
            return Consumer<Orders>(
              builder: (ctx, orderData, child) => ListView.builder(
                itemCount: orderData.items.length,
                itemBuilder: (ctx, i) => Order_Items(orderData.items[i]),
              ),
            );
          }
        },
      ),
      drawer: AppDrawer(),
    );
  }
}
