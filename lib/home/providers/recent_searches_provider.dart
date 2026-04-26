import 'package:flutter/material.dart';
import 'package:sayarti/ai_search/services/car_api_service.dart';
import 'package:sayarti/home/models/recent_search.dart';

class RecentSearchesProvider extends ChangeNotifier {
  final CarApiService _api;

  RecentSearchesProvider(this._api);

  List<RecentSearch> searches = [];
  bool loading = false;

  Future<void> load() async {
    if (loading) return;
    loading = true;
    notifyListeners();

    try {
      final raw = await _api.getSearchHistory();
      searches = raw.map((m) => RecentSearch.fromJson(m)).toList();
    } catch (e) {
      debugPrint('RecentSearchesProvider load error: $e');
      searches = [];
    }

    loading = false;
    notifyListeners();
  }

  void remove(int index) {
    if (index < 0 || index >= searches.length) return;
    searches.removeAt(index);
    notifyListeners();
  }

  void clear() {
    searches.clear();
    notifyListeners();
  }
}
