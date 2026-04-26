import 'package:flutter/material.dart';
import 'package:sayarti/ai_search/models/car_brand.dart';
import 'package:sayarti/ai_search/models/city.dart';
import 'package:sayarti/ai_search/services/car_api_service.dart';
import 'package:sayarti/search/models/car_model.dart';

class SearchProvider extends ChangeNotifier {
  final CarApiService api;

  SearchProvider(this.api);

  // --------------------
  // BRANDS
  // --------------------
  List<CarBrand> brands = [];
  bool isLoadingBrands = false;
  String? error;
  CarBrand? selectedBrand; // last selected brand (used for model loading)
  final Set<int> selectedBrandIds = {};

  // --------------------
  // MILEAGE
  // --------------------
  double minMileage = 0;
  double maxMileage = 200000;

  final double mileageMinLimit = 0;
  final double mileageMaxLimit = 200000;

  // --------------------
  // ACTIONS
  // --------------------
  Future<void> loadBrands() async {
    isLoadingBrands = true;
    error = null;
    notifyListeners();

    try {
      brands = await api.getBrands();
    } catch (e) {
      error = 'Failed to load brands';
    }

    isLoadingBrands = false;
    notifyListeners();
  }

  void toggleBrand(CarBrand brand) {
    if (selectedBrandIds.contains(brand.id)) {
      // deselect
      selectedBrandIds.clear();
      selectedBrand = null;
      models.clear();
      selectedModelIds.clear();
    } else {
      // select only this one
      selectedBrandIds.clear();
      selectedBrandIds.add(brand.id);
      selectedBrand = brand;
      models.clear();
      selectedModelIds.clear();
      loadModels();
    }
    notifyListeners();
  }

  void selectBrand(CarBrand brand) {
    selectedBrandIds
      ..clear()
      ..add(brand.id);
    selectedBrand = brand;
    models.clear();
    selectedModelIds.clear();
    loadModels();
    notifyListeners();
  }

  void clearBrands() {
    selectedBrandIds.clear();
    selectedBrand = null;
    models.clear();
    selectedModelIds.clear();
    notifyListeners();
  }


  void updateMileage(RangeValues values) {
    minMileage = values.start;
    maxMileage = values.end;
    notifyListeners();
  }

  void clearMileage() {
    minMileage = mileageMinLimit;
    maxMileage = mileageMaxLimit;
    notifyListeners();
  }

  // --------------------
  // PRICE
  // --------------------
  double minPrice = 50000;
  double maxPrice = 500000;

  final double priceMinLimit = 50000;
  final double priceMaxLimit = 500000;

  double _snapPrice(double v) => (v / 10000).round() * 10000.0;

  void updatePrice(RangeValues values) {
    minPrice = _snapPrice(values.start).clamp(priceMinLimit, priceMaxLimit);
    maxPrice = _snapPrice(values.end).clamp(priceMinLimit, priceMaxLimit);
    notifyListeners();
  }

  void clearPrice() {
    minPrice = priceMinLimit;
    maxPrice = priceMaxLimit;
    notifyListeners();
  }

  // --------------------
  // MODELS
  // --------------------
  List<CarModel> models = [];
  bool isLoadingModels = false;

  final Set<int> selectedModelIds = {};
// COLORS
final Set<int> selectedInsideColorIds = {};
final Set<int> selectedOutsideColorIds = {};

void toggleInsideColor(int id) {
  selectedInsideColorIds.contains(id)
      ? selectedInsideColorIds.remove(id)
      : selectedInsideColorIds.add(id);
  notifyListeners();
}

void toggleOutsideColor(int id) {
  selectedOutsideColorIds.contains(id)
      ? selectedOutsideColorIds.remove(id)
      : selectedOutsideColorIds.add(id);
  notifyListeners();
}

void clearColors() {
  selectedInsideColorIds.clear();
  selectedOutsideColorIds.clear();
  notifyListeners();
}

  Future<void> loadModels() async {
  if (selectedBrand == null) return;

  isLoadingModels = true;
  notifyListeners();

  try {
    models = await api.getModelsByBrand(selectedBrand!.id);
  } catch (e) {
    models = [];
  }

  isLoadingModels = false;
  notifyListeners();
}


  void toggleModel(CarModel model) {
    if (selectedModelIds.contains(model.id)) {
      selectedModelIds.remove(model.id);
    } else {
      selectedModelIds.add(model.id);
    }
    notifyListeners();
  }

  void clearModels() {
    selectedModelIds.clear();
    notifyListeners();
  }

  // --------------------
// FEATURES (MORE FILTERS)
// --------------------
final Map<String, bool> features = {
  // Safety
  'abs': false,
  'traction_control': false,
  'tire_pressure_monitoring_system': false,
  'lane_departure_warning': false,
  'automatic_emergency_braking': false,
  'blind_spot_monitoring': false,
  'adaptive_cruise_control': false,

  // Parking & Visibility
  'rear_parking_sensors': false,
  'rearview_camera': false,
  'fog_lights': false,
  'led_headlights': false,
  'automatic_headlights': false,
  'rain_sensing_wipers': false,

  // Comfort & Convenience
  'panoramic_sunroof': false,
  'adaptive_climate_control': false,
  'power_windows': false,
  'power_mirrors': false,
  'heated_seats': false,
  'ventilated_seats': false,
  'keyless_entry': false,
  'push_button_start': false,
  'electric_parking_brake': false,
  'memory_electronic_adjustable_seats': false,
  'rear_ac_vents': false,

  // Technology
  'touchscreen_display': false,
  'bluetooth_connectivity': false,
  'apple_carplay': false,
  'android_auto': false,
  'usb_type_c_ports': false,
  'navigation_system_gps': false,
  'voice_control': false,
  'wireless_charging': false,
  'premium_sound_system': false,
  'drive_modes': false,
};


void toggleFeature(String key) {
  features[key] = !(features[key] ?? false);
  notifyListeners();
}

void clearFeatures() {
  for (final key in features.keys) {
    features[key] = false;
  }
  notifyListeners();
}

int selectedFeaturesCount() {
  return features.values.where((v) => v).length;
}


  void reset() {
    selectedBrand = null;
    selectedBrandIds.clear();

    models.clear();
    selectedModelIds.clear();

    clearMileage();
    clearPrice();
    clearFeatures();
    clearColors();
    clearYear();
    clearCities();
    clearGearTypes();
    clearFuelType();

    notifyListeners();
  }




  Map<String, dynamic> buildSearchParams() {
  final Map<String, dynamic> params = {};

  // ===== BRAND =====
  if (selectedBrandIds.isNotEmpty) {
    params['car_brand_id'] = selectedBrandIds.first;
  }

  // ===== MODEL (API يدعم واحد فقط) =====
  if (selectedModelIds.isNotEmpty) {
    params['car_model_id'] = selectedModelIds.first;
  }

  // ===== PRICE =====
  if (minPrice != priceMinLimit || maxPrice != priceMaxLimit) {
    params['min_price'] = minPrice.toInt();
    params['max_price'] = maxPrice.toInt();
  }

  // ===== MILEAGE =====
  if (minMileage != mileageMinLimit || maxMileage != mileageMaxLimit) {
    params['min_mileage'] = minMileage.toInt();
    params['max_mileage'] = maxMileage.toInt();
  }

  // ===== YEARS =====
  if (minYear != yearMinLimit || maxYear != yearMaxLimit) {
    params['min_year'] = minYear.toInt();
    params['max_year'] = maxYear.toInt();
  }

  // ===== COLORS (API يدعم واحد فقط) =====
  if (selectedInsideColorIds.isNotEmpty) {
    params['car_inside_color_id'] = selectedInsideColorIds.first;
  }

  if (selectedOutsideColorIds.isNotEmpty) {
    params['car_outside_color_id'] = selectedOutsideColorIds.first;
  }

  // ===== GEAR TYPE =====
  if (selectedGearTypes.length == 1) {
    params['gear_type'] = selectedGearTypes.first;
  }

  // ===== FUEL TYPE =====
  if (selectedFuelTypeId != null) {
    params['car_fuel_type_id'] = selectedFuelTypeId;
  }

  // ===== FEATURES =====
  for (final entry in features.entries) {
    if (entry.value == true) {
      params[entry.key] = true;
    }
  }

  return params;
}

// ===================
// CITIES
// ===================
List<CityModel> cities = [];
bool isLoadingCities = false;

final Set<int> selectedCityIds = {};

Future<void> loadCities() async {
  if (cities.isNotEmpty) return; // 🔒 load مرة واحدة

  isLoadingCities = true;
  notifyListeners();

  try {
    cities = await api.getCities();
  } catch (e) {
    cities = [];
  }

  isLoadingCities = false;
  notifyListeners();
}

void toggleCity(int id) {
  selectedCityIds.contains(id)
      ? selectedCityIds.remove(id)
      : selectedCityIds.add(id);
  notifyListeners();
}

void clearCities() {
  selectedCityIds.clear();
  notifyListeners();
}




bool hasActiveFilters() {
  return selectedBrand != null ||
      selectedModelIds.isNotEmpty ||
      minYear != yearMinLimit || maxYear != yearMaxLimit ||
      selectedInsideColorIds.isNotEmpty ||
      selectedOutsideColorIds.isNotEmpty ||
      minMileage != mileageMinLimit ||
      maxMileage != mileageMaxLimit ||
      minPrice != priceMinLimit ||
      maxPrice != priceMaxLimit ||
      selectedFeaturesCount() > 0;
}


// GEAR TYPE
final Set<String> selectedGearTypes = {};

void toggleGearType(String value) {
  selectedGearTypes.contains(value)
      ? selectedGearTypes.remove(value)
      : selectedGearTypes.add(value);
  notifyListeners();
}

void clearGearTypes() {
  selectedGearTypes.clear();
  notifyListeners();
}

// FUEL TYPE
int? selectedFuelTypeId;

void setFuelTypeId(int? id) {
  selectedFuelTypeId = id;
  notifyListeners();
}

void clearFuelType() {
  selectedFuelTypeId = null;
  notifyListeners();
}

// YEARS
final double yearMinLimit = 1980;
final double yearMaxLimit = 2027;
double minYear = 1980;
double maxYear = 2027;

void updateYear(RangeValues values) {
  minYear = values.start.roundToDouble();
  maxYear = values.end.roundToDouble();
  notifyListeners();
}

void clearYear() {
  minYear = yearMinLimit;
  maxYear = yearMaxLimit;
  notifyListeners();
}


}
