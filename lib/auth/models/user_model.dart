// lib/auth/models/user_model.dart
class UserModel {
  final int id;
  final String phone;
  final String name;
  final String? nameAr;
  final int? cityId;
  final String userType; // user | showroom | admin
  final bool isVerified;
  final int? showroomId;

  bool get isDealer => userType == 'showroom';

  UserModel({
    required this.id,
    required this.phone,
    required this.name,
    this.nameAr,
    this.cityId,
    required this.userType,
    required this.isVerified,
    this.showroomId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      phone: json['phone'] ?? '',
      name: json['name'] ?? '',
      nameAr: json['name_ar'],
      cityId: json['city_id'],
      userType: json['user_type'] ?? 'user',
      isVerified: json['is_verified'] ?? false,
      showroomId: json['showroom_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'name': name,
      'name_ar': nameAr,
      'city_id': cityId,
      'user_type': userType,
      'is_verified': isVerified,
      'showroom_id': showroomId,
    };
  }
}
