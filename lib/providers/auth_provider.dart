import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _username;

  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;

  bool login(String username, String password) {
    // Contoh login sederhana (biasanya diganti dengan API call)
    if (username == 'admin@ombapos.com' && password == 'password') {
      // _isLoggedIn = true;
      // _username = username;
      // notifyListeners(); // memberitahu UI bahwa data berubah
      return true;
    }
    return false;
  }

  void logout() {
    _isLoggedIn = false;
    _username = null;
    // notifyListeners();
  }
}
