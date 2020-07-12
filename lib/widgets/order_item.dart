import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/Provider/orders.dart';
import 'package:intl/intl.dart';

class Order_Items extends StatefulWidget {
  final Order order;
  Order_Items(this.order);

  @override
  _Order_ItemsState createState() => _Order_ItemsState();
}

class _Order_ItemsState extends State<Order_Items> {
  @override
  Widget build(BuildContext context) {
    var _expanded = false;

    // TODO: implement build
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle:
                Text(DateFormat('dd MM hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
                icon:
                Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                ),
              
            ),
          ),
          if (!_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.order.products.length * 20.0 + 10, 180),
              child: ListView(
                children: widget.order.products
                    .map((prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              prod.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "${prod.quantity} x \$${prod.price}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ))
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
