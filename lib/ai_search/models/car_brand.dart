class CarBrand {
  final int id;
  final String name;
  final String imagePath;

  CarBrand({
    required this.id,
    required this.name,
    required this.imagePath,
  });

  factory CarBrand.fromJson(Map<String, dynamic> json) {
    return CarBrand(
      id: json['id'] as int,
      name: json['name'] as String,
      imagePath: json['image_path'] as String? ?? '',
    );
  }
}
