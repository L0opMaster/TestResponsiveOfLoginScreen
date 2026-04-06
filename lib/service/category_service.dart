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

  // ─── CREATE ───────────────────────────────────────────────────────────────
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

  // ─── UPDATE ───────────────────────────────────────────────────────────────

  /// Updates an existing customer by [id] and returns the updated [CategoriesModel]
  Future<CategoryModel> updateCategory({
    String? token,
    required int id,
    required Map<String, dynamic> body,
  }) async {
    final response = await apiClient.put(
      '/api/categories/$id',
      body,
      token: token,
    );
    if (response.statusCode == 200) {
      return CategoryModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to update customer');
  }

  // ─── DELETED ───────────────────────────────────────────────────────────────
  Future<void> deleteCategory({String? token, required int id}) async {
    final response = await apiClient.delete(
      '/api/categories/$id',
      token: token,
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to deleted category');
    }
  }
}
