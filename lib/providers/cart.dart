import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem(
      {@required this.id,
      @required this.price,
      @required this.title,
      @required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get amountOfItems {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;

    _items.forEach((_, carItem) {
      total += carItem.price * carItem.quantity;
    });

    return total;
  }


  void addItem(
    String productId,
    double price,
    String title,
  ) {
    
    if (_items.containsKey(productId)) {
      //Update
      _items.update(
          productId,
          (cartItem) => CartItem(
                id: cartItem.id,
                price: cartItem.price,
                quantity: cartItem.quantity + 1,
                title: cartItem.title,
              ));
    } else {
      //add item
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              price: price,
              title: title,
              quantity: 1));
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if (!_items.containsKey(id)) {
      return;
    }
    if (_items[id].quantity > 1) {
      _items.update(
        id,
        ((cartItem) => CartItem(
            id: cartItem.id,
            price: cartItem.price,
            title: cartItem.title,
            quantity: cartItem.quantity - 1)),
      );
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
