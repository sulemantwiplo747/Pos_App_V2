import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_v2/constants/app_constants.dart';
import 'package:pos_v2/core/services/api_services.dart'
    show ApiException, ApiService;
import 'package:pos_v2/screens/auth/widget/success_dialoug.dart'
    show SuccessDialog;

import '../constants/api_urls.dart';
import '../utils/snakbar_helper.dart';

class ChangePasswordController extends GetxController {
  var isLoading = false.obs;
  final ApiService api = Get.find<ApiService>();
  var showCurrent = false.obs;
  var showNew = false.obs;
  var showConfirm = false.obs;

  String? validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'password_empty'.tr;
    if (v.length < 6) return 'password_min_length'.tr;
    return null;
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    isLoading.value = true;

    try {
      final headers = await AppConstants.getAuthHeaders();
      final data = await api.post(
        ApiUrls.changePassword,
        headers: headers,
        body: {"current_password": currentPassword, "password": newPassword},
      );
      if (data['success'] == true) {
        showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (_) => WillPopScope(
            onWillPop: () async => false,
            child: SuccessDialog(
              title: 'password_updated_head'.tr,
              message: 'password_changed_successfully'.tr,
              animation: 'assets/lottie/logout.json',
              btnText: 'logout'.tr,
              onDone: () {
                AppConstants.logout();
              },
            ),
          ),
        );
      } else {
        SnackbarHelper.showError(data['message'] ?? 'try_again'.tr);
      }
    } on ApiException catch (e) {
      SnackbarHelper.showError(e.message);
    } catch (e) {
      SnackbarHelper.showError('unexpected_error'.tr);
    } finally {
      isLoading.value = false;
    }
  }
}
