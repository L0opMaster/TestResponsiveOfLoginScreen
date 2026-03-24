import 'dart:convert';
import 'package:test_responsive/model/product_page.dart';
import 'package:test_responsive/service/api_client.dart';

class ProductService {
  final ApiClient apiClient;
  ProductService({required this.apiClient});

  Future<ProductPage> fetchProducts({
    String query = "",
    int? categoryId,
    String? token,
    int page = 0,
    int size = 20,
  }) async {
    final response = await apiClient.get(
      '/api/products?q=$query&page=$page&size=$size',
      token: token,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ProductPage.fromJson(data);
    } else {
      throw Exception('Failed to fetch products');
    }
  }
}
