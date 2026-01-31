import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos_v2/constants/app_keys.dart';
import 'package:pos_v2/screens/home_screen.dart';
import 'package:pos_v2/screens/language/language_selector_screen.dart';

import '../core/services/analytics_services.dart';
import '../utils/app_utils.dart';

class SplashController extends GetxController {
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();

    _navigate();
  }

  Future<void> _navigate() async {
    DeviceUtils.getFcmToken();
    await AnalyticsService.logScreen(screenName: 'Splash');
    Timer(const Duration(seconds: 4), () {
      final savedLocale = box.read('locale');
      final token = box.read(AppKeys.userToken);

      if (savedLocale == null || savedLocale.toString().isEmpty) {
        Get.offAll(LanguageScreen());
      } else if (token != null && token.toString().isNotEmpty) {
        Get.offAll(HomeScreen());
      } else {
        Get.offAll(LanguageScreen());
      }
    });
  }

  // void _navigate() {
  //   DeviceUtils.getFcmToken();
  //   Timer(const Duration(seconds: 4), () {
  //     final lang = box.read(AppKeys.appLanguage);
  //     final token = box.read(AppKeys.userToken);

  //     if (lang == null || lang.toString().isEmpty) {
  //       Get.offAll(LanguageScreen());
  //     } else if (token != null && token.toString().isNotEmpty) {
  //       Get.offAll(HomeScreen());
  //     } else {
  //       Get.offAll(LanguageScreen());
  //     }
  //   });
  // }
}
