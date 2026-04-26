class CarShowroom {
  final int id;
  final String description;
  final String? descriptionAr;
  final String? imagePath;
  final String cityNameAr;
  final String cityNameEn;

  CarShowroom({
    required this.id,
    required this.description,
    this.descriptionAr,
    required this.imagePath,
    required this.cityNameAr,
    required this.cityNameEn,
  });

  factory CarShowroom.fromJson(Map<String, dynamic> json) {
    return CarShowroom(
      id: json['id'],
      description: json['description'] ?? '',
      descriptionAr: json['description_ar'],
      imagePath: json['image_path'],
      cityNameAr: json['city']?['name_ar'] ?? '',
      cityNameEn: json['city']?['name_en'] ?? '',
    );
  }
}
