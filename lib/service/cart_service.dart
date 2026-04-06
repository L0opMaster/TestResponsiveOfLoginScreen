import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:test_responsive/model/cart_model.dart';
import 'package:test_responsive/service/api_client.dart';

// ──────────────────────────────────────────────────────────────────────────────
// CHANGED: Rewrote cart service to call backend REST endpoints instead of
// only having a single createSale() method.
//
// New endpoints:
//   - createCart()          → POST   /api/carts
//   - getCart()             → GET    /api/carts/{cartId}
//   - addItem()             → POST   /api/carts/{cartId}/items
//   - updateItemQuantity()  → PUT    /api/carts/{cartId}/items/{itemId}
//     (also accepts optional unitPrice to edit price in cart)
//   - removeItem()          → DELETE /api/carts/{cartId}/items/{itemId}
//   - clearCart()           → DELETE /api/carts/{cartId}
//   - checkout()            → POST   /api/carts/{cartId}/checkout
// ──────────────────────────────────────────────────────────────────────────────

class CartService {
  final ApiClient apiClient;

  CartService({required this.apiClient});

  /// POST /api/carts
  Future<CartModel> createCart({
    String? token,
    int? customerId,
    int? storeId,
  }) async {
    final body = <String, dynamic>{
      if (customerId != null) 'customerId': customerId,
      if (storeId != null) 'storeId': storeId,
    };
    final response = await apiClient.post('/api/carts', body, token: token);
    debugPrint('createCart response: ${response.statusCode} ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return CartModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to create cart (${response.statusCode}): ${response.body}');
  }

  /// GET /api/carts/{cartId}
  Future<CartModel> getCart({String? token, required int cartId}) async {
    final response = await apiClient.get('/api/carts/$cartId', token: token);
    if (response.statusCode == 200) {
      return CartModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to get cart (${response.statusCode}): ${response.body}');
  }

  /// POST /api/carts/{cartId}/items
  Future<CartItemModel> addItem({
    String? token,
    required int cartId,
    required int productId,
    required int quantity,
    double? unitPrice,
  }) async {
    final body = <String, dynamic>{
      'productId': productId,
      'quantity': quantity,
      if (unitPrice != null) 'unitPrice': unitPrice,
    };
    final response = await apiClient.post('/api/carts/$cartId/items', body, token: token);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return CartItemModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to add item (${response.statusCode}): ${response.body}');
  }

  /// PUT /api/carts/{cartId}/items/{itemId}
  Future<CartItemModel> updateItemQuantity({
    String? token,
    required int cartId,
    required int itemId,
    required int quantity,
    double? unitPrice, // CHANGED: optional unitPrice to allow editing price in cart
  }) async {
    final body = <String, dynamic>{
      'quantity': quantity,
      if (unitPrice != null) 'unitPrice': unitPrice, // CHANGED: send custom price if provided
    };
    final response = await apiClient.put('/api/carts/$cartId/items/$itemId', body, token: token);
    if (response.statusCode == 200) {
      return CartItemModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to update item (${response.statusCode}): ${response.body}');
  }

  /// DELETE /api/carts/{cartId}/items/{itemId}
  Future<void> removeItem({
    String? token,
    required int cartId,
    required int itemId,
  }) async {
    final response = await apiClient.delete('/api/carts/$cartId/items/$itemId', token: token);
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to remove item (${response.statusCode}): ${response.body}');
    }
  }

  /// DELETE /api/carts/{cartId}
  Future<void> clearCart({String? token, required int cartId}) async {
    final response = await apiClient.delete('/api/carts/$cartId', token: token);
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to clear cart (${response.statusCode}): ${response.body}');
    }
  }

  /// POST /api/carts/{cartId}/checkout
  Future<Map<String, dynamic>> checkout({String? token, required int cartId}) async {
    final response = await apiClient.post('/api/carts/$cartId/checkout', null, token: token);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to checkout (${response.statusCode}): ${response.body}');
  }
}
