class CarCategory {
  final int id;
  final String name;
  final String code;
  final int minSeat;
  final int maxSeat;
  final String description;
  final String imagePath;

  CarCategory({
    required this.id,
    required this.name,
    required this.code,
    required this.minSeat,
    required this.maxSeat,
    required this.description,
    required this.imagePath,
  });

  factory CarCategory.fromJson(Map<String, dynamic> json) {
    return CarCategory(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      minSeat: json['min_seat'],
      maxSeat: json['max_seat'],
      description: json['description'] ?? '',
      imagePath: json['image_path'] ?? '',
    );
  }
}
