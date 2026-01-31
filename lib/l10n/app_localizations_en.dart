// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'POS';

  @override
  String get recentOrders => 'Recent Orders';

  @override
  String get balance => 'Balance';

  @override
  String get recharge => 'Recharge';

  @override
  String get activeMembers => 'Active Members';

  @override
  String get addMember => 'Add Member';

  @override
  String get orderDelivered => 'Delivered';

  @override
  String get orderOnTheWay => 'On the way';

  @override
  String get orderCancelled => 'Cancelled';
}
