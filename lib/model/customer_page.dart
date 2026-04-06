import 'package:test_responsive/model/customer_model.dart';

class CustomerPage {
  final List<CustomerModel> data;
  final int total;
  final bool hasMore;

  CustomerPage({
    required this.data,
    required this.total,
    required this.hasMore,
  });

  factory CustomerPage.fromJson(Map<String, dynamic> json) {
    return CustomerPage(
      data: (json['data'] as List)
          .map((e) => CustomerModel.fromJson(e))
          .toList(),
      total: json['total'] ?? 0,
      hasMore: json['hasMore'] ?? false,
    );
  }
}
