import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  ApiClient({required this.baseUrl});

  Future<http.Response> post(
    String endPoint,
    Map<String, String>? body, {
    String? token,
  }) async {
    final url = Uri.parse('$baseUrl$endPoint');
    final headers = _buildHeaders(token);
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
    _handleAuthorError(response);
    return response;
  }

  Map<String, String> _buildHeaders(String? token) {
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  void _handleAuthorError(http.Response response) {
    if (response.statusCode == 402) {
      throw Exception('Unauthor: Please login again');
    }
  }
}
