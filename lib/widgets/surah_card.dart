import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../models/surah.dart';
import '../services/audio_player_service.dart';
import 'package:provider/provider.dart';

class SurahCard extends StatelessWidget {
  final Surah surah;
  final VoidCallback onTap;
  final VoidCallback onPlayTap;
  
  const SurahCard({
    Key? key,
    required this.surah,
    required this.onTap,
    required this.onPlayTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // رقم السورة في دائرة
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                ),
                child: Center(
                  child: Text(
                    surah.number.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // معلومات السورة
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.arabicName,
                      style: isDarkMode ? AppTheme.darkSubheadingStyle : AppTheme.subheadingStyle,
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'عدد الآيات: ${surah.ayahCount}',
                      style: TextStyle(
                        color: isDarkMode ? AppTheme.darkSecondaryTextColor : AppTheme.secondaryTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // زر التشغيل
              IconButton(
                icon: const Icon(Icons.play_circle_filled),
                color: isDarkMode ? AppTheme.darkAccentColor : AppTheme.accentColor,
                iconSize: 36,
                onPressed: onPlayTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
