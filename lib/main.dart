import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:advflutter/l10n/app_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';

import 'core/providers/theme_provider.dart';
import 'core/providers/language_provider.dart';
import 'ui/screens/login_screen.dart';
import 'ui/screens/customer/customer_table_screen.dart';
import 'firebase_options.dart';
import 'core/services/firestore_service.dart';
import 'core/models/dish_model.dart';
import 'core/models/inventory_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirestoreService().seedDatabase(DishModel.mockDishes, []);

  final doc = await FirebaseFirestore.instance.collection('recipes').doc('bev_1').get();
  print('DEBUG_SEED: Caramel Macchiato imageUrl in DB is: ${doc.data()?['imageUrl']}');

  runApp(const ProviderScope(child: MyApp()));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();
    
    // Handle link when app is in background
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });
  }

  void _handleDeepLink(Uri uri) {
    if (uri.pathSegments.isNotEmpty && uri.pathSegments[0] == 'table') {
      final tableId = uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;
      if (tableId != null) {
        navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (context) => CustomerTableScreen(tableId: tableId),
        ));
      }
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(currentThemeProvider);
    final locale = ref.watch(currentLocaleProvider);

    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'RestoManager',
      theme: theme,
      locale: locale,
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
      home: const LoginScreen(),
      onGenerateRoute: (settings) {
        if (settings.name != null && settings.name!.startsWith('/table/')) {
          final uri = Uri.parse(settings.name!);
          final segments = uri.pathSegments;
          if (segments.length == 2 && segments[0] == 'table') {
            final tableId = segments[1];
            return MaterialPageRoute(
              builder: (context) => CustomerTableScreen(tableId: tableId),
            );
          }
        }
        return null;
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
