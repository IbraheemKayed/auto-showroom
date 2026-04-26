class DriveTrainType {
  final int id;
  final String name;
  final String code;

  DriveTrainType({required this.id, required this.name, required this.code});

  factory DriveTrainType.fromJson(Map<String, dynamic> json) {
    return DriveTrainType(
      id: json['id'],
      name: json['name'],
      code: json['code'] ?? '',
    );
  }
}
