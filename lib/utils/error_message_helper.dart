import 'package:get/get.dart';
import 'package:pos_v2/core/services/api_services.dart';

/// Normalizes API/network errors to short, user-friendly translated messages
/// so long exceptions (e.g. ClientException) don't flood the toast.
class ErrorMessageHelper {
  /// Returns a short, translated message suitable for snackbar/toast.
  /// Use this instead of showing raw exception messages.
  static String toUserMessage(dynamic error, {String? fallbackKey}) {
    final String raw = error is ApiException
        ? error.message
        : error?.toString() ?? '';

    // Network/connection errors (often very long in Dart)
    if (_isNetworkError(raw)) {
      return 'network_error'.tr;
    }
    // Server/API returned an error message (keep if short and readable)
    if (error is ApiException && error.message.isNotEmpty) {
      final msg = error.message;
      if (msg.length <= 80 && !msg.contains('Exception') && !msg.contains('Error:')) {
        return msg;
      }
      return 'network_error'.tr;
    }
    return (fallbackKey ?? 'unexpected_error').tr;
  }

  static bool _isNetworkError(String message) {
    final lower = message.toLowerCase();
    return lower.contains('socketexception') ||
        lower.contains('clientexception') ||
        lower.contains('connection') ||
        lower.contains('network error') ||
        lower.contains('connection refused') ||
        lower.contains('connection timed out') ||
        lower.contains('failed host lookup') ||
        lower.contains('handshake exception') ||
        lower.contains('timeout');
  }
}
