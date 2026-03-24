import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  ApiClient({required this.baseUrl});

  Future<http.Response> get(String endpoint, {String? token}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = _buildHeaders(token);
    final response = await http.get(url, headers: headers);
    _handleAuthError(response);
    return response;
  }

  Future<http.Response> post(
    String endpoint,
    Map<String, String>? body, {
    String? token,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = _buildHeaders(token);
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
    _handleAuthError(response);
    return response;
  }

  Map<String, String> _buildHeaders(String? token) {
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  void _handleAuthError(http.Response response) {
    if (response.statusCode == 402) {
      throw Exception('Unauthorized: Please login again');
    }
  }
}
