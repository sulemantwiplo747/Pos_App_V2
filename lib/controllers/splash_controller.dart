import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos_v2/constants/app_keys.dart';
import 'package:pos_v2/screens/home_screen.dart';
import 'package:pos_v2/screens/language/language_selector_screen.dart';

import '../constants/api_urls.dart';
import '../constants/app_constants.dart';
import '../core/services/analytics_services.dart';
import '../core/services/api_services.dart';
import '../models/app_config_model.dart';
import '../utils/app_utils.dart';

class SplashController extends GetxController {
  final box = GetStorage();
  final api = Get.find<ApiService>();
  @override
  void onInit() {
    super.onInit();
    fetchAppConfigs();
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

  Future<void> fetchAppConfigs() async {
    try {
      final headers = await AppConstants.getAuthHeaders();

      final data = await api.get(ApiUrls.configsUrl, headers: headers);

      print("✅ Config API Response: $data");

      final configModel = AppConfig.fromJson(data);

      if (configModel.success == true) {
        // ✅ Save in AppConstants
        AppConstants.saveConfig(configModel);

        print("✅ Config Saved Successfully");
        print("Base URL: ${AppConstants.paymentBaseUrl}");
        print("API Key: ${AppConstants.paymentApiKey}");
      }
    } catch (e) {
      print("❌ Config API Error: $e");
    }
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
