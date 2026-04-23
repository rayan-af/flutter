import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
  ];

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileTitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get nameHint;

  /// No description provided for @nameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get nameError;

  /// No description provided for @profileImageLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile Image URL'**
  String get profileImageLabel;

  /// No description provided for @profileImageHint.
  ///
  /// In en, this message translates to:
  /// **'https://...'**
  String get profileImageHint;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdated;

  /// No description provided for @profileUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile.'**
  String get profileUpdateFailed;

  /// No description provided for @themeSettings.
  ///
  /// In en, this message translates to:
  /// **'Theme Settings'**
  String get themeSettings;

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get languageSettings;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navPOS.
  ///
  /// In en, this message translates to:
  /// **'POS Terminal'**
  String get navPOS;

  /// No description provided for @navInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get navInventory;

  /// No description provided for @navCosting.
  ///
  /// In en, this message translates to:
  /// **'Recipe Costing'**
  String get navCosting;

  /// No description provided for @navWaste.
  ///
  /// In en, this message translates to:
  /// **'Waste Log'**
  String get navWaste;

  /// No description provided for @navAI.
  ///
  /// In en, this message translates to:
  /// **'AI Chat Assistant'**
  String get navAI;

  /// No description provided for @navTableMap.
  ///
  /// In en, this message translates to:
  /// **'Table Mapping'**
  String get navTableMap;

  /// No description provided for @navChefOrders.
  ///
  /// In en, this message translates to:
  /// **'Chef Orders'**
  String get navChefOrders;

  /// No description provided for @navDrinks.
  ///
  /// In en, this message translates to:
  /// **'Drinks'**
  String get navDrinks;

  /// No description provided for @navMenu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get navMenu;

  /// No description provided for @navLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get navLogin;

  /// No description provided for @navLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get navLogout;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get navOrders;

  /// No description provided for @navSchedule.
  ///
  /// In en, this message translates to:
  /// **'Work Time'**
  String get navSchedule;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Hey, {name}'**
  String greeting(String name);

  /// No description provided for @hungry.
  ///
  /// In en, this message translates to:
  /// **'Hungry?'**
  String get hungry;

  /// No description provided for @searchDishes.
  ///
  /// In en, this message translates to:
  /// **'Search dishes...'**
  String get searchDishes;

  /// No description provided for @browseByCategory.
  ///
  /// In en, this message translates to:
  /// **'Browse by category'**
  String get browseByCategory;

  /// No description provided for @popularDishes.
  ///
  /// In en, this message translates to:
  /// **'Popular Dishes'**
  String get popularDishes;

  /// No description provided for @trySomethingNew.
  ///
  /// In en, this message translates to:
  /// **'Try Something New'**
  String get trySomethingNew;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See more'**
  String get seeMore;

  /// No description provided for @noPopularDishes.
  ///
  /// In en, this message translates to:
  /// **'No popular dishes found'**
  String get noPopularDishes;

  /// No description provided for @noNewDishes.
  ///
  /// In en, this message translates to:
  /// **'No other dishes found'**
  String get noNewDishes;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'RestoManager'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Login to your account to continue'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email *'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Email@email.com'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password *'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'************'**
  String get passwordHint;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @signupButton.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signupButton;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// No description provided for @emailError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get emailError;

  /// No description provided for @passwordError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordError;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get invalidCredentials;

  /// No description provided for @registrationFailedError.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Email might already be in use.'**
  String get registrationFailedError;

  /// No description provided for @signupTitle.
  ///
  /// In en, this message translates to:
  /// **'Join Us'**
  String get signupTitle;

  /// No description provided for @signupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create an account to get started'**
  String get signupSubtitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name *'**
  String get fullNameLabel;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'John Doe'**
  String get fullNameHint;

  /// No description provided for @fullNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get fullNameError;

  /// No description provided for @emailInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailInvalidError;

  /// No description provided for @navCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get navCreateAccount;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'PREFERENCES'**
  String get preferences;

  /// No description provided for @aiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistant;

  /// No description provided for @bookTable.
  ///
  /// In en, this message translates to:
  /// **'Book a Table'**
  String get bookTable;

  /// No description provided for @catAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get catAll;

  /// No description provided for @catFastFood.
  ///
  /// In en, this message translates to:
  /// **'Fast food'**
  String get catFastFood;

  /// No description provided for @catCasual.
  ///
  /// In en, this message translates to:
  /// **'Casual'**
  String get catCasual;

  /// No description provided for @catFineDining.
  ///
  /// In en, this message translates to:
  /// **'Fine dining'**
  String get catFineDining;

  /// No description provided for @catCafe.
  ///
  /// In en, this message translates to:
  /// **'Cafe'**
  String get catCafe;

  /// No description provided for @catBuffet.
  ///
  /// In en, this message translates to:
  /// **'Buffet'**
  String get catBuffet;

  /// No description provided for @menuTitle.
  ///
  /// In en, this message translates to:
  /// **'Our Menu'**
  String get menuTitle;

  /// No description provided for @addedToCart.
  ///
  /// In en, this message translates to:
  /// **'{name} added to cart'**
  String addedToCart(String name);

  /// No description provided for @catAppetizers.
  ///
  /// In en, this message translates to:
  /// **'Appetizers'**
  String get catAppetizers;

  /// No description provided for @catEntrees.
  ///
  /// In en, this message translates to:
  /// **'Entrees'**
  String get catEntrees;

  /// No description provided for @catFajitas.
  ///
  /// In en, this message translates to:
  /// **'Fajitas'**
  String get catFajitas;

  /// No description provided for @catRibs.
  ///
  /// In en, this message translates to:
  /// **'Ribs'**
  String get catRibs;

  /// No description provided for @catBurgers.
  ///
  /// In en, this message translates to:
  /// **'Burgers'**
  String get catBurgers;

  /// No description provided for @catSandwiches.
  ///
  /// In en, this message translates to:
  /// **'Sandwiches'**
  String get catSandwiches;

  /// No description provided for @catSalads.
  ///
  /// In en, this message translates to:
  /// **'Salads'**
  String get catSalads;

  /// No description provided for @catSides.
  ///
  /// In en, this message translates to:
  /// **'Sides'**
  String get catSides;

  /// No description provided for @catDesserts.
  ///
  /// In en, this message translates to:
  /// **'Desserts'**
  String get catDesserts;

  /// No description provided for @catKidsMenu.
  ///
  /// In en, this message translates to:
  /// **'Kids Menu'**
  String get catKidsMenu;

  /// No description provided for @catDrinks.
  ///
  /// In en, this message translates to:
  /// **'Drinks'**
  String get catDrinks;

  /// No description provided for @drinksFoodTitle.
  ///
  /// In en, this message translates to:
  /// **'Drinks & Food'**
  String get drinksFoodTitle;

  /// No description provided for @tabDrinks.
  ///
  /// In en, this message translates to:
  /// **'Drinks'**
  String get tabDrinks;

  /// No description provided for @tabFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get tabFood;

  /// No description provided for @noItemsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No {type} available'**
  String noItemsAvailable(String type);

  /// No description provided for @dashTitle.
  ///
  /// In en, this message translates to:
  /// **'Intelligence Dashboard'**
  String get dashTitle;

  /// No description provided for @keyMetrics.
  ///
  /// In en, this message translates to:
  /// **'KEY METRICS'**
  String get keyMetrics;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'QUICK ACTIONS'**
  String get quickActions;

  /// No description provided for @liveActivity.
  ///
  /// In en, this message translates to:
  /// **'LIVE ACTIVITY FEED'**
  String get liveActivity;

  /// No description provided for @lowStockAlert.
  ///
  /// In en, this message translates to:
  /// **'CRITICAL: LOW STOCK'**
  String get lowStockAlert;

  /// No description provided for @lowStockCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items have dropped below their minimum threshold.'**
  String lowStockCount(Object count);

  /// No description provided for @resolve.
  ///
  /// In en, this message translates to:
  /// **'Resolve'**
  String get resolve;

  /// No description provided for @resetPopDishes.
  ///
  /// In en, this message translates to:
  /// **'Reset Popular Dishes'**
  String get resetPopDishes;

  /// No description provided for @resetPopDishesSub.
  ///
  /// In en, this message translates to:
  /// **'Clear all POS order statistics and reset popular dishes to default logic.'**
  String get resetPopDishesSub;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @resetPopDishesSuccess.
  ///
  /// In en, this message translates to:
  /// **'Popular dishes statistics have been reset.'**
  String get resetPopDishesSuccess;

  /// No description provided for @dailySales.
  ///
  /// In en, this message translates to:
  /// **'Daily Sales'**
  String get dailySales;

  /// No description provided for @activeOrders.
  ///
  /// In en, this message translates to:
  /// **'Active Orders'**
  String get activeOrders;

  /// No description provided for @wasteLoss.
  ///
  /// In en, this message translates to:
  /// **'Waste Loss (7d)'**
  String get wasteLoss;

  /// No description provided for @invHealth.
  ///
  /// In en, this message translates to:
  /// **'Inventory Health'**
  String get invHealth;

  /// No description provided for @noActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity recorded.'**
  String get noActivity;

  /// No description provided for @newOrderActivity.
  ///
  /// In en, this message translates to:
  /// **'New Order Created'**
  String get newOrderActivity;

  /// No description provided for @wasteLoggedActivity.
  ///
  /// In en, this message translates to:
  /// **'Waste Logged'**
  String get wasteLoggedActivity;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @lost.
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get lost;

  /// No description provided for @qty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get qty;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @aiAssistantTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Cafe Assistant'**
  String get aiAssistantTitle;

  /// No description provided for @aiAssistantHint.
  ///
  /// In en, this message translates to:
  /// **'Ask about the menu or reservations...'**
  String get aiAssistantHint;

  /// No description provided for @aiAssistantError.
  ///
  /// In en, this message translates to:
  /// **'Sorry, I\'m having trouble connecting right now. 😔'**
  String get aiAssistantError;

  /// No description provided for @recipeCostingTitle.
  ///
  /// In en, this message translates to:
  /// **'Recipe Costing'**
  String get recipeCostingTitle;

  /// No description provided for @selectTemplate.
  ///
  /// In en, this message translates to:
  /// **'Select Template'**
  String get selectTemplate;

  /// No description provided for @selectMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Select Menu Item (Optional)'**
  String get selectMenuItem;

  /// No description provided for @plateInputs.
  ///
  /// In en, this message translates to:
  /// **'Plate Inputs'**
  String get plateInputs;

  /// No description provided for @plateCostLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Plate Cost (\$)'**
  String get plateCostLabel;

  /// No description provided for @plateCostHelper.
  ///
  /// In en, this message translates to:
  /// **'Auto-calculated from recipe or manual.'**
  String get plateCostHelper;

  /// No description provided for @targetPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Target Sales Price (\$)'**
  String get targetPriceLabel;

  /// No description provided for @targetPriceHelper.
  ///
  /// In en, this message translates to:
  /// **'Menu price for the customer.'**
  String get targetPriceHelper;

  /// No description provided for @grossProfitMargin.
  ///
  /// In en, this message translates to:
  /// **'GROSS PROFIT MARGIN'**
  String get grossProfitMargin;

  /// No description provided for @profitPerPlate.
  ///
  /// In en, this message translates to:
  /// **'Profit per Plate'**
  String get profitPerPlate;

  /// No description provided for @missingIngredientsWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning: Some ingredients not found in inventory. Cost may be inaccurate.'**
  String get missingIngredientsWarning;

  /// No description provided for @tableMappingTitle.
  ///
  /// In en, this message translates to:
  /// **'Table Mapping'**
  String get tableMappingTitle;

  /// No description provided for @chefOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'Chef Orders'**
  String get chefOrdersTitle;

  /// No description provided for @inventoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventoryTitle;

  /// No description provided for @posTitle.
  ///
  /// In en, this message translates to:
  /// **'POS Terminal'**
  String get posTitle;

  /// No description provided for @wasteLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Waste Log'**
  String get wasteLogTitle;

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Cart Empty'**
  String get cartEmpty;

  /// No description provided for @itemsCount.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get itemsCount;

  /// No description provided for @addMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Add Menu Item'**
  String get addMenuItem;

  /// No description provided for @noItemsInMenu.
  ///
  /// In en, this message translates to:
  /// **'No items in menu. Try seeding data.'**
  String get noItemsInMenu;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @sessionLog.
  ///
  /// In en, this message translates to:
  /// **'Session Log'**
  String get sessionLog;

  /// No description provided for @confirmOrder.
  ///
  /// In en, this message translates to:
  /// **'Confirm Order'**
  String get confirmOrder;

  /// No description provided for @clearCart.
  ///
  /// In en, this message translates to:
  /// **'Clear Cart'**
  String get clearCart;

  /// No description provided for @orderConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Order Confirmed Successfully!'**
  String get orderConfirmed;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @scheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Work Time'**
  String get scheduleTitle;

  /// No description provided for @inventoryListing.
  ///
  /// In en, this message translates to:
  /// **'Inventory Listing'**
  String get inventoryListing;

  /// No description provided for @inventoryManagement.
  ///
  /// In en, this message translates to:
  /// **'Inventory Management'**
  String get inventoryManagement;

  /// No description provided for @newItem.
  ///
  /// In en, this message translates to:
  /// **'New Item'**
  String get newItem;

  /// No description provided for @itemName.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get itemName;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @priceCost.
  ///
  /// In en, this message translates to:
  /// **'Price (Cost)'**
  String get priceCost;

  /// No description provided for @quickQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quick Quantity'**
  String get quickQuantity;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @lowStock.
  ///
  /// In en, this message translates to:
  /// **'Low Stock'**
  String get lowStock;

  /// No description provided for @inStock.
  ///
  /// In en, this message translates to:
  /// **'In Stock'**
  String get inStock;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @removeInventoryItem.
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from inventory?'**
  String removeInventoryItem(Object name);

  /// No description provided for @updateItem.
  ///
  /// In en, this message translates to:
  /// **'Update {name}'**
  String updateItem(Object name);

  /// No description provided for @addQuantity.
  ///
  /// In en, this message translates to:
  /// **'Add Quantity'**
  String get addQuantity;

  /// No description provided for @addInventoryItem.
  ///
  /// In en, this message translates to:
  /// **'Add Inventory Item'**
  String get addInventoryItem;

  /// No description provided for @costPrice.
  ///
  /// In en, this message translates to:
  /// **'Cost / Price'**
  String get costPrice;

  /// No description provided for @addItemSuccess.
  ///
  /// In en, this message translates to:
  /// **'Item added to Inventory!'**
  String get addItemSuccess;

  /// No description provided for @liquid.
  ///
  /// In en, this message translates to:
  /// **'Liquid'**
  String get liquid;

  /// No description provided for @solid.
  ///
  /// In en, this message translates to:
  /// **'Solid'**
  String get solid;

  /// No description provided for @groundFloor.
  ///
  /// In en, this message translates to:
  /// **'Ground Floor'**
  String get groundFloor;

  /// No description provided for @firstFloor.
  ///
  /// In en, this message translates to:
  /// **'1st Floor'**
  String get firstFloor;

  /// No description provided for @secondFloor.
  ///
  /// In en, this message translates to:
  /// **'2nd Floor'**
  String get secondFloor;

  /// No description provided for @rooftop.
  ///
  /// In en, this message translates to:
  /// **'Rooftop'**
  String get rooftop;

  /// No description provided for @seats.
  ///
  /// In en, this message translates to:
  /// **'{count} Seats'**
  String seats(int count);

  /// No description provided for @seatWalkIn.
  ///
  /// In en, this message translates to:
  /// **'Seat Walk-In Customer'**
  String get seatWalkIn;

  /// No description provided for @markReserved.
  ///
  /// In en, this message translates to:
  /// **'Mark as Reserved'**
  String get markReserved;

  /// No description provided for @clearTableAvailable.
  ///
  /// In en, this message translates to:
  /// **'Clear Table (Available)'**
  String get clearTableAvailable;

  /// No description provided for @occupied.
  ///
  /// In en, this message translates to:
  /// **'Occupied'**
  String get occupied;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @reserved.
  ///
  /// In en, this message translates to:
  /// **'Reserved'**
  String get reserved;

  /// No description provided for @logSpoilage.
  ///
  /// In en, this message translates to:
  /// **'Log Spoilage / Waste'**
  String get logSpoilage;

  /// No description provided for @quantityWasted.
  ///
  /// In en, this message translates to:
  /// **'Quantity Wasted'**
  String get quantityWasted;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @spilled.
  ///
  /// In en, this message translates to:
  /// **'Spilled'**
  String get spilled;

  /// No description provided for @badQuality.
  ///
  /// In en, this message translates to:
  /// **'Bad Quality'**
  String get badQuality;

  /// No description provided for @mistake.
  ///
  /// In en, this message translates to:
  /// **'Mistake'**
  String get mistake;

  /// No description provided for @logWaste.
  ///
  /// In en, this message translates to:
  /// **'LOG WASTE'**
  String get logWaste;

  /// No description provided for @recentWasteLogs.
  ///
  /// In en, this message translates to:
  /// **'Recent Waste Logs'**
  String get recentWasteLogs;

  /// No description provided for @noWasteLogs.
  ///
  /// In en, this message translates to:
  /// **'No waste logs recorded.'**
  String get noWasteLogs;

  /// No description provided for @wasteLoggedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Waste Logged Successfully'**
  String get wasteLoggedSuccess;

  /// No description provided for @selectItem.
  ///
  /// In en, this message translates to:
  /// **'Please select an item'**
  String get selectItem;

  /// No description provided for @selectReason.
  ///
  /// In en, this message translates to:
  /// **'Select a reason'**
  String get selectReason;

  /// No description provided for @enterQuantity.
  ///
  /// In en, this message translates to:
  /// **'Enter quantity'**
  String get enterQuantity;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get invalidNumber;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get item;

  /// No description provided for @markCompleted.
  ///
  /// In en, this message translates to:
  /// **'Double-tap to mark done'**
  String get markCompleted;

  /// No description provided for @totalWeeklyHours.
  ///
  /// In en, this message translates to:
  /// **'Total Weekly Hours'**
  String get totalWeeklyHours;

  /// No description provided for @upcomingShifts.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Shifts'**
  String get upcomingShifts;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get today;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minsAgo.
  ///
  /// In en, this message translates to:
  /// **'{mins} mins ago'**
  String minsAgo(int mins);

  /// No description provided for @hoursMinsAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {mins}m ago'**
  String hoursMinsAgo(int hours, int mins);

  /// No description provided for @errorMsg.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorMsg(String error);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'es', 'fr', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
