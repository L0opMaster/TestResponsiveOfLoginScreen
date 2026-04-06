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
  bool _isDeleted = false;
  bool _isUpdate = false;
  bool _isCreate = false;
  String? _errorMessage;

  List<CategoryModel> get categories => _categories;
  bool get isUpdate => _isUpdate;
  bool get isDelete => _isDeleted;
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
          active: true,
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

  // ─── UPDATE ───────────────────────────────────────────────────────────────

  /// Updates the category with [id] using [body] and replaces it in the list.
  /// Returns `true` on success, `false` on failure.
  Future<bool> updateCategories(int id, Map<String, dynamic> body) async {
    _isUpdate = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      final updated = await categoryService.updateCategory(
        id: id,
        body: body,
        token: token,
      );
      final index = _categories.indexWhere((category) => category.id == id);
      if (index != -1) _categories[index] = updated;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isUpdate = false;
      notifyListeners();
    }
  }

  // ─── UPDATE ───────────────────────────────────────────────────────────────
  Future<bool> deletedCategories(int id) async {
    _isDeleted = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      await categoryService.deleteCategory(id: id, token: token);
      _categories.removeWhere((category) => category.id == id);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isDeleted = false;
      notifyListeners();
    }
  }
}
