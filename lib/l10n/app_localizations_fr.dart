// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get profileTitle => 'Modifier le profil';

  @override
  String get nameLabel => 'Nom';

  @override
  String get nameHint => 'Votre nom';

  @override
  String get nameError => 'Veuillez entrer un nom';

  @override
  String get profileImageLabel => 'URL de l\'image de profil';

  @override
  String get profileImageHint => 'https://...';

  @override
  String get saveChanges => 'Enregistrer les modifications';

  @override
  String get profileUpdated => 'Profil mis à jour avec succès !';

  @override
  String get profileUpdateFailed => 'Échec de la mise à jour du profil.';

  @override
  String get themeSettings => 'Paramètres du thème';

  @override
  String get languageSettings => 'Paramètres de langue';

  @override
  String get lightTheme => 'Clair';

  @override
  String get darkTheme => 'Sombre';

  @override
  String get language => 'Langue';

  @override
  String get theme => 'Thème';

  @override
  String get settingsTitle => 'Paramètres';
}
