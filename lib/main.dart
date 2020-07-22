import 'package:flutter/material.dart';
import 'package:shop/Provider/orders.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/screens/orders_screen.dart';
import 'package:shop/screens/product_details_screen.dart';
import 'package:shop/screens/product_overview_screen.dart';
//import '../screens/product_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/user_product_screen.dart';
import './Provider/Product.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx)=> Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx)=> Orders(),
        )
      ],
    

    child: 
    MaterialApp(
        home: Product_Overview_Screen(),
        theme: ThemeData(
          primaryColor: Colors.indigo,
          fontFamily: 'Montserrat',
        ),
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          CartScreen.routeName: (context) => CartScreen(),
          OrdersScreen.routeName: (context) =>OrdersScreen(),
          User_Screen.routeName : (context) => User_Screen(),
          EditProductScreen.routeName : (context) => EditProductScreen(),
        }),
    );
  }
}
