import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:firstreport/screens/splashscreen/splashscreen.dart';
import 'package:firstreport/utils/appcolors.dart';
import 'package:firstreport/utils/theme_preference.dart';
import 'package:firstreport/providers/language_provider.dart';
import 'package:firstreport/l10n/app_localizations.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Global key to access app state
GlobalKey<MyAppState>? appStateKey;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Small delay to allow platform channels to warm up
  await Future.delayed(const Duration(milliseconds: 100));
  await Firebase.initializeApp();
  
  appStateKey = GlobalKey<MyAppState>();
  runApp(
    ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: MyApp(key: appStateKey),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
  
  static MyAppState? get instance => appStateKey?.currentState;
}

class MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    try {
      // Get and print FCM token
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      debugPrint("🚀 FCM Token: $fcmToken");
      
      // Subscribe to broadcast topic
      FirebaseMessaging.instance.subscribeToTopic("all_users").then((_) {
        debugPrint("🔔 Subscribed to 'all_users' topic");
      }).catchError((e) {
        debugPrint("❌ Error subscribing to topic: $e");
      });
    } catch (e) {
      debugPrint("❌ Error in Firebase init: $e");
    }
  }

  Future<void> _loadThemePreference() async {
    final isDark = await ThemePreference.isDarkMode();
    if (mounted) {
      setState(() {
        _isDarkMode = isDark;
      });
    }
  }

  void setThemeMode(bool isDark) async {
    await ThemePreference.setDarkMode(isDark);
    if (mounted) {
      setState(() {
        _isDarkMode = isDark;
      });
    }
  }

  ThemeData get _lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.screenBackground,
      cardColor: AppColors.white,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textDarkGrey),
        bodyMedium: TextStyle(color: AppColors.textDarkGrey),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.gradientStart,
        brightness: Brightness.light,
      ),
    );
  }

  ThemeData get _darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      cardColor: AppColors.darkCard,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.darkTextPrimary),
        bodyMedium: TextStyle(color: AppColors.darkTextPrimary),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.gradientStart,
        brightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    
    return MaterialApp(
      title: 'First Report',
      debugShowCheckedModeBanner: false,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      
      // Localization configuration
      locale: languageProvider.locale,
      supportedLocales: const [
        Locale('en'), // English
        Locale('hi'), // Hindi
        Locale('te'), // Telugu
        Locale('ta'), // Tamil
        Locale('kn'), // Kannada
      ],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      home: const SplashScreen(),
    );
  }
}
 
