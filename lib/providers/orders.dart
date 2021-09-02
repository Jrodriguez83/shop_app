import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.dateTime,
    @required this.products,
  });
}

class Orders with ChangeNotifier {
  final String token;
  final String userId;
  Orders(this.token, this._orders, this.userId);
  List<OrderItem> _orders = [];

  List<OrderItem> get order {
    return [..._orders];
  }

  Future<void> fetchAndSetData() async {
    final url = 'https://shop-app-c7134.firebaseio.com/orders.json?auth=$token&orderBy="creatorId"&equalTo="$userId"';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedProducts = [];
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((orderId, orderData) {
        loadedProducts.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    title: item['title'],
                    quantity: item['quantity'],
                  ))
              .toList(),
        ));
      });
      _orders = loadedProducts;
    } catch (error) {
      throw error;
    }
  }

  Future<void> addItem(List<CartItem> cartProducts, double total) async {
    final url = 'https://shop-app-c7134.firebaseio.com/orders.json?auth=$token';
    final theTime = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': theTime.toIso8601String(),
          'creatorId': userId,
          'products': cartProducts
              .map((prod) => {
                    'id': prod.id,
                    'price': prod.price,
                    'title': prod.title,
                    'quantity': prod.quantity,
                  })
              .toList(),
        }));
    _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: theTime,
          products: cartProducts,
        ));
    notifyListeners();
  }
}
