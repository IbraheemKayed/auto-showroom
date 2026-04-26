import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sayarti/ai_search/models/brand_country.dart';
import 'package:sayarti/home/models/app_notification.dart';
import 'package:sayarti/ai_search/models/car_brand.dart';
import 'package:sayarti/ai_search/models/car_category.dart';
import 'package:sayarti/ai_search/models/drive_train_type.dart';
import 'package:sayarti/ai_search/models/fuel_type.dart';
import 'package:sayarti/ai_search/models/city.dart';
import 'package:sayarti/home/models/ShowroomReviews_response.dart';
import 'package:sayarti/home/models/brand_model.dart';
import 'package:sayarti/home/models/car_full.dart';
import 'package:sayarti/home/models/filter_car.dart';
import 'package:sayarti/home/models/showroom.dart';
import 'package:sayarti/home/services/filter_cars_params.dart';
import 'package:sayarti/auth/providers/auth_provider.dart';
import 'package:sayarti/search/models/car_color.dart';
import 'package:sayarti/search/models/car_model.dart';

class CarApiService {
  final Dio _dio;

  /// token (fallback)
  String? token;

  /// 🔐 Auth provider reference
  AuthProvider? _authProvider;

  /// refresh handling
  bool _isRefreshing = false;
  final List<({Future<void> Function() onSuccess, void Function() onFailure})>
      _retryQueue = [];

  CarApiService(String baseUrl)
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: const {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // لا تفرض content-type لو FormData
          if (options.data is! FormData) {
            options.headers['Content-Type'] = 'application/json';
          } else {
            options.headers.remove('Content-Type');
          }

          if (options.path == '/cities') {
            options.headers.remove('Authorization');
            handler.next(options);
            return;
          }

          final accessToken = _authProvider?.accessToken ?? token;

          if (accessToken != null && accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          } else {
            options.headers.remove('Authorization');
          }

          handler.next(options);
        },

        onError: (error, handler) async {
          final requestOptions = error.requestOptions;
          final statusCode = error.response?.statusCode;

          final hasAuthHeader = requestOptions.headers['Authorization'] != null;

          final isMultipart = requestOptions.data is FormData;

          // ❌ ممنوع إعادة المحاولة للـ multipart
          if (isMultipart) {
            handler.reject(error);
            return;
          }
          if (error.requestOptions.extra['noRetry'] == true) {
            return handler.next(error);
          }

          final shouldTryRefresh =
              statusCode == 401 &&
              hasAuthHeader &&
              _authProvider != null &&
              _authProvider!.refreshToken != null;

          if (!shouldTryRefresh) {
            handler.reject(error);
            return;
          }

          if (_isRefreshing) {
            _retryQueue.add((
              onSuccess: () async {
                requestOptions.headers['Authorization'] =
                    'Bearer ${_authProvider!.accessToken}';
                requestOptions.extra['noRetry'] = true;
                try {
                  final response = await _dio.fetch(requestOptions);
                  handler.resolve(response);
                } catch (_) {
                  handler.reject(error);
                }
              },
              onFailure: () => handler.reject(error),
            ));
            return;
          }

          _isRefreshing = true;

          final success = await _authProvider!.refreshAccessToken();

          _isRefreshing = false;

          if (!success) {
            for (final item in _retryQueue) {
              item.onFailure();
            }
            _retryQueue.clear();
            handler.reject(error);
            return;
          }

          requestOptions.headers['Authorization'] =
              'Bearer ${_authProvider!.accessToken}';
          requestOptions.extra['noRetry'] = true;

          for (final item in _retryQueue) {
            await item.onSuccess();
          }
          _retryQueue.clear();

          try {
            final response = await _dio.fetch(requestOptions);
            handler.resolve(response);
          } on DioException catch (e) {
            handler.reject(e);
          }
        },
      ),
    );
  }

  // ==============================
  // 🔗 ATTACH AUTH PROVIDER
  // ==============================
  void attachAuthProvider(AuthProvider provider) {
    _authProvider = provider;
  }

  // ==============================
  // 🔐 TOKEN HANDLING (كما كان)
  // ==============================
  void setToken(String newToken) {
    token = newToken;
  }

  void clearToken() {
    token = null;
  }

  bool get hasToken =>
      (token != null && token!.isNotEmpty) ||
      (_authProvider?.accessToken != null &&
          _authProvider!.accessToken!.isNotEmpty);

  // ==============================
  // 🧠 RESPONSE PARSER
  // ==============================
  List<dynamic> _extractList(Response res, String key) {
    final data = res.data;
    if (data is Map) {
      if (data['data'] is Map && data['data'][key] is List) {
        return data['data'][key];
      }
      if (data[key] is List) {
        return data[key];
      }
    }
    return const [];
  }

  // ==============================
  // 🔍 AI SEARCH APIs
  // ==============================
  Future<List<CarCategory>> getCarCategories() async {
    final res = await _dio.get('/car/categories');
    final list = _extractList(res, 'categories');
    return list.map((e) => CarCategory.fromJson(e)).toList();
  }

  Future<List<BrandCountry>> getBrandCountries() async {
    final res = await _dio.get('/car/brand_countries');
    final list = _extractList(res, 'countries');
    return list.map((e) => BrandCountry.fromJson(e)).toList();
  }

  Future<List<FuelType>> getFuelTypes() async {
    final res = await _dio.get('/car/fuel_types');
    final list = _extractList(res, 'fuel_types');
    return list.map((e) => FuelType.fromJson(e)).toList();
  }

  Future<List<DriveTrainType>> getDriveTrains() async {
    final res = await _dio.get('/car/drive_trains');
    final list = _extractList(res, 'drive_trains');
    return list.map((e) => DriveTrainType.fromJson(e)).toList();
  }

  Future<List<CityModel>> getCities() async {
    final res = await _dio.get('/cities');
    final list = _extractList(res, 'cities');
    final all = list.map((e) => CityModel.fromJson(e)).toList();
    // Temporarily limit to Ramallah only for launch
    final ramallah = all.where(
      (c) => c.nameEn.toLowerCase().contains('ramallah'),
    ).toList();
    return ramallah.isNotEmpty ? ramallah : all;
  }

  Future<List<CarFull>> searchCars({
    required List<int> categoryIds,
    required List<int> brandCountryIds,
    required List<String> fuels,
    required double minPrice,
    required double maxPrice,
    required String? city,
  }) async {
    final res = await _dio.post(
      '/car/search',
      data: {
        'category_ids': categoryIds,
        'brand_country_ids': brandCountryIds,
        'fuels': fuels,
        'min_price': minPrice,
        'max_price': maxPrice,
        'city': city,
      },
    );

    final list = _extractList(res, 'cars');
    return list.map((e) => CarFull.fromJson(e)).toList();
  }

  // ==============================
  // 🏠 HOME APIs
  // ==============================
  Future<List<BrandModel>> getBrandsHome() async {
    try {
      final res = await _dio.get('/car/brands');

      // حسب شكل الـ response عندك
      final List list = res.data['data']['brands'] ?? [];
      return list.map((e) => BrandModel.fromJson(e)).toList();
    } on DioException catch (e) {
      debugPrint('❌ Get Brands Error: ${e.response?.data}');
      rethrow;
    }
  }

  Future<List<CarFull>> getAdminRate5Cars({
    int limit = 8,
    int? afterCarId,
    bool random = true,
  }) async {
    final res = await _dio.get(
      '/cars/admin_rate_5',
      queryParameters: {
        'limit': limit,
        if (afterCarId != null) 'after_car_id': afterCarId,
        if (afterCarId == null) 'random': random,
      },
    );

    final list = _extractList(res, 'cars');
    return list.map((e) => CarFull.fromJson(e)).toList();
  }

  Future<List<CarFull>> getRecentlyPriceDropped({
    int limit = 20,
    int? afterCarId,
  }) async {
    final res = await _dio.get(
      '/cars/recently_price_dropped',
      queryParameters: {
        'limit': limit,
        if (afterCarId != null) 'after_car_id': afterCarId,
      },
    );

    final list = _extractList(res, 'cars');
    return list.map((e) => CarFull.fromJson(e)).toList();
  }

  Future<List<CarFull>> getNearbyCars({
    int limit = 20,
    int? afterCarId,
    bool random = true,
  }) async {
    final res = await _dio.get(
      '/cars/nearby',
      queryParameters: {
        'limit': limit,
        if (afterCarId != null) 'after_car_id': afterCarId,
        if (afterCarId == null) 'random': random,
      },
    );

    final list = _extractList(res, 'cars');
    return list.map((e) => CarFull.fromJson(e)).toList();
  }

  // ==============================
  // 🚗 CAR DETAILS
  // ==============================
 Future<Map<String, dynamic>> getCarById(int carId) async {
  Response res;
  try {
    res = await _dio.get('/cars/$carId', queryParameters: {'showroom_stats': 'true'});
  } on DioException catch (e) {
    if (e.response?.statusCode == 422) {
      // Some cars (e.g. pending) reject showroom_stats — retry without it
      res = await _dio.get('/cars/$carId');
    } else {
      rethrow;
    }
  }

  final data = res.data;

  // CASE 1: { data: { car: {...} } }
  if (data is Map &&
      data['data'] is Map &&
      data['data']['car'] is Map) {
    return Map<String, dynamic>.from(data['data']['car']);
  }

  // CASE 2: { id: 43, ... }
  if (data is Map && data['id'] != null) {
    return Map<String, dynamic>.from(data);
  }

  throw Exception('Car data not found in response');
}



  Future<Showroom> getShowroomById(int id) async {
    final res = await _dio.get('/showrooms/$id');
    return Showroom.fromJson(res.data['data']['showroom']);
  }

  Future<FilteredCarsResponse> filterCars(FilterCarsParams params) async {
    final res = await _dio.get(
      '/cars/filter',
      queryParameters: params.toQuery(),
    );
    return FilteredCarsResponse.fromJson(res.data);
  }


  Future<ShowroomReviewsResponse> getShowroomReviews({
    required int showroomId,
    int limit = 20,
    int offset = 0,
  }) async {
    final res = await _dio.get(
      '/showrooms/$showroomId/reviews',
      queryParameters: {'limit': limit, 'offset': offset},
    );
    print(res.data);
    return ShowroomReviewsResponse.fromJson(res.data);
  }

  Future<void> createShowroomReview({
    required int showroomId,
    String? review,
    int? rate,
  }) async {
    await _dio.post(
      '/showrooms/$showroomId/reviews',
      data: {
        if (review != null) 'review': review,
        if (rate != null) 'rate': rate,
      },
    );
  }

  Future<List<CarBrand>> getBrands() async {
    final response = await _dio.get('/car/brands');

    final List list = response.data['data']['brands'];
    return list.map((e) => CarBrand.fromJson(e)).toList();
  }

  Future<List<CarModel>> getModelsByBrand(int brandId) async {
    final response = await _dio.get(
      '/car/models',
      queryParameters: {'car_brand_id': brandId},
    );

    final List list = response.data['data']['models'];
    return list.map((e) => CarModel.fromJson(e)).toList();
  }

  Future<ShowroomsResponse> getShowrooms({
    String? searchTerm,
    int offset = 0,
    int limit = 20,
  }) async {
    final response = await _dio.get(
      '/showrooms',
      queryParameters: {
        if (searchTerm != null && searchTerm.isNotEmpty)
          'search_term': searchTerm,
        'offset': offset,
        'limit': limit,
      },
    );

    return ShowroomsResponse.fromJson(response.data['data']);
  }

  Future<List<CarColor>> getInsideColors() async {
    final res = await _dio.get('/car/inside_colors');

    final list = res.data['data']['inside_colors'] as List;
    return list.map((e) => CarColor.fromJson(e)).toList();
  }

  Future<List<CarColor>> getOutsideColors() async {
    final res = await _dio.get('/car/outside_colors');

    final list = res.data['data']['outside_colors'] as List;
    return list.map((e) => CarColor.fromJson(e)).toList();
  }

  // ==============================
  // 🚗 DEALER
  // ==============================

  Future<List<String>> uploadCarImages(List<File> images) async {
    final formData = FormData.fromMap({
      'image_type': 'car',
      'images': [
        for (final img in images) await MultipartFile.fromFile(img.path),
      ],
    });

    final res = await _dio.post(
      '/images/upload',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    final List paths = res.data['data']['paths'];
    return paths.cast<String>();
  }

  Future<void> createCar(Map<String, dynamic> body) async {
    await _dio.post('/showroom/cars', data: body);
  }

  Future<void> updateCarPricing(int carId, double price) async {
    await _dio.patch('/showroom/cars/$carId/pricing', data: {'price': price});
  }

  // ==============================
  // 🔔 NOTIFICATIONS
  // ==============================
  Future<List<AppNotification>> getNotifications() async {
    final res = await _dio.get('/notifications');
    final list = _extractList(res, 'notifications');
    return list
        .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> markNotificationsRead(List<int> notificationIds) async {
    for (final id in notificationIds) {
      await _dio.post('/notifications/$id/mark_read');
    }
  }

  Future<void> registerFcmToken(String fcmToken) async {
    await _dio.post('/users/fcm_token', data: {'fcm_token': fcmToken});
  }

  Future<void> deleteFcmToken(String fcmToken) async {
    await _dio.delete('/users/fcm_token', data: {'fcm_token': fcmToken});
  }

  // ==============================
  // 📸 UPLOAD SINGLE CAR IMAGE (WITH PROGRESS)
  // ==============================
  Future<String> uploadSingleCarImage(
    File image, {
    required Function(int sent, int total) onProgress,
  }) async {
    print('start upload');

    try {
      final formData = FormData.fromMap({
        'image_type': 'car',
        'images': [
          await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
        ],
      });

      final res = await _dio.post(
        '/images/upload',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',

          // 🔥 مهم جدًا
          extra: {'noRetry': true},
        ),
        onSendProgress: onProgress,
      );

      print('image success upload');
      print(res.data);

      final List paths = res.data['data']['paths'];
      return paths.first as String;
    } on DioException catch (e) {
      print('UPLOAD FAILED');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      print('HEADERS SENT: ${e.requestOptions.headers}');
      rethrow;
    }
  }


  // ===============================
// ❤️ FAVORITES
// ===============================

// ADD TO FAVORITES
Future<void> addToFavorites(int carId) async {
  await _dio.post(
    '/favorite/cars',
    data: {
      'car_id': carId,
    },
  );
}

// MARK AS SOLD
Future<void> markAsSold(int carId) async {
  await _dio.patch(
    '/showroom/cars/$carId/pricing',
    data: {'is_sold': true},
  );
}

// REMOVE FROM FAVORITES
Future<void> removeFromFavorites(int carId) async {
  await _dio.delete(
    '/favorite/cars/$carId',
  );
}

// GET FAVORITE CARS (PAGINATED)
Future<Map<String, dynamic>> getFavoriteCars({
  int offset = 0,
  int limit = 20,
}) async {
  final res = await _dio.get(
    '/favorite/cars',
    queryParameters: {
      'offset': offset,
      'limit': limit,
    },
  );

  return res.data['data'];
}





  // ==============================
  // SEARCH HISTORY
  // ==============================
  Future<List<Map<String, dynamic>>> getSearchHistory() async {
    final res = await _dio.get('/search_history');
    final list = res.data['data']['search_history'] as List;
    return list.cast<Map<String, dynamic>>();
  }
}
