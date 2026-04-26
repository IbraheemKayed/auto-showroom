import 'package:flutter/material.dart';
import 'package:sayarti/ai_search/services/car_api_service.dart';
import 'package:sayarti/home/models/showroom.dart';

class DealerSearchProvider extends ChangeNotifier {
  final CarApiService api;

  DealerSearchProvider(this.api);

  List<Showroom> showrooms = [];
  bool isLoading = false;
  bool hasMore = true;

  String searchTerm = '';
  int offset = 0;
  final int limit = 3;

  Future<void> search({bool reset = false}) async {
    if (isLoading) return;

    if (reset) {
      offset = 0;
      hasMore = true;
      showrooms.clear();
    }

    isLoading = true;
    notifyListeners();

    final res = await api.getShowrooms(
      searchTerm: searchTerm,
      offset: offset,
      limit: limit,
    );

    showrooms.addAll(res.showrooms);
    offset += limit;
    hasMore = offset < res.total;

    isLoading = false;
    notifyListeners();
  }

  void updateSearch(String value) {
    searchTerm = value;
    search(reset: true);
  }
}
