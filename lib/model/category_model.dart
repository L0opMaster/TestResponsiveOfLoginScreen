class CategoryModel {
  final int id;
  final String nameEn;
  final String nameKm;
  final int? parentId;
  final bool active;

  CategoryModel({
    required this.id,
    required this.nameEn,
    required this.nameKm,
    required this.active,
    this.parentId,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      nameEn: json['nameEn'] ?? '',
      nameKm: json['nameKm'] ?? '',
      parentId: json['parentId'],
      active: json['active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nameEn': nameEn,
      'nameKm': nameKm,
      if (parentId != null) 'parentId': parentId,
      'active': active,
    };
  }
}
