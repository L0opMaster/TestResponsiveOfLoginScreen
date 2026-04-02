import 'package:flutter/material.dart';
import 'package:test_responsive/core/storage_service.dart';
import 'package:test_responsive/model/category_model.dart';
import 'package:test_responsive/service/api_client.dart';
import 'package:test_responsive/service/category_service.dart';
import 'package:test_responsive/util/base_url.dart';

class CategoryProvider with ChangeNotifier {
  late final CategoryService categoryService;

  CategoryProvider() {
    categoryService = CategoryService(
      apiClient: ApiClient(baseUrl: BaseUrl().baseUrl),
    );
  }
  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  bool _isCreate = false;
  String? _errorMessage;

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  bool get isCreate => _isCreate;
  String? get errorMessage => _errorMessage;

  int _selectedCategoryId = 0;
  int get selectedCategoryId => _selectedCategoryId;

  void setSelectedCategory(int id) {
    _selectedCategoryId = id;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      final result = await categoryService.fetchCategory(token: token);
      _categories = [
        CategoryModel(
          id: 0,
          nameEn: 'All',
          nameKm: 'ទាំងអស់',
          active: false,
          parentId: null,
        ),
        ...result,
      ];
    } catch (e) {
      _errorMessage = e.toString();
      _categories = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── CREATE ───────────────────────────────────────────────────────────────
  Future<bool> createCategories(Map<String, dynamic> body) async {
    _isCreate = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      final newCategories = await categoryService.createCategory(
        body: body,
        token: token,
      );
      _categories = [newCategories, ..._categories];
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isCreate = false;
      notifyListeners();
    }
  }
}
