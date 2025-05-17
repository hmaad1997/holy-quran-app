import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class PrayerTimeCard extends StatelessWidget {
  final String prayerName;
  final String prayerTime;
  final IconData icon;
  final bool isNext;
  
  const PrayerTimeCard({
    Key? key,
    required this.prayerName,
    required this.prayerTime,
    required this.icon,
    this.isNext = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      elevation: isNext ? 4 : 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: isNext ? BorderSide(
          color: isDarkMode ? AppTheme.darkAccentColor : AppTheme.accentColor,
          width: 2,
        ) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // أيقونة الصلاة
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isNext 
                  ? (isDarkMode ? AppTheme.darkAccentColor : AppTheme.accentColor)
                  : (isDarkMode ? AppTheme.darkPrimaryColor.withOpacity(0.7) : AppTheme.primaryColor.withOpacity(0.7)),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            // معلومات الصلاة
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prayerName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isNext 
                        ? (isDarkMode ? AppTheme.darkAccentColor : AppTheme.accentColor)
                        : (isDarkMode ? AppTheme.darkTextColor : AppTheme.textColor),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    prayerTime,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? AppTheme.darkSecondaryTextColor : AppTheme.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            // علامة الصلاة التالية
            if (isNext)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppTheme.darkAccentColor : AppTheme.accentColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'التالية',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
