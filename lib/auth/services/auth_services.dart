import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  late final Dio _dio;

  AuthService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "https://3dkhd9zn8w.eu-central-1.awsapprunner.com/api/v1/auth",
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: const {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      ),
    );

    // ----------------------------------
    // 🔍 LOGGING (DEBUG ONLY)
    // ----------------------------------
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
        ),
      );
    }
  }

  // ==============================
  // 1️⃣ REQUEST OTP
  // ==============================
  Future<Response> requestOtp(String phone) async {
    return _dio.post(
      "/request_otp",
      data: {"phone": phone},
    );
  }

  // ==============================
  // 2️⃣ LOGIN WITH OTP
  // ==============================
  Future<Response> login(String phone, String otp) async {
    try {
      return await _dio.post(
        "/login",
        data: {
          "phone": phone,
          "otp": otp,
        },
      );
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  // ==============================
  // 3️⃣ COMPLETE PROFILE
  // ==============================
  Future<Response> completeProfile({
    required String tempToken,
    required String name,
    required int cityId,
  }) async {
    try {
      return await _dio.post(
        "/complete_profile",
        data: {
          "temp_token": tempToken,
          "name": name,
          "city_id": cityId,
        },
      );
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  // ==============================
  // 4️⃣ VERIFY ADMIN PASSWORD
  // ==============================
  Future<Response> verifyPassword({
    required String tempToken,
    required String password,
  }) async {
    try {
      return await _dio.post(
        "/verify_password",
        data: {
          "temp_token": tempToken,
          "password": password,
        },
      );
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  // ==============================
  // 5️⃣ REFRESH TOKEN
  // ==============================
  Future<Response> refreshToken(String refreshToken) async {
    try {
      return await _dio.post(
        "/refresh",
        data: {"refresh_token": refreshToken},
      );
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  // ==============================
  // 6️⃣ LOGOUT
  // ==============================
  Future<Response> logout(String accessToken) async {
    try {
      return await _dio.post(
        "/logout",
        options: Options(
          headers: {"Authorization": "Bearer $accessToken"},
        ),
      );
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  // ==============================
  // 7️⃣ GET CURRENT USER
  // ==============================
  Future<Response> getCurrentUser(String accessToken) async {
    try {
      return await _dio.get(
        "/me",
        options: Options(
          headers: {"Authorization": "Bearer $accessToken"},
        ),
      );
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  // ==============================
  // 🔥 CENTRAL ERROR HANDLER
  // ==============================
  void _handleError(DioException e) {
    if (kDebugMode) {
      debugPrint("❌ AUTH API ERROR");
      debugPrint("Status: ${e.response?.statusCode}");
      debugPrint("Data: ${e.response?.data}");
    }
  }
}
