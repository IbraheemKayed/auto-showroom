import 'package:flutter/foundation.dart';
import 'package:sayarti/home/models/brand_model.dart';
import 'package:sayarti/home/models/car_full.dart';
import '../services/car_api_service.dart';

class CarsProvider extends ChangeNotifier {
  final CarApiService _api;
  CarsProvider(this._api);

  // =========================================================
  // 🔐 TOKEN CHECK
  // =========================================================
  bool get hasToken => _api.hasToken;

  // =========================================================
  // ❗ ERRORS
  // =========================================================
  String? adminRate5Error;
  String? priceDropError;
  String? nearbyError;

  List<BrandModel> brands = [];
bool loadingBrands = false;
String? brandsError;
  // =========================================================
  // 🔥 ADMIN RATE 5
  // =========================================================
  List<CarFull> adminRate5Cars = [];
  bool loadingAdminRate5 = false;

  Future<void> loadAdminRate5Cars({bool refresh = false}) async {
    if (!hasToken) {
      adminRate5Error = "Authentication required";
      notifyListeners();
      return;
    }

    loadingAdminRate5 = true;
    adminRate5Error = null;

    if (refresh) adminRate5Cars.clear();
    notifyListeners();

    try {
      adminRate5Cars = await _api.getAdminRate5Cars(
        limit: 8,
        random: adminRate5Cars.isEmpty,
      );
    } catch (e) {
      adminRate5Error = "Failed to load top-rated cars";
      adminRate5Cars.clear();
      if (kDebugMode) {
        print("AdminRate5Cars Error: $e");
      }
    }

    loadingAdminRate5 = false;
    notifyListeners();
  }

  // =========================================================
  // 💰 RECENT PRICE DROPS
  // =========================================================
  List<CarFull> priceDroppedCars = [];
  bool loadingPriceDropped = false;

  Future<void> loadPriceDroppedCars({bool refresh = false}) async {
    if (!hasToken) {
      priceDropError = "Authentication required";
      notifyListeners();
      return;
    }

    loadingPriceDropped = true;
    priceDropError = null;

    if (refresh) priceDroppedCars.clear();
    notifyListeners();

    try {
      priceDroppedCars = await _api.getRecentlyPriceDropped(limit: 20);
    } catch (e) {
      priceDropError = "Failed to load price dropped cars";
      priceDroppedCars.clear();
      if (kDebugMode) print("PriceDroppedCars Error: $e");
    }

    loadingPriceDropped = false;
    notifyListeners();
  }

  // =========================================================
  // 📍 NEARBY CARS
  // =========================================================
  List<CarFull> nearbyCars = [];
  bool loadingNearby = false;

  Future<void> loadNearbyCars({bool refresh = false}) async {
    if (!hasToken) {
      nearbyError = "Authentication required";
      notifyListeners();
      return;
    }

    loadingNearby = true;
    nearbyError = null;

    if (refresh) nearbyCars.clear();
    notifyListeners();

    try {
      nearbyCars = await _api.getNearbyCars(
        limit: 20,
        random: nearbyCars.isEmpty, // random فقط أول مرة
      );
    } catch (e) {
      nearbyError = "Failed to load nearby cars";
      nearbyCars.clear();
      if (kDebugMode) print("NearbyCars Error: $e");
    }

    loadingNearby = false;
    notifyListeners();
  }

 Future<void> loadBrands({bool refresh = false}) async {
  if (!hasToken) {
    brandsError = "Authentication required";
    notifyListeners();
    return;
  }

  loadingBrands = true;
  brandsError = null;

  if (refresh) brands.clear();
  notifyListeners();

  try {
    brands = await _api.getBrandsHome();
  } catch (e) {
    brandsError = "Failed to load brands";
    brands.clear();
    if (kDebugMode) print("Brands Error: $e");
  }

  loadingBrands = false;
  notifyListeners();
}

  // =========================================================
  // 🏠 LOAD HOME (SAFE)
  // =========================================================
  Future<void> loadHomeSections({bool refresh = false}) async {
  await Future.wait([
    loadBrands(refresh: refresh),          // ✅ جديد
    loadAdminRate5Cars(refresh: refresh),
    loadPriceDroppedCars(refresh: refresh),
    loadNearbyCars(refresh: refresh),
  ]);
}

void syncFavorite(int carId, bool isFavorite) {
  bool changed = false;
  void update(List<CarFull> list) {
    final i = list.indexWhere((c) => c.id == carId);
    if (i != -1 && list[i].isFavorite != isFavorite) {
      list[i] = list[i].copyWith(isFavorite: isFavorite);
      changed = true;
    }
  }
  update(adminRate5Cars);
  update(priceDroppedCars);
  update(nearbyCars);
  if (changed) notifyListeners();
}

void toggleFavorite(CarFull car) async {
  void update(List<CarFull> list) {
    final i = list.indexWhere((c) => c.id == car.id);
    if (i != -1) {
      final newVal = !list[i].isFavorite;
      list[i] = list[i].copyWith(isFavorite: newVal);
    }
  }

  update(adminRate5Cars);
  update(priceDroppedCars);
  update(nearbyCars);

  notifyListeners();

  try {
    if (!car.isFavorite) {
      await _api.addToFavorites(car.id);
    } else {
      await _api.removeFromFavorites(car.id);
    }
  } catch (_) {
    // rollback (اختياري)
  }
}


}
