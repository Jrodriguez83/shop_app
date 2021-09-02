import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/cart_items.dart';
import '../providers/orders.dart';

class CartScreen extends StatefulWidget {

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  var _isInit = false;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(!_isInit){
      

    }
    setState(() {
      _isInit = true;
    });
  }
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body:Column(
        children: <Widget>[
          Card(
            elevation: 5,
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: cart.items.length <=0? null: () {
                      setState(() {
                        _isLoading = true;
                      });
                      Provider.of<Orders>(context, listen: false)
                      .addItem(cart.items.values.toList(), cart.totalAmount).then((_){
                        setState(() {
                          _isLoading = false;
                        });
                        cart.clearCart();
                      });
                  
                    },
                    child: _isLoading ? Center(child: CircularProgressIndicator(),):Text('Order Now!'),
                    textColor: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: ((context, i) {
                return CartItems(
                  id: cart.items.values.toList()[i].id,
                  price: cart.items.values.toList()[i].price,
                  quantity: cart.items.values.toList()[i].quantity,
                  title: cart.items.values.toList()[i].title,
                  prodId: cart.items.keys.toList()[i],
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
