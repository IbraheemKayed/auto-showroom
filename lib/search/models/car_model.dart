class CarModel {
  final int id;
  final int brandId;
  final String name;

  CarModel({
    required this.id,
    required this.brandId,
    required this.name,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      brandId: json['car_brand_id'],
      name: json['name'],
    );
  }
}
