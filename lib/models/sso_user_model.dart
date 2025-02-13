class SsoUserModel {
  int? id;
  String? name;
  String? email;
  String? nik;
  String? nip;
  String? phone;

  SsoUserModel({
    this.id,
    this.name,
    this.email,
    this.nik,
    this.nip,
    this.phone,
  });

  factory SsoUserModel.fromJson(Map<String, dynamic> json) {
    return SsoUserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      nik: json['nik'],
      phone: json['phone_number'],
    );
  }
}
