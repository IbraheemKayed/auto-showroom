class Showroom {
  final int id;
  final String? imagePath;
  final String description;
  final String? descriptionAr;
  final String? note;
  final double latitude;
  final double longitude;
  final DateTime? addedAt;

  final ShowroomUser user;
  final ShowroomCity? city;
final ShowroomStats? stats;
final List<PaymentMethod> paymentMethods;


  Showroom({
    required this.id,
    required this.imagePath,
    required this.description,
    this.descriptionAr,
    required this.note,
    required this.latitude,
    required this.longitude,
    required this.addedAt,
    required this.user,
    required this.city,
    required this.stats,
    required this.paymentMethods,
  });

  factory Showroom.fromJson(Map<String, dynamic> json) {
  return Showroom(
    id: json['id'],
    imagePath: json['image_path'],
    description: json['description'] ?? '',
    descriptionAr: json['description_ar'],
    note: json['note'],
    latitude: (json['latitude'] ?? 0).toDouble(),
    longitude: (json['longitude'] ?? 0).toDouble(),
    addedAt: json['added_at'] != null
        ? DateTime.tryParse(json['added_at'])
        : null,

    user: ShowroomUser.fromJson(json['user']),

    city: json['city'] != null
        ? ShowroomCity.fromJson(json['city'])
        : null,

    stats: json['showroom_stats'] != null
        ? ShowroomStats.fromJson(json['showroom_stats'])
        : null,

    paymentMethods: (json['payment_methods'] as List? ?? [])
        .map((e) => PaymentMethod.fromJson(e['payment_method']))
        .toList(),
  );
}

}

class ShowroomUser {
  final int id;
  final String name;
  final String phone;

  ShowroomUser({required this.id, required this.name, required this.phone});

  factory ShowroomUser.fromJson(Map<String, dynamic> json) {
    return ShowroomUser(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
    );
  }
}

class ShowroomCity {
  final int id;
  final String nameAr;
  final String nameEn;

  ShowroomCity({required this.id, required this.nameAr, required this.nameEn});

  factory ShowroomCity.fromJson(Map<String, dynamic> json) {
    return ShowroomCity(
      id: json['id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
    );
  }
}

class ShowroomStats {
  final double avgRate;
  final int reviewsCount;
  final int carsCount;

  ShowroomStats({
    required this.avgRate,
    required this.reviewsCount,
    required this.carsCount,
  });

  factory ShowroomStats.fromJson(Map<String, dynamic> json) {
    return ShowroomStats(
      avgRate: (json['avg_rate'] ?? 0).toDouble(),
      reviewsCount: json['reviews_count'] ?? 0,
      carsCount: json['cars_count'] ?? 0,
    );
  }
}

class PaymentMethod {
  final int id;
  final String name;
  final String code;

  PaymentMethod({required this.id, required this.name, required this.code});

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      name: json['name'],
      code: json['code'],
    );
  }
}


class ShowroomsResponse {
  final List<Showroom> showrooms;
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;

  ShowroomsResponse({
    required this.showrooms,
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
  });

  factory ShowroomsResponse.fromJson(Map<String, dynamic> json) {
    return ShowroomsResponse(
      showrooms:
          (json['showrooms'] as List).map((e) => Showroom.fromJson(e)).toList(),
      total: json['total'],
      perPage: json['per_page'],
      currentPage: json['current_page'],
      lastPage: json['last_page'],
    );
  }
}
