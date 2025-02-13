class EsuketLayananModel {
  String? name;
  String? slug;
  String? description;

  EsuketLayananModel({
    this.name,
    this.slug,
    this.description,
  });

  factory EsuketLayananModel.fromJson(Map<String, dynamic> json) {
    return EsuketLayananModel(
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
    );
  }
}
