import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  final String token;
  final String userId;

  ProductsProvider(this.token, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Future<void> fetchAndSetData([bool filterByUser = false]) async {
    final filterString = filterByUser ?'orderBy="creatorId"&equalTo="$userId"': '';
    var url =
        'https://shop-app-c7134.firebaseio.com/products.json?auth=$token&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData == null) {
        return;
      }
      url = 'https://shop-app-c7134.firebaseio.com/userFavorites/$userId.json?auth=$token';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite: favoriteData == null ? false :favoriteData[prodId]) ?? false);
      });
      _items = loadedProducts;
    } catch (error) {
      throw error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> addProducts(Product product) async {
    final url =
        'https://shop-app-c7134.firebaseio.com/products.json?auth=$token';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId':userId
          }));
      _items.add(Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      ));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(Product product, String id) async {
    final url =
        'https://shop-app-c7134.firebaseio.com/products/$id.json?auth=$token';
    final i = _items.indexWhere((test) => test.id == id);

    if (i >= 0) {
      var update = await http.patch(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
          }));
      _items[i] = product;
      if (!update.body.contains('title')) {
        throw 'Unable to save';
      }
    }
    notifyListeners();
  }

  Future<void> removeProduct(String id) async {
    final url =
        'https://shop-app-c7134.firebaseio.com/products/$id.json?auth=$token';
    final productIndex = _items.indexWhere((test) => test.id == id);
    var existingProduct = _items[productIndex];
    _items.removeAt(productIndex);
    try {
      await http.delete(
        url,
      );
      existingProduct = null;
      notifyListeners();
    } catch (error) {
      _items.insert(productIndex, existingProduct);
      notifyListeners();
    }
  }

  Product findById(String id) {
    return _items.firstWhere((test) => test.id == id);
  }
}
