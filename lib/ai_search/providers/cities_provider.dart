import 'package:flutter/material.dart';
import 'package:sayarti/ai_search/models/city.dart';
import 'package:sayarti/ai_search/services/car_api_service.dart';

class CitiesProvider extends ChangeNotifier {
  final CarApiService api;

  CitiesProvider(this.api);

  List<CityModel> cities = [];
  bool loading = false;
  String? error;

  Future<void> loadCities() async {
    loading = true;
    notifyListeners();

    try {
      cities = await api.getCities();
      error = null;
    } catch (e) {
      error = 'Failed to load cities';
    }

    loading = false;
    notifyListeners();
  }

  CityModel? getCityById(int? id) {
    if (id == null) return null;
    try {
      return cities.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
