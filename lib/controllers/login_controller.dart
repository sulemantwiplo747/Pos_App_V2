import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_v2/constants/api_urls.dart';
import 'package:pos_v2/core/services/api_services.dart'
    show ApiService, ApiException;

import '../constants/app_keys.dart';
import '../core/app_storage.dart';
import '../models/user_signup_model.dart';
import '../screens/home_screen.dart';
import '../utils/snakbar_helper.dart';

class LoginController extends GetxController {
  final api = Get.find<ApiService>();
  final formKey = GlobalKey<FormState>();

  // Text controllers

  // Loading state
  var isLoading = false.obs;

  // Validation
  String? validateUserName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> login({required String email, required String password}) async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading.value = true;

    try {
      final data = await api.post(
        ApiUrls.loginUrl,
        body: {"username": email, "password": password},
      );
      if (data['success'] == true) {
        final model = UserSignupModel.fromJson(data);
        await AppStorage.writeString(
          AppKeys.userToken,
          model.message!.accessToken!,
        );
        Get.offAll(HomeScreen());
      } else {
        SnackbarHelper.showError(data['message'] ?? "Login failed");
      }
    } on ApiException catch (e) {
      SnackbarHelper.showError(e.message);
    } catch (e) {
      SnackbarHelper.showError("An unexpected error occurred");
    } finally {
      isLoading.value = false;
    }
  }
}
