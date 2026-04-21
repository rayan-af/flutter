// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get profileTitle => 'プロフィールを編集';

  @override
  String get nameLabel => '名前';

  @override
  String get nameHint => 'お名前';

  @override
  String get nameError => '名前を入力してください';

  @override
  String get profileImageLabel => 'プロフィール画像のURL';

  @override
  String get profileImageHint => 'https://...';

  @override
  String get saveChanges => '変更を保存';

  @override
  String get profileUpdated => 'プロフィールが更新されました！';

  @override
  String get profileUpdateFailed => 'プロフィールの更新に失敗しました。';

  @override
  String get themeSettings => 'テーマ設定';

  @override
  String get languageSettings => '言語設定';

  @override
  String get lightTheme => 'ライト';

  @override
  String get darkTheme => 'ダーク';

  @override
  String get language => '言語';

  @override
  String get theme => 'テーマ';

  @override
  String get settingsTitle => '設定';
}
