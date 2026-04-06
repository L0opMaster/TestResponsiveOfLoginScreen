import 'dart:convert';

import 'package:test_responsive/model/product_model.dart';
import 'package:test_responsive/model/product_page.dart';
import 'package:test_responsive/service/api_client.dart';

class ProductService {
  final ApiClient apiClient;

  ProductService({required this.apiClient});

  Future<ProductPage> fetchProduct({
    String query = '',
    int page = 0,
    int size = 20,
    int? categoryId,
    String? token,
  }) async {
    String url = '/api/products?q=$query&page=$page&size=$size';
    if (categoryId != null) {
      url += '&categoryId=$categoryId';
    }
    final response = await apiClient.get(url, token: token);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ProductPage.fromJson(data);
    } else {
      throw Exception('Failed to fetch product');
    }
  }

  // ─── CREATE ───────────────────────────────────────────────────────────────
  Future<ProductModel> createProduct({
    String? token,
    required Map<String, dynamic> body,
  }) async {
    print('CREATE PRODUCT body: ${jsonEncode(body)}');
    final response = await apiClient.post(
      '/api/products',
      body,
      token: token,
    );
    print('CREATE PRODUCT status: ${response.statusCode}');
    print('CREATE PRODUCT response: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ProductModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to create product (${response.statusCode}): ${response.body}');
  }

  // ─── UPDATE ───────────────────────────────────────────────────────────────
  Future<ProductModel> updateProduct({
    String? token,
    required int id,
    required Map<String, dynamic> body,
  }) async {
    print('UPDATE PRODUCT body: ${jsonEncode(body)}');
    final response = await apiClient.put(
      '/api/products/$id',
      body,
      token: token,
    );
    print('UPDATE PRODUCT status: ${response.statusCode}');
    print('UPDATE PRODUCT response: ${response.body}');

    if (response.statusCode == 200) {
      return ProductModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to update product (${response.statusCode}): ${response.body}');
  }

  // ─── DELETE ───────────────────────────────────────────────────────────────
  Future<void> deleteProduct({String? token, required int id}) async {
    final response = await apiClient.delete(
      '/api/products/$id',
      token: token,
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete product (${response.statusCode}): ${response.body}');
    }
  }
}
