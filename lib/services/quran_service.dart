import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/surah.dart';
import '../models/ayah.dart';

class QuranService {
  List<Surah> _surahs = [];
  Map<int, List<Ayah>> _ayahsCache = {};
  bool _initialized = false;
  
  List<Surah> get surahs => _surahs;
  
  Future<void> init() async {
    if (_initialized) return;
    
    await _loadSurahs();
    _initialized = true;
  }
  
  Future<void> _loadSurahs() async {
    try {
      // محاولة تحميل السور من الملفات المحلية
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/surahs.json');
      
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonList = json.decode(jsonString);
        _surahs = jsonList.map((json) => Surah.fromJson(json)).toList();
      } else {
        // إذا لم يوجد ملف محلي، قم بتحميل البيانات من الأصول
        final jsonString = await rootBundle.loadString('assets/quran_text/surahs.json');
        final List<dynamic> jsonList = json.decode(jsonString);
        _surahs = jsonList.map((json) => Surah.fromJson(json)).toList();
        
        // حفظ البيانات محلياً للاستخدام في المستقبل
        await file.writeAsString(jsonString);
      }
    } catch (e) {
      // في حالة حدوث خطأ، قم بتحميل قائمة السور الافتراضية
      _loadDefaultSurahs();
    }
  }
  
  void _loadDefaultSurahs() {
    // قائمة افتراضية للسور في حالة فشل التحميل
    _surahs = [
      Surah(number: 1, name: 'الفاتحة', arabicName: 'الفاتحة', ayahCount: 7),
      Surah(number: 2, name: 'البقرة', arabicName: 'البقرة', ayahCount: 286),
      Surah(number: 3, name: 'آل عمران', arabicName: 'آل عمران', ayahCount: 200),
      // ... إضافة المزيد من السور
    ];
  }
  
  Future<List<Ayah>> getAyahs(int surahNumber) async {
    if (_ayahsCache.containsKey(surahNumber)) {
      return _ayahsCache[surahNumber]!;
    }
    
    try {
      // محاولة تحميل الآيات من الملفات المحلية
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/surah_$surahNumber.json');
      
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonList = json.decode(jsonString);
        final ayahs = jsonList.map((json) => Ayah.fromJson(json)).toList();
        _ayahsCache[surahNumber] = ayahs;
        return ayahs;
      } else {
        // إذا لم يوجد ملف محلي، قم بتحميل البيانات من الأصول
        final jsonString = await rootBundle.loadString('assets/quran_text/surah_$surahNumber.json');
        final List<dynamic> jsonList = json.decode(jsonString);
        final ayahs = jsonList.map((json) => Ayah.fromJson(json)).toList();
        
        // حفظ البيانات محلياً للاستخدام في المستقبل
        await file.writeAsString(jsonString);
        
        _ayahsCache[surahNumber] = ayahs;
        return ayahs;
      }
    } catch (e) {
      // في حالة حدوث خطأ، قم بإرجاع قائمة فارغة
      return [];
    }
  }
  
  Future<String> getRecitationUrl(int surahNumber, String reciter) async {
    // تحويل اسم القارئ إلى معرف API
    final Map<String, String> reciterIds = {
      'ياسر الدوسري': 'yasser_aldosari',
      'عبد الباسط عبد الصمد': 'abdul_basit',
      'ماهر المعيقلي': 'maher_almuaiqly',
      'مشاري راشد العفاسي': 'mishari_rashid_alafasy',
      'سعد الغامدي': 'saad_alghamdi',
    };
    
    final reciterId = reciterIds[reciter] ?? 'yasser_aldosari';
    
    // بناء رابط التلاوة (يمكن تعديله حسب API المستخدم)
    return 'https://api.quran.com/api/v4/recitations/$reciterId/by_surah/$surahNumber';
  }
  
  Future<List<Surah>> searchSurahs(String query) async {
    if (query.isEmpty) return _surahs;
    
    final normalizedQuery = query.trim().toLowerCase();
    return _surahs.where((surah) {
      return surah.name.toLowerCase().contains(normalizedQuery) ||
             surah.arabicName.contains(normalizedQuery) ||
             surah.number.toString() == normalizedQuery;
    }).toList();
  }
}
