import 'package:flutter/material.dart';
import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart';
import 'package:pos_v2/constants/app_constants.dart';

class RechargeNow extends StatefulWidget {
  const RechargeNow({super.key});

  @override
  State<RechargeNow> createState() => _RechargeNowState();
}

class _RechargeNowState extends State<RechargeNow> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: AppConstants.checkoutHeight,
          builder: (context, height, child) {
            return SizedBox(
              height: height.toDouble(),
              child: OttuCheckoutWidget(
                arguments: CheckoutArguments(
                  merchantId: "alpha.ottu.net",
                  apiKey: 'your Api key',
                  sessionId: 'your session id',
                  amount: 20.0,
                  showPaymentDetails: true,
                  paymentOptionsDisplaySettings: PaymentOptionsDisplaySettings(
                    mode: PaymentOptionsDisplayMode.BOTTOM_SHEET,
                    visibleItemsCount: 5,
                    defaultSelectedPgCode: "",
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
