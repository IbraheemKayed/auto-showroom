import 'package:flutter/material.dart';
import 'package:sayarti/ai_search/services/car_api_service.dart';
import 'package:sayarti/home/models/car_full.dart';
import 'package:sayarti/home/services/filter_cars_params.dart';
import 'package:sayarti/search/providers/search_provider.dart';

class SearchCarsProvider extends ChangeNotifier {
  final CarApiService api;
   SearchProvider search;

  SearchCarsProvider(this.api, this.search);

  // --------------------
  // STATE
  // --------------------
  List<CarFull> cars = [];
  bool loading = false;
  bool hasNext = true;
  int totalCount = 0;
  bool _isFetchingCount = false;

  FilterCarsParams? _params;

  // --------------------
  // 🔥 DEALER MODE STATE (NEW)
  // --------------------
  bool dealerMode = false;
  int? dealerShowroomId;

  // --------------------
  // RESULT SORT/FILTER STATE
  // --------------------
  String resultSortBy = 'id';
  String resultSortOrder = 'desc';
  String resultDateFilter = 'anytime';
  double? resultMinPrice;
  double? resultMaxPrice;

  String get resultSortKey {
    if (resultSortBy == 'price' && resultSortOrder == 'desc') return 'priceHighLow';
    if (resultSortBy == 'price' && resultSortOrder == 'asc') return 'priceLowHigh';
    if (resultSortBy == 'created') return 'datePosted';
    return 'relevance';
  }

  // --------------------
  // PUBLIC - NORMAL SEARCH
  // --------------------
  Future<void> searchCars({bool reset = false}) async {
    if (loading) return;
    if (!hasNext && !reset) return;

    if (reset) {
      _buildParams(saveHistory: true);
      cars.clear();
      hasNext = true;
    }

    if (_params == null) return;

    loading = true;
    notifyListeners();

    try {
      final res = await api.filterCars(_params!);

      cars.addAll(res.cars);
      hasNext = res.hasNext;
      totalCount = res.totalCount;
      _params!.offset += _params!.limit;
    } catch (e) {
      debugPrint('SearchCarsProvider error: $e');
    }

    loading = false;
    notifyListeners();
  }

  // --------------------
  // FETCH COUNT ONLY (lightweight - no car list change)
  // --------------------
  Future<void> fetchCount() async {
    if (_isFetchingCount) return;
    _isFetchingCount = true;

    final p = _buildCountParams();
    if (p == null) {
      _isFetchingCount = false;
      return;
    }

    try {
      final res = await api.filterCars(p);
      totalCount = res.totalCount;
      notifyListeners();
    } catch (e) {
      debugPrint('fetchCount error: $e');
    }

    _isFetchingCount = false;
  }

  // builds params for count only (local, doesn't touch _params)
  FilterCarsParams? _buildCountParams() {
    final p = FilterCarsParams();
    p.limit = 1;
    p.offset = 0;
    p.sortBy = 'id';
    p.sortOrder = 'desc';

    if (dealerMode && dealerShowroomId != null) {
      p.carShowroomId = dealerShowroomId;
      p.carStatuses = ['PENDING', 'APPROVED'];
      return p;
    }

    p.carBrandId = search.selectedBrand?.id;

    if (search.selectedModelIds.isNotEmpty) {
      p.carModelIds = search.selectedModelIds.toList();
    }
    if (search.minPrice != search.priceMinLimit || search.maxPrice != search.priceMaxLimit) {
      p.minPrice = search.minPrice;
      p.maxPrice = search.maxPrice;
    }
    if (search.minMileage != search.mileageMinLimit || search.maxMileage != search.mileageMaxLimit) {
      p.minMileage = search.minMileage.toInt();
      p.maxMileage = search.maxMileage.toInt();
    }
    if (search.minYear != search.yearMinLimit || search.maxYear != search.yearMaxLimit) {
      p.minYear = search.minYear.toInt();
      p.maxYear = search.maxYear.toInt();
    }
    if (search.selectedCityIds.isNotEmpty) {
      p.selectedCityIds = search.selectedCityIds.toList();
    }
    if (search.selectedInsideColorIds.isNotEmpty) {
      p.insideColorIds = search.selectedInsideColorIds.toList();
    }
    if (search.selectedOutsideColorIds.isNotEmpty) {
      p.outsideColorIds = search.selectedOutsideColorIds.toList();
    }
    // ---------- GEAR TYPE ----------
    if (search.selectedGearTypes.length == 1) {
      p.gearType = search.selectedGearTypes.first;
    }

    // ---------- FUEL TYPE ----------
    if (search.selectedFuelTypeId != null) {
      p.carFuelTypeId = search.selectedFuelTypeId;
    }

    p.features = Map.fromEntries(
      search.features.entries.where((e) => e.value),
    );

    return p;
  }

  // --------------------
  // 🔥 PUBLIC - DEALER LISTINGS
  // --------------------
  Future<void> fetchDealerListings({
    required int showroomId,
    bool reset = true,
  }) async {
    dealerMode = true;
    dealerShowroomId = showroomId;

    await searchCars(reset: reset);
  }

  // --------------------
  // BUILD PARAMS (🔥 المهم)
  // --------------------
  void _buildParams({bool saveHistory = false}) {
    final p = FilterCarsParams();

    // =================================================
    // 🟦 DEALER MODE (ONLY ADDITION)
    // =================================================
    if (dealerMode && dealerShowroomId != null) {
      p.carShowroomId = dealerShowroomId;

      // الديلر يشوف سياراته سواء approved أو pending
      p.carStatuses = ['PENDING', 'APPROVED'];

      // pagination
      p.offset = 0;
      p.limit = 20;

      // sorting
      p.sortBy = 'id';
      p.sortOrder = 'desc';

      _params = p;
      return;
    }

    // =================================================
    // 🔍 NORMAL SEARCH MODE (OLD LOGIC - UNTOUCHED)
    // =================================================

    // ---------- BRAND ----------
    p.carBrandId = search.selectedBrand?.id;

    // ---------- MODELS ----------
    if (search.selectedModelIds.isNotEmpty) {
      p.carModelIds = search.selectedModelIds.toList();
    }

    // ---------- PRICE ----------
    if (search.minPrice != search.priceMinLimit ||
        search.maxPrice != search.priceMaxLimit) {
      p.minPrice = search.minPrice;
      p.maxPrice = search.maxPrice;
    }

    // ---------- MILEAGE ----------
    if (search.minMileage != search.mileageMinLimit ||
        search.maxMileage != search.mileageMaxLimit) {
      p.minMileage = search.minMileage.toInt();
      p.maxMileage = search.maxMileage.toInt();
    }

    // ---------- YEARS ----------
    if (search.minYear != search.yearMinLimit || search.maxYear != search.yearMaxLimit) {
      p.minYear = search.minYear.toInt();
      p.maxYear = search.maxYear.toInt();
    }

    // ---------- CITIES ----------
    if (search.selectedCityIds.isNotEmpty) {
      p.selectedCityIds = search.selectedCityIds.toList();
    }

    // ---------- COLORS ----------
    if (search.selectedInsideColorIds.isNotEmpty) {
      p.insideColorIds = search.selectedInsideColorIds.toList();
    }

    if (search.selectedOutsideColorIds.isNotEmpty) {
      p.outsideColorIds = search.selectedOutsideColorIds.toList();
    }

    // ---------- GEAR TYPE ----------
    if (search.selectedGearTypes.length == 1) {
      p.gearType = search.selectedGearTypes.first;
    }

    // ---------- FUEL TYPE ----------
    if (search.selectedFuelTypeId != null) {
      p.carFuelTypeId = search.selectedFuelTypeId;
    }

    // ---------- FEATURES ----------
    p.features = Map.fromEntries(
      search.features.entries.where((e) => e.value),
    );

    // ---------- PAGINATION ----------
    p.offset = 0;
    p.limit = 20;

    // ---------- SORT ----------
    p.sortBy = resultSortBy;
    p.sortOrder = resultSortOrder;

    // ---------- RESULT PRICE OVERRIDE ----------
    if (resultMinPrice != null) p.minPrice = resultMinPrice;
    if (resultMaxPrice != null) p.maxPrice = resultMaxPrice;

    // ---------- SAVE SEARCH ----------
    if (saveHistory) {
      p.saveAsSearchHistory = true;
    }

    _params = p;
  }

  // --------------------
  // HISTORY SEARCH
  // --------------------
  Future<void> searchWithRawParams(Map<String, dynamic> rawParams) async {
    if (loading) return;

    dealerMode = false;
    dealerShowroomId = null;
    cars.clear();
    hasNext = true;
    totalCount = 0;

    _params = _paramsFromMap(rawParams);

    loading = true;
    notifyListeners();

    try {
      final res = await api.filterCars(_params!);
      cars.addAll(res.cars);
      hasNext = res.hasNext;
      totalCount = res.totalCount;
      _params!.offset += _params!.limit;
    } catch (e) {
      debugPrint('searchWithRawParams error: $e');
    }

    loading = false;
    notifyListeners();
  }

  FilterCarsParams _paramsFromMap(Map<String, dynamic> m) {
    final p = FilterCarsParams();

    p.carBrandId = m['car_brand_id'] as int?;

    final modelIds = m['car_model_id'];
    if (modelIds is List) {
      p.carModelIds = modelIds.map((e) => (e as num).toInt()).toList();
    }

    final minPrice = m['min_price'];
    if (minPrice != null) p.minPrice = (minPrice as num).toDouble();
    final maxPrice = m['max_price'];
    if (maxPrice != null) p.maxPrice = (maxPrice as num).toDouble();

    final minMileage = m['min_mileage'];
    if (minMileage != null) p.minMileage = (minMileage as num).toInt();
    final maxMileage = m['max_mileage'];
    if (maxMileage != null) p.maxMileage = (maxMileage as num).toInt();

    final minYear = m['min_year'];
    if (minYear != null) p.minYear = (minYear as num).toInt();
    final maxYear = m['max_year'];
    if (maxYear != null) p.maxYear = (maxYear as num).toInt();

    final cityIds = m['city_ids'];
    if (cityIds is List) {
      p.selectedCityIds = cityIds.map((e) => (e as num).toInt()).toList();
    }

    final outsideColors = m['car_outside_color_id'];
    if (outsideColors is List) {
      p.outsideColorIds = outsideColors.map((e) => (e as num).toInt()).toList();
    }

    final insideColors = m['car_inside_color_id'];
    if (insideColors is List) {
      p.insideColorIds = insideColors.map((e) => (e as num).toInt()).toList();
    }

    const nonFeatureKeys = {
      'car_brand_id', 'car_model_id', 'min_price', 'max_price',
      'min_mileage', 'max_mileage', 'min_year', 'max_year', 'city_ids',
      'city_id', 'car_outside_color_id', 'car_inside_color_id',
      'sort_by', 'sort_order', 'offset', 'limit', 'save_as_search_history',
      'car_showroom_id', 'car_statuses', 'is_sold',
    };
    for (final entry in m.entries) {
      if (!nonFeatureKeys.contains(entry.key) && entry.value == true) {
        p.features[entry.key] = true;
      }
    }

    p.offset = 0;
    p.limit = 20;
    p.sortBy = m['sort_by'] as String? ?? 'id';
    p.sortOrder = m['sort_order'] as String? ?? 'desc';

    return p;
  }

  // --------------------
  // CLEAR (IMPORTANT)
  // --------------------
  void clear() {
    cars.clear();
    hasNext = true;
    totalCount = 0;
    _params = null;

    // 🔥 reset dealer mode
    dealerMode = false;
    dealerShowroomId = null;

    resultSortBy = 'id';
    resultSortOrder = 'desc';
    resultDateFilter = 'anytime';
    resultMinPrice = null;
    resultMaxPrice = null;

    notifyListeners();
  }

  // --------------------
  // FAVORITES (OLD)
  // --------------------
  Future<void> toggleFavorite(CarFull car) async {
    final index = cars.indexWhere((c) => c.id == car.id);
    if (index == -1) return;

    final newValue = !cars[index].isFavorite;

    // optimistic update
    cars[index] = cars[index].copyWith(isFavorite: newValue);
    notifyListeners();

    try {
      if (newValue) {
        await api.addToFavorites(car.id);
      } else {
        await api.removeFromFavorites(car.id);
      }
    } catch (e) {
      // rollback
      cars[index] = cars[index].copyWith(isFavorite: !newValue);
      notifyListeners();
    }
  }
}
