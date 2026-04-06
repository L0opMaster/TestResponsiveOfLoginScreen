import 'package:flutter/material.dart';
import 'package:test_responsive/core/storage_service.dart';
import 'package:test_responsive/model/customer_model.dart';
import 'package:test_responsive/service/api_client.dart';
import 'package:test_responsive/service/customer_service.dart';
import 'package:test_responsive/util/base_url.dart';

/// State manager for all customer CRUD operations.
class CustomerProvider with ChangeNotifier {
  late final CustomerService customerService;

  CustomerProvider() {
    customerService = CustomerService(
      apiClient: ApiClient(baseUrl: BaseUrl().baseUrl),
    );
  }

  // ─── State ────────────────────────────────────────────────────────────────

  List<CustomerModel> _customers = [];
  bool _isLoading = false;
  bool _isCreate = false;
  bool _isUpdating = false;
  bool _isDeleting = false;
  int _page = 0;
  bool _hasMore = true;
  String _query = '';
  String? _errorMessage;
  ValueNotifier<int?> selectedCustomer = ValueNotifier(null);

  // ─── Getters ──────────────────────────────────────────────────────────────

  List<CustomerModel> get customers => _customers;
  bool get isLoading => _isLoading;
  bool get isCreate => _isCreate;
  bool get isUpdating => _isUpdating;
  bool get isDeleting => _isDeleting;
  bool get hasMore => _hasMore;
  String get query => _query;
  int get page => _page;
  String? get errorMessage => _errorMessage;

  // ─── FETCH (paginated) ────────────────────────────────────────────────────

  Future<void> fetchCustomers({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _page = 0;
      _customers.clear();
      _hasMore = true;
    }

    if (!_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      final result = await customerService.fetchCustomers(
        query: _query,
        page: _page,
        token: token,
      );
      _customers.addAll(result.data);
      _hasMore = result.hasMore;
      _page++;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }

    _isLoading = false;
    notifyListeners();
  }

  // ─── SEARCH ───────────────────────────────────────────────────────────────

  Future<void> search(String value) async {
    _query = value;
    await fetchCustomers(refresh: true);
  }

  // ─── CREATE ───────────────────────────────────────────────────────────────

  Future<bool> createCustomer(Map<String, dynamic> body) async {
    _isCreate = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      final newCustomer = await customerService.createCustomer(
        body: body,
        token: token,
      );
      _customers = [newCustomer, ..._customers];
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isCreate = false;
      notifyListeners();
    }
  }

  // ─── UPDATE ───────────────────────────────────────────────────────────────

  Future<bool> updateCustomer(int id, Map<String, dynamic> body) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      final updated = await customerService.updateCustomer(
        id: id,
        body: body,
        token: token,
      );
      final idx = _customers.indexWhere((c) => c.id == id);
      if (idx != -1) _customers[idx] = updated;
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  // ─── DELETE ───────────────────────────────────────────────────────────────

  Future<bool> deleteCustomer(int id) async {
    _isDeleting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      await customerService.deleteCustomer(id: id, token: token);
      _customers.removeWhere((c) => c.id == id);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }

  /// SelectedCustomerId
  void setSelectedCustomer(int id) {
    selectedCustomer.value = id;
  }
}
