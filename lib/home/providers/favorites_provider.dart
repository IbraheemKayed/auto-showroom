import 'package:flutter/material.dart';
import 'package:sayarti/ai_search/services/car_api_service.dart';
import 'package:sayarti/home/models/car_full.dart';

class FavoritesProvider extends ChangeNotifier {
  final CarApiService api;
  FavoritesProvider(this.api);

  final List<CarFull> favorites = [];
  final Set<int> _removedIds = {};
  bool loading = false;
  bool hasNext = true;
  int page = 0;

  bool wasRemoved(int id) => _removedIds.contains(id);

  List<CarFull> get cars => favorites;

  // =========================
  // LOAD FAVORITES (PAGINATED)
  // =========================
 Future<void> loadFavorites({bool reset = false}) async {
  if (loading) return;

  if (reset) {
    favorites.clear();
    _removedIds.clear();
    page = 0;
    hasNext = true;
    notifyListeners();
  }

  if (!hasNext) return;

  loading = true;
  notifyListeners();

  try {
    final res = await api.getFavoriteCars(
      offset: page * 20,
      limit: 20,
    );

    final List list = res['cars'] ?? [];
    final int total = (res['total'] as int?) ?? 0;

    final fetched = list
        .map((e) => CarFull.fromJson(e))
        .toList();

    favorites.addAll(fetched);

    hasNext = favorites.length < total;
    page++;
  } catch (e) {
    debugPrint('LOAD FAVORITES ERROR: $e');
  }

  loading = false;
  notifyListeners();
}



  // =========================
  // REMOVE FAVORITE (LIVE)
  // =========================
  Future<void> removeFavorite(int carId) async {
    final index = favorites.indexWhere((c) => c.id == carId);
    if (index == -1) return;

    final removedCar = favorites[index];
    favorites.removeAt(index);
    _removedIds.add(carId);
    notifyListeners();

    try {
      await api.removeFromFavorites(carId);
    } catch (e) {
      // rollback لو فشل
      favorites.insert(index, removedCar);
      notifyListeners();
    }
  }
}
