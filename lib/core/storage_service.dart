import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const tokenKey = "auth_token";
  static const emailKey = "last_email";
  static const passwordKey = "last_password";
  static const terminalKay = "last_terminal";

  static Future<void> saveLogin({
    required String token,
    required String email,
    required String password,
    required String terminal,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(tokenKey, token);
    await prefs.setString(emailKey, email);
    await prefs.setString(passwordKey, password);
    await prefs.setString(terminalKay, terminal);
  }

  static Future<Map<String, String>> getLastLogin() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      "email": prefs.getString(emailKey) ?? "",
      "password": prefs.getString(passwordKey) ?? "",
      "terminal": prefs.getString(terminalKay) ?? "",
    };
  }

  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey) ?? "";
  }
}
