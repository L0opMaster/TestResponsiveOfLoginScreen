import 'package:flutter/material.dart';
import 'package:test_responsive/core/storage_service.dart';
import 'package:test_responsive/model/cart_model.dart';
import 'package:test_responsive/service/api_client.dart';
import 'package:test_responsive/service/cart_service.dart';
import 'package:test_responsive/util/base_url.dart';

// ──────────────────────────────────────────────────────────────────────────────
// CHANGED: Converted from local-only cart (List<CartItemModel> in memory)
// to a fully backend-driven cart.
//
// Key changes:
//   1. CREATE CART: Cart is auto-created on first addItem() via POST /api/carts.
//      Requires customerId (user must select customer before adding items).
//   2. ADD ITEM: Calls POST /api/carts/{cartId}/items instead of local list add.
//   3. UPDATE QUANTITY + EDIT PRICE: Calls PUT /api/carts/{cartId}/items/{itemId}
//      with optional unitPrice param — allows changing item price in cart
//      (e.g. product costs 20000 but seller wants to charge 18000).
//   4. REMOVE / CLEAR / CHECKOUT: All call backend DELETE/POST endpoints.
//   5. After each mutation, the full cart is re-fetched (getCart) to sync totals.
// ──────────────────────────────────────────────────────────────────────────────

class CartProvider with ChangeNotifier {
  late final CartService cartService;

  CartProvider() {
    cartService = CartService(
      apiClient: ApiClient(baseUrl: BaseUrl().baseUrl),
    );
  }

  // ─── State ────────────────────────────────────────────────────────────────

  CartModel? _cart;
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  // ─── Getters ──────────────────────────────────────────────────────────────

  CartModel? get cart => _cart;
  List<CartItemModel> get items => _cart?.items ?? [];
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;

  int get itemCount => _cart?.itemCount ?? 0;
  double get totalAmount => _cart?.totalAmount ?? 0;
  bool get isEmpty => _cart == null || _cart!.items.isEmpty;
  int? get cartId => _cart?.id;

  // ─── CREATE CART ──────────────────────────────────────────────────────────

  Future<bool> createCart({int? customerId, int? storeId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      _cart = await cartService.createCart(
        token: token,
        customerId: customerId,
        storeId: storeId,
      );
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── FETCH CART ───────────────────────────────────────────────────────────

  Future<bool> fetchCart({required int cartId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      _cart = await cartService.getCart(token: token, cartId: cartId);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── ADD ITEM (auto-creates cart if needed) ────────────────────────────────
  // CHANGED: On first add, lazily creates a backend cart with the selected
  // customerId. Then POSTs the item. unitPrice is optional — if not provided,
  // backend uses the product's default price.

  Future<bool> addItem({
    required int productId,
    int quantity = 1,
    int? customerId,
    double? unitPrice,
  }) async {
    _errorMessage = null;

    try {
      final token = await StorageService.getToken();

      // CHANGED: Auto-create cart on first item add (requires customerId)
      _cart ??= await cartService.createCart(
        token: token,
        customerId: customerId,
      );

      await cartService.addItem(
        token: token,
        cartId: _cart!.id,
        productId: productId,
        quantity: quantity,
        unitPrice: unitPrice,
      );
      // Refresh the full cart to get updated totals
      _cart = await cartService.getCart(token: token, cartId: _cart!.id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      debugPrint('CartProvider.addItem error: $e');
      notifyListeners();
      return false;
    }
  }

  // ──��� UPDATE QUANTITY ──────────────────────────────────────────────────────

  // CHANGED: Added optional unitPrice param — allows editing price per item
  // in the cart (e.g. give a discount: 20000 → 18000). Calls PUT endpoint.
  Future<bool> updateQuantity({
    required int itemId,
    required int quantity,
    double? unitPrice,
  }) async {
    if (_cart == null) return false;

    _errorMessage = null;

    try {
      final token = await StorageService.getToken();
      await cartService.updateItemQuantity(
        token: token,
        cartId: _cart!.id,
        itemId: itemId,
        quantity: quantity,
        unitPrice: unitPrice,
      );
      _cart = await cartService.getCart(token: token, cartId: _cart!.id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // ─── REMOVE ITEM ─────────────────────────────────────────────────────────

  Future<bool> removeItem({required int itemId}) async {
    if (_cart == null) return false;

    _errorMessage = null;

    try {
      final token = await StorageService.getToken();
      await cartService.removeItem(
        token: token,
        cartId: _cart!.id,
        itemId: itemId,
      );
      _cart = await cartService.getCart(token: token, cartId: _cart!.id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // ─── CLEAR CART ───────────────────────────────────────────────────────────

  Future<bool> clearCart() async {
    if (_cart == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      await cartService.clearCart(token: token, cartId: _cart!.id);
      _cart = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── CHECKOUT ─────────────────────────────────────────────────────────────

  Future<bool> checkout() async {
    if (_cart == null) return false;

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      await cartService.checkout(token: token, cartId: _cart!.id);
      _cart = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  // ─── RESET ────────────────────────────────────────────────────────────────

  void reset() {
    _cart = null;
    _errorMessage = null;
    notifyListeners();
  }
}
