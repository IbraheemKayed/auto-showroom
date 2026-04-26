import 'car_feature.dart';
import 'car_full.dart';

class ShowroomStats {
  final double avgRate;
  final int reviewsCount;
  final int carsCount;
  final double? responseRate;

  ShowroomStats({
    required this.avgRate,
    required this.reviewsCount,
    required this.carsCount,
    this.responseRate,
  });

  factory ShowroomStats.fromJson(Map<String, dynamic> json) {
    return ShowroomStats(
      avgRate: (json['avg_rate'] ?? 0).toDouble(),
      reviewsCount: json['reviews_count'] ?? 0,
      carsCount: json['cars_count'] ?? 0,
      responseRate: json['response_rate'] != null
          ? (json['response_rate'] as num).toDouble()
          : null,
    );
  }
}

class ShowroomDetails {
  final int id;
  final String? image;
  final String description;
  final String? descriptionAr;
  final double latitude;
  final double longitude;
  final String cityNameAr;
  final String cityNameEn;
  final ShowroomStats? stats;
  final DateTime? addedAt;
  final String phone;

  ShowroomDetails({
    required this.id,
    required this.image,
    required this.description,
    this.descriptionAr,
    required this.latitude,
    required this.longitude,
    required this.cityNameAr,
    required this.cityNameEn,
    required this.stats,
    this.addedAt,
    this.phone = '',
  });

  factory ShowroomDetails.fromJson(Map<String, dynamic> json) {
    return ShowroomDetails(
      id: json['id'],
      image: json['image_path'],
      description: json['description'] ?? '',
      descriptionAr: json['description_ar'],
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      cityNameAr: json['city']?['name_ar'] ?? '',
      cityNameEn: json['city']?['name_en'] ?? '',
      stats: json['showroom_stats'] != null
          ? ShowroomStats.fromJson(json['showroom_stats'])
          : null,
      addedAt: json['added_at'] != null
          ? DateTime.tryParse(json['added_at'])
          : null,
      phone: json['user']?['phone'] ?? '',
    );
  }
}

class CarDetails {
  final CarFull base;
  final CarFeature? feature;
  final ShowroomDetails? showroom;

  CarDetails({
    required this.base,
    required this.feature,
    required this.showroom,
  });

  factory CarDetails.fromJson(Map<String, dynamic> json) {
    return CarDetails(
      base: CarFull.fromJson(json),
      feature: json['feature'] != null
          ? CarFeature.fromJson(json['feature'])
          : null,
      showroom: json['showroom'] != null
          ? ShowroomDetails.fromJson(json['showroom'])
          : null,
    );
  }
}
