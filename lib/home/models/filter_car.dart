
import 'package:sayarti/home/models/car_full.dart';

class FilterCar {
  final int id;
  final String gearType;
  final int mileage;
  final int year;
  final double price;

  final String modelName;
  final String brandName;
  final String? brandImage;

  final String fuelType;
  final String driveTrain;

  final int showroomId;
  final String showroomName;
  final String showroomCity;
  final int adminPriceRate;

  final String? coverImage;
  final bool isFavorite;
  final List<CarImage>? images;

  FilterCar({
    required this.id,
    required this.gearType,
    required this.mileage,
    required this.year,
    required this.price,
    required this.modelName,
    required this.brandName,
    required this.brandImage,
    required this.fuelType,
    required this.driveTrain,
    required this.showroomId,
    required this.showroomName,
    required this.showroomCity,
    required this.coverImage,
    required this.isFavorite,
    required this.images,
    required this.adminPriceRate
  });

  factory FilterCar.fromJson(Map<String, dynamic> json) {
  final imagesJson = (json['images'] as List? ?? []);

  final images = imagesJson
      .map((e) => CarImage.fromJson(e))
      .toList();

  return FilterCar(
    id: json['id'],
    gearType: json['gear_type'] ?? '',
    mileage: json['mileage'] ?? 0,
    year: json['year'] ?? 0,
    price: double.parse(json['price'].toString()),

    modelName: json['model']?['name'] ?? '',
    brandName: json['model']?['brand']?['name'] ?? '',
    brandImage: json['model']?['brand']?['image_path'],

    fuelType: json['fuel_type']?['name'] ?? '',
    driveTrain: json['drive_train']?['code'] ?? '',

    showroomId: json['showroom']?['id'] ?? 0,
    showroomName: json['showroom']?['description'] ?? '',
    showroomCity: json['showroom']?['city']?['name_en'] ?? '',

    coverImage: images.isNotEmpty ? images.first.imagePath : null,
    isFavorite: json['is_favorite_car'] ?? false,
    images: images,
    adminPriceRate: json['admin_price_rate'] ?? 0,

  );
}

}
  


  class FilteredCarsResponse {
  final List<CarFull> cars;
  final int totalCount;
  final bool hasNext;
  final bool hasPrevious;
  final int offset;
  final int limit;

  FilteredCarsResponse({
    required this.cars,
    required this.totalCount,
    required this.hasNext,
    required this.hasPrevious,
    required this.offset,
    required this.limit,
  });

  factory FilteredCarsResponse.fromJson(Map<String, dynamic> json) {
    final pagination = json['pagination'] as Map<String, dynamic>?;

    return FilteredCarsResponse(
      cars: (json['data']?['cars'] as List? ?? [])
          .map((e) => CarFull.fromJson(e))
          .toList(),

      totalCount: pagination?['total_count'] ?? 0,
      hasNext: pagination?['has_next'] ?? false,
      hasPrevious: pagination?['has_previous'] ?? false,
      offset: pagination?['offset'] ?? 0,
      limit: pagination?['limit'] ?? 0,
    );
  }
}


class CarImage {
  final String imagePath;
  final bool isCover;

  CarImage({
    required this.imagePath,
    required this.isCover,
  });

  factory CarImage.fromJson(Map<String, dynamic> json) {
    return CarImage(
      imagePath: json['image_path'],
      isCover: json['is_cover'] ?? false,
    );
  }
}
