class ProductModel {
  final int id;
  final String sku;
  final String barcode;
  final String nameEn;
  final String nameKm;
  final String? imageUrl;
  final double cost;
  final double price;
  final double resolvedPrice;
  final bool active;
  final bool sellable;
  final bool purchasable;
  final bool trackInventory;
  final String productType;
  final double lowStockThreshold;
  final String? categoryId;
  final String? categoryNameEn;
  final String? categoryNameKm;
  final String? parentProductId;
  final String? parentProductNameEn;
  final String? variantLabel;
  final String? bundleMode;
  final int saleUnitId;
  final String saleUnitCode;
  final int purchaseUnitId;
  final String purchaseUnitCode;
  final String stockUnitCode;
  final int stockUnitId;
  final double stock;
  final bool outOfStock;
  final bool lowStock;
  final List<dynamic> images;
  final List<dynamic> bundleComponents;

  ProductModel({
    required this.id,
    required this.sku,
    required this.barcode,
    required this.nameEn,
    required this.nameKm,
    this.imageUrl,
    required this.cost,
    required this.price,
    required this.resolvedPrice,
    required this.active,
    required this.sellable,
    required this.purchasable,
    required this.trackInventory,
    required this.productType,
    required this.lowStockThreshold,
    this.categoryId,
    this.categoryNameEn,
    this.categoryNameKm,
    this.parentProductId,
    this.parentProductNameEn,
    this.variantLabel,
    this.bundleMode,
    required this.saleUnitId,
    required this.saleUnitCode,
    required this.purchaseUnitId,
    required this.purchaseUnitCode,
    required this.stockUnitCode,
    required this.stockUnitId,
    required this.stock,
    required this.lowStock,
    required this.outOfStock,
    required this.bundleComponents,
    required this.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      sku: json['sku'] ?? '',
      barcode: json['barcode'] ?? '',
      nameEn: json['nameEn'] ?? '',
      nameKm: json['nameKm'] ?? '',
      cost: (json['cost'] ?? 0).toDouble(),
      price: (json['price'] ?? 0).toDouble(),
      resolvedPrice: (json['resolvedPrice'] ?? 0).toDouble(),
      active: json['active'] ?? false,
      sellable: json['sellable'] ?? false,
      purchasable: json['purchasable'] ?? false,
      trackInventory: json['trackInventory'] ?? false,
      productType: json['productType'] ?? '',
      lowStockThreshold: (json['lowStockThreshold'] ?? 0).toDouble(),
      saleUnitId: json['saleUnitId'] ?? 0,
      saleUnitCode: json['saleUnitCode'] ?? '',
      purchaseUnitId: json['purchaseUnitId'] ?? 0,
      purchaseUnitCode: json['purchaseUnitCode'] ?? '',
      stockUnitId: json['stockUnitId'] ?? 0,
      stockUnitCode: json['stockUnitCode'] ?? '',
      stock: (json['stock'] ?? 0).toDouble(),
      lowStock: json['lowStock'] ?? false,
      outOfStock: json['outOfStock'] ?? false,
      bundleComponents: json['bundleComponents'] ?? [],
      images: json['images'] ?? [],
      imageUrl: json['imageUrl'],
      categoryId: json['categoryId'],
      categoryNameEn: json['categoryNameEn'],
      categoryNameKm: json['categoryNameKm'],
      parentProductId: json['parentProductId'],
      parentProductNameEn: json['parentProductNameEn'],
      variantLabel: json['variantLabel'],
      bundleMode: json['bundleMode'],
    );
  }
}
