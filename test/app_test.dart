import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/screens/home_screen.dart';
import '../lib/screens/quran_screen.dart';
import '../lib/screens/adhan_screen.dart';
import '../lib/screens/settings_screen.dart';
import '../lib/services/quran_service.dart';
import '../lib/services/adhan_service.dart';
import '../lib/services/settings_service.dart';
import '../lib/services/audio_player_service.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('اختبار تحميل الشاشة الرئيسية', (WidgetTester tester) async {
    // إعداد الخدمات
    final settingsService = SettingsService();
    await settingsService.init();
    
    final quranService = QuranService();
    await quranService.init();
    
    final adhanService = AdhanService();
    await adhanService.init();
    
    final audioPlayerService = AudioPlayerService();
    
    // بناء التطبيق مع الخدمات
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: settingsService),
          Provider.value(value: quranService),
          Provider.value(value: adhanService),
          Provider.value(value: audioPlayerService),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );
    
    // التحقق من وجود شريط التنقل السفلي
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    
    // التحقق من وجود عناصر شريط التنقل
    expect(find.text('القرآن'), findsOneWidget);
    expect(find.text('الأذان'), findsOneWidget);
    expect(find.text('الإعدادات'), findsOneWidget);
    
    // التحقق من أن الشاشة الافتراضية هي شاشة القرآن
    expect(find.byType(QuranScreen), findsOneWidget);
    
    // الانتقال إلى شاشة الأذان
    await tester.tap(find.text('الأذان'));
    await tester.pumpAndSettle();
    
    // التحقق من ظهور شاشة الأذان
    expect(find.byType(AdhanScreen), findsOneWidget);
    
    // الانتقال إلى شاشة الإعدادات
    await tester.tap(find.text('الإعدادات'));
    await tester.pumpAndSettle();
    
    // التحقق من ظهور شاشة الإعدادات
    expect(find.byType(SettingsScreen), findsOneWidget);
  });
  
  testWidgets('اختبار وظائف شاشة القرآن', (WidgetTester tester) async {
    // إعداد الخدمات
    final settingsService = SettingsService();
    await settingsService.init();
    
    final quranService = QuranService();
    await quranService.init();
    
    final adhanService = AdhanService();
    await adhanService.init();
    
    final audioPlayerService = AudioPlayerService();
    
    // بناء شاشة القرآن مع الخدمات
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: settingsService),
          Provider.value(value: quranService),
          Provider.value(value: adhanService),
          Provider.value(value: audioPlayerService),
        ],
        child: const MaterialApp(
          home: QuranScreen(),
        ),
      ),
    );
    
    // التحقق من وجود عنوان الشاشة
    expect(find.text('القرآن الكريم'), findsOneWidget);
    
    // التحقق من وجود حقل البحث
    expect(find.byType(TextField), findsOneWidget);
    
    // انتظار تحميل قائمة السور
    await tester.pump(const Duration(seconds: 2));
    
    // التحقق من وجود قائمة السور
    expect(find.byType(ListView), findsOneWidget);
  });
  
  testWidgets('اختبار وظائف شاشة الأذان', (WidgetTester tester) async {
    // إعداد الخدمات
    final settingsService = SettingsService();
    await settingsService.init();
    
    final quranService = QuranService();
    await quranService.init();
    
    final adhanService = AdhanService();
    await adhanService.init();
    
    final audioPlayerService = AudioPlayerService();
    
    // بناء شاشة الأذان مع الخدمات
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: settingsService),
          Provider.value(value: quranService),
          Provider.value(value: adhanService),
          Provider.value(value: audioPlayerService),
        ],
        child: const MaterialApp(
          home: AdhanScreen(),
        ),
      ),
    );
    
    // التحقق من وجود عنوان الشاشة
    expect(find.text('مواقيت الصلاة'), findsOneWidget);
    
    // انتظار تحميل مواقيت الصلاة
    await tester.pump(const Duration(seconds: 2));
    
    // التحقق من وجود بطاقة الصلاة القادمة
    expect(find.text('الصلاة القادمة'), findsOneWidget);
    
    // التحقق من وجود قائمة مواقيت الصلاة
    expect(find.byType(ListView), findsOneWidget);
  });
  
  testWidgets('اختبار وظائف شاشة الإعدادات', (WidgetTester tester) async {
    // إعداد الخدمات
    final settingsService = SettingsService();
    await settingsService.init();
    
    final quranService = QuranService();
    await quranService.init();
    
    final adhanService = AdhanService();
    await adhanService.init();
    
    final audioPlayerService = AudioPlayerService();
    
    // بناء شاشة الإعدادات مع الخدمات
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: settingsService),
          Provider.value(value: quranService),
          Provider.value(value: adhanService),
          Provider.value(value: audioPlayerService),
        ],
        child: const MaterialApp(
          home: SettingsScreen(),
        ),
      ),
    );
    
    // التحقق من وجود عنوان الشاشة
    expect(find.text('الإعدادات'), findsOneWidget);
    
    // التحقق من وجود إعدادات العرض
    expect(find.text('إعدادات العرض'), findsOneWidget);
    expect(find.text('الوضع الليلي'), findsOneWidget);
    
    // التحقق من وجود إعدادات التلاوة
    expect(find.text('إعدادات التلاوة'), findsOneWidget);
    expect(find.text('القارئ المفضل'), findsOneWidget);
    
    // التحقق من وجود إعدادات الإشعارات
    expect(find.text('إعدادات الإشعارات'), findsOneWidget);
    expect(find.text('إشعارات مواقيت الصلاة'), findsOneWidget);
    
    // اختبار تغيير الوضع الليلي
    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();
    
    // اختبار فتح قائمة اختيار القارئ
    await tester.tap(find.text('القارئ المفضل'));
    await tester.pumpAndSettle();
    
    // التحقق من ظهور مربع حوار اختيار القارئ
    expect(find.text('اختر القارئ المفضل'), findsOneWidget);
  });
}
