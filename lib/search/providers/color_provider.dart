import 'package:flutter/material.dart';
import 'package:sayarti/ai_search/services/car_api_service.dart';
import 'package:sayarti/search/models/car_color.dart';

class CarColorsProvider extends ChangeNotifier {
  final CarApiService api;

  CarColorsProvider(this.api);

  List<CarColor> insideColors = [];
  List<CarColor> outsideColors = [];

  bool loading = false;

  List<CarColor> _dedupe(List<CarColor> list) {
    final seen = <String>{};
    return list.where((c) => seen.add(c.name.trim().toUpperCase())).toList();
  }

  Future<void> load() async {
    if (insideColors.isNotEmpty || loading) return;

    loading = true;
    notifyListeners();

    try {
      final insideRes = await api.getInsideColors();
      final outsideRes = await api.getOutsideColors();

      insideColors = _dedupe(insideRes);
      outsideColors = _dedupe(outsideRes);
    } catch (_) {}

    loading = false;
    notifyListeners();
  }
}
