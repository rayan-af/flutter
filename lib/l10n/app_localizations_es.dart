// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get profileTitle => 'Editar perfil';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get nameHint => 'Tu nombre';

  @override
  String get nameError => 'Por favor, introduce un nombre';

  @override
  String get profileImageLabel => 'URL de la imagen de perfil';

  @override
  String get profileImageHint => 'https://...';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get profileUpdated => '¡Perfil actualizado con éxito!';

  @override
  String get profileUpdateFailed => 'Error al actualizar el perfil.';

  @override
  String get themeSettings => 'Configuración del tema';

  @override
  String get languageSettings => 'Configuración de idioma';

  @override
  String get lightTheme => 'Claro';

  @override
  String get darkTheme => 'Oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get theme => 'Tema';

  @override
  String get settingsTitle => 'Ajustes';
}
