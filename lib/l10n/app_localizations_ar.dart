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
  String get navSchedule => 'الجدول';

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
  String get drinksFoodTitle => 'Drinks & Food';

  @override
  String get tabDrinks => 'Drinks';

  @override
  String get tabFood => 'Food';

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
}
