class BrandModel {
  final int id;
  final String name;
  final String imagePath;

  BrandModel({
    required this.id,
    required this.name,
    required this.imagePath,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'],
      name: json['name'] ?? '',
      imagePath: json['image_path'] ?? '',
    );
  }
}
