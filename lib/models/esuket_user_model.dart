class EsuketUserModel {
  int? id;
  String? name;
  String? email;
  String? nik;
  String? phone;

  EsuketUserModel({
    this.id,
    this.name,
    this.email,
    this.nik,
    this.phone,
  });

  factory EsuketUserModel.fromJson(Map<String, dynamic> json) {
    return EsuketUserModel(
      id: json['id'] as int,
      name: json['name'],
      email: json['email'],
      nik: json['nik'],
      phone: json['phone'],
    );
  }
}
