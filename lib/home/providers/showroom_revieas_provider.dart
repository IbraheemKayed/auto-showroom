import 'package:flutter/material.dart';
import 'package:sayarti/ai_search/services/car_api_service.dart';
import 'package:sayarti/home/models/showroom_review.dart';

class ShowroomReviewsProvider extends ChangeNotifier {
  final CarApiService api;
  final int showroomId;

  ShowroomReviewsProvider({
    required this.api,
    required this.showroomId,
  });

  final List<ShowroomReview> reviews = [];
  bool loading = false;
  bool hasMore = true;

  int _offset = 0;
  final int _limit = 20;

  Future<void> load({bool reset = true}) async {
    if (loading) return;

    if (reset) {
      _offset = 0;
      reviews.clear();
      hasMore = true;
    }

    loading = true;
    notifyListeners();

    try {
      final res = await api.getShowroomReviews(
        showroomId: showroomId,
        limit: _limit,
        offset: _offset,
      );
      reviews.addAll(res.reviews);
      _offset += _limit;
      hasMore = reviews.length < res.total;
    } catch (e) {
      print(e.toString());
      hasMore = false;
    }

    loading = false;
    notifyListeners();
  }
}
