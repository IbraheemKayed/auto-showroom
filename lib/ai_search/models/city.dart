class CityModel {
  final int id;
  final String nameAr;
  final String nameEn;
  final String code;

  CityModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.code,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
      code: json['code'],
    );
  }
}
