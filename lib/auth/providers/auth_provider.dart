import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sayarti/auth/models/user_model.dart';
import 'package:sayarti/auth/services/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

enum AuthState {
  loggedOut,
  waitingForOtp,
  waitingForProfile,
  waitingForAdminPassword,
  loggedIn,
  loading,
}

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  // ========================================
  // 📱 PHONE FIELDS
  // ========================================
  String countryCode = "+970";
  String phoneNumber = "";

  String get fullNumber => "$countryCode$phoneNumber";

  void setCountryCode(String value) {
    countryCode = value;
    notifyListeners();
  }

  void setPhoneNumber(String value) {
    phoneNumber = value;
    notifyListeners();
  }

  // ========================================
  // 🔐 AUTH FIELDS
  // ========================================
  String? tempToken;
  String? accessToken;
  String? refreshToken;
  UserModel? user;

  AuthState state = AuthState.loggedOut;
  String? errorMessage;

  // ========================================
  // 🔥 LOGIN CALLBACK (SINGLE SOURCE)
  // ========================================
  VoidCallback? _onLoggedIn;

  void setOnLoggedIn(VoidCallback callback) {
    _onLoggedIn = callback;
  }

  void _triggerLoggedIn() {
    _onLoggedIn?.call();
  }

  // ========================================
  // 🚪 PRE-LOGOUT CALLBACK
  // ========================================
  Future<void> Function()? _preLogoutCallback;

  void setPreLogoutCallback(Future<void> Function() callback) {
    _preLogoutCallback = callback;
  }

  void _setError(String message, AuthState fallbackState) {
    errorMessage = message;
    state = fallbackState;
    notifyListeners();
  }

  // ========================================
  // ⬅️ BACK TO PHONE ENTRY
  // ========================================
  void backToPhoneEntry() {
    state = AuthState.loggedOut;
    notifyListeners();
  }

  // ========================================
  // 📲 1) REQUEST OTP
  // ========================================
  Future<void> requestOtp() async {
    try {
      errorMessage = null;
      state = AuthState.loading;
      notifyListeners();
      await _authService.requestOtp(fullNumber);
      state = AuthState.waitingForOtp;
      notifyListeners();
    } catch (e) {
      _setError("Failed to send OTP", AuthState.loggedOut);
    }
  }

  // ========================================
  // 🔑 2) VERIFY OTP
  // ========================================
  Future<void> verifyOtp(String otp) async {
    try {
      errorMessage = null;
      state = AuthState.loading;
      notifyListeners();

      final res = await _authService.login(fullNumber, otp);
      final data = res.data['data'];

      // ADMIN
      if (data["requires_password"] == true) {
        tempToken = data["temp_token"];
        user = UserModel.fromJson(data["user"]);
        await _saveUser();

        state = AuthState.waitingForAdminPassword;
        notifyListeners();
        return;
      }

      // NEW USER
      if (data["requires_profile"] == true) {
        tempToken = data["temp_token"];
        state = AuthState.waitingForProfile;
        notifyListeners();
        return;
      }

      // NORMAL LOGIN
      accessToken = data["access_token"];
      refreshToken = data["refresh_token"];
      user = UserModel.fromJson(data["user"]);
      await _saveUser();
      await _saveTokens();
      try { await refreshUser(); } catch (_) {}

      state = AuthState.loggedIn;
      notifyListeners();

      _triggerLoggedIn();
    } catch (e) {
      _setError("Invalid OTP", AuthState.waitingForOtp);
    }
  }

  // ========================================
  // 📝 3) COMPLETE PROFILE
  // ========================================
  Future<void> completeProfile(String name, int cityId) async {
    try {
      errorMessage = null;
      state = AuthState.loading;
      notifyListeners();

      final res = await _authService.completeProfile(
        tempToken: tempToken!,
        name: name,
        cityId: cityId,
      );

      final data = res.data['data'];

      accessToken = data["access_token"];
      refreshToken = data["refresh_token"];
      user = UserModel.fromJson(data["user"]);
      await _saveUser();
      await _saveTokens();
      try { await refreshUser(); } catch (_) {}

      state = AuthState.loggedIn;
      notifyListeners();

      _triggerLoggedIn();
    } catch (e) {
      _setError("Failed to complete profile", AuthState.waitingForProfile);
    }
  }

  // ========================================
  // 🔐 4) VERIFY ADMIN PASSWORD
  // ========================================
  Future<void> verifyAdminPassword(String password) async {
    try {
      errorMessage = null;
      state = AuthState.loading;
      notifyListeners();

      final res = await _authService.verifyPassword(
        tempToken: tempToken!,
        password: password,
      );

      final data = res.data['data'];

      accessToken = data["access_token"];
      refreshToken = data["refresh_token"];
      user = UserModel.fromJson(data["user"]);
      await _saveUser();
      await _saveTokens();
      try { await refreshUser(); } catch (_) {}

      state = AuthState.loggedIn;
      notifyListeners();

      _triggerLoggedIn();
    } catch (e) {
      _setError("Wrong admin password", AuthState.waitingForAdminPassword);
    }
  }

  // ========================================
  // 🚪 5) LOGOUT
  // ========================================
  Future<void> logout() async {
    print('logout');
  try {
    await _preLogoutCallback?.call();
  } catch (_) {}
  try {
    print('logout');
    if (accessToken != null) {
      await _authService.logout(accessToken!);
    }
  } catch (_) {}

  accessToken = null;
  refreshToken = null;
  tempToken = null;
  user = null;
  errorMessage = null;

  final prefs = await SharedPreferences.getInstance();
  await prefs.remove("access_token");
  await prefs.remove("refresh_token");
  await prefs.remove("user");
  
  state = AuthState.loggedOut;
  
  notifyListeners();
}


  // ========================================
  // 💾 Save Tokens
  // ========================================
  Future<void> _saveTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("access_token", accessToken!);
    await prefs.setString("refresh_token", refreshToken!);
  }

  // ========================================
  // 🔄 LOAD STORED TOKENS
  // ========================================
  Future<void> loadSavedTokens() async {
  final prefs = await SharedPreferences.getInstance();

  accessToken = prefs.getString("access_token");
  refreshToken = prefs.getString("refresh_token");

  if (accessToken != null && accessToken!.isNotEmpty) {
    await _loadUser();

    // Proactively refresh the access token so we start with a valid one.
    // If the refresh token itself is expired (401), log out immediately so
    // the home screen is never shown with an invalid token.
    if (refreshToken != null && refreshToken!.isNotEmpty) {
      try {
        final res = await _authService.refreshToken(refreshToken!);
        final data = res.data['data'] ?? res.data;
        accessToken = data['access_token'];
        refreshToken = data['refresh_token'] ?? refreshToken;
        await _saveTokens();
      } on DioException catch (e) {
        if (e.response?.statusCode == 401) {
          // Both tokens definitively expired — go straight to login.
          accessToken = null;
          refreshToken = null;
          await prefs.remove('access_token');
          await prefs.remove('refresh_token');
          state = AuthState.loggedOut;
          notifyListeners();
          return;
        }
        // Network / server error — proceed with the existing token and let
        // the app handle failures gracefully.
      } catch (_) {
        // Unknown error — same: proceed optimistically.
      }
    }

    try { await refreshUser(); } catch (_) {}
    state = AuthState.loggedIn;
  } else {
    state = AuthState.loggedOut;
  }

  notifyListeners();
}

  // ========================================
  // 🔄 REFRESH ACCESS TOKEN
  // ========================================
  Future<bool> refreshAccessToken() async {
    try {
      if (refreshToken == null || refreshToken!.isEmpty) {
        return false;
      }

      final res = await _authService.refreshToken(refreshToken!);
      final data = res.data['data'] ?? res.data;

      accessToken = data['access_token'];
      refreshToken = data['refresh_token'] ?? refreshToken;

      await _saveTokens();

      // ❌ لا تغيّر state
      // ❌ لا trigger callbacks

      return true;
    } catch (e) {
      await logout();
      return false;
    }
  }

  Future<void> _saveUser() async {
  if (user == null) return;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('user', jsonEncode(user!.toJson()));
}

Future<void> _loadUser() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString('user');
  if (raw != null) {
    user = UserModel.fromJson(jsonDecode(raw));
  }
}

Future<void> refreshUser() async {
  if (accessToken == null) return;

  final res = await _authService.getCurrentUser(accessToken!);
  // /me response shape: {"data": {"id":1, "user_type":"showroom", "data": {...showroom fields including id = showroom_id...}}}
  final outer = res.data['data'] as Map<String, dynamic>;
  final inner = (outer['data'] as Map<String, dynamic>?) ?? {};
  // inner already contains showroom_id for showroom-type users
  user = UserModel.fromJson({
    ...inner,
    'id': outer['id'],
    'user_type': outer['user_type'],
  });
  await _saveUser();
  notifyListeners();
}


}
