import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pos_v2/constants/app_colors.dart' show AppColors;
import 'package:pos_v2/controllers/login_controller.dart';
import 'package:pos_v2/screens/auth/frogetPassword/forget_password.dart';
import 'package:pos_v2/screens/auth/register/register_main_screen.dart';

import '../../../core/services/analytics_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final LoginController controller = Get.put(LoginController());
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  late final AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
    AnalyticsService.logScreen(screenName: 'Login');
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAnimatedIllustration(),
                const SizedBox(height: 20),
                Text(
                  'welcome_back'.tr,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'sign_in_continue'.tr,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: userNameController,
                  decoration: InputDecoration(
                    labelText: 'user_name'.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: controller.validateUserName,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'password'.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  validator: controller.validatePassword,
                ),
                const SizedBox(height: 30),
                Obx(() {
                  return controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            controller.login(
                              email: userNameController.text,
                              password: passwordController.text,
                            );
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
                            'login'.tr,
                            style: const TextStyle(fontSize: 18),
                          ),
                        );
                }),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    AnalyticsService.logScreen(screenName: 'ForgetPassword');
                    Get.to(() => ForgotPasswordScreen());
                  },
                  child: Text(
                    'forgot_password'.tr,
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("dont_have_account".tr),
                    TextButton(
                      onPressed: () {
                        AnalyticsService.logScreen(screenName: 'Register');
                        Get.to(() => RegisterScreen(isFamilyMember: false));
                      },
                      child: Text(
                        'register'.tr,
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIllustration() {
    return SizedBox(
      width: 250,
      height: 250,
      child: Lottie.asset(
        'assets/lottie/cart.json',
        controller: _lottieController,
        animate: true,
        repeat: true,
        onLoaded: (composition) {
          _lottieController
            ..duration = composition.duration
            ..repeat();
        },
      ),
    );
  }
}
