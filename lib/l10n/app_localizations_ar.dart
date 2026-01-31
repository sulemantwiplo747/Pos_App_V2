// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'نقطة البيع';

  @override
  String get recentOrders => 'الطلبات الأخيرة';

  @override
  String get balance => 'الرصيد';

  @override
  String get recharge => 'إعادة الشحن';

  @override
  String get activeMembers => 'الأعضاء النشطون';

  @override
  String get addMember => 'إضافة عضو';

  @override
  String get orderDelivered => 'تم التسليم';

  @override
  String get orderOnTheWay => 'في الطريق';

  @override
  String get orderCancelled => 'ملغاة';
}
