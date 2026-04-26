class CarColor {
  final int id;
  final String name;
  final String code;

  CarColor({
    required this.id,
    required this.name,
    required this.code,
  });

  factory CarColor.fromJson(Map<String, dynamic> json) {
    return CarColor(
      id: json['id'],
      name: json['name'],
      code: json['code'],
    );
  }
}
