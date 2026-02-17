import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_v2/constants/api_urls.dart';

import '../constants/app_constants.dart';
import '../core/services/api_services.dart';
import '../models/intiate_payment_model.dart';
import '../screens/recharge/ottu_checkout_screen.dart';

class WalletRechargeController extends GetxController {
  TextEditingController amountController = TextEditingController();
  final api = Get.find<ApiService>();
  RxBool isLoading = false.obs;
  Future<void> startRecharge() async {
    if (amountController.text.isEmpty) {
      Get.snackbar("Error", "Please enter amount");
      return;
    }

    isLoading.value = true;

    try {
      final lang = Get.locale?.languageCode ?? "en";

      final headers = await AppConstants.getAuthHeaders();
      final user = AppConstants.currentUser.value!.userData;

      final body = {
        "amount": double.parse(amountController.text),
        "email": user?.email ?? "",
        "first_name": user?.name ?? "User",
        "phone": user?.phone ?? "",
        "pg_codes": ["mada-visa-master", "apple-pay"],
        "lang": lang,
      };

      // ✅ Call Your Backend API (Same as FCM Token Example)
      final data = await api.post(
        ApiUrls.paymentInitiateUrl,
        headers: headers,
        body: body,
      );

      print("✅ Payment Initiate Response: $data");

      // ✅ Parse Model Response
      final paymentModel = InitiatePaymentModel.fromJson(data);

      if (paymentModel.success == true) {
        final sessionId = paymentModel.message?.sessionId;
        final orderNo = paymentModel.message?.orderNo;

        print("✅ Session Generated: $sessionId");

        // ✅ Open Ottu Checkout Screen
        Get.to(
          () => OttuCheckoutScreen(
            sessionId: sessionId!,
            amount: paymentModel.message!.amount!,
            orderNo: orderNo ?? '',
          ),
        );
      } else {
        Get.snackbar("Error", "Payment initiation failed");
      }
    } catch (e) {
      print("❌ Exception: $e");
      Get.snackbar("Error", e.toString());
    }

    isLoading.value = false;
  }

  // Future<void> startRecharge() async {
  //   if (amountController.text.isEmpty) {
  //     Get.snackbar("Error", "Please enter amount");
  //     return;
  //   }

  //   isLoading.value = true;

  //   try {
  //     final user = AppConstants.currentUser.value!.userData;

  //     final response = await http.post(
  //       Uri.parse("https://sandbox.ottu.net/b/checkout/v1/pymt-txn/"),
  //       headers: {
  //         "Authorization": "Api-Key ${AppConstants.ottuApiKey}",
  //         "Content-Type": "application/json",
  //       },
  //       body: jsonEncode({
  //         "amount": amountController.text,
  //         "currency_code": "SAR",
  //         "payment_type": "one_off",
  //         "type": "e_commerce",

  //         "pg_codes": ["credit-card-bsf"],
  //         "customer_email": user?.email ?? "",
  //         "customer_first_name": user?.name ?? "User",
  //         "customer_phone": user?.phone ?? "",

  //         "order_no": DateTime.now().millisecondsSinceEpoch.toString(),

  //         "redirect_url": "https://fosshati.com/payment/redirect",
  //         "webhook_url": "https://fosshati.com/payment/webhook",
  //       }),
  //     );

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final jsonData = jsonDecode(response.body);

  //       final sessionId = jsonData["session_id"];

  //       print("✅ Session Generated: $sessionId");

  //       // ✅ Open Checkout Screen
  //       Get.to(
  //         () => OttuCheckoutScreen(
  //           sessionId: sessionId,
  //           amount: double.parse(amountController.text),
  //         ),
  //       );
  //     } else {
  //       print(response.body);
  //       Get.snackbar("Error", "Failed to generate payment session");
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", e.toString());
  //   }

  //   isLoading.value = false;
  // }
}
