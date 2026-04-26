class ShowroomReview {
  final int id;
  final int userId;
  final int showroomId;
  final String review;
  final int rate;
  final String status;
  final DateTime addedAt;
  final ReviewUser user;

  ShowroomReview({
    required this.id,
    required this.userId,
    required this.showroomId,
    required this.review,
    required this.rate,
    required this.status,
    required this.addedAt,
    required this.user,
  });

  factory ShowroomReview.fromJson(Map<String, dynamic> json) {
    return ShowroomReview(
      id: json['id'],
      userId: json['user_id'],
      showroomId: json['car_showroom_id'],
      review: json['review'] ?? '',
      rate: json['rate'] ?? 0,
      status: json['status'] ?? '',
      addedAt: DateTime.tryParse(json['added_at'] as String? ?? '') ?? DateTime.now(),
      user: ReviewUser.fromJson(json['user']),
    );
  }
}

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
      name: json['name'],
      phone: json['phone'],
      created: DateTime.tryParse(json['created'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
