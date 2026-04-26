import 'package:flutter/foundation.dart';

import 'package:sayarti/home/models/car_full.dart';
import 'package:sayarti/home/services/filter_cars_params.dart';
import 'package:sayarti/ai_search/models/car_category.dart';
import 'package:sayarti/ai_search/models/brand_country.dart';
import 'package:sayarti/ai_search/models/fuel_type.dart';
import 'package:sayarti/ai_search/models/city.dart';

import '../services/car_api_service.dart';

class PreferencesProvider extends ChangeNotifier {
  final CarApiService _api;
  PreferencesProvider(this._api);

  // ==================================================
  // 🔐 TOKEN CHECK
  // ==================================================
  bool get hasToken => _api.hasToken;

  // ==================================================
  // 📂 CATEGORIES
  // ==================================================
  List<CarCategory> categories = [];
  bool isLoadingCategories = false;
  String? categoriesError;
  final Set<int> selectedCategoryIds = {};


   void setAuthToken(String token) {
    _api.setToken(token);
  }

  Future<void> loadCategories() async {
    if (!hasToken || categories.isNotEmpty) return;

    isLoadingCategories = true;
    categoriesError = null;
    notifyListeners();

    try {
      categories = await _api.getCarCategories();
    } catch (_) {
      categoriesError = "Failed to load categories";
    }

    isLoadingCategories = false;
    notifyListeners();
  }

  void toggleCategory(int id) {
    selectedCategoryIds.contains(id)
        ? selectedCategoryIds.remove(id)
        : selectedCategoryIds.add(id);
    notifyListeners();
  }

  // ==================================================
  // 🌍 BRAND COUNTRIES
  // ==================================================
  List<BrandCountry> countries = [];
  bool isLoadingCountries = false;
  String? countriesError;

  final Set<int> selectedCountryIds = {};
  bool noCountryPreference = false;

  Future<void> loadBrandCountries() async {
    if (!hasToken || countries.isNotEmpty) return;

    isLoadingCountries = true;
    countriesError = null;
    notifyListeners();

    try {
      countries = await _api.getBrandCountries();
    } catch (_) {
      countriesError = "Failed to load brand countries";
    }

    isLoadingCountries = false;
    notifyListeners();
  }

  void toggleCountry(int id) {
    noCountryPreference = false;

    selectedCountryIds.contains(id)
        ? selectedCountryIds.remove(id)
        : selectedCountryIds.add(id);

    notifyListeners();
  }

  void selectNoCountryPreference() {
    noCountryPreference = true;
    selectedCountryIds.clear();
    notifyListeners();
  }

  // ==================================================
  // ⛽ FUEL TYPES
  // ==================================================
  List<FuelType> fuelTypes = [];
  bool isLoadingFuelTypes = false;
  String? fuelError;
  final Set<int> selectedFuelIds = {};

  Future<void> loadFuelTypes() async {
    if (!hasToken || fuelTypes.isNotEmpty) return;

    isLoadingFuelTypes = true;
    fuelError = null;
    notifyListeners();

    try {
      fuelTypes = await _api.getFuelTypes();
    } catch (_) {
      fuelError = "Failed to load fuel types";
    }

    isLoadingFuelTypes = false;
    notifyListeners();
  }

  void toggleFuel(int id) {
    selectedFuelIds.contains(id)
        ? selectedFuelIds.remove(id)
        : selectedFuelIds.add(id);
    notifyListeners();
  }

  // ==================================================
  // 🏙️ CITIES
  // ==================================================
  List<CityModel> cities = [];
  bool isLoadingCities = false;
  String? citiesError;
  int? selectedCityId;

  Future<void> loadCities() async {
    if (cities.isNotEmpty) return;

    isLoadingCities = true;
    citiesError = null;
    notifyListeners();

    try {
      cities = await _api.getCities();
    } catch (_) {
      citiesError = "Failed to load cities";
    }

    isLoadingCities = false;
    notifyListeners();
  }

  void selectCity(int id) {
    selectedCityId = id;
    notifyListeners();
  }

  // ==================================================
  // 💰 PRICE RANGE
  // ==================================================
  final double minPrice = 50000;
  final double maxPrice = 500000;

  double selectedMinPrice = 50000;
  double selectedMaxPrice = 500000;

  double _snapPrice(double v) => (v / 10000).round() * 10000.0;

  void setPriceRange(double min, double max) {
    selectedMinPrice = _snapPrice(min).clamp(minPrice, maxPrice);
    selectedMaxPrice = _snapPrice(max).clamp(minPrice, maxPrice);
    notifyListeners();
  }

  // ==================================================
  // 🔍 SEARCH
  // ==================================================
  bool isSearching = false;
  List<CarFull> results = [];
  List<CarFull> _allResults = [];
  List<CarFull> displayedResults = [];
  String? searchError;

  // Result sort/filter state
  String resultSortOption = 'relevance';
  String resultDateFilter = 'anytime';
  double? resultMinPrice;
  double? resultMaxPrice;

  Future<void> searchCars() async {
    if (!hasToken) {
      searchError = "Authentication required";
      notifyListeners();
      return;
    }

    isSearching = true;
    searchError = null;
    results.clear();
    notifyListeners();

    try {
      final params = FilterCarsParams()
        ..categoryId = selectedCategoryIds.isNotEmpty ? selectedCategoryIds.first : null
        ..carFuelTypeId = selectedFuelIds.isNotEmpty ? selectedFuelIds.first : null
        ..carStatuses = ['APPROVED']
        ..limit = 50;

      // Only apply price filter if user changed from defaults
      if (selectedMinPrice != minPrice || selectedMaxPrice != maxPrice) {
        params.minPrice = selectedMinPrice;
        params.maxPrice = selectedMaxPrice;
      }

      debugPrint('AI search params: ${params.toQuery()}');
      final response = await _api.filterCars(params);
      results = response.cars;
      _allResults = List<CarFull>.from(response.cars);
      displayedResults = List<CarFull>.from(response.cars);
    } catch (e) {
      searchError = "Failed to search cars";
      debugPrint('AI search error: $e');
    }

    isSearching = false;
    notifyListeners();
  }

  void applyResultFilters({
    required String sort,
    required String date,
    double? min,
    double? max,
  }) {
    resultSortOption = sort;
    resultDateFilter = date;
    resultMinPrice = min;
    resultMaxPrice = max;
    _applyDisplayFilters();
    notifyListeners();
  }

  void _applyDisplayFilters() {
    var filtered = List<CarFull>.from(_allResults);

    if (resultMinPrice != null) {
      filtered = filtered.where((c) => c.price >= resultMinPrice!).toList();
    }
    if (resultMaxPrice != null) {
      filtered = filtered.where((c) => c.price <= resultMaxPrice!).toList();
    }

    final now = DateTime.now();
    DateTime? cutoff;
    switch (resultDateFilter) {
      case 'week':  cutoff = now.subtract(const Duration(days: 7)); break;
      case '30d':   cutoff = now.subtract(const Duration(days: 30)); break;
      case '90d':   cutoff = now.subtract(const Duration(days: 90)); break;
      case '6m':    cutoff = now.subtract(const Duration(days: 180)); break;
      case 'year':  cutoff = now.subtract(const Duration(days: 365)); break;
    }
    if (cutoff != null) {
      filtered = filtered.where((c) {
        final d = c.listedAt;
        return d != null && d.isAfter(cutoff!);
      }).toList();
    }

    switch (resultSortOption) {
      case 'datePosted':
        filtered.sort((a, b) {
          final da = a.listedAt, db = b.listedAt;
          if (da == null && db == null) return 0;
          if (da == null) return 1;
          if (db == null) return -1;
          return db.compareTo(da);
        });
        break;
      case 'priceHighLow':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'priceLowHigh':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
    }

    displayedResults = filtered;
  }

  // ==================================================
  // 🔄 RESET
  // ==================================================
  void resetAll() {
    selectedCategoryIds.clear();
    selectedCountryIds.clear();
    selectedFuelIds.clear();
    selectedCityId = null;

    noCountryPreference = false;
    selectedMinPrice = 50000;
    selectedMaxPrice = 500000;

    results.clear();
    _allResults = [];
    displayedResults = [];
    resultSortOption = 'relevance';
    resultDateFilter = 'anytime';
    resultMinPrice = null;
    resultMaxPrice = null;
    notifyListeners();
  }
}
