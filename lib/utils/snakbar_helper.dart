import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarHelper {
  static DateTime? _lastErrorShownAt;
  static const _errorThrottleDuration = Duration(seconds: 2);

  /// Prevents showing multiple error toasts in quick succession (e.g. when several APIs fail at once).
  static bool _shouldThrottleError() {
    final now = DateTime.now();
    if (_lastErrorShownAt != null &&
        now.difference(_lastErrorShownAt!) < _errorThrottleDuration) {
      return true;
    }
    _lastErrorShownAt = now;
    return false;
  }

  // Success snackbar
  static void showSuccess(String message) {
    Get.snackbar(
      "success".tr,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle, color: Colors.white),
      snackStyle: SnackStyle.FLOATING,
      animationDuration: const Duration(milliseconds: 500),
    );
  }

  // Error snackbar
  static void showError(String message) {
    if (_shouldThrottleError()) return;
    Get.snackbar(
      "error".tr,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.error, color: Colors.white),
      snackStyle: SnackStyle.FLOATING,
      animationDuration: const Duration(milliseconds: 500),
    );
  }

  // Optional: Info snackbar
  static void showInfo(String message) {
    Get.snackbar(
      "Info",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.info, color: Colors.white),
      snackStyle: SnackStyle.FLOATING,
      animationDuration: const Duration(milliseconds: 500),
    );
  }
}
