// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get profileTitle => 'Edit Profile';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameHint => 'Your name';

  @override
  String get nameError => 'Please enter a name';

  @override
  String get profileImageLabel => 'Profile Image URL';

  @override
  String get profileImageHint => 'https://...';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get profileUpdated => 'Profile updated successfully!';

  @override
  String get profileUpdateFailed => 'Failed to update profile.';

  @override
  String get themeSettings => 'Theme Settings';

  @override
  String get languageSettings => 'Language Settings';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get settingsTitle => 'Settings';
}
