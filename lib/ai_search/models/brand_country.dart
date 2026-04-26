import 'package:sayarti/ai_search/models/car_brand.dart';


class BrandCountry {
  final int id;
  final String name;
  final String code;
  final String imagePath;
  final List<CarBrand> brands;

  BrandCountry({
    required this.id,
    required this.name,
    required this.code,
    required this.imagePath,
    required this.brands,
  });

  factory BrandCountry.fromJson(Map<String, dynamic> json) {
    return BrandCountry(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      imagePath: _fixImagePath(json['image_path'] ?? ''),
      brands: (json['brands'] as List<dynamic>? ?? [])
          .map((b) => CarBrand.fromJson(b))
          .toList(),
    );
  }

  static String _fixImagePath(String path) {
    const s3Base = 'https://staging-sayyarati-assets.s3.eu-north-1.amazonaws.com/';
    if (path.startsWith(s3Base)) {
      final rest = path.substring(s3Base.length);
      if (rest.startsWith('http://') || rest.startsWith('https://')) {
        return rest;
      }
    }
    return path;
  }
}
