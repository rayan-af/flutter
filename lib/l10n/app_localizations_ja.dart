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

  @override
  String get navHome => 'ホーム';

  @override
  String get navDashboard => 'ダッシュボード';

  @override
  String get navPOS => 'POSターミナル';

  @override
  String get navInventory => '在庫';

  @override
  String get navCosting => 'レシピ原価計算';

  @override
  String get navWaste => '廃棄ログ';

  @override
  String get navAI => 'AIチャットアシスタント';

  @override
  String get navTableMap => 'テーブルマッピング';

  @override
  String get navChefOrders => 'シェフの注文';

  @override
  String get navDrinks => 'ドリンク';

  @override
  String get navMenu => 'メニュー';

  @override
  String get navLogin => 'ログイン';

  @override
  String get navLogout => 'ログアウト';

  @override
  String get navProfile => 'プロフィール';

  @override
  String get navSearch => '検索';

  @override
  String get navOrders => '注文';

  @override
  String get navSchedule => 'スケジュール';

  @override
  String greeting(String name) {
    return 'こんにちは、$nameさん';
  }

  @override
  String get hungry => 'お腹が空きましたか？';

  @override
  String get searchDishes => '料理を検索...';

  @override
  String get browseByCategory => 'カテゴリーから探す';

  @override
  String get popularDishes => '人気の料理';

  @override
  String get trySomethingNew => '新しい料理を試す';

  @override
  String get seeMore => 'もっと見る';

  @override
  String get noPopularDishes => '人気の料理は見つかりませんでした';

  @override
  String get noNewDishes => '他の料理は見つかりませんでした';

  @override
  String get loginTitle => 'RestoManager';

  @override
  String get loginSubtitle => '続行するにはアカウントにログインしてください';

  @override
  String get emailLabel => 'メールアドレス *';

  @override
  String get emailHint => 'Email@email.com';

  @override
  String get passwordLabel => 'パスワード *';

  @override
  String get passwordHint => '************';

  @override
  String get loginButton => 'ログイン';

  @override
  String get signupButton => 'サインアップ';

  @override
  String get dontHaveAccount => 'アカウントをお持ちでないですか？';

  @override
  String get alreadyHaveAccount => 'すでにアカウントをお持ちですか？';

  @override
  String get continueAsGuest => 'ゲストとして続行';

  @override
  String get emailError => 'メールアドレスを入力してください';

  @override
  String get passwordError => 'パスワードを入力してください';

  @override
  String get invalidCredentials => 'メールアドレスまたはパスワードが無効です';

  @override
  String get registrationFailedError => '登録に失敗しました。メールアドレスが既に使用されている可能性があります。';

  @override
  String get signupTitle => '参加する';

  @override
  String get signupSubtitle => '開始するにはアカウントを作成してください';

  @override
  String get fullNameLabel => 'フルネーム *';

  @override
  String get fullNameHint => '山田太郎';

  @override
  String get fullNameError => '名前を入力してください';

  @override
  String get emailInvalidError => '有効なメールアドレスを入力してください';

  @override
  String get navCreateAccount => 'アカウント作成';

  @override
  String get preferences => '設定';

  @override
  String get aiAssistant => 'AIアシスタント';

  @override
  String get bookTable => 'テーブルを予約';

  @override
  String get catAll => 'すべて';

  @override
  String get catFastFood => 'ファストフード';

  @override
  String get catCasual => 'カジュアル';

  @override
  String get catFineDining => 'ファインダイニング';

  @override
  String get catCafe => 'カフェ';

  @override
  String get catBuffet => 'ビュッフェ';

  @override
  String get menuTitle => 'メニュー';

  @override
  String addedToCart(String name) {
    return '$nameをカートに追加しました';
  }

  @override
  String get catAppetizers => '前菜';

  @override
  String get catEntrees => 'メイン料理';

  @override
  String get catFajitas => 'ファヒータ';

  @override
  String get catRibs => 'リブ';

  @override
  String get catBurgers => 'ハンバーガー';

  @override
  String get catSandwiches => 'サンドイッチ';

  @override
  String get catSalads => 'サラダ';

  @override
  String get catSides => 'サイドメニュー';

  @override
  String get catDesserts => 'デザート';

  @override
  String get catKidsMenu => 'キッズメニュー';

  @override
  String get catDrinks => 'ドリンク';

  @override
  String get drinksFoodTitle => 'ドリンク＆フード';

  @override
  String get tabDrinks => 'ドリンク';

  @override
  String get tabFood => 'フード';

  @override
  String noItemsAvailable(String type) {
    return '$typeはありません';
  }

  @override
  String get dashTitle => 'インテリジェンス・ダッシュボード';

  @override
  String get keyMetrics => '主要メトリクス';

  @override
  String get quickActions => 'クイックアクション';

  @override
  String get liveActivity => 'ライブ・アクティビティ・フィード';

  @override
  String get lowStockAlert => '重要：在庫不足';

  @override
  String lowStockCount(Object count) {
    return '$count個のアイテムが最小しきい値を下回りました。';
  }

  @override
  String get resolve => '解決する';

  @override
  String get resetPopDishes => '人気の料理をリセット';

  @override
  String get resetPopDishesSub => 'すべてのPOS注文統計を消去し、人気の料理をデフォルトのロジックにリセットします。';

  @override
  String get reset => 'リセット';

  @override
  String get resetPopDishesSuccess => '人気の料理の統計がリセットされました。';

  @override
  String get dailySales => '今日の売上';

  @override
  String get activeOrders => 'アクティブな注文';

  @override
  String get wasteLoss => '廃棄損失 (7日間)';

  @override
  String get invHealth => '在庫ヘルス';

  @override
  String get noActivity => '最近のアクティビティはありません。';

  @override
  String get newOrderActivity => '新しい注文が作成されました';

  @override
  String get wasteLoggedActivity => '廃棄が記録されました';

  @override
  String get lost => '損失';

  @override
  String get qty => '数量';

  @override
  String get reason => '理由';

  @override
  String get aiAssistantTitle => 'AIカフェアシスタント';

  @override
  String get aiAssistantHint => 'メニューや予約について聞いてください...';

  @override
  String get aiAssistantError => '申し訳ありません。現在接続に問題があります。 😔';
}
