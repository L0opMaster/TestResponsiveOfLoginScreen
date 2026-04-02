class CustomerModel {
  final int id;
  final String code;
  final String type;
  final String status;
  final String? nameEn;
  final String? nameKm;
  final String? displayName;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;
  final String? contactPerson;
  final String? paymentTerms;
  final String? taxNumber;
  final double creditBalance;
  final double creditLimit;
  final bool creditHold;
  final double totalSales;

  CustomerModel({
    required this.id,
    required this.code,
    required this.type,
    required this.status,
    this.nameEn,
    this.nameKm,
    this.displayName,
    this.phone,
    this.email,
    this.address,
    this.notes,
    this.contactPerson,
    this.paymentTerms,
    this.taxNumber,
    required this.creditBalance,
    required this.creditHold,
    required this.creditLimit,
    required this.totalSales,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      code: json['code'] ?? '',
      type: json['type'] ?? '',
      status: json['status'],
      nameEn: json['nameEn'],
      nameKm: json['nameKm'],
      displayName: json['displayName'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      notes: json['notes'],
      contactPerson: json['contactPerson'],
      paymentTerms: json['paymentTerms'],
      taxNumber: json['taxNumber'],
      creditBalance: (json['creditBalance'] ?? 0.00).toDouble(),
      creditHold: json['creditHold'] ?? false,
      creditLimit: (json['creditLimit'] ?? 0.00).toDouble(),
      totalSales: (json['totalSales'] ?? 0.00).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'type': type,
      'status': status,
      if (nameEn != null) 'nameEn': nameEn,
      if (nameKm != null) 'nameKm': nameKm,
      if (displayName != null) 'displayName': displayName,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
      if (contactPerson != null) 'contactPerson': contactPerson,
      if (paymentTerms != null) 'paymentTerms': paymentTerms,
      if (taxNumber != null) 'taxNumber': taxNumber,
      'creditBalance': creditBalance,
      'creditLimit': creditLimit,
      'creditHold': creditHold,
    };
  }
}
