import 'package:flutter/material.dart';
import 'package:firstreport/services/notification_service.dart';

class NotificationProvider with ChangeNotifier {
  int _unreadCount = 0;
  int get unreadCount => _unreadCount;

  Future<void> updateUnreadCount() async {
    try {
      final count = await NotificationService.getUnreadCount();
      if (_unreadCount != count) {
        _unreadCount = count;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating unread count in provider: $e');
    }
  }

  void decrementCount() {
    if (_unreadCount > 0) {
      _unreadCount--;
      notifyListeners();
    }
  }

  void setCount(int count) {
    _unreadCount = count;
    notifyListeners();
  }
}
