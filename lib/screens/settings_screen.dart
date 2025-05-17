import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsService = Provider.of<SettingsService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildSectionTitle(context, 'إعدادات العرض'),
          SwitchListTile(
            title: const Text('الوضع الليلي'),
            subtitle: const Text('تفعيل الوضع الليلي للقراءة في الظلام'),
            value: settingsService.isDarkMode,
            onChanged: (value) {
              settingsService.setDarkMode(value);
            },
          ),
          const Divider(),
          _buildSectionTitle(context, 'إعدادات التلاوة'),
          ListTile(
            title: const Text('القارئ المفضل'),
            subtitle: Text(settingsService.selectedReciter),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              _showReciterSelectionDialog(context, settingsService);
            },
          ),
          const Divider(),
          _buildSectionTitle(context, 'إعدادات الإشعارات'),
          SwitchListTile(
            title: const Text('إشعارات مواقيت الصلاة'),
            subtitle: const Text('تلقي إشعارات عند دخول وقت الصلاة'),
            value: settingsService.notificationsEnabled,
            onChanged: (value) {
              settingsService.setNotificationsEnabled(value);
            },
          ),
          const Divider(),
          _buildSectionTitle(context, 'عن التطبيق'),
          ListTile(
            title: const Text('تطبيق القرآن والأذان'),
            subtitle: const Text('الإصدار 1.0.0'),
            leading: const Icon(Icons.info_outline),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
  
  void _showReciterSelectionDialog(BuildContext context, SettingsService settingsService) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('اختر القارئ المفضل'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: settingsService.availableReciters.length,
              itemBuilder: (context, index) {
                final reciter = settingsService.availableReciters[index];
                return RadioListTile<String>(
                  title: Text(reciter),
                  value: reciter,
                  groupValue: settingsService.selectedReciter,
                  onChanged: (value) {
                    if (value != null) {
                      settingsService.setSelectedReciter(value);
                      Navigator.pop(context);
                    }
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('إلغاء'),
            ),
          ],
        );
      },
    );
  }
}
