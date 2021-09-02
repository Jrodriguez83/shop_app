import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem({this.order});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded ? min(widget.order.products.length * 20.0 + 110, 200): 75,
      child: Card(
        margin: EdgeInsets.all(0),
        elevation: 5,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('\$${widget.order.amount}'),
              subtitle: Text(DateFormat.MEd().format(widget.order.dateTime)),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: _expanded ? min(widget.order.products.length * 20.0 + 10, 100):0,
                child: ListView.builder(
                  itemCount: widget.order.products.length,
                  itemBuilder: ((ctx, i) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          widget.order.products[i].title,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${widget.order.products[i].price} x${widget.order.products[i].quantity}',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        )
                      ],
                    );
                  }),
                ),
              )
          ],
        ),
      ),
    );
  }
}
