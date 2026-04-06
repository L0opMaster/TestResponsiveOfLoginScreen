// ──────────────────────────────────────────────────────────────────────────────
// CHANGED: Replaced local-only CartItemModel with two backend-backed models.
//   - CartModel  → mirrors GET /api/carts/{cartId} response (cart + items).
//   - CartItemModel → mirrors each item inside the cart response.
// Previously this file had a single CartItemModel that held a ProductModel
// reference and computed price locally. Now all data comes from the backend.
// ──────────────────────────────────────────────────────────────────────────────

/// Mirrors the backend CartResponse DTO from GET /api/carts/{cartId}.
class CartModel {
  final int id;
  final int? customerId;
  final String? customerNameEn;
  final String? customerNameKm;
  final int? storeId;
  final String? storeName;
  final String status;
  final double totalAmount;
  final int itemCount;
  final List<CartItemModel> items;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CartModel({
    required this.id,
    this.customerId,
    this.customerNameEn,
    this.customerNameKm,
    this.storeId,
    this.storeName,
    this.status = 'ACTIVE',
    this.totalAmount = 0,
    this.itemCount = 0,
    this.items = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] ?? 0,
      customerId: json['customerId'],
      customerNameEn: json['customerNameEn'],
      customerNameKm: json['customerNameKm'],
      storeId: json['storeId'],
      storeName: json['storeName'],
      status: json['status'] ?? 'ACTIVE',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      itemCount: json['itemCount'] ?? 0,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }
}

/// Mirrors the backend CartItemResponse DTO.
class CartItemModel {
  final int id;
  final int productId;
  final String productNameEn;
  final String productNameKm;
  final String? productSku;
  final int quantity;
  final double unitPrice;
  final double discountAmount;
  final double totalPrice;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CartItemModel({
    required this.id,
    required this.productId,
    this.productNameEn = '',
    this.productNameKm = '',
    this.productSku,
    this.quantity = 1,
    this.unitPrice = 0,
    this.discountAmount = 0,
    this.totalPrice = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] ?? 0,
      productId: json['productId'] ?? 0,
      productNameEn: json['productNameEn'] ?? '',
      productNameKm: json['productNameKm'] ?? '',
      productSku: json['productSku'],
      quantity: json['quantity'] ?? 1,
      unitPrice: (json['unitPrice'] ?? 0).toDouble(),
      discountAmount: (json['discountAmount'] ?? 0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }
}
