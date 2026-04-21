import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:advflutter/l10n/app_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'core/providers/auth_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/inventory_provider.dart';
import 'core/providers/language_provider.dart';
import 'core/providers/cart_provider.dart';
import 'ui/screens/login_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: Consumer3<ThemeProvider, AuthProvider, LanguageProvider>(
        builder: (context, themeProvider, authProvider, languageProvider, child) {
          return MaterialApp(
            title: 'RestoManager',
            theme: themeProvider.currentTheme,
            locale: languageProvider.currentLocale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, widget) {
              return ResponsiveBreakpoints.builder(
                child: Builder(
                  builder: (context) {
                    return ResponsiveScaledBox(
                      width: ResponsiveBreakpoints.of(context).isMobile ? 390 : null,
                      child: widget!,
                    );
                  },
                ),
                breakpoints: [
                  const Breakpoint(start: 0, end: 450, name: MOBILE),
                  const Breakpoint(start: 451, end: 800, name: TABLET),
                  const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                  const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
                ],
              );
            },
            home: const LoginScreen(), // Start with Login Screen
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }

}
