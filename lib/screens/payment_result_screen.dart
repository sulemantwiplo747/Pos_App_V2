import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pos_v2/constants/app_colors.dart';
import 'package:pos_v2/controllers/bottom_nav_controller.dart';
import 'package:pos_v2/controllers/home_controller.dart';
import 'package:pos_v2/controllers/wallet_controller.dart';
import 'package:pos_v2/screens/home_screen.dart';

class PaymentResultScreen extends StatefulWidget {
  final bool isSuccess;
  final double amount;
  final String shopName;

  const PaymentResultScreen({
    super.key,
    required this.isSuccess,
    this.amount = 102.99,
    this.shopName = 'ABC Shop',
  });

  @override
  State<PaymentResultScreen> createState() => _PaymentResultScreenState();
}

class _PaymentResultScreenState extends State<PaymentResultScreen>
    with TickerProviderStateMixin {
  late final AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    // Lottie controller will be driven by the LottieAnimation widget itself,
    // but we keep a reference in case we need to restart it later.
    _lottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    Get.find<BottomNavController>().changeIndex(1);
    Get.offAll(() => HomeScreen());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<HomeController>().getCurrentBalance();
      if (Get.isRegistered<WalletController>()) {
        Get.find<WalletController>().fetchTransactions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _navigateToHome();
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 236, 236, 236),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 380),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ------------------- ANIMATED ILLUSTRATION -------------------
                  _buildAnimatedIllustration(),

                  // const SizedBox(height: 32),

                  // ------------------- TITLE -------------------
                  Text(
                    widget.isSuccess
                        ? 'Payment successful!'
                        : 'Oh no!\nSomething went wrong.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: widget.isSuccess
                          ? Colors.black87
                          : Colors.red.shade700,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ------------------- SUBTITLE -------------------
                  if (widget.isSuccess)
                    Text(
                      'The payment of \$${widget.amount.toStringAsFixed(2)} '
                      'has successfully been sent to ${widget.shopName} '
                      'from your wallet.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    )
                  else
                    const Text(
                      'We weren\'t able to process your payment. '
                      'Please try again.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.redAccent,
                        height: 1.5,
                      ),
                    ),

                  const SizedBox(height: 32),

                  // ------------------- ACTION BUTTON -------------------
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _navigateToHome,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.isSuccess
                            ? AppColors.primaryOrange
                            : AppColors.lightOrange,
                        foregroundColor: widget.isSuccess
                            ? Colors.white
                            : Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        widget.isSuccess ? 'Complete' : 'Try again',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// --------------------------------------------------------------
  /// Animated illustration using Lottie
  /// --------------------------------------------------------------
  Widget _buildAnimatedIllustration() {
    // Choose the correct JSON file
    final String asset = widget.isSuccess
        ? 'assets/lottie/success.json'
        : 'assets/lottie/error.json';

    return SizedBox(
      width: 250,
      height: 250,
      child: Lottie.asset(
        asset,
        controller: _lottieController,
        animate: true,
        repeat: true,

        onLoaded: (composition) {
          // Play once (you can set repeat: true if you want a loop)
          _lottieController
            ..duration = composition.duration
            ..repeat(); // <-- This makes it loop continuously
        },
      ),
    );
  }
}
