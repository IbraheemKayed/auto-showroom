class CarResult {
  final int id;
  final String name;

  CarResult({
    required this.id,
    required this.name,
  });

  factory CarResult.fromJson(Map<String, dynamic> json) {
    return CarResult(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Car',
    );
  }
}
