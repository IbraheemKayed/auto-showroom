import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sayarti/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:sayarti/ai_search/providers/cars_provider.dart';
import 'package:sayarti/ai_search/providers/cities_provider.dart';
import 'package:sayarti/ai_search/providers/preferences_provider.dart';
import 'package:sayarti/ai_search/services/car_api_service.dart';

import 'package:sayarti/auth/providers/auth_provider.dart';
import 'package:sayarti/dealer/providers/dealer_listings_provider.dart';
import 'package:sayarti/home/providers/favorites_provider.dart';
import 'package:sayarti/home/providers/notifications_provider.dart';
import 'package:sayarti/home/providers/recent_searches_provider.dart';
import 'package:sayarti/profile/providers/language_provider.dart';
import 'package:sayarti/search/providers/color_provider.dart';
import 'package:sayarti/search/providers/dealer_search_provider.dart';
import 'package:sayarti/search/providers/search_cars_provider.dart';
import 'package:sayarti/search/providers/search_provider.dart';
import 'package:sayarti/splash_screen.dart';

// --------------------------------------------------
// 🔔 FCM BACKGROUND HANDLER (must be top-level)
// --------------------------------------------------
@pragma('vm:entry-point')
Future<void> _onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Register background message handler
  FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

  // Request notification permissions (Android 13+ and iOS)
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // ----------------------------------------
  // 🌐 SINGLE API INSTANCE
  // ----------------------------------------
  final carApiService = CarApiService(
    'https://3dkhd9zn8w.eu-central-1.awsapprunner.com/api/v1',
  );

  // ----------------------------------------
  // 🔐 AUTH PROVIDER
  // ----------------------------------------
  final authProvider = AuthProvider();
  await authProvider.loadSavedTokens();

  // 🔗 Link AuthProvider with CarApiService
  carApiService.attachAuthProvider(authProvider);

  // Inject token if exists (cold start)
  if (authProvider.accessToken != null &&
      authProvider.accessToken!.isNotEmpty) {
    carApiService.setToken(authProvider.accessToken!);

    // Register FCM token for already-logged-in user on cold start
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      carApiService.registerFcmToken(fcmToken).catchError((_) {});
    }
  }

  runApp(
    MultiProvider(
      providers: [
        // 🌐 API (Singleton)
        Provider<CarApiService>.value(value: carApiService),
        ChangeNotifierProvider(
          create: (ctx) => FavoritesProvider(ctx.read<CarApiService>()),
        ),
        // 🔐 AUTH
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),

        ChangeNotifierProvider(
          create: (ctx) => CitiesProvider(ctx.read<CarApiService>())
            ..loadCities(),
        ),

        // ⚙️ PREFERENCES
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(carApiService),
        ),

        // 🚗 HOME CARS
        ChangeNotifierProvider(create: (_) => CarsProvider(carApiService)),

        // 🔍 SEARCH STATE (Filters UI)
        ChangeNotifierProvider(create: (_) => SearchProvider(carApiService)),

        // 🏪 DEALER SEARCH
        ChangeNotifierProvider(
          create: (_) => DealerSearchProvider(carApiService),
        ),

        // 🔎 SEARCH RESULTS (depends on SearchProvider)
        ChangeNotifierProxyProvider<SearchProvider, SearchCarsProvider>(
          create: (context) => SearchCarsProvider(
            context.read<CarApiService>(),
            context.read<SearchProvider>(),
          ),
          update: (context, searchProvider, previous) =>
              previous!..search = searchProvider,
        ),

        ChangeNotifierProvider(create: (_) => CarColorsProvider(carApiService)),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(
          create: (ctx) => NotificationsProvider(ctx.read<CarApiService>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => RecentSearchesProvider(ctx.read<CarApiService>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => DealerListingsProvider(ctx.read<CarApiService>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

// --------------------------------------------------
// 🧱 APP ROOT
// --------------------------------------------------
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final api = context.read<CarApiService>();
      final auth = context.read<AuthProvider>();

      // 🔁 After every login: set API token + reload home + register FCM token
      auth.setOnLoggedIn(() {
        final token = auth.accessToken;
        if (token != null && token.isNotEmpty) {
          api.setToken(token);
        }
        context.read<CarsProvider>().loadHomeSections(refresh: true);
        FirebaseMessaging.instance.getToken().then((fcmToken) {
          if (fcmToken != null) {
            api.registerFcmToken(fcmToken).catchError((_) {});
          }
        });
      });

      // 🚪 Before logout: delete FCM token from backend
      auth.setPreLogoutCallback(() async {
        final fcmToken = await FirebaseMessaging.instance.getToken();
        if (fcmToken != null) {
          await api.deleteFcmToken(fcmToken).catchError((_) {});
        }
      });

      // 🔄 FCM token rotated by Firebase - re-register
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        if (auth.state == AuthState.loggedIn) {
          api.registerFcmToken(newToken).catchError((_) {});
        }
      });

      // 🔔 Foreground message - refresh notification list
      final notifications = context.read<NotificationsProvider>();
      FirebaseMessaging.onMessage.listen((_) {
        notifications.load();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return MaterialApp(
      locale: lang.locale,
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'FunnelDisplay',
        fontFamilyFallback: const ['NotoSansArabic'],
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: const Color(0xFF0066EE),
          selectionColor: const Color(0xFF0066EE).withValues(alpha: 0.25),
          selectionHandleColor: const Color(0xFF0066EE),
        ),
      ),
      builder: (context, child) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        onVerticalDragEnd: (details) {
          if ((details.primaryVelocity ?? 0) > 100) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: child!,
      ),
      home: const SplashPage(),
    );
  }
}
