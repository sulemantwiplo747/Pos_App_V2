import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart'
    hide TextStyle;
import 'package:pos_v2/constants/api_urls.dart';
import 'package:pos_v2/constants/app_constants.dart';
import 'package:pos_v2/core/services/api_services.dart';
import 'package:pos_v2/models/get_order_detail_model.dart';
import 'package:pos_v2/screens/payment_result_screen.dart';

const _methodChannel = MethodChannel("com.ottu.sample/checkout");
const _methodCheckoutHeight = "METHOD_CHECKOUT_HEIGHT";
// Ottu native SDK may send payment result with this method name
const _methodPaymentSuccess = "METHOD_PAYMENT_SUCCESS_RESULT";
const _methodPaymentFailure = "METHOD_PAYMENT_FAILURE";

class OttuCheckoutScreen extends StatefulWidget {
  final String sessionId;
  final double amount;
  final String orderNo;

  const OttuCheckoutScreen({
    super.key,
    required this.sessionId,
    required this.amount,
    required this.orderNo,
  });

  @override
  State<OttuCheckoutScreen> createState() => _OttuCheckoutScreenState();
}

class _OttuCheckoutScreenState extends State<OttuCheckoutScreen> {
  final _checkoutHeight = ValueNotifier(500);
  bool _isWaitingForConfirmation = false;
  bool _pollingCancelled = false;
  static const _pollInterval = Duration(seconds: 2);
  static const _maxPollAttempts = 45; // ~90 seconds max

  @override
  void initState() {
    super.initState();
    print("sessionId:${widget.sessionId}");
    _methodChannel.setMethodCallHandler((call) async {
      if (call.method == _methodCheckoutHeight) {
        _checkoutHeight.value = call.arguments as int;
      } else if (call.method == _methodPaymentSuccess) {
        if (!_isWaitingForConfirmation && mounted) {
          _onPaymentSuccessFromOttu();
        }
      } else if (call.method == _methodPaymentFailure) {
        if (mounted) {
          _onPaymentFailureFromOttu();
        }
      }
    });
  }

  void _onPaymentSuccessFromOttu() {
    if (!mounted || _isWaitingForConfirmation) return;
    setState(() => _isWaitingForConfirmation = true);
    _pollOrderDetailsUntilCompleted();
  }

  void _onPaymentFailureFromOttu() {
    if (!mounted) return;
    Get.off(
      () => PaymentResultScreen(
        isSuccess: false,
        amount: widget.amount,
        shopName: 'Wallet Recharge',
      ),
    );
  }

  Future<void> _pollOrderDetailsUntilCompleted() async {
    _pollingCancelled = false;
    final api = Get.find<ApiService>();
    var attempt = 0;

    while (!_pollingCancelled && mounted && attempt < _maxPollAttempts) {
      // Wait before each call (except allow first call immediately)
      if (attempt > 0) {
        await Future.delayed(_pollInterval);
      }
      if (!mounted || _pollingCancelled) return;

      try {
        final headers = await AppConstants.getAuthHeaders();
        final data = await api.post(
          ApiUrls.getOrderDetails,
          headers: headers,
          body: {'order_no': widget.orderNo},
        );

        final orderDetails = getOrderDetails.fromJson(data);
        final status = orderDetails.message?.status?.toLowerCase();

        if (status == 'completed' || status == 'success') {
          if (!mounted) return;
          Get.off(
            () => PaymentResultScreen(
              isSuccess: true,
              amount: widget.amount,
              shopName: 'Wallet Recharge',
            ),
          );
          return;
        }
      } catch (e) {
        debugPrint('get-order-details poll error: $e');
        // continue polling
      }
      attempt++;
    }

    if (!mounted) return;
    setState(() => _isWaitingForConfirmation = false);
    Get.snackbar(
      'Payment',
      'Confirmation is taking longer than usual. Please check your wallet or try again.',
    );
  }

  @override
  void dispose() {
    _pollingCancelled = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Complete Payment",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Recharge Amount",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${widget.amount.toStringAsFixed(2)} SAR",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  "Choose Payment Method",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder(
                  valueListenable: _checkoutHeight,
                  builder: (context, height, child) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: SizedBox(
                        height: height.toDouble(),
                        child: OttuCheckoutWidget(
                          arguments: CheckoutArguments(
                            merchantId: AppConstants.ottuMerchantId,
                            apiKey: AppConstants.paymentApiKey,
                            sessionId: widget.sessionId,
                            amount: widget.amount,
                            formsOfPayment: [
                              FormsOfPayment.googlePay,
                              FormsOfPayment.applePay,
                              FormsOfPayment.cardOnSite,
                              FormsOfPayment.redirect,
                            ],
                            showPaymentDetails: true,
                            theme: CheckoutTheme(uiMode: CustomerUiMode.light),
                            paymentOptionsDisplaySettings:
                                PaymentOptionsDisplaySettings(
                                  mode: PaymentOptionsDisplayMode.BOTTOM_SHEET,
                                  visibleItemsCount: 5,
                                ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
                Center(
                  child: Text(
                    "🔒 Secure Payment Powered by Ottu",
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
          ),
          if (_isWaitingForConfirmation) _buildConfirmingOverlay(),
        ],
      ),
    );
  }

  Widget _buildConfirmingOverlay() {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 160,
                height: 160,
                child: Lottie.asset(
                  'assets/lottie/update.json',
                  fit: BoxFit.contain,
                  repeat: true,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Confirming payment',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please wait while we verify your payment…',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
