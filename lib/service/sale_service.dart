import 'dart:convert';

import 'package:test_responsive/model/sale_model.dart';
import 'package:test_responsive/service/api_client.dart';

class SaleService {
  final ApiClient apiClient;

  SaleService({required this.apiClient});

  /// GET /api/pos/sales?status={status}
  Future<List<SaleModel>> listSales({String? token, String? status}) async {
    String url = '/api/pos/sales';
    if (status != null && status.isNotEmpty) {
      url += '?status=$status';
    }
    final response = await apiClient.get(url, token: token);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((e) => SaleModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception(
        'Failed to fetch sales (${response.statusCode}): ${response.body}');
  }

  /// GET /api/pos/sales/{id}
  Future<SaleModel> getById({String? token, required int id}) async {
    final response = await apiClient.get('/api/pos/sales/$id', token: token);
    if (response.statusCode == 200) {
      return SaleModel.fromJson(jsonDecode(response.body));
    }
    throw Exception(
        'Failed to fetch sale (${response.statusCode}): ${response.body}');
  }

  /// PUT /api/pos/sales/{id}/start-preparing — employee claims this order
  Future<SaleModel> startPreparing({String? token, required int id}) async {
    final response = await apiClient.put(
        '/api/pos/sales/$id/start-preparing', null,
        token: token);
    if (response.statusCode == 200) {
      return SaleModel.fromJson(jsonDecode(response.body));
    }
    throw Exception(
        'Failed to start preparing (${response.statusCode}): ${response.body}');
  }

  /// PUT /api/pos/sales/{id}/complete-packaging — done packaging
  Future<SaleModel> completePackaging({String? token, required int id}) async {
    final response = await apiClient.put(
        '/api/pos/sales/$id/complete-packaging', null,
        token: token);
    if (response.statusCode == 200) {
      return SaleModel.fromJson(jsonDecode(response.body));
    }
    throw Exception(
        'Failed to complete packaging (${response.statusCode}): ${response.body}');
  }

  /// GET /api/pos/sales/{id}/invoice.pdf
  Future<List<int>> getInvoicePdf(
      {String? token, required int id, bool thermal = false}) async {
    final response = await apiClient.get(
        '/api/pos/sales/$id/invoice.pdf?thermal=$thermal',
        token: token);
    if (response.statusCode == 200) {
      return response.bodyBytes;
    }
    throw Exception(
        'Failed to get invoice PDF (${response.statusCode}): ${response.body}');
  }

  /// GET /api/pos/sales/{id}/receipt
  Future<Map<String, dynamic>> getReceipt(
      {String? token, required int id}) async {
    final response =
        await apiClient.get('/api/pos/sales/$id/receipt', token: token);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception(
        'Failed to get receipt (${response.statusCode}): ${response.body}');
  }
}
