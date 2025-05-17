import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AdhanService {
  PrayerTimes? _currentPrayerTimes;
  Coordinates? _coordinates;
  CalculationParameters _calculationParameters = CalculationMethod.egyptian();
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  
  PrayerTimes? get currentPrayerTimes => _currentPrayerTimes;
  
  Future<void> init() async {
    if (_initialized) return;
    
    // تهيئة الإشعارات
    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _notificationsPlugin.initialize(initializationSettings);
    
    // تحميل الإحداثيات المحفوظة
    await _loadSavedCoordinates();
    
    // إذا لم تكن الإحداثيات محفوظة، حاول الحصول عليها
    if (_coordinates == null) {
      await _getCurrentLocation();
    }
    
    // تحديث أوقات الصلاة
    await updatePrayerTimes();
    
    // جدولة الإشعارات
    await schedulePrayerNotifications();
    
    _initialized = true;
  }
  
  Future<void> _loadSavedCoordinates() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCoordinates = prefs.getString('coordinates');
    
    if (savedCoordinates != null) {
      final Map<String, dynamic> coordinatesMap = json.decode(savedCoordinates);
      _coordinates = Coordinates(
        coordinatesMap['latitude'],
        coordinatesMap['longitude'],
      );
    }
  }
  
  Future<void> _saveCoordinates() async {
    if (_coordinates != null) {
      final prefs = await SharedPreferences.getInstance();
      final coordinatesMap = {
        'latitude': _coordinates!.latitude,
        'longitude': _coordinates!.longitude,
      };
      await prefs.setString('coordinates', json.encode(coordinatesMap));
    }
  }
  
  Future<void> _getCurrentLocation() async {
    try {
      // التحقق من أذونات الموقع
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // استخدام إحداثيات افتراضية (مكة المكرمة)
          _coordinates = Coordinates(21.3891, 39.8579);
          return;
        }
      }
      
      // الحصول على الموقع الحالي
      final position = await Geolocator.getCurrentPosition();
      _coordinates = Coordinates(position.latitude, position.longitude);
      
      // حفظ الإحداثيات
      await _saveCoordinates();
    } catch (e) {
      // استخدام إحداثيات افتراضية (مكة المكرمة)
      _coordinates = Coordinates(21.3891, 39.8579);
    }
  }
  
  Future<void> updatePrayerTimes() async {
    if (_coordinates == null) {
      await _getCurrentLocation();
    }
    
    final date = DateTime.now();
    _calculationParameters.madhab = Madhab.shafi;
    
    _currentPrayerTimes = PrayerTimes(
      _coordinates!,
      DateComponents(date.year, date.month, date.day),
      _calculationParameters,
    );
  }
  
  Future<void> schedulePrayerNotifications() async {
    if (_currentPrayerTimes == null) {
      await updatePrayerTimes();
    }
    
    final prefs = await SharedPreferences.getInstance();
    final notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    
    if (!notificationsEnabled) return;
    
    // إلغاء الإشعارات السابقة
    await _notificationsPlugin.cancelAll();
    
    // جدولة إشعارات جديدة
    _scheduleNotification('صلاة الفجر', _currentPrayerTimes!.fajr);
    _scheduleNotification('صلاة الظهر', _currentPrayerTimes!.dhuhr);
    _scheduleNotification('صلاة العصر', _currentPrayerTimes!.asr);
    _scheduleNotification('صلاة المغرب', _currentPrayerTimes!.maghrib);
    _scheduleNotification('صلاة العشاء', _currentPrayerTimes!.isha);
  }
  
  Future<void> _scheduleNotification(String title, DateTime time) async {
    final now = DateTime.now();
    if (time.isBefore(now)) return;
    
    const androidDetails = AndroidNotificationDetails(
      'adhan_channel',
      'مواقيت الصلاة',
      channelDescription: 'إشعارات مواقيت الصلاة',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const iOSDetails = DarwinNotificationDetails();
    
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );
    
    final timeFormatter = DateFormat('hh:mm a');
    final formattedTime = timeFormatter.format(time);
    
    await _notificationsPlugin.schedule(
      time.millisecondsSinceEpoch ~/ 1000,
      title,
      'حان الآن موعد $title - $formattedTime',
      time,
      notificationDetails,
    );
  }
  
  String getNextPrayer() {
    if (_currentPrayerTimes == null) return '';
    
    final now = DateTime.now();
    final prayers = {
      'الفجر': _currentPrayerTimes!.fajr,
      'الشروق': _currentPrayerTimes!.sunrise,
      'الظهر': _currentPrayerTimes!.dhuhr,
      'العصر': _currentPrayerTimes!.asr,
      'المغرب': _currentPrayerTimes!.maghrib,
      'العشاء': _currentPrayerTimes!.isha,
    };
    
    String nextPrayer = '';
    DateTime? nextPrayerTime;
    
    prayers.forEach((name, time) {
      if (time.isAfter(now) && (nextPrayerTime == null || time.isBefore(nextPrayerTime!))) {
        nextPrayer = name;
        nextPrayerTime = time;
      }
    });
    
    if (nextPrayer.isEmpty) {
      // إذا كانت جميع الصلوات لليوم الحالي قد انتهت، فالصلاة التالية هي فجر اليوم التالي
      nextPrayer = 'الفجر (غداً)';
    }
    
    return nextPrayer;
  }
  
  String getFormattedPrayerTime(Prayer prayer) {
    if (_currentPrayerTimes == null) return '';
    
    DateTime time;
    switch (prayer) {
      case Prayer.fajr:
        time = _currentPrayerTimes!.fajr;
        break;
      case Prayer.sunrise:
        time = _currentPrayerTimes!.sunrise;
        break;
      case Prayer.dhuhr:
        time = _currentPrayerTimes!.dhuhr;
        break;
      case Prayer.asr:
        time = _currentPrayerTimes!.asr;
        break;
      case Prayer.maghrib:
        time = _currentPrayerTimes!.maghrib;
        break;
      case Prayer.isha:
        time = _currentPrayerTimes!.isha;
        break;
      default:
        return '';
    }
    
    final timeFormatter = DateFormat('hh:mm a');
    return timeFormatter.format(time);
  }
  
  Future<void> setCalculationMethod(CalculationMethod method) async {
    _calculationParameters = method.getParameters();
    await updatePrayerTimes();
    await schedulePrayerNotifications();
  }
}
