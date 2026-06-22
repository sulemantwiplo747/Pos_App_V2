import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart'
    hide TextStyle;
import 'package:pos_v2/constants/api_urls.dart';
import 'package:pos_v2/constants/app_constants.dart';
import 'package:pos_v2/core/services/api_services.dart';
import 'package:pos_v2/models/get_order_detail_model.dart';
import 'package:pos_v2/screens/payment_result_screen.dart';
import 'package:pos_v2/utils/ottu_checkout_url.dart';
import 'package:pos_v2/widgets/app_screen_wrapper.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OttuCheckoutScreen extends StatefulWidget {
  final String sessionId;
  final double amount;
  final String orderNo;
  final String? checkoutPageUrl;
  final String? checkoutUrl;

  const OttuCheckoutScreen({
    super.key,
    required this.sessionId,
    required this.amount,
    required this.orderNo,
    this.checkoutPageUrl,
    this.checkoutUrl,
  });

  @override
  State<OttuCheckoutScreen> createState() => _OttuCheckoutScreenState();
}

class _OttuCheckoutScreenState extends State<OttuCheckoutScreen> {
  bool _isWaitingForConfirmation = false;
  bool _pollingCancelled = false;
  static const _pollInterval = Duration(seconds: 2);
  static const _maxPollAttempts = 45;

  bool get _useWebCheckoutOnIos =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  String? get _webCheckoutUrl => resolveOttuCheckoutUrl(
        sessionId: widget.sessionId,
        checkoutPageUrl: widget.checkoutPageUrl,
        checkoutUrl: widget.checkoutUrl,
      );

  CheckoutArguments get _checkoutArguments => CheckoutArguments(
        merchantId: AppConstants.ottuMerchantId,
        apiKey: AppConstants.paymentApiKey,
        sessionId: widget.sessionId,
        amount: widget.amount,
        showPaymentDetails: true,
        paymentOptionsDisplaySettings: PaymentOptionsDisplaySettings(
          mode: PaymentOptionsDisplayMode.BOTTOM_SHEET,
          visibleItemsCount: 5,
        ),
      );

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
    if (AppConstants.paymentApiKey.isEmpty) {
      return _buildShell(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Payment configuration is not ready. Please go back and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
            ),
          ),
        ),
      );
    }

    if (_useWebCheckoutOnIos) {
      final checkoutUrl = _webCheckoutUrl;
      if (checkoutUrl == null) {
        return _buildShell(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Unable to open the payment page. Please try again later.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
              ),
            ),
          ),
        );
      }

      return _buildShell(
        child: Stack(
          children: [
            Column(
              children: [
                _buildAmountHeader(),
                Expanded(
                  child: _OttuWebCheckoutView(
                    checkoutUrl: checkoutUrl,
                    onPaymentUrlDetected: _handleWebCheckoutUrl,
                  ),
                ),
                _buildWebCheckoutActions(),
              ],
            ),
            if (_isWaitingForConfirmation) _buildConfirmingOverlay(),
          ],
        ),
      );
    }

    return _buildShell(
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAmountHeader(),
                const SizedBox(height: 25),
                Text(
                  'Choose Payment Method',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                DecoratedBox(
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
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: OttuCheckoutWidget(
                      arguments: _checkoutArguments,
                      successCallback: (_) => _onPaymentSuccessFromOttu(),
                      cancelCallback: (_) => _onPaymentFailureFromOttu(),
                      errorCallback: (_) => _onPaymentFailureFromOttu(),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: Text(
                    '🔒 Secure Payment Powered by Ottu',
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

  Widget _buildShell({required Widget child}) {
    return AppScreenWrapper(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Complete Payment',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      child: child,
    );
  }

  Widget _buildAmountHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
            'Recharge Amount',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 6),
          Text(
            '${widget.amount.toStringAsFixed(2)} SAR',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebCheckoutActions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _isWaitingForConfirmation
                  ? null
                  : _onPaymentSuccessFromOttu,
              child: const Text('I completed payment'),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '🔒 Secure Payment Powered by Ottu',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  void _handleWebCheckoutUrl(String? url) {
    if (url == null || url.isEmpty || _isWaitingForConfirmation) return;
    final lower = url.toLowerCase();
    if (_looksLikePaymentSuccess(lower)) {
      _onPaymentSuccessFromOttu();
    } else if (_looksLikePaymentFailure(lower)) {
      _onPaymentFailureFromOttu();
    }
  }

  bool _looksLikePaymentSuccess(String url) {
    return url.contains('success') ||
        url.contains('completed') ||
        url.contains('payment-success');
  }

  bool _looksLikePaymentFailure(String url) {
    return url.contains('cancel') ||
        url.contains('failure') ||
        url.contains('failed') ||
        url.contains('payment-fail');
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

class _OttuWebCheckoutView extends StatefulWidget {
  final String checkoutUrl;
  final ValueChanged<String?> onPaymentUrlDetected;

  const _OttuWebCheckoutView({
    required this.checkoutUrl,
    required this.onPaymentUrlDetected,
  });

  @override
  State<_OttuWebCheckoutView> createState() => _OttuWebCheckoutViewState();
}

class _OttuWebCheckoutViewState extends State<_OttuWebCheckoutView> {
  late final WebViewController _controller;
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (url) {
            if (mounted) setState(() => _isLoading = false);
            widget.onPaymentUrlDetected(url);
          },
          onUrlChange: (change) => widget.onPaymentUrlDetected(change.url),
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading)
          const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
