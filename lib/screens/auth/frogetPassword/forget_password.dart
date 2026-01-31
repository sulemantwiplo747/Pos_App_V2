import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../controllers/auth_controller.dart';
import '../../../core/services/analytics_services.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  final AuthController controller = Get.put(AuthController());
  final forgotPasswordFormKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'forget_password'.tr,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: forgotPasswordFormKey,
          child: Column(
            children: [
              Lottie.asset(
                'assets/lottie/forget.json',
                height: 200,
                width: 200,
                fit: BoxFit.fill,
                animate: true,
                repeat: true,
              ),
              const SizedBox(height: 20),

              /// Title
              Text(
                'forgot_password_title'.tr,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              /// Subtitle
              Text(
                'forgot_password_subtitle'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              /// Username / Email Field
              TextFormField(
                controller: userNameController,
                decoration: InputDecoration(
                  labelText: 'username'.tr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
                validator: controller.validateEmailOrPhone,
              ),
              const SizedBox(height: 30),

              /// Send OTP Button
              Obx(() {
                return controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.blue)
                    : ElevatedButton(
                        onPressed: () async {
                          if (forgotPasswordFormKey.currentState!.validate()) {
                            AnalyticsService.logScreen(
                              screenName: 'ForgetPasswordOTP',
                            );
                            await controller.sendOtp(
                              userName: userNameController.text,
                              isResend: false,
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
                          'send_otp'.tr,
                          style: const TextStyle(fontSize: 18),
                        ),
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
