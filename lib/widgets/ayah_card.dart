import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../models/ayah.dart';

class AyahCard extends StatelessWidget {
  final Ayah ayah;
  final VoidCallback onShare;
  
  const AyahCard({
    Key? key,
    required this.ayah,
    required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // رقم الآية وزر المشاركة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                  ),
                  child: Center(
                    child: Text(
                      ayah.number.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  color: isDarkMode ? AppTheme.darkAccentColor : AppTheme.accentColor,
                  onPressed: onShare,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // نص الآية
            Text(
              ayah.text,
              style: isDarkMode ? AppTheme.darkQuranTextStyle : AppTheme.quranTextStyle,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            // الترجمة إذا كانت متوفرة
            if (ayah.translation.isNotEmpty) ...[
              const Divider(height: 24),
              Text(
                ayah.translation,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: isDarkMode ? AppTheme.darkSecondaryTextColor : AppTheme.secondaryTextColor,
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
