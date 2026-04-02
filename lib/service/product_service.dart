import 'dart:convert';

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
    String url = '/api/products?q=$query&p=$page&size=$size';
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
}
