import 'package:get_storage/get_storage.dart';

class AppStorage {
  static final GetStorage _box = GetStorage();

  static Future<void> writeString(String key, String value) async {
    await _box.write(key, value);
  }

  static Future<void> writeInt(String key, int value) async {
    await _box.write(key, value);
  }

  static Future<void> writeDouble(String key, double value) async {
    await _box.write(key, value);
  }

  static Future<void> writeBool(String key, bool value) async {
    await _box.write(key, value);
  }

  static Future<void> writeMap(String key, Map value) async {
    await _box.write(key, value);
  }

  static Future<void> writeList(String key, List value) async {
    await _box.write(key, value);
  }

  static String readString(String key, {String defaultValue = ""}) {
    return _box.read(key) ?? defaultValue;
  }

  static int readInt(String key, {int defaultValue = 0}) {
    return _box.read(key) ?? defaultValue;
  }

  static double readDouble(String key, {double defaultValue = 0.0}) {
    return _box.read(key) ?? defaultValue;
  }

  static bool readBool(String key, {bool defaultValue = false}) {
    return _box.read(key) ?? defaultValue;
  }

  static Map readMap(String key, {Map defaultValue = const {}}) {
    return _box.read(key) ?? defaultValue;
  }

  static List readList(String key, {List defaultValue = const []}) {
    return _box.read(key) ?? defaultValue;
  }

  static Future<void> remove(String key) async {
    await _box.remove(key);
  }

  static Future<void> clear() async {
    await _box.erase();
  }
}
