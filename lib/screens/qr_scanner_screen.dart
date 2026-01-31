import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pos_v2/screens/payment_result_screen.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isScanning = true;

  Timer? timer;

  @override
  void dispose() {
    // timer?.cancel();
    cameraController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // timer = Timer(Duration(seconds: 5), () {
    //   Get.off(() => PaymentResultScreen( isSuccess: true ));
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Scan QR Code'),
      //   backgroundColor: Colors.white,
      //   foregroundColor: Colors.black,
      // ),
      body: Stack(
        children: [
          // Full-screen scanner
          SizedBox(
            width: size.width,
            height: size.height,
            child: MobileScanner(
              controller: cameraController,
              fit: BoxFit.cover, // Full coverage
              onDetect: (BarcodeCapture capture) {
                if (!_isScanning) return;
                _isScanning = false;

                final barcode = capture.barcodes.firstOrNull;
                if (barcode?.rawValue != null) {
                  print('QR Code Detected: ${barcode!.rawValue}');

                  // Navigate using GetX
                  Get.off(() => PaymentResultScreen(isSuccess: false));
                }
              },
            ),
          ),

          // Optional: Scanner overlay (frame + instructions)
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          // Scanning line animation (optional)
          // You can add a moving line here using AnimatedPositioned

          // Instructions
          const Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Icon(Icons.qr_code_scanner, size: 40, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  'Align QR code within the frame',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
