import 'package:flutter/material.dart';
import 'package:sayarti/ai_search/services/car_api_service.dart';
import 'package:sayarti/home/models/showroom.dart';

class ShowroomProvider extends ChangeNotifier {
  final CarApiService api;

  ShowroomProvider(this.api);

  Showroom? showroom;
  bool loading = false;
  String? error;

  Future<void> loadShowroom(int id) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      showroom = await api.getShowroomById(id);
    } catch (e) {
      error = 'Failed to load showroom';
    }

    loading = false;
    notifyListeners();
  }
}
