// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get profileTitle => 'تعديل الملف الشخصي';

  @override
  String get nameLabel => 'الاسم';

  @override
  String get nameHint => 'اسمك';

  @override
  String get nameError => 'الرجاء إدخال اسم';

  @override
  String get profileImageLabel => 'رابط صورة الملف الشخصي';

  @override
  String get profileImageHint => 'https://...';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي بنجاح!';

  @override
  String get profileUpdateFailed => 'فشل في تحديث الملف الشخصي.';

  @override
  String get themeSettings => 'إعدادات المظهر';

  @override
  String get languageSettings => 'إعدادات اللغة';

  @override
  String get lightTheme => 'فاتح';

  @override
  String get darkTheme => 'داكن';

  @override
  String get language => 'اللغة';

  @override
  String get theme => 'المظهر';

  @override
  String get settingsTitle => 'الإعدادات';
}
