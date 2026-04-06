import 'package:flutter/material.dart';
import 'package:test_responsive/core/storage_service.dart';
import 'package:test_responsive/model/product_model.dart';
import 'package:test_responsive/service/api_client.dart';
import 'package:test_responsive/service/product_service.dart';
import 'package:test_responsive/util/base_url.dart';

class ProductProvider with ChangeNotifier {
  late final ProductService productService;

  ProductProvider() {
    productService = ProductService(
      apiClient: ApiClient(baseUrl: BaseUrl().baseUrl),
    );
  }

  // Make private field
  List<ProductModel> _products = [];
  bool _isLoading = false;
  bool _isCreate = false;
  bool _isUpdate = false;
  bool _isDeleted = false;
  int _page = 0;
  bool _hasMore = true;
  String _query = "";
  String? _errorMessage;

  // Make getter field
  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  bool get isCreate => _isCreate;
  bool get isUpdate => _isUpdate;
  bool get isDelete => _isDeleted;
  bool get hasMore => _hasMore;
  String get query => _query;
  int get page => _page;
  String? get errorMessage => _errorMessage;

  // Provider Fetching Products metaData
  Future<void> fetchProduct({bool refresh = false, int? categoryId}) async {
    if (isLoading) return;

    if (refresh) {
      _page = 0;
      products.clear();
      _hasMore = true;
    }

    if (!hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      final result = await productService.fetchProduct(
        query: query,
        page: page,
        categoryId: categoryId,
        token: token,
      );
      products.addAll(result.content);
      //false
      _hasMore = !result.last;
      _page = result.page + 1;
    } catch (e) {
      print(e);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> search(String value) async {
    _query = value;
    await fetchProduct(refresh: true);
  }

  // ─── CREATE ───────────────────────────────────────────────────────────────
  Future<bool> createProduct(Map<String, dynamic> body) async {
    _isCreate = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      print('TOKEN: $token');
      print('BODY: $body');
      final newProduct = await productService.createProduct(
        body: body,
        token: token,
      );
      _products = [newProduct, ..._products];
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      print('CREATE ERROR: $e');
      return false;
    } finally {
      _isCreate = false;
      notifyListeners();
    }
  }

  // ─── UPDATE ───────────────────────────────────────────────────────────────
  Future<bool> updateProduct(int id, Map<String, dynamic> body) async {
    _isUpdate = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      final updated = await productService.updateProduct(
        id: id,
        body: body,
        token: token,
      );
      final index = _products.indexWhere((product) => product.id == id);
      if (index != -1) _products[index] = updated;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isUpdate = false;
      notifyListeners();
    }
  }

  // ─── DELETE ───────────────────────────────────────────────────────────────
  Future<bool> deleteProduct(int id) async {
    _isDeleted = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      await productService.deleteProduct(id: id, token: token);
      _products.removeWhere((product) => product.id == id);
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
