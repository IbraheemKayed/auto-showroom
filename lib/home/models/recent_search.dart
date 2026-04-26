class RecentSearch {
  final int id;
  final Map<String, dynamic> metaData;

  const RecentSearch({required this.id, required this.metaData});

  factory RecentSearch.fromJson(Map<String, dynamic> json) => RecentSearch(
        id: json['id'] as int,
        metaData: Map<String, dynamic>.from(json['meta_data'] as Map? ?? {}),
      );

  int? get carBrandId => metaData['car_brand_id'] as int?;

  List<int> get cityIds {
    final v = metaData['city_ids'];
    if (v is List) return v.map((e) => (e as num).toInt()).toList();
    return const [];
  }

  List<int> get outsideColorIds {
    final v = metaData['car_outside_color_id'];
    if (v is List) return v.map((e) => (e as num).toInt()).toList();
    return const [];
  }

  double? get minPrice => (metaData['min_price'] as num?)?.toDouble();
  double? get maxPrice => (metaData['max_price'] as num?)?.toDouble();

  // Number of filters applied (brand is shown as title, not counted here)
  int get activeFilterCount {
    int count = 0;
    final models = metaData['car_model_id'];
    if (models is List && models.isNotEmpty) count++;
    final cities = metaData['city_ids'];
    if (cities is List && cities.isNotEmpty) count++;
    final outsideColors = metaData['car_outside_color_id'];
    if (outsideColors is List && outsideColors.isNotEmpty) count++;
    final insideColors = metaData['car_inside_color_id'];
    if (insideColors is List && insideColors.isNotEmpty) count++;
    if (metaData['min_price'] != null || metaData['max_price'] != null) count++;
    if (metaData['min_mileage'] != null || metaData['max_mileage'] != null) count++;
    if (metaData['min_year'] != null || metaData['max_year'] != null) count++;

    // Feature flags
    const nonFeatureKeys = {
      'car_brand_id', 'car_model_id', 'min_price', 'max_price',
      'min_mileage', 'max_mileage', 'min_year', 'max_year', 'city_ids',
      'city_id', 'car_outside_color_id', 'car_inside_color_id',
      'sort_by', 'sort_order', 'offset', 'limit', 'save_as_search_history',
      'car_showroom_id', 'car_statuses', 'is_sold',
    };
    for (final entry in metaData.entries) {
      if (!nonFeatureKeys.contains(entry.key) && entry.value == true) count++;
    }

    return count;
  }
}
