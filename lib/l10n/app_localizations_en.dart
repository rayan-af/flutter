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

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get update => 'Update';

  @override
  String get confirm => 'Confirm';

  @override
  String get unit => 'Unit';

  @override
  String get navHome => 'Home';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navPOS => 'POS Terminal';

  @override
  String get navInventory => 'Inventory';

  @override
  String get navCosting => 'Recipe Costing';

  @override
  String get navWaste => 'Waste Log';

  @override
  String get navAI => 'AI Chat Assistant';

  @override
  String get navTableMap => 'Table Mapping';

  @override
  String get navChefOrders => 'Chef Orders';

  @override
  String get navDrinks => 'Drinks';

  @override
  String get navMenu => 'Menu';

  @override
  String get navLogin => 'Login';

  @override
  String get navLogout => 'Logout';

  @override
  String get navProfile => 'Profile';

  @override
  String get navSearch => 'Search';

  @override
  String get navOrders => 'Orders';

  @override
  String get navSchedule => 'Work Time';

  @override
  String greeting(String name) {
    return 'Hey, $name';
  }

  @override
  String get hungry => 'Hungry?';

  @override
  String get searchDishes => 'Search dishes...';

  @override
  String get browseByCategory => 'Browse by category';

  @override
  String get popularDishes => 'Popular Dishes';

  @override
  String get trySomethingNew => 'Try Something New';

  @override
  String get seeMore => 'See more';

  @override
  String get noPopularDishes => 'No popular dishes found';

  @override
  String get noNewDishes => 'No other dishes found';

  @override
  String get loginTitle => 'RestoManager';

  @override
  String get loginSubtitle => 'Login to your account to continue';

  @override
  String get emailLabel => 'Email *';

  @override
  String get emailHint => 'Email@email.com';

  @override
  String get passwordLabel => 'Password *';

  @override
  String get passwordHint => '************';

  @override
  String get loginButton => 'Login';

  @override
  String get signupButton => 'Sign up';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get emailError => 'Please enter your email';

  @override
  String get passwordError => 'Please enter your password';

  @override
  String get invalidCredentials => 'Invalid email or password';

  @override
  String get registrationFailedError =>
      'Registration failed. Email might already be in use.';

  @override
  String get signupTitle => 'Join Us';

  @override
  String get signupSubtitle => 'Create an account to get started';

  @override
  String get fullNameLabel => 'Full Name *';

  @override
  String get fullNameHint => 'John Doe';

  @override
  String get fullNameError => 'Please enter your name';

  @override
  String get emailInvalidError => 'Please enter a valid email';

  @override
  String get navCreateAccount => 'Create Account';

  @override
  String get preferences => 'PREFERENCES';

  @override
  String get aiAssistant => 'AI Assistant';

  @override
  String get bookTable => 'Book a Table';

  @override
  String get catAll => 'All';

  @override
  String get catFastFood => 'Fast food';

  @override
  String get catCasual => 'Casual';

  @override
  String get catFineDining => 'Fine dining';

  @override
  String get catCafe => 'Cafe';

  @override
  String get catBuffet => 'Buffet';

  @override
  String get menuTitle => 'Our Menu';

  @override
  String addedToCart(String name) {
    return '$name added to cart';
  }

  @override
  String get catAppetizers => 'Appetizers';

  @override
  String get catEntrees => 'Entrees';

  @override
  String get catFajitas => 'Fajitas';

  @override
  String get catRibs => 'Ribs';

  @override
  String get catBurgers => 'Burgers';

  @override
  String get catSandwiches => 'Sandwiches';

  @override
  String get catSalads => 'Salads';

  @override
  String get catSides => 'Sides';

  @override
  String get catDesserts => 'Desserts';

  @override
  String get catKidsMenu => 'Kids Menu';

  @override
  String get catDrinks => 'Drinks';

  @override
  String get drinksFoodTitle => 'Drinks & Food';

  @override
  String get tabDrinks => 'Drinks';

  @override
  String get tabFood => 'Food';

  @override
  String noItemsAvailable(String type) {
    return 'No $type available';
  }

  @override
  String get dashTitle => 'Intelligence Dashboard';

  @override
  String get keyMetrics => 'KEY METRICS';

  @override
  String get quickActions => 'QUICK ACTIONS';

  @override
  String get liveActivity => 'LIVE ACTIVITY FEED';

  @override
  String get lowStockAlert => 'CRITICAL: LOW STOCK';

  @override
  String lowStockCount(Object count) {
    return '$count items have dropped below their minimum threshold.';
  }

  @override
  String get resolve => 'Resolve';

  @override
  String get resetPopDishes => 'Reset Popular Dishes';

  @override
  String get resetPopDishesSub =>
      'Clear all POS order statistics and reset popular dishes to default logic.';

  @override
  String get reset => 'Reset';

  @override
  String get resetPopDishesSuccess =>
      'Popular dishes statistics have been reset.';

  @override
  String get dailySales => 'Daily Sales';

  @override
  String get activeOrders => 'Active Orders';

  @override
  String get wasteLoss => 'Waste Loss (7d)';

  @override
  String get invHealth => 'Inventory Health';

  @override
  String get noActivity => 'No recent activity recorded.';

  @override
  String get newOrderActivity => 'New Order Created';

  @override
  String get wasteLoggedActivity => 'Waste Logged';

  @override
  String get total => 'Total';

  @override
  String get status => 'Status';

  @override
  String get lost => 'Lost';

  @override
  String get qty => 'Qty';

  @override
  String get reason => 'Reason';

  @override
  String get aiAssistantTitle => 'AI Cafe Assistant';

  @override
  String get aiAssistantHint => 'Ask about the menu or reservations...';

  @override
  String get aiAssistantError =>
      'Sorry, I\'m having trouble connecting right now. 😔';

  @override
  String get recipeCostingTitle => 'Recipe Costing';

  @override
  String get selectTemplate => 'Select Template';

  @override
  String get selectMenuItem => 'Select Menu Item (Optional)';

  @override
  String get plateInputs => 'Plate Inputs';

  @override
  String get plateCostLabel => 'Total Plate Cost (\$)';

  @override
  String get plateCostHelper => 'Auto-calculated from recipe or manual.';

  @override
  String get targetPriceLabel => 'Target Sales Price (\$)';

  @override
  String get targetPriceHelper => 'Menu price for the customer.';

  @override
  String get grossProfitMargin => 'GROSS PROFIT MARGIN';

  @override
  String get profitPerPlate => 'Profit per Plate';

  @override
  String get missingIngredientsWarning =>
      'Warning: Some ingredients not found in inventory. Cost may be inaccurate.';

  @override
  String get tableMappingTitle => 'Table Mapping';

  @override
  String get chefOrdersTitle => 'Chef Orders';

  @override
  String get inventoryTitle => 'Inventory';

  @override
  String get posTitle => 'POS Terminal';

  @override
  String get wasteLogTitle => 'Waste Log';

  @override
  String get cartEmpty => 'Cart Empty';

  @override
  String get itemsCount => 'Items';

  @override
  String get addMenuItem => 'Add Menu Item';

  @override
  String get noItemsInMenu => 'No items in menu. Try seeding data.';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get sessionLog => 'Session Log';

  @override
  String get confirmOrder => 'Confirm Order';

  @override
  String get clearCart => 'Clear Cart';

  @override
  String get orderConfirmed => 'Order Confirmed Successfully!';

  @override
  String get quantity => 'Quantity';

  @override
  String get scheduleTitle => 'Work Time';

  @override
  String get inventoryListing => 'Inventory Listing';

  @override
  String get inventoryManagement => 'Inventory Management';

  @override
  String get newItem => 'New Item';

  @override
  String get itemName => 'Item Name';

  @override
  String get category => 'Category';

  @override
  String get priceCost => 'Price (Cost)';

  @override
  String get quickQuantity => 'Quick Quantity';

  @override
  String get actions => 'Actions';

  @override
  String get lowStock => 'Low Stock';

  @override
  String get inStock => 'In Stock';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String removeInventoryItem(Object name) {
    return 'Remove $name from inventory?';
  }

  @override
  String updateItem(Object name) {
    return 'Update $name';
  }

  @override
  String get addQuantity => 'Add Quantity';

  @override
  String get addInventoryItem => 'Add Inventory Item';

  @override
  String get costPrice => 'Cost / Price';

  @override
  String get addItemSuccess => 'Item added to Inventory!';

  @override
  String get liquid => 'Liquid';

  @override
  String get solid => 'Solid';

  @override
  String get groundFloor => 'Ground Floor';

  @override
  String get firstFloor => '1st Floor';

  @override
  String get secondFloor => '2nd Floor';

  @override
  String get rooftop => 'Rooftop';

  @override
  String seats(int count) {
    return '$count Seats';
  }

  @override
  String get seatWalkIn => 'Seat Walk-In Customer';

  @override
  String get markReserved => 'Mark as Reserved';

  @override
  String get clearTableAvailable => 'Clear Table (Available)';

  @override
  String get occupied => 'Occupied';

  @override
  String get available => 'Available';

  @override
  String get reserved => 'Reserved';

  @override
  String get logSpoilage => 'Log Spoilage / Waste';

  @override
  String get quantityWasted => 'Quantity Wasted';

  @override
  String get expired => 'Expired';

  @override
  String get spilled => 'Spilled';

  @override
  String get badQuality => 'Bad Quality';

  @override
  String get mistake => 'Mistake';

  @override
  String get logWaste => 'LOG WASTE';

  @override
  String get recentWasteLogs => 'Recent Waste Logs';

  @override
  String get noWasteLogs => 'No waste logs recorded.';

  @override
  String get wasteLoggedSuccess => 'Waste Logged Successfully';

  @override
  String get selectItem => 'Please select an item';

  @override
  String get selectReason => 'Select a reason';

  @override
  String get enterQuantity => 'Enter quantity';

  @override
  String get invalidNumber => 'Invalid number';

  @override
  String get item => 'Item';

  @override
  String get markCompleted => 'Double-tap to mark done';

  @override
  String get totalWeeklyHours => 'Total Weekly Hours';

  @override
  String get upcomingShifts => 'Upcoming Shifts';

  @override
  String get today => 'TODAY';

  @override
  String get justNow => 'Just now';

  @override
  String minsAgo(int mins) {
    return '$mins mins ago';
  }

  @override
  String hoursMinsAgo(int hours, int mins) {
    return '${hours}h ${mins}m ago';
  }

  @override
  String errorMsg(String error) {
    return 'Error: $error';
  }
}
