import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos_v2/controllers/home_controller.dart';
import 'package:pos_v2/utils/snakbar_helper.dart';
import 'package:pos_v2/widgets/app_screen_wrapper.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _answerController = TextEditingController();

  late int num1;
  late int num2;

  final HomeController homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    _generateNumbers();
  }

  void _generateNumbers() {
    setState(() {
      num1 = Random().nextInt(10);
      num2 = Random().nextInt(10);
      _answerController.clear();
    });
  }

  void _showFinalDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('are_you_sure'.tr == 'are_you_sure' ? "Are you sure?" : 'are_you_sure'.tr),
        content: Text('delete_account_warning'.tr == 'delete_account_warning' ? "You will lose all data from this application. This action cannot be undone." : 'delete_account_warning'.tr),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              _generateNumbers();
            },
            child: Text('cancel'.tr, style: const TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Get.back();
              await homeController.deleteMyAccount();
            },
            child: Text('delete'.tr, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _onDeletePressed() {
    final sum = num1 + num2;
    final ans = _answerController.text.trim();

    if (ans.isEmpty) {
      SnackbarHelper.showError("Please enter your answer.");
      return;
    }

    if (ans != sum.toString()) {
      SnackbarHelper.showError("Incorrect answer. Please try again.");
      _generateNumbers();
      return;
    }

    _showFinalDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return AppScreenWrapper(
      title: 'delete_account'.tr,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Icon(
                Icons.warning_amber_rounded,
                size: 80,
                color: Colors.red.shade400,
              ),
              const SizedBox(height: 20),
              Text(
                "Delete Your Account",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "If you delete your account, all your data, transactions, and preferences will be permanently erased. This action cannot be reversed.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(width: 1, color: Colors.grey.shade300)),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Enter the sum of the following numbers to proceed:",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                '$num1 + $num2',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 48,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: _answerController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: "Answer",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Obx(() {
                if (homeController.deletingAccount.isTrue) {
                  return const Center(child: CircularProgressIndicator(color: Colors.red));
                }
                return ElevatedButton(
                  onPressed: _onDeletePressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'delete_account'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }
}
