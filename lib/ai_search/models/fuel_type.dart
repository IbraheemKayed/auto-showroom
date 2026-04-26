class FuelType {
  final int id;
  final String name;
  final String code;
  final String description;

  FuelType({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
  });

  factory FuelType.fromJson(Map<String, dynamic> json) {
    return FuelType(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      description: json['description'] ?? '',
    );
  }
}
