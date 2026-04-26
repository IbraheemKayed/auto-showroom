import 'package:flutter/material.dart';
import 'package:sayarti/ai_search/services/car_api_service.dart';
import 'package:sayarti/home/models/car_full.dart';
import 'package:sayarti/home/services/filter_cars_params.dart';

/// Wraps a car with its known status (APPROVED / PENDING / REJECTED)
class DealerCarItem {
  final CarFull car;
  final String status; // 'APPROVED' | 'PENDING' | 'REJECTED'

  const DealerCarItem({required this.car, required this.status});
}

enum DealerSortOption {
  relevance,
  datePosted,
  priceHighLow,
  priceLowHigh,
}

class DealerListingsProvider extends ChangeNotifier {
  final CarApiService api;

  DealerListingsProvider(this.api);

  // ---- STATE ----
  List<DealerCarItem> _allItems = [];
  List<DealerCarItem> items = [];
  bool loading = false;
  String? error;
  DealerSortOption sortOption = DealerSortOption.relevance;
  String dateFilter = 'anytime';
  double? minPrice;
  double? maxPrice;

  void applyFilters({
    required DealerSortOption sort,
    required String date,
    double? min,
    double? max,
  }) {
    sortOption = sort;
    dateFilter = date;
    minPrice = min;
    maxPrice = max;

    var filtered = List<DealerCarItem>.from(_allItems);

    // ── price filter ──
    if (min != null) filtered = filtered.where((i) => i.car.price >= min).toList();
    if (max != null) filtered = filtered.where((i) => i.car.price <= max).toList();

    // ── date filter ──
    final now = DateTime.now();
    DateTime? cutoff;
    switch (date) {
      case 'week':  cutoff = now.subtract(const Duration(days: 7)); break;
      case '30d':   cutoff = now.subtract(const Duration(days: 30)); break;
      case '90d':   cutoff = now.subtract(const Duration(days: 90)); break;
      case '6m':    cutoff = now.subtract(const Duration(days: 180)); break;
      case 'year':  cutoff = now.subtract(const Duration(days: 365)); break;
    }
    if (cutoff != null) {
      filtered = filtered.where((i) {
        final d = i.car.listedAt;
        return d != null && d.isAfter(cutoff!);
      }).toList();
    }

    // ── sort ──
    switch (sort) {
      case DealerSortOption.relevance:
        filtered.sort((a, b) => b.car.id.compareTo(a.car.id));
      case DealerSortOption.datePosted:
        filtered.sort((a, b) {
          final da = a.car.listedAt, db = b.car.listedAt;
          if (da == null && db == null) return 0;
          if (da == null) return 1;
          if (db == null) return -1;
          return db.compareTo(da);
        });
      case DealerSortOption.priceHighLow:
        filtered.sort((a, b) => b.car.price.compareTo(a.car.price));
      case DealerSortOption.priceLowHigh:
        filtered.sort((a, b) => a.car.price.compareTo(b.car.price));
    }

    items = filtered;
    notifyListeners();
  }

  // ---- FETCH ----
  Future<void> fetch(int showroomId) async {
    loading = true;
    error = null;
    _allItems = [];
    items = [];
    sortOption = DealerSortOption.relevance;
    dateFilter = 'anytime';
    minPrice = null;
    maxPrice = null;
    notifyListeners();

    debugPrint('🔍 DealerListings: fetching for showroomId=$showroomId');

    try {
      final results = await Future.wait([
        api.filterCars(
          FilterCarsParams()
            ..carShowroomId = showroomId
            ..carStatuses = ['APPROVED']
            ..limit = 50
            ..sortBy = 'id'
            ..sortOrder = 'desc',
        ),
        api.filterCars(
          FilterCarsParams()
            ..carShowroomId = showroomId
            ..carStatuses = ['PENDING']
            ..limit = 50
            ..sortBy = 'id'
            ..sortOrder = 'desc',
        ),
        api.filterCars(
          FilterCarsParams()
            ..carShowroomId = showroomId
            ..carStatuses = ['REJECTED']
            ..limit = 50
            ..sortBy = 'id'
            ..sortOrder = 'desc',
        ),
      ]);

      debugPrint('🔍 DealerListings: APPROVED=${results[0].cars.length}, PENDING=${results[1].cars.length}, REJECTED=${results[2].cars.length}');

      final merged = [
        ...results[0].cars.map((c) => DealerCarItem(car: c, status: 'APPROVED')),
        ...results[1].cars.map((c) => DealerCarItem(car: c, status: 'PENDING')),
        ...results[2].cars.map((c) => DealerCarItem(car: c, status: 'REJECTED')),
      ];

      merged.sort((a, b) => b.car.id.compareTo(a.car.id));

      _allItems = merged;
      items = List.from(merged);
    } catch (e) {
      error = e.toString();
      debugPrint('🔍 DealerListings ERROR: $e');
    }

    loading = false;
    notifyListeners();
  }

  void clear() {
    _allItems = [];
    items = [];
    error = null;
    loading = false;
    sortOption = DealerSortOption.relevance;
    dateFilter = 'anytime';
    minPrice = null;
    maxPrice = null;
    notifyListeners();
  }
}
