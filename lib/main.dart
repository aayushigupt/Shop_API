import 'package:flutter/material.dart';
import 'package:shop/Provider/auth.dart';
import 'package:shop/Provider/orders.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/screens/auth_screen.dart';
import 'package:shop/screens/cart_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/product_details_screen.dart';
import './screens/product_overview_screen.dart';
//import '../screens/product_overview_screen.dart';
import 'package:provider/provider.dart';
import './screens/splashScreen.dart';
import './screens/user_product_screen.dart';
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
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, previousProduct) => Products(
              auth.token,
              auth.userId,
              previousProduct == null ? [] : previousProduct.items,
            ),
          ),
          // ChangeNotifierProvider(
          //   create: (ctx) => Products(),
          // ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, auth, orderProducts) => Orders(
              auth.token,
              auth.userId,
              orderProducts == null ? [] : orderProducts.items,
            ),
          )
          // ChangeNotifierProvider(
          //   create: (ctx) => Orders(),
          // )
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
              home: auth.isAuth
                  ? Product_Overview_Screen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, snapshot) =>
                          snapshot.connectionState == ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
              theme: ThemeData(
                primaryColor: Colors.indigo,
                fontFamily: 'Montserrat',
              ),
              routes: {
                ProductDetailScreen.routeName: (context) =>
                    ProductDetailScreen(),
                CartScreen.routeName: (context) => CartScreen(),
                OrdersScreen.routeName: (context) => OrdersScreen(),
                User_Screen.routeName: (context) => User_Screen(),
                EditProductScreen.routeName: (context) => EditProductScreen(),
              }),
        ));
  }
}
