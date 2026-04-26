import 'package:flutter/material.dart';
import 'package:sayarti/ai_search/services/car_api_service.dart';
import 'package:sayarti/home/models/car_full.dart';
import 'package:sayarti/home/models/filter_car.dart';
import 'package:sayarti/home/services/filter_cars_params.dart';

class CarsFilterProvider extends ChangeNotifier {
  final CarApiService api;

  CarsFilterProvider(this.api);

  final params = FilterCarsParams();

  List<CarFull> cars = [];
  bool loading = false;
  bool hasNext = true;
  int totalCount = 0;

  Future<void> load({bool reset = false}) async {
    if (loading) return;
    if (!hasNext && !reset) return;

    if (reset) {
      params.offset = 0;
      cars.clear();
      hasNext = true;
    }

    loading = true;
    notifyListeners();

    try {
      final res = await api.filterCars(params);

      cars.addAll(res.cars);
      hasNext = res.hasNext;
      totalCount = res.totalCount;
      params.offset += params.limit;
    } catch (e) {
      debugPrint('CarsFilterProvider error: $e');
    }

    loading = false;
    notifyListeners();
  }
}
