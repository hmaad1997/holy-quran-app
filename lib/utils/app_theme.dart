import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ألوان التطبيق الرئيسية
  static const Color primaryColor = Color(0xFF43A047);
  static const Color accentColor = Color(0xFFFFB300);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color textColor = Color(0xFF212121);
  static const Color secondaryTextColor = Color(0xFF757575);
  
  // ألوان الوضع الداكن
  static const Color darkPrimaryColor = Color(0xFF2E7D32);
  static const Color darkAccentColor = Color(0xFFFFD54F);
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkTextColor = Color(0xFFEEEEEE);
  static const Color darkSecondaryTextColor = Color(0xFFBDBDBD);
  
  // أنماط النصوص
  static TextStyle get headingStyle => GoogleFonts.amiri(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
  );
  
  static TextStyle get subheadingStyle => GoogleFonts.amiri(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textColor,
  );
  
  static TextStyle get bodyStyle => GoogleFonts.amiri(
    fontSize: 16,
    color: textColor,
  );
  
  static TextStyle get quranTextStyle => GoogleFonts.scheherazadeNew(
    fontSize: 24,
    height: 1.8,
    color: textColor,
  );
  
  // أنماط النصوص للوضع الداكن
  static TextStyle get darkHeadingStyle => headingStyle.copyWith(color: darkTextColor);
  static TextStyle get darkSubheadingStyle => subheadingStyle.copyWith(color: darkTextColor);
  static TextStyle get darkBodyStyle => bodyStyle.copyWith(color: darkTextColor);
  static TextStyle get darkQuranTextStyle => quranTextStyle.copyWith(color: darkTextColor);
  
  // أنماط الأزرار
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
  
  static ButtonStyle get secondaryButtonStyle => OutlinedButton.styleFrom(
    foregroundColor: primaryColor,
    side: const BorderSide(color: primaryColor),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
  
  // أنماط البطاقات
  static CardTheme get cardTheme => const CardTheme(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  );
  
  // الثيم الرئيسي للتطبيق
  static ThemeData get lightTheme => ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      background: backgroundColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: headingStyle.copyWith(color: Colors.white),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    textTheme: TextTheme(
      displayLarge: headingStyle,
      displayMedium: subheadingStyle,
      bodyLarge: bodyStyle,
      bodyMedium: bodyStyle,
    ),
    cardTheme: cardTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: primaryButtonStyle,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: secondaryButtonStyle,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: secondaryTextColor,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );
  
  // الثيم الداكن للتطبيق
  static ThemeData get darkTheme => ThemeData(
    primaryColor: darkPrimaryColor,
    scaffoldBackgroundColor: darkBackgroundColor,
    colorScheme: ColorScheme.dark(
      primary: darkPrimaryColor,
      secondary: darkAccentColor,
      background: darkBackgroundColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: darkPrimaryColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: darkHeadingStyle.copyWith(color: Colors.white),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    textTheme: TextTheme(
      displayLarge: darkHeadingStyle,
      displayMedium: darkSubheadingStyle,
      bodyLarge: darkBodyStyle,
      bodyMedium: darkBodyStyle,
    ),
    cardTheme: cardTheme.copyWith(
      color: const Color(0xFF1E1E1E),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: primaryButtonStyle.copyWith(
        backgroundColor: MaterialStateProperty.all(darkPrimaryColor),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: secondaryButtonStyle.copyWith(
        foregroundColor: MaterialStateProperty.all(darkPrimaryColor),
        side: MaterialStateProperty.all(BorderSide(color: darkPrimaryColor)),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: darkAccentColor,
      unselectedItemColor: darkSecondaryTextColor,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );
}
