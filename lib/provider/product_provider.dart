import 'package:flutter/material.dart';
import 'package:test_responsive/core/storage_service.dart';
import 'package:test_responsive/model/product_model.dart';
import 'package:test_responsive/service/api_client.dart';
import 'package:test_responsive/service/product_service.dart';
import 'package:test_responsive/util/base_url.dart';

class ProductProvider with ChangeNotifier {
  late final ProductService _productService;

  ProductProvider() {
    _productService = ProductService(
      apiClient: ApiClient(baseUrl: BaseUrl().baseUrl),
    );
  }

  List<ProductModel> products = [];

  bool isLoading = false;
  bool hasMore = true;

  int page = 0;
  String query = "";

  Future<void> fetchProducts({bool refresh = false, int? categoryId}) async {
    if (isLoading) {
      return;
    }

    if (refresh) {
      page = 0;
      products.clear();
      hasMore = true;
    }

    if (!hasMore) return;

    isLoading = true;
    notifyListeners();

    try {
      final auth = await StorageService.getToken();
      final result = await _productService.fetchProducts(
        query: query,
        page: page,
        categoryId: categoryId,
        token: auth,
      );

      products.addAll(result.content);

      hasMore = !result.last;
      page = result.page + 1;
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> search(String value) async {
    query = value;
    await fetchProducts(refresh: true);
  }
}
