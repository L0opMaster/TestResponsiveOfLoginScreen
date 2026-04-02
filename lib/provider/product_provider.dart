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
  int _page = 0;
  bool _hasMore = true;
  String _query = "";

  // Make getter field
  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String get query => _query;
  int get page => _page;

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
}
