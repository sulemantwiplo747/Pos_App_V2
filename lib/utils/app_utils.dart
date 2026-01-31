import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos_v2/constants/app_constants.dart';
import 'package:pos_v2/constants/app_keys.dart';

class DeviceUtils {
  static final GetStorage _box = GetStorage();

  static String getDeviceId() {
    String? id = _box.read(AppKeys.deviceIdKey);
    if (id == null) {
      id = _generateRandomId();
      _box.write(AppKeys.deviceIdKey, id);
    }
    return id;
  }

  static Future<void> getFcmToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        AppConstants.fcmToken = token;
        print("fcm token=$token");
      }
    } catch (e) {
      AppConstants.fcmToken = "";
    }
  }

  static String _generateRandomId({int length = 16}) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return List.generate(
      length,
      (index) => chars[rand.nextInt(chars.length)],
    ).join();
  }

  static Future<void> resetIds() async {
    await _box.remove(AppKeys.deviceIdKey);
    await _box.remove(AppKeys.fcmTokenKey);
  }

  static String getPlatform() => Platform.isAndroid ? "android" : "ios";
}
