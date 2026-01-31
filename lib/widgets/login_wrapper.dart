import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos_v2/constants/app_constants.dart';
import 'package:pos_v2/controllers/locale_controller.dart';
import 'package:pos_v2/dialogs/my_qr_dialog.dart';
import 'package:pos_v2/screens/auth/edit_profile_screen.dart';
import 'package:pos_v2/screens/qr_scanner_screen.dart';

import '../controllers/bottom_nav_controller.dart';
import '../screens/auth/update_password.dart';

class LoginWrapper extends StatefulWidget {
  final Widget child;
  final String? title;
  final VoidCallback? onWalletTap;
  const LoginWrapper({
    super.key,
    required this.child,
    this.title,
    this.onWalletTap,
  });

  @override
  State<LoginWrapper> createState() => _LoginWrapperState();
}

class _LoginWrapperState extends State<LoginWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _scaleAnimation;

  // Add your locales here (you can extend later)
  final List<Locale> _locales = const [
    Locale('en', 'US'), // LTR
    Locale('ar', 'AE'), // RTL
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // --------------------------------------------------------------
  // 1. Show the main menu dialog (unchanged except language tile)
  // --------------------------------------------------------------
  void _showMenuDialog(BuildContext context) {
    _animController.forward(from: 0.0);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 350,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ----- User info -----
                  Row(
                    children: [
                      Obx(() {
                        final user = AppConstants.currentUser.value?.userData;
                        final images = user?.imageUrl?.imageUrls;

                        final img =
                            (images != null &&
                                images.isNotEmpty &&
                                images.first.trim().isNotEmpty)
                            ? images.first.trim()
                            : "";

                        return CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: img.isNotEmpty
                              ? NetworkImage(img)
                              : null,
                          child: img.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  size: 20,
                                  color: Colors.grey,
                                )
                              : null,
                        );
                      }),
                      // CircleAvatar(
                      //   backgroundColor: Color(0xFFE0E0E0),
                      //   child: Icon(
                      //     Icons.person,
                      //     color: Colors.white,
                      //     size: 30,
                      //   ),
                      // ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppConstants.currentUser.value!.userData!.name ??
                                  "",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.badge_outlined, // Gov ID icon
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  AppConstants
                                          .currentUser
                                          .value!
                                          .userData!
                                          .govId ??
                                      "",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ----- Menu items -----
                  _buildMenuTile(
                    icon: Icons.qr_code,
                    title: 'my_qr'.tr,
                    onTap: () {
                      Get.back();
                      _showQRCodeDialog();
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: Color.fromARGB(255, 235, 235, 235),
                  ),
                  _buildMenuTile(
                    icon: Icons.person,
                    title: 'edit_info'.tr,
                    onTap: () {
                      Get.back();
                      Get.to(() => EditProfileScreen());
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: Color.fromARGB(255, 235, 235, 235),
                  ),
                  _buildMenuTile(
                    icon: Icons.wallet,
                    title: 'wallets'.tr,
                    onTap: () {
                      Get.back();
                      final BottomNavController navController = Get.find();
                      navController.changeIndex(1);
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: Color.fromARGB(255, 235, 235, 235),
                  ),

                  // ---------- LANGUAGE SWITCHER ----------
                  _buildMenuTile(
                    icon: Icons.language,
                    title: 'change_language'.tr,
                    onTap: () {
                      Get.back(); // close menu
                      _showLanguagePicker(); // open language dialog
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: Color.fromARGB(255, 235, 235, 235),
                  ),
                  _buildMenuTile(
                    icon: Icons.lock,
                    title: 'change_password'.tr,
                    onTap: () {
                      Get.off(ChangePasswordScreen());
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: Color.fromARGB(255, 235, 235, 235),
                  ),

                  _buildMenuTile(
                    icon: Icons.logout,
                    title: 'logout'.tr,
                    color: Colors.red,
                    onTap: () {
                      Get.back();
                      _showLogoutDialog();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).then((_) => _animController.reset());
  }

  // --------------------------------------------------------------
  // 2. Language picker dialog (zoom-in, RTL aware)
  // --------------------------------------------------------------
  void _showLanguagePicker() {
    _animController.forward(from: 0.0);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'select_language'.tr,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ..._locales.map((locale) {
                  final isCurrent = Get.locale == locale;
                  final langName = locale.languageCode == 'en'
                      ? 'English'
                      : locale.languageCode == 'ar'
                      ? 'العربية'
                      : locale.languageCode.toUpperCase();

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCurrent
                            ? Colors.blue
                            : Colors.grey[300],
                        foregroundColor: isCurrent
                            ? Colors.white
                            : Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      onPressed: () {
                        Get.back(); // close picker
                        _changeLocale(locale);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (locale.languageCode == 'ar') ...[
                            const Icon(Icons.arrow_back_ios, size: 16),
                            const SizedBox(width: 8),
                          ],
                          Text(langName, style: TextStyle(fontSize: 24)),
                          if (locale.languageCode != 'ar') ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    ).then((_) => _animController.reset());
  }

  void _changeLocale(Locale locale) {
    Get.updateLocale(locale);
    GetStorage().write(
      'locale',
      '${locale.languageCode}_${locale.countryCode ?? ''}',
    );
  }

  // --------------------------------------------------------------
  // 4. Helper tiles (unchanged)
  // --------------------------------------------------------------
  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    Color? color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black87, size: 22),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, color: color ?? Colors.black87),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      minLeadingWidth: 30,
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('logout'.tr),
        content: Text('logout_confirmation'.tr),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Get.back();
              await AppConstants.logout();
            },
            child: Text('logout'.tr, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showQRCodeDialog() {
    _animController.reset();

    showDialog(
      context: context,
      barrierDismissible: true, // Re-enable
      builder: (_) => MyQRDialog(animationController: _animController),
    ).then((_) {
      _animController.reset(); // Reset after close
    });

    // Start animation AFTER dialog is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animController.forward();
    });
  }

  // --------------------------------------------------------------
  // 5. Scaffold (unchanged)
  // --------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: widget.title != null
            ? Text(
                widget.title!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              )
            : null,
        actions: [
          GetBuilder<LocaleController>(
            init: LocaleController(), // Initialize once
            builder: (controller) {
              final isRtl = Get.locale?.languageCode == 'ar';

              return Padding(
                padding: EdgeInsets.only(
                  right: isRtl ? 0 : 16,
                  left: isRtl ? 16 : 0,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(
                        () => const QRScannerScreen(),
                        transition: Transition.native,
                      ),
                      child: const Icon(
                        Icons.qr_code_scanner,
                        color: Colors.blue,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Obx(() {
                      final user = AppConstants.currentUser.value?.userData;
                      final images = user?.imageUrl?.imageUrls;

                      final img =
                          (images != null &&
                              images.isNotEmpty &&
                              images.first.trim().isNotEmpty)
                          ? images.first.trim()
                          : "";

                      return GestureDetector(
                        onTap: () => _showMenuDialog(context),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: img.isNotEmpty
                              ? NetworkImage(img)
                              : null,
                          child: img.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  size: 20,
                                  color: Colors.grey,
                                )
                              : null,
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: widget.child,
    );
  }
}
