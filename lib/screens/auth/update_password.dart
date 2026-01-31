import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/chnage_password_controller.dart';
import '../../core/services/analytics_services.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final ChangePasswordController controller = Get.put(
    ChangePasswordController(),
  );

  final formKey = GlobalKey<FormState>();

  final TextEditingController currentPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AnalyticsService.logScreen(screenName: 'ChangePassword');
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'change_password'.tr,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Lottie.asset(
                    'assets/lottie/update.json',
                    animate: true,
                    repeat: true,
                  ),
                ),
                const SizedBox(height: 30),

                Text(
                  'secure_account'.tr,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'secure_account_desc'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),

                const SizedBox(height: 10),

                // Current Password
                Obx(() {
                  return TextFormField(
                    controller: currentPassword,
                    obscureText: !controller.showCurrent.value,
                    decoration: InputDecoration(
                      labelText: 'current_password'.tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                    validator: controller.validatePassword,
                  );
                }),

                const SizedBox(height: 20),

                // New Password
                Obx(() {
                  return TextFormField(
                    controller: newPassword,
                    obscureText: !controller.showNew.value,
                    decoration: InputDecoration(
                      labelText: 'new_password'.tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                    ),
                    validator: controller.validatePassword,
                  );
                }),

                const SizedBox(height: 20),

                // Confirm Password
                Obx(() {
                  return TextFormField(
                    controller: confirmPassword,
                    obscureText: !controller.showConfirm.value,
                    decoration: InputDecoration(
                      labelText: 'confirm_new_password'.tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.lock_person_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.showConfirm.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          controller.showConfirm.value =
                              !controller.showConfirm.value;
                        },
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'confirm_password_required'.tr;
                      }
                      if (v != newPassword.text) {
                        return 'passwords_not_match'.tr;
                      }
                      return null;
                    },
                  );
                }),

                const SizedBox(height: 40),

                // Submit Button
                Obx(() {
                  return controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.blue)
                      : ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              await controller.changePassword(
                                currentPassword: currentPassword.text,
                                newPassword: newPassword.text,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'update_password'.tr,
                            style: const TextStyle(fontSize: 18),
                          ),
                        );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
