import 'package:flutter/material.dart';
import 'package:test_responsive/core/storage_service.dart';
import 'package:test_responsive/model/sale_model.dart';
import 'package:test_responsive/service/api_client.dart';
import 'package:test_responsive/service/sale_service.dart';
import 'package:test_responsive/util/base_url.dart';

class PackagingProvider with ChangeNotifier {
  late final SaleService saleService;

  PackagingProvider() {
    saleService = SaleService(
      apiClient: ApiClient(baseUrl: BaseUrl().baseUrl),
    );
  }

  List<SaleModel> _sales = [];
  bool _isLoading = false;
  bool _isActionLoading = false;
  String? _errorMessage;
  String _filterStatus = '';

  List<SaleModel> get sales => _sales;
  bool get isLoading => _isLoading;
  bool get isActionLoading => _isActionLoading;
  String? get errorMessage => _errorMessage;
  String get filterStatus => _filterStatus;

  void setFilter(String status) {
    _filterStatus = status;
    fetchSales();
  }

  Future<void> fetchSales() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      if (_filterStatus.isEmpty) {
        // Show both PACKAGING and PREPARING by default
        final packaging =
            await saleService.listSales(token: token, status: 'PACKAGING');
        final preparing =
            await saleService.listSales(token: token, status: 'PREPARING');
        _sales = [...packaging, ...preparing];
      } else {
        _sales =
            await saleService.listSales(token: token, status: _filterStatus);
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _sales = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Hold = employee claims this order (PACKAGING → PREPARING)
  Future<bool> startPreparing(int saleId) async {
    _isActionLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      await saleService.startPreparing(token: token, id: saleId);
      await fetchSales();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  /// Complete packaging (PREPARING → PAID → invoice)
  Future<SaleModel?> completePackaging(int saleId) async {
    _isActionLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      final sale =
          await saleService.completePackaging(token: token, id: saleId);
      await fetchSales();
      return sale;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return null;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }
}
