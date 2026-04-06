import 'dart:convert';

import 'package:test_responsive/model/customer_model.dart';
import 'package:test_responsive/model/customer_page.dart';
import 'package:test_responsive/service/api_client.dart';

/// Handles all HTTP calls for the `/api/customers` endpoint.
class CustomerService {
  final ApiClient apiClient;

  CustomerService({required this.apiClient});

  // ─── READ (paginated) ───────────────────────────────────────────────────

  /// Fetches a page of customers from the server.
  Future<CustomerPage> fetchCustomers({
    String query = '',
    int page = 0,
    int size = 20,
    String? token,
  }) async {
    final url = '/api/customers/search?q=$query&page=$page&size=$size';
    final response = await apiClient.get(url, token: token);
    if (response.statusCode == 200) {
      return CustomerPage.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to get customers (${response.statusCode}): ${response.body}');
  }

  // ─── CREATE ───────────────────────────────────────────────────────────────

  /// Creates a new customer and returns the saved [CustomerModel].
  Future<CustomerModel> createCustomer({
    String? token,
    required Map<String, dynamic> body,
  }) async {
    final response = await apiClient.post('/api/customers', body, token: token);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return CustomerModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to create customer (${response.statusCode}): ${response.body}');
  }

  // ─── UPDATE ───────────────────────────────────────────────────────────────

  /// Updates an existing customer by [id] and returns the updated [CustomerModel].
  Future<CustomerModel> updateCustomer({
    String? token,
    required int id,
    required Map<String, dynamic> body,
  }) async {
    final response = await apiClient.put(
      '/api/customers/$id',
      body,
      token: token,
    );
    if (response.statusCode == 200) {
      return CustomerModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to update customer (${response.statusCode}): ${response.body}');
  }

  // ─── DELETE ───────────────────────────────────────────────────────────────

  /// Deletes a customer by [id].
  Future<void> deleteCustomer({String? token, required int id}) async {
    final response = await apiClient.delete('/api/customers/$id', token: token);
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete customer (${response.statusCode}): ${response.body}');
    }
  }
}
