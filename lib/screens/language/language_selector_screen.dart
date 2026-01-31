import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/services/analytics_services.dart';
import '../../utils/snakbar_helper.dart';
import '../auth/login/login_screen.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final List<Map<String, dynamic>> languages = [
    {"locale": const Locale('en', 'US'), "title": "English"},
    {"locale": const Locale('ar', 'AE'), "title": "العربية"},
  ];

  final Rx<Locale?> selectedLocale = Rx<Locale?>(null);

  void _changeLocale(Locale locale) {
    selectedLocale.value = locale;
    Get.updateLocale(locale);
    GetStorage().write(
      'locale',
      '${locale.languageCode}_${locale.countryCode ?? ''}',
    );
  }

  void _saveAndProceed() {
    if (selectedLocale.value != null) {
      Get.offAll(() => const LoginScreen());
    } else {
      SnackbarHelper.showError("language_error".tr);
    }
  }

  @override
  void initState() {
    AnalyticsService.logScreen(screenName: 'Language');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              "welcome_message".tr,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            // const SizedBox(height: 6),
            // Text(
            //   "choose_language".tr,
            //   style: const TextStyle(fontSize: 18, color: Colors.black54),
            //   textAlign: TextAlign.center,
            // ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: languages.length,
                itemBuilder: (_, index) {
                  final item = languages[index];
                  final Locale itemLocale = item["locale"];

                  return Obx(() {
                    final isSelected =
                        selectedLocale.value?.languageCode ==
                        itemLocale.languageCode;

                    return GestureDetector(
                      onTap: () => _changeLocale(itemLocale),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: isSelected
                                ? Colors.blue
                                : Colors.grey.shade400,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Button text stays English/Arabic
                            Text(
                              item["title"],
                              style: TextStyle(
                                fontSize: 20,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey.shade600,
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      size: 18,
                                      color: Colors.blue,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "language_info".tr,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                onPressed: _saveAndProceed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "continue".tr,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
