class LayananModel {
  String? name;
  String? slug;
  String? description;
  String? icon;
  int? categoryId;

  LayananModel({
    this.name,
    this.slug,
    this.description,
    this.icon,
    this.categoryId,
  });

  factory LayananModel.fromJson(Map<String, dynamic> json) {
    return LayananModel(
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      icon: json['icon'],
      categoryId: json['category_id'] as int,
    );
  }
}
