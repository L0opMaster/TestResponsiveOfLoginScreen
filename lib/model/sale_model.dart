class SaleModel {
  final int id;
  final String? invoiceNumber;
  final String status;
  final String? displayName;
  final double subtotal;
  final double discountAmount;
  final double taxRate;
  final double taxAmount;
  final double grandTotal;
  final double paidAmount;
  final double deliveryCharge;
  final double otherCharge;
  final double depositAmount;
  final String? note;
  final String? orderDate;
  final String? deliveryDate;
  final String? paymentTerms;
  final int? customerId;
  final String? customerName;
  final int? tableId;
  final String? tableNumber;
  final String? cashierName;
  final int? shiftId;
  final String? createdAt;
  final List<SaleLineModel> lines;

  SaleModel({
    required this.id,
    this.invoiceNumber,
    required this.status,
    this.displayName,
    required this.subtotal,
    required this.discountAmount,
    required this.taxRate,
    required this.taxAmount,
    required this.grandTotal,
    required this.paidAmount,
    required this.deliveryCharge,
    required this.otherCharge,
    required this.depositAmount,
    this.note,
    this.orderDate,
    this.deliveryDate,
    this.paymentTerms,
    this.customerId,
    this.customerName,
    this.tableId,
    this.tableNumber,
    this.cashierName,
    this.shiftId,
    this.createdAt,
    required this.lines,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: json['id'] as int,
      invoiceNumber: json['invoiceNumber'] as String?,
      status: json['status'] as String? ?? '',
      displayName: json['displayName'] as String?,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0,
      taxRate: (json['taxRate'] as num?)?.toDouble() ?? 0,
      taxAmount: (json['taxAmount'] as num?)?.toDouble() ?? 0,
      grandTotal: (json['grandTotal'] as num?)?.toDouble() ?? 0,
      paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0,
      deliveryCharge: (json['deliveryCharge'] as num?)?.toDouble() ?? 0,
      otherCharge: (json['otherCharge'] as num?)?.toDouble() ?? 0,
      depositAmount: (json['depositAmount'] as num?)?.toDouble() ?? 0,
      note: json['note'] as String?,
      orderDate: json['orderDate'] as String?,
      deliveryDate: json['deliveryDate'] as String?,
      paymentTerms: json['paymentTerms'] as String?,
      customerId: json['customerId'] as int?,
      customerName: json['customerName'] as String?,
      tableId: json['tableId'] as int?,
      tableNumber: json['tableNumber'] as String?,
      cashierName: json['cashierName'] as String?,
      shiftId: json['shiftId'] as int?,
      createdAt: json['createdAt'] as String?,
      lines: (json['lines'] as List<dynamic>?)
              ?.map((e) => SaleLineModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class SaleLineModel {
  final int id;
  final int productId;
  final String? productNameEn;
  final String? productNameKm;
  final double quantity;
  final double unitPrice;
  final double lineDiscount;
  final double lineTotal;
  final String? note;

  SaleLineModel({
    required this.id,
    required this.productId,
    this.productNameEn,
    this.productNameKm,
    required this.quantity,
    required this.unitPrice,
    required this.lineDiscount,
    required this.lineTotal,
    this.note,
  });

  factory SaleLineModel.fromJson(Map<String, dynamic> json) {
    return SaleLineModel(
      id: json['id'] as int,
      productId: json['productId'] as int,
      productNameEn: json['productNameEn'] as String?,
      productNameKm: json['productNameKm'] as String?,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0,
      lineDiscount: (json['lineDiscount'] as num?)?.toDouble() ?? 0,
      lineTotal: (json['lineTotal'] as num?)?.toDouble() ?? 0,
      note: json['note'] as String?,
    );
  }
}
