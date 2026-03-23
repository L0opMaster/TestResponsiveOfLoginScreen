import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_responsive/core/storage_service.dart';

class AuthProvider with ChangeNotifier {
  String? _token;

  String? get token => _token;
  bool get isLoggedIn => _token != null && _token!.isNotEmpty;

  Future<void> loadToken() async {
    final savedToken = await StorageService.getToken();
    _token = savedToken.isNotEmpty ? savedToken : null;
    notifyListeners();
  }

  Future<void> setToken(String token) async {
    _token = token;
    notifyListeners();
  }

  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();

    // remove only token, keep email/password/terminal
    await prefs.remove(StorageService.tokenKey);

    _token = null;
    notifyListeners();
  }
}
