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
  String get nameError => 'يرجى إدخال الاسم';

  @override
  String get profileImageLabel => 'رابط صورة الملف الشخصي';

  @override
  String get profileImageHint => 'https://...';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي بنجاح!';

  @override
  String get profileUpdateFailed => 'فشل تحديث الملف الشخصي.';

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

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get delete => 'حذف';

  @override
  String get update => 'تحديث';

  @override
  String get confirm => 'تأكيد';

  @override
  String get unit => 'الوحدة';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navDashboard => 'لوحة التحكم';

  @override
  String get navPOS => 'نقطة البيع';

  @override
  String get navInventory => 'المخزون';

  @override
  String get navCosting => 'تكلفة الوصفات';

  @override
  String get navWaste => 'سجل الهدر';

  @override
  String get navAI => 'مساعد الذكاء الاصطناعي';

  @override
  String get navTableMap => 'خريطة الطاولات';

  @override
  String get navChefOrders => 'طلبات الشيف';

  @override
  String get navDrinks => 'المشروبات';

  @override
  String get navMenu => 'القائمة';

  @override
  String get navLogin => 'تسجيل الدخول';

  @override
  String get navLogout => 'تسجيل الخروج';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get navSearch => 'بحث';

  @override
  String get navOrders => 'الطلبات';

  @override
  String get navSchedule => 'ساعات العمل';

  @override
  String greeting(String name) {
    return 'مرحباً، $name';
  }

  @override
  String get hungry => 'هل أنت جائع؟';

  @override
  String get searchDishes => 'ابحث عن الأطباق...';

  @override
  String get browseByCategory => 'تصفح حسب الفئة';

  @override
  String get popularDishes => 'الأطباق الشعبية';

  @override
  String get trySomethingNew => 'جرب شيئاً جديداً';

  @override
  String get seeMore => 'عرض المزيد';

  @override
  String get noPopularDishes => 'لم يتم العثور على أطباق شعبية';

  @override
  String get noNewDishes => 'لم يتم العثور على أطباق أخرى';

  @override
  String get loginTitle => 'RestoManager';

  @override
  String get loginSubtitle => 'قم بتسجيل الدخول إلى حسابك للمتابعة';

  @override
  String get emailLabel => 'البريد الإلكتروني *';

  @override
  String get emailHint => 'Email@email.com';

  @override
  String get passwordLabel => 'كلمة المرور *';

  @override
  String get passwordHint => '************';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get signupButton => 'إنشاء حساب';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get continueAsGuest => 'المتابعة كضيف';

  @override
  String get emailError => 'يرجى إدخال بريدك الإلكتروني';

  @override
  String get passwordError => 'يرجى إدخال كلمة المرور';

  @override
  String get invalidCredentials => 'البريد الإلكتروني أو كلمة المرور غير صالحة';

  @override
  String get registrationFailedError =>
      'فشل التسجيل. قد يكون البريد الإلكتروني مستخدماً بالفعل.';

  @override
  String get signupTitle => 'انضم إلينا';

  @override
  String get signupSubtitle => 'أنشئ حساباً للبدء';

  @override
  String get fullNameLabel => 'الاسم الكامل *';

  @override
  String get fullNameHint => 'أحمد محمد';

  @override
  String get fullNameError => 'يرجى إدخال اسمك';

  @override
  String get emailInvalidError => 'يرجى إدخال بريد إلكتروني صحيح';

  @override
  String get navCreateAccount => 'إنشاء حساب';

  @override
  String get preferences => 'تفضيلات';

  @override
  String get aiAssistant => 'مساعد الذكاء الاصطناعي';

  @override
  String get bookTable => 'حجز طاولة';

  @override
  String get catAll => 'الكل';

  @override
  String get catFastFood => 'وجبات سريعة';

  @override
  String get catCasual => 'عادي';

  @override
  String get catFineDining => 'فاخر';

  @override
  String get catCafe => 'مقهى';

  @override
  String get catBuffet => 'بوفيه';

  @override
  String get menuTitle => 'قائمتنا';

  @override
  String addedToCart(String name) {
    return 'تم إضافة $name إلى السلة';
  }

  @override
  String get catAppetizers => 'المقبلات';

  @override
  String get catEntrees => 'الأطباق الرئيسية';

  @override
  String get catFajitas => 'فاهيتا';

  @override
  String get catRibs => 'أضلاع';

  @override
  String get catBurgers => 'برجر';

  @override
  String get catSandwiches => 'سندويشات';

  @override
  String get catSalads => 'سلطات';

  @override
  String get catSides => 'أطباق جانبية';

  @override
  String get catDesserts => 'حلويات';

  @override
  String get catKidsMenu => 'قائمة الأطفال';

  @override
  String get catDrinks => 'مشروبات';

  @override
  String get drinksFoodTitle => 'المشروبات والطعام';

  @override
  String get tabDrinks => 'مشروبات';

  @override
  String get tabFood => 'طعام';

  @override
  String noItemsAvailable(String type) {
    return 'لا توجد $type متاحة';
  }

  @override
  String get dashTitle => 'لوحة القيادة الذكية';

  @override
  String get keyMetrics => 'المقاييس الرئيسية';

  @override
  String get quickActions => 'إجراءات سريعة';

  @override
  String get liveActivity => 'موجز النشاط المباشر';

  @override
  String get lowStockAlert => 'هام: نقص في المخزون';

  @override
  String lowStockCount(Object count) {
    return 'انخفضت $count عناصر عن الحد الأدنى لها.';
  }

  @override
  String get resolve => 'حل';

  @override
  String get resetPopDishes => 'إعادة تعيين الأطباق الشعبية';

  @override
  String get resetPopDishesSub =>
      'مسح جميع إحصائيات طلبات POS وإعادة ضبط الأطباق الشعبية.';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get resetPopDishesSuccess =>
      'تم إعادة تعيين إحصائيات الأطباق الشعبية.';

  @override
  String get dailySales => 'المبيعات اليومية';

  @override
  String get activeOrders => 'الطلبات النشطة';

  @override
  String get wasteLoss => 'خسارة الهدر (7 أيام)';

  @override
  String get invHealth => 'صحة المخزون';

  @override
  String get noActivity => 'لم يتم تسجيل أي نشاط حديث.';

  @override
  String get newOrderActivity => 'تم إنشاء طلب جديد';

  @override
  String get wasteLoggedActivity => 'تم تسجيل هدر';

  @override
  String get total => 'الإجمالي';

  @override
  String get status => 'الحالة';

  @override
  String get lost => 'فقدت';

  @override
  String get qty => 'الكمية';

  @override
  String get reason => 'السبب';

  @override
  String get aiAssistantTitle => 'مساعد المقهى الذكي';

  @override
  String get aiAssistantHint => 'اسأل عن القائمة أو الحجوزات...';

  @override
  String get aiAssistantError => 'عذراً، أواجه مشكلة في الاتصال حالياً. 😔';

  @override
  String get recipeCostingTitle => 'تكلفة الوصفة';

  @override
  String get selectTemplate => 'اختر قالب';

  @override
  String get selectMenuItem => 'اختر عنصر من القائمة (اختياري)';

  @override
  String get plateInputs => 'مدخلات الطبق';

  @override
  String get plateCostLabel => 'إجمالي تكلفة الطبق (\$)';

  @override
  String get plateCostHelper => 'يتم احتسابه تلقائياً من الوصفة أو يدوياً.';

  @override
  String get targetPriceLabel => 'سعر البيع المستهدف (\$)';

  @override
  String get targetPriceHelper => 'سعر القائمة للعميل.';

  @override
  String get grossProfitMargin => 'هامش الربح الإجمالي';

  @override
  String get profitPerPlate => 'الربح لكل طبق';

  @override
  String get missingIngredientsWarning =>
      'تحذير: لم يتم العثور على بعض المكونات في المخزون. قد تكون التكلفة غير دقيقة.';

  @override
  String get tableMappingTitle => 'تخطيط الطاولات';

  @override
  String get chefOrdersTitle => 'طلبات الشيف';

  @override
  String get inventoryTitle => 'المخزون';

  @override
  String get posTitle => 'نقطة البيع';

  @override
  String get wasteLogTitle => 'سجل الهادر';

  @override
  String get cartEmpty => 'السلة فارغة';

  @override
  String get itemsCount => 'عناصر';

  @override
  String get addMenuItem => 'إضافة عنصر للمنيو';

  @override
  String get noItemsInMenu => 'لا توجد عناصر في المنيو.';

  @override
  String get addToCart => 'أضف للسلة';

  @override
  String get sessionLog => 'سجل الجلسة';

  @override
  String get confirmOrder => 'تأكيد الطلب';

  @override
  String get clearCart => 'مسح السلة';

  @override
  String get orderConfirmed => 'تم تأكيد الطلب بنجاح!';

  @override
  String get quantity => 'الكمية';

  @override
  String get scheduleTitle => 'ساعات العمل';

  @override
  String get inventoryListing => 'قائمة المخزون';

  @override
  String get inventoryManagement => 'إدارة المخزون';

  @override
  String get newItem => 'عنصر جديد';

  @override
  String get itemName => 'اسم العنصر';

  @override
  String get category => 'الفئة';

  @override
  String get priceCost => 'السعر (التكلفة)';

  @override
  String get quickQuantity => 'كمية سريعة';

  @override
  String get actions => 'إجراءات';

  @override
  String get lowStock => 'مخزون منخفض';

  @override
  String get inStock => 'متوفر';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String removeInventoryItem(Object name) {
    return 'هل تريد إزالة $name من المخزون؟';
  }

  @override
  String updateItem(Object name) {
    return 'تحديث $name';
  }

  @override
  String get addQuantity => 'إضافة كمية';

  @override
  String get addInventoryItem => 'إضافة عنصر للمخزون';

  @override
  String get costPrice => 'التكلفة / السعر';

  @override
  String get addItemSuccess => 'تم إضافة العنصر للمخزون!';

  @override
  String get liquid => 'سائل';

  @override
  String get solid => 'صلب';

  @override
  String get groundFloor => 'الطابق الأرضي';

  @override
  String get firstFloor => 'الطابق الأول';

  @override
  String get secondFloor => 'الطابق الثاني';

  @override
  String get rooftop => 'السطح';

  @override
  String seats(int count) {
    return '$count مقاعد';
  }

  @override
  String get seatWalkIn => 'إجلاس عميل بدون حجز';

  @override
  String get markReserved => 'تحديد كمحجوز';

  @override
  String get clearTableAvailable => 'تفريغ الطاولة (متاحة)';

  @override
  String get occupied => 'مشغولة';

  @override
  String get available => 'متاحة';

  @override
  String get reserved => 'محجوزة';

  @override
  String get logSpoilage => 'تسجيل الهادر / التلف';

  @override
  String get quantityWasted => 'الكمية الهالكة';

  @override
  String get expired => 'منتهي الصلاحية';

  @override
  String get spilled => 'مسكوب / تالف';

  @override
  String get badQuality => 'جودة سيئة';

  @override
  String get mistake => 'خطأ في الطلب';

  @override
  String get logWaste => 'تسجيل الهادر';

  @override
  String get recentWasteLogs => 'سجلات الهادر الأخيرة';

  @override
  String get noWasteLogs => 'لا توجد سجلات هادر مسجلة.';

  @override
  String get wasteLoggedSuccess => 'تم تسجيل الهادر بنجاح';

  @override
  String get selectItem => 'يرجى اختيار عنصر';

  @override
  String get selectReason => 'اختر السبب';

  @override
  String get enterQuantity => 'أدخل الكمية';

  @override
  String get invalidNumber => 'رقم غير صالح';

  @override
  String get item => 'العنصر';

  @override
  String get markCompleted => 'انقر مرتين للإكمال';

  @override
  String get totalWeeklyHours => 'إجمالي الساعات الأسبوعية';

  @override
  String get upcomingShifts => 'المناوبات القادمة';

  @override
  String get today => 'اليوم';

  @override
  String get justNow => 'الآن';

  @override
  String minsAgo(int mins) {
    return 'منذ $mins دقائق';
  }

  @override
  String hoursMinsAgo(int hours, int mins) {
    return 'منذ $hoursس و$minsد';
  }

  @override
  String errorMsg(String error) {
    return 'خطأ: $error';
  }
}
