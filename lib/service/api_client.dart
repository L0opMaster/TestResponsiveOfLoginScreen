import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final Duration timeOut;
  ApiClient({
    required this.baseUrl,
    this.timeOut = const Duration(seconds: 15),
  });

  Future<http.Response> get(String endpoint, {String? token}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = _buildHeaders(token);
    final response = await http
        .get(url, headers: headers)
        .timeout(timeOut, onTimeout: () => _timeoutResponse());
    _handleError(response);
    return response;
  }

  Future<http.Response> post(
    String endpoint,
    Map<String, dynamic>? body, {
    String? token,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = _buildHeaders(token);
    final response = await http
        .post(url, headers: headers, body: jsonEncode(body))
        .timeout(timeOut, onTimeout: () => _timeoutResponse());
    _handleError(response);
    return response;
  }

  Future<http.Response> put(
    String endpoint,
    Map<String, dynamic>? body, {
    String? token,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = _buildHeaders(token);
    final response = await http
        .put(url, headers: headers, body: jsonEncode(body))
        .timeout(timeOut, onTimeout: () => _timeoutResponse());
    _handleError(response);
    return response;
  }

  Future<http.Response> patch(
    String endpoint,
    Map<String, dynamic>? body, {
    String? token,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = _buildHeaders(token);
    final response = await http
        .patch(url, headers: headers, body: jsonEncode(body))
        .timeout(timeOut, onTimeout: () => _timeoutResponse());
    _handleError(response);
    return response;
  }

  Future<http.Response> delete(String endpoint, {String? token}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = _buildHeaders(token);
    final response = await http
        .delete(url, headers: headers)
        .timeout(timeOut, onTimeout: () => _timeoutResponse());
    _handleError(response);
    return response;
  }

  Map<String, String> _buildHeaders(String? token) {
    return {
      "Content-Type": "application/json",
      if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
    };
  }

  void _handleError(http.Response response) {
    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Unauthorized: Please login again');
    }
    if (response.statusCode >= 500) {
      throw Exception(
        'Server error: (${response.statusCode}) : Please try again later',
      );
    }
  }

  http.Response _timeoutResponse() {
    return http.Response('{"message": "Request time out"}', 408);
  }
}
