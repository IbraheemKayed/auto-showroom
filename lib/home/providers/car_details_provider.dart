import 'package:flutter/material.dart';
import 'package:sayarti/ai_search/services/car_api_service.dart';
import 'package:sayarti/home/models/car_details.dart';
import 'package:sayarti/home/models/car_full.dart';

class CarDetailsProvider extends ChangeNotifier {
  final CarApiService api;
  final void Function(int carId, bool isFavorite)? onFavoriteChanged;

  CarDetailsProvider(this.api, {this.onFavoriteChanged});

  CarDetails? car;
  bool loading = false;
  String? error;

  bool get isFavorite => car?.base.isFavorite ?? false;
  bool get isSold => car?.base.isSold ?? false;

  bool _markingSold = false;
  bool get markingSold => _markingSold;

  Future<bool> markAsSold() async {
    if (car == null || _markingSold) return false;
    _markingSold = true;
    notifyListeners();
    try {
      await api.markAsSold(car!.base.id);
      car = CarDetails(
        base: car!.base.copyWith(isSold: true),
        feature: car!.feature,
        showroom: car!.showroom,
      );
      _markingSold = false;
      notifyListeners();
      return true;
    } catch (_) {
      _markingSold = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> toggleFavorite() async {
    if (car == null) return;

    final original = car!;
    final newValue = !original.base.isFavorite;

    // Optimistic update
    car = CarDetails(
      base: original.base.copyWith(isFavorite: newValue),
      feature: original.feature,
      showroom: original.showroom,
    );
    notifyListeners();
    onFavoriteChanged?.call(original.base.id, newValue);

    try {
      if (newValue) {
        await api.addToFavorites(original.base.id);
      } else {
        await api.removeFromFavorites(original.base.id);
      }
    } catch (_) {
      car = original;
      notifyListeners();
      onFavoriteChanged?.call(original.base.id, original.base.isFavorite);
    }
  }

 /// Pre-populate from an already-loaded CarFull (e.g. dealer listings).
  /// This lets the screen render immediately; loadCar() will upgrade it with
  /// full API data (features, showroom stats, price history).
  void preload(CarFull carFull) {
    car = CarDetails(base: carFull, feature: null, showroom: null);
    error = null;
    notifyListeners();
  }

 /// Reload silently (no skeleton, keeps existing car visible while refreshing).
  Future<void> refreshCar(int carId) async {
    if (loading) return;
    loading = true;
    // Don't clear car — screen stays rendered with old data
    notifyListeners();

    try {
      final carJson = await api.getCarById(carId);
      car = CarDetails.fromJson(carJson);
    } catch (_) {}

    loading = false;
    notifyListeners();
  }

 Future<void> loadCar(int carId) async {
  if (loading) return;
  loading = true;
  error = null;
  notifyListeners();

  try {
    final carJson = await api.getCarById(carId);
    car = CarDetails.fromJson(carJson);
  } catch (e) {
    debugPrint('LOAD CAR ERROR: $e');
    // If we already have pre-loaded data, keep it and clear the error
    // so the screen still renders with what we have.
    if (car == null) {
      error = 'Failed to load car details';
    }
  }

  loading = false;
  notifyListeners();
}




}
