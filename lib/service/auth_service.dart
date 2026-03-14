import 'dart:convert';
import '../core/storage_service.dart';
import '../util/base_url.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient apiClient = ApiClient(baseUrl: BaseUrl().baseUrl);

  Future<bool> login({
    required String email,
    required String password,
    required String terminal,
  }) async {
    final response = await apiClient.post("/api/auth/login", {
      "email": email,
      "password": password,
      "terminalId": terminal,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final token = data["token"];

      await StorageService.saveLogin(
        token: token,
        email: email,
        password: password,
        terminal: terminal,
      );

      return true;
    }

    return false;
  }
}
