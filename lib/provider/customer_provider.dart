import 'package:flutter/material.dart';
import 'package:test_responsive/core/storage_service.dart';
import 'package:test_responsive/model/customer_model.dart';
import 'package:test_responsive/service/api_client.dart';
import 'package:test_responsive/service/customer_service.dart';
import 'package:test_responsive/util/base_url.dart';

/// State manager for all customer CRUD operations.
///
/// Exposes reactive loading flags per action so the UI can show
/// granular progress indicators (create, update, delete).
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
  String? _errorMessage;
  ValueNotifier<int?> selectedCustomer = ValueNotifier(null);

  // ─── Getters ──────────────────────────────────────────────────────────────

  List<CustomerModel> get customers => _customers;
  bool get isLoading => _isLoading;
  bool get isCreate => _isCreate;
  bool get isUpdating => _isUpdating;
  bool get isDeleting => _isDeleting;
  String? get errorMessage => _errorMessage;

  // ─── FETCH ────────────────────────────────────────────────────────────────

  /// Loads all customers from the server into [customers].
  /// Guards against duplicate calls while already loading.
  Future<void> fetchCustomers() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      _customers = await customerService.fetchCustomer(token: token);
    } catch (e) {
      _customers = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── CREATE ───────────────────────────────────────────────────────────────

  /// Creates a new customer from [body] and prepends it to the list.
  /// Returns `true` on success, `false` on failure.
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
      _errorMessage = e.toString();
      return false;
    } finally {
      _isCreate = false;
      notifyListeners();
    }
  }

  // ─── UPDATE ───────────────────────────────────────────────────────────────

  /// Updates the customer with [id] using [body] and replaces it in the list.
  /// Returns `true` on success, `false` on failure.
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
      _errorMessage = e.toString();
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  // ─── DELETE ───────────────────────────────────────────────────────────────

  /// Deletes the customer with [id] and removes it from the list.
  /// Returns `true` on success, `false` on failure.
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
      _errorMessage = e.toString();
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
