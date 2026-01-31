
import 'package:flutter/material.dart';
import 'package:get/Get.dart';

/// Global: Show language changed snackbar
/// Can be called from ANY file without import: showLanguageChangedSnackBar(locale)
void showSnackbar(String title, String message) {
  

  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.red[300],
    colorText: Colors.white,
    duration: const Duration(seconds: 2),
    margin: const EdgeInsets.all(16),
    borderRadius: 12,
    animationDuration: const Duration(milliseconds: 400),
    forwardAnimationCurve: Curves.easeOutCubic,
    reverseAnimationCurve: Curves.easeIn,
    icon: const Icon(Icons.language, color: Colors.white, size: 28),
    shouldIconPulse: true,
    mainButton: TextButton(
      onPressed: Get.back,
      child: Text(
        'OK'.tr,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}