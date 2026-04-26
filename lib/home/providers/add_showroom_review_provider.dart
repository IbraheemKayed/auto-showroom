import 'package:flutter/material.dart';
import 'package:sayarti/ai_search/services/car_api_service.dart';

class AddShowroomReviewProvider extends ChangeNotifier {
  final CarApiService api;

  AddShowroomReviewProvider(this.api);

  bool loading = false;
  String? error;

  Future<bool> submitReview({
    required int showroomId,
    String? review,
    int? rate,
  }) async {
    if ((review == null || review.isEmpty) && rate == null) {
      error = 'Please add rating or review';
      notifyListeners();
      return false;
    }

    loading = true;
    error = null;
    notifyListeners();

    try {
      await api.createShowroomReview(
        showroomId: showroomId,
        review: review,
        rate: rate,
      );

      loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      loading = false;
      error = _mapError(e.toString());
      notifyListeners();
      return false;
    }
  }

  String _mapError(String raw) {
    if (raw.contains('409')) {
      return 'You already reviewed this showroom';
    }
    if (raw.contains('400')) {
      return 'Invalid review data';
    }
    if (raw.contains('401')) {
      return 'Please login first';
    }
    return 'Failed to submit review';
  }
}
