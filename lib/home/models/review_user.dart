class ReviewUser {
  final int id;
  final String name;
  final String phone;
  final DateTime created;

  ReviewUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.created,
  });

  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(
      id: json['id'],
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      created: DateTime.parse(json['created']),
    );
  }
}
