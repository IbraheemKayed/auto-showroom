import 'package:flutter/material.dart';
import 'package:sayarti/ai_search/services/car_api_service.dart';
import 'package:sayarti/home/models/app_notification.dart';

class NotificationsProvider extends ChangeNotifier {
  final CarApiService api;

  NotificationsProvider(this.api) {
    // Load badge count silently at startup
    Future.microtask(load);
  }

  List<AppNotification> notifications = [];
  bool isLoading = false;
  String? error;

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      notifications = await api.getNotifications();
    } catch (_) {
      error = 'Failed to load notifications';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> markAllRead() async {
    final unreadIds = notifications
        .where((n) => !n.isRead)
        .map((n) => n.id)
        .toList();
    if (unreadIds.isEmpty) return;
    try {
      await api.markNotificationsRead(unreadIds);
    } catch (_) {}
    notifications = notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
  }
}
