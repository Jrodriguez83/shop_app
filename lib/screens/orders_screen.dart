import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/drawer.dart';
import '../widgets/order_item.dart' as orderItem;
import '../providers/orders.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    Provider.of<Orders>(context, listen: false).fetchAndSetData().then((_) {
      setState(() {
        _isLoading = false;
      });
    }).catchError((error) {
      showDialog(
        context: context,
        builder: ((context) => AlertDialog(
          title: Text('An error has occurred'),
          content: Text(error.toString()),
        ))
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<Orders>(
              builder: ((ctx, orderData, child) {
                return RefreshIndicator(
                  onRefresh: () {
                    return orderData.fetchAndSetData();
                  },
                  child: orderData == null
                      ? Center(child: Text('There are no orders!'))
                      : ListView.builder(
                          itemBuilder: ((ctx, i) => orderItem.OrderItem(
                                order: orderData.order[i],
                              )),
                          itemCount: orderData.order.length,
                        ),
                );
              }),
            ),
    );
  }
}
