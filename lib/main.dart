import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home_screen.dart';
import 'services/quran_service.dart';
import 'services/adhan_service.dart';
import 'services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة الخدمات
  final settingsService = SettingsService();
  await settingsService.init();
  
  final quranService = QuranService();
  await quranService.init();
  
  final adhanService = AdhanService();
  await adhanService.init();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => settingsService),
        Provider.value(value: quranService),
        Provider.value(value: adhanService),
      ],
      child: const QuranAdhanApp(),
    ),
  );
}

class QuranAdhanApp extends StatelessWidget {
  const QuranAdhanApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsService>(context);
    
    return MaterialApp(
      title: 'القرآن والأذان',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Amiri',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          displayMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          bodyLarge: TextStyle(fontSize: 18, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black),
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green,
          accentColor: Colors.amber,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.teal,
        fontFamily: 'Amiri',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          displayMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          bodyLarge: TextStyle(fontSize: 18, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.white),
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
          accentColor: Colors.amberAccent,
          backgroundColor: Colors.grey[900]!,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
      locale: const Locale('ar', ''),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', ''),
      ],
    );
  }
}
