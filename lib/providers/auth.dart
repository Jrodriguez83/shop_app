import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expirationDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_token != null &&
        _expirationDate.isAfter(DateTime.now()) &&
        _expirationDate != null) {
      return _token;
    }

    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlBlock) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlBlock?key=AIzaSyAcANHY44JRvEhmoa_vKVNolPnw5i9nQIg';

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expirationDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      notifyListeners();
      final preferences = await SharedPreferences.getInstance();
      final encodedData = json.encode({
        'token': _token,
        'userId': _userId,
        'expirationData': _expirationDate.toIso8601String(),
      });
      preferences.setString('userData', encodedData);
    } catch (error) {
      throw error;
    }
    _autoLogout();
  }

  Future<bool> tryAutoLogin() async {
    final preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey('userData')) {
      return false;
    }
    final extractedData = json.decode(preferences.getString('userData')) as Map<String,dynamic>;
    final extractedDate = DateTime.parse(extractedData['expirationData']);

    if (extractedDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedData['token'];
    _userId = extractedData['userId'];
    _expirationDate = extractedDate;
    notifyListeners();
    return true;
    
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logOut() async{
    _userId = null;
    _token = null;
    _expirationDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expirationDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logOut);
  }
}
