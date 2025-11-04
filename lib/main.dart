import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:newsapp/screens/splashscreen/splashscreen.dart';
import 'package:newsapp/l10n/app_localizations.dart';
import 'package:newsapp/utils/language_preference.dart';
import 'package:newsapp/utils/appcolors.dart';
import 'package:newsapp/utils/theme_preference.dart';

// Global key to access app state
GlobalKey<MyAppState>? appStateKey;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  appStateKey = GlobalKey<MyAppState>();
  runApp(MyApp(key: appStateKey));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
  
  static MyAppState? get instance => appStateKey?.currentState;
}

class MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en', 'US');
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
    _loadThemePreference();
  }

  Future<void> _loadSavedLanguage() async {
    final languageCode = await LanguagePreference.getLanguageCode();
    final countryCode = await LanguagePreference.getCountryCode();
    
    if (mounted) {
      setState(() {
        _locale = Locale(languageCode ?? 'en', countryCode ?? 'US');
      });
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

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
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
    return MaterialApp(
      title: 'First Report',
      debugShowCheckedModeBanner: false,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('hi', 'IN'), // Hindi
        Locale('te', 'IN'), // Telugu
        Locale('ta', 'IN'), // Tamil
        Locale('kn', 'IN'), // Kannada
      ],
      home: const SplashScreen(),
    );
  }
}
 
