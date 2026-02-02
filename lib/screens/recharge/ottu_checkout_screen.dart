import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart'
    hide TextStyle;
import 'package:pos_v2/constants/app_constants.dart';

const _methodChannel = MethodChannel("com.ottu.sample/checkout");
const _methodCheckoutHeight = "METHOD_CHECKOUT_HEIGHT";

class OttuCheckoutScreen extends StatefulWidget {
  final String sessionId;
  final double amount;

  const OttuCheckoutScreen({
    super.key,
    required this.sessionId,
    required this.amount,
  });

  @override
  State<OttuCheckoutScreen> createState() => _OttuCheckoutScreenState();
}

class _OttuCheckoutScreenState extends State<OttuCheckoutScreen> {
  final _checkoutHeight = ValueNotifier(500);

  @override
  void initState() {
    super.initState();

    _methodChannel.setMethodCallHandler((call) async {
      if (call.method == _methodCheckoutHeight) {
        _checkoutHeight.value = call.arguments as int;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ✅ Clean AppBar
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Payment Summary Card
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

            // ✅ Payment Methods Title
            Text(
              "Choose Payment Method",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 12),

            // ✅ Checkout Widget in Card Container
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
                        apiKey: AppConstants.ottuApiKey,
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

            // ✅ Secure Payment Footer
            Center(
              child: Text(
                "🔒 Secure Payment Powered by Ottu",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
