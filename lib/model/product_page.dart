import 'package:test_responsive/model/product_model.dart';

class ProductPage {
  final List<ProductModel> content;
  final int page;
  final int totalPages;
  final bool last;

  ProductPage({
    required this.content,
    required this.last,
    required this.page,
    required this.totalPages,
  });

  factory ProductPage.fromJson(Map<String, dynamic> json) {
    return ProductPage(
      content: (json['content'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList(),
      page: json['number'],
      totalPages: json['totalPages'],
      last: json['last'],
    );
  }
}
