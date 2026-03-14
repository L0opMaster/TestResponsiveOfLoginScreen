import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;

  ApiClient({required this.baseUrl});

  Future<http.Response> get(String endPoint, {String? token}) async {
    final url = Uri.parse('$baseUrl$endPoint');
    final headers = _buildHeader(token);
    final response = await http.get(url, headers: headers);
    _handleAuthError(response);
    return response;
  }

  Future<http.Response> post(
    String endPoint,
    Map<String, dynamic>? body, {
    String? token,
  }) async {
    final url = Uri.parse('$baseUrl$endPoint');
    final headers = _buildHeader(token);
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
    _handleAuthError(response);
    return response;
  }

  Map<String, String> _buildHeader(String? token) {
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  void _handleAuthError(http.Response response) {
    if (response.statusCode == 401) {
      throw Exception('Unauthorized: Please login again');
    }
  }
}
