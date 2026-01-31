import 'package:get/get.dart';

class LocaleController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Listen to Get.locale changes and trigger UI update
    ever(Get.locale.obs, (_) => update());
  }
}