import 'package:sayarti/home/models/showroom_review.dart';

class ShowroomReviewsResponse {
  final List<ShowroomReview> reviews;
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;

  ShowroomReviewsResponse({
    required this.reviews,
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
  });

  factory ShowroomReviewsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    final rawList = (data?['reviews'] as List? ?? []);
    return ShowroomReviewsResponse(
      reviews: rawList
          .map((e) => ShowroomReview.fromJson(e as Map<String, dynamic>))
          .where((r) => r.status == 'APPROVED')
          .toList(),
      total: json['total'] ?? 0,
      perPage: json['per_page'] ?? 20,
      currentPage: json['current_page'] ?? 0,
      lastPage: json['last_page'] ?? 0,
    );
  }
}
