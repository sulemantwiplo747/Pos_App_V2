import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class AnalyticsService {
  AnalyticsService._();

  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      await _analytics.logEvent(
        name: name,
        parameters: _toAnalyticsParams(parameters),
      );
    } catch (e) {
      debugPrint('Firebase Analytics error: $e');
    }
  }
  static Future<void> logScreen({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
    } catch (e) {
      debugPrint('Screen tracking error: $e');
    }
  }
  static Future<void> setUser({
    required String userId,
    String? userRole,
  }) async {
    try {
      await _analytics.setUserId(id: userId);

      if (userRole != null) {
        await _analytics.setUserProperty(name: 'role', value: userRole);
      }
    } catch (e) {
      debugPrint('Set user error: $e');
    }
  }
  static Map<String, Object>? _toAnalyticsParams(Map<String, dynamic>? params) {
    if (params == null) return null;

    return params.map((key, value) => MapEntry(key, _parseValue(value)));
  }


  static Object _parseValue(dynamic value) {
    if (value is String || value is int || value is double || value is bool) {
      return value;
    }
    return value.toString();
  }
}
