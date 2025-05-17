import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  late SharedPreferences _prefs;
  bool _isDarkMode = false;
  String _selectedReciter = 'ياسر الدوسري';
  bool _notificationsEnabled = true;
  
  bool get isDarkMode => _isDarkMode;
  String get selectedReciter => _selectedReciter;
  bool get notificationsEnabled => _notificationsEnabled;
  
  // قائمة القراء المتاحين
  final List<String> availableReciters = [
    'ياسر الدوسري',
    'عبد الباسط عبد الصمد',
    'ماهر المعيقلي',
    'مشاري راشد العفاسي',
    'سعد الغامدي',
  ];
  
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadSettings();
  }
  
  void _loadSettings() {
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
    _selectedReciter = _prefs.getString('selectedReciter') ?? 'ياسر الدوسري';
    _notificationsEnabled = _prefs.getBool('notificationsEnabled') ?? true;
    notifyListeners();
  }
  
  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    await _prefs.setBool('isDarkMode', value);
    notifyListeners();
  }
  
  Future<void> setSelectedReciter(String reciter) async {
    if (availableReciters.contains(reciter)) {
      _selectedReciter = reciter;
      await _prefs.setString('selectedReciter', reciter);
      notifyListeners();
    }
  }
  
  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    await _prefs.setBool('notificationsEnabled', value);
    notifyListeners();
  }
}
