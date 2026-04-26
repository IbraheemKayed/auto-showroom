import 'package:sayarti/home/models/car_showroom.dart';

class PriceHistory {
  final DateTime date;
  final double price;

  PriceHistory({required this.date, required this.price});

  factory PriceHistory.fromJson(Map<String, dynamic> json) {
    return PriceHistory(
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      price: double.tryParse(json['price'].toString()) ?? 0,
    );
  }
}

class CarImage {
  final int id;
  final String? imagePath;
  final bool isCover;

  CarImage({
    required this.id,
    required this.imagePath,
    required this.isCover,
  });

  factory CarImage.fromJson(Map<String, dynamic> json) {
    return CarImage(
      id: json['id'],
      imagePath: json['image_path'],
      isCover: json['is_cover'] ?? false,
    );
  }
}


class CarFull {
  final int id;
  final String gearType;
  final int mileage;
  final int year;
  final double price;
  final String engineSize;
  final String power;
  final int adminPriceRate;
  final String status;
  final String description;
  final String? descriptionAr;

  final String modelName;
  final String brandName;
  final String? brandImage;

  final String categoryName;
  final String fuelTypeName;
  final String driveTrain; // ⭐️ مهم

  final List<CarImage> images;
  final bool isFavorite;
  final CarShowroom? showroom;
  final int? previousOwners;
  final DateTime? listedAt;
  final List<PriceHistory> priceHistory;
  final bool isSold;

  CarFull({
    required this.id,
    required this.gearType,
    required this.mileage,
    required this.year,
    required this.price,
    required this.engineSize,
    required this.power,
    required this.adminPriceRate,
    required this.status,
    required this.description,
    this.descriptionAr,
    required this.modelName,
    required this.brandName,
    required this.brandImage,
    required this.categoryName,
    required this.fuelTypeName,
    required this.driveTrain,
    required this.images,
    required this.isFavorite,
    required this.showroom,
    this.previousOwners,
    this.listedAt,
    this.priceHistory = const [],
    this.isSold = false,
  });
  CarFull copyWith({
  bool? isFavorite,
  List<CarImage>? images,
  CarShowroom? showroom,
  bool? isSold,
}) {
  return CarFull(
    id: id,
    gearType: gearType,
    mileage: mileage,
    year: year,
    price: price,
    engineSize: engineSize,
    power: power,
    adminPriceRate: adminPriceRate,
    status: status,
    description: description,
    descriptionAr: descriptionAr,
    modelName: modelName,
    brandName: brandName,
    brandImage: brandImage,
    categoryName: categoryName,
    fuelTypeName: fuelTypeName,
    driveTrain: driveTrain,
    images: images ?? this.images,
    isFavorite: isFavorite ?? this.isFavorite,
    showroom: showroom ?? this.showroom,
    previousOwners: previousOwners ?? this.previousOwners,
    listedAt: listedAt,
    priceHistory: priceHistory,
    isSold: isSold ?? this.isSold,
  );
}


  
  factory CarFull.fromJson(Map<String, dynamic> json) {
  final model = json['model'] as Map<String, dynamic>?;

  return CarFull(
    id: json['id'],
    gearType: json['gear_type'] ?? "",
    mileage: json['mileage'] ?? 0,
    year: json['year'] ?? 0,
    price: double.tryParse(json['price'].toString()) ?? 0,
    engineSize: json['engine_size'] ?? "",
    power: json['power'] ?? "",
    adminPriceRate: json['admin_price_rate'] ?? 0,
    status: json['status'] ?? "",
    description: json['description'] ?? "",
    descriptionAr: json['description_ar'],

    modelName: model?['name'] ?? "",
    brandName: model?['brand']?['name'] ?? "",
    brandImage: model?['brand']?['image_path'],

    categoryName: json['category']?['name'] ?? "",
    fuelTypeName: json['fuel_type']?['name'] ?? "",
    driveTrain: json['drive_train']?['code'] ?? "",

    images: (json['images'] as List? ?? [])
        .map((e) => CarImage.fromJson(e))
        .toList(),

    isFavorite: json['is_favorite_car'] ?? false,
    isSold: json['is_sold'] ?? false,

    showroom: json['showroom'] != null
        ? CarShowroom.fromJson(json['showroom'])
        : null,

    previousOwners: json['previous_owners'] as int?,
    listedAt: json['created'] != null
        ? DateTime.tryParse(json['created'])
        : null,
    priceHistory: (json['price_history'] as List? ?? [])
        .map((e) => PriceHistory.fromJson(e))
        .toList(),
  );
}



  // =======================================
  // 🖼️ COVER IMAGE GETTER (CLEAN & SAFE)
  // =======================================
  String? get coverImage {
  // 1) get cover image first
  for (final img in images) {
    final path = img.imagePath;
    if (img.isCover == true && path != null && path.isNotEmpty) {
      return path;
    }
  }

  // 2) fallback: first non-empty image
  for (final img in images) {
    final path = img.imagePath;
    if (path != null && path.isNotEmpty) return path;
  }

  return null;
}


}

