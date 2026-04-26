class FilterCarsParams {
  // =========================================================
  // LOCATION / RELATIONS
  // =========================================================
  int? cityId;
  int? carBrandId;
  int? carShowroomId;
  int? categoryId;
  int? carFuelTypeId;

  int? carDriveTrainId;

  // =========================================================
  // BASIC ATTRIBUTES
  // =========================================================
  String? gearType; // MANUAL | AUTOMATIC
  String? engineSize; // example: "2.0L"
  List<int>? carModelIds;
  List<int>? insideColorIds;
  List<int>? outsideColorIds;
  List<int>? selectedCityIds;
  // =========================================================
  // PRICE
  // =========================================================
  double? minPrice;
  double? maxPrice;

  // =========================================================
  // YEAR
  // =========================================================
  int? minYear;
  int? maxYear;

  // =========================================================
  // MILEAGE
  // =========================================================
  int? minMileage;
  int? maxMileage;

  // =========================================================
  // STATUS
  // =========================================================
  bool? isSold;

  /// APPROVED / PENDING / REJECTED
  List<String>? carStatuses;

  /// save search history
  bool? saveAsSearchHistory;

  // =========================================================
  // FEATURES (DYNAMIC BOOLEAN FILTERS)
  // =========================================================
  /// example:
  /// {
  ///   "abs": true,
  ///   "apple_carplay": true
  /// }
  Map<String, bool> features = {};

  // =========================================================
  // SORTING
  // =========================================================
  String sortBy = 'id'; // id, price, year, mileage, created
  String sortOrder = 'desc'; // asc, desc

  // =========================================================
  // PAGINATION
  // =========================================================
  int offset = 0;
  int limit = 20;

  // =========================================================
  // QUERY BUILDER
  // =========================================================
 Map<String, dynamic> toQuery() {
  final Map<String, dynamic> query = {};

  void add(String key, dynamic value) {
    if (value != null) query[key] = value;
  }

  // ---------- BRAND ----------
  add('car_brand_id', carBrandId);

  // ---------- SHOWROOM ----------
  add('car_showroom_id', carShowroomId);

  // ---------- CATEGORY ----------
  add('category_id', categoryId);

  // ---------- FUEL TYPE ----------
  add('car_fuel_type_id', carFuelTypeId);

  // ---------- DRIVE TRAIN ----------
  add('car_drive_train_id', carDriveTrainId);

  // ---------- GEAR TYPE ----------
  add('gear_type', gearType);

  // ---------- ENGINE SIZE ----------
  add('engine_size', engineSize);

  // ---------- MODELS (list) ----------
  if (carModelIds != null && carModelIds!.isNotEmpty) {
    query['car_model_id'] = carModelIds;
  }

  // ---------- CITIES (list) ----------
  add('city_id', cityId);
  if (selectedCityIds != null && selectedCityIds!.isNotEmpty) {
    for (final id in selectedCityIds!) {
      query.putIfAbsent('city_ids', () => <int>[]).add(id);
    }
  }

  // ---------- COLORS ----------
  if (insideColorIds != null && insideColorIds!.isNotEmpty) {
    query['car_inside_color_id'] = insideColorIds;
  }
  if (outsideColorIds != null && outsideColorIds!.isNotEmpty) {
    query['car_outside_color_id'] = outsideColorIds;
  }

  // ---------- STATUS ----------
  if (carStatuses != null && carStatuses!.isNotEmpty) {
    for (final status in carStatuses!) {
      query.putIfAbsent('car_statuses', () => <String>[]).add(status);
    }
  }

  // ---------- PRICE ----------
  add('min_price', minPrice?.toInt());
  add('max_price', maxPrice?.toInt());

  // ---------- YEAR ----------
  add('min_year', minYear);
  add('max_year', maxYear);

  // ---------- MILEAGE ----------
  add('min_mileage', minMileage);
  add('max_mileage', maxMileage);

  // ---------- IS SOLD ----------
  add('is_sold', isSold);

  // ---------- SAVE SEARCH HISTORY ----------
  add('save_as_search_history', saveAsSearchHistory);

  // ---------- FEATURES ----------
  for (final entry in features.entries) {
    if (entry.value) query[entry.key] = true;
  }

  // ---------- SORT ----------
  query['sort_by'] = sortBy;
  query['sort_order'] = sortOrder;

  // ---------- PAGINATION ----------
  query['offset'] = offset;
  query['limit'] = limit;

  return query;
}




}
