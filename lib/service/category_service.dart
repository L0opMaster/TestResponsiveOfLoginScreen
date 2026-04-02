import 'dart:convert';

import 'package:test_responsive/model/category_model.dart';
import 'package:test_responsive/service/api_client.dart';

class CategoryService {
  final ApiClient apiClient;

  CategoryService({required this.apiClient});

  Future<List<CategoryModel>> fetchCategory({String? token}) async {
    final response = await apiClient.get('/api/categories', token: token);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body) as List;
      print(response.statusCode);
      print(response.body);
      return data.map((e) => CategoryModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed: ${response.statusCode}');
    }
  }

  // Create category

  Future<CategoryModel> createCategory({
    String? token,
    required Map<String, dynamic> body,
  }) async {
    final response = await apiClient.post(
      '/api/categories',
      body,
      token: token,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return CategoryModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to create categories');
  }
}
