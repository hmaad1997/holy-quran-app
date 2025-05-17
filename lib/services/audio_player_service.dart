import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentReciterId;
  int? _currentSurahNumber;
  bool _isDownloading = false;
  
  bool get isPlaying => _audioPlayer.playing;
  bool get isDownloading => _isDownloading;
  Duration get position => _audioPlayer.position;
  Duration get duration => _audioPlayer.duration ?? Duration.zero;
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  
  Future<void> playSurah(int surahNumber, String reciterId) async {
    if (_isDownloading) return;
    
    if (_currentSurahNumber == surahNumber && _currentReciterId == reciterId && _audioPlayer.playing) {
      await _audioPlayer.pause();
      return;
    }
    
    _currentSurahNumber = surahNumber;
    _currentReciterId = reciterId;
    
    // التحقق من وجود الملف محلياً
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/recitations/${reciterId}_${surahNumber}.mp3';
    final file = File(filePath);
    
    if (await file.exists()) {
      // تشغيل الملف المحلي
      await _audioPlayer.setFilePath(filePath);
      await _audioPlayer.play();
    } else {
      // تحميل الملف من الإنترنت
      await _downloadAndPlaySurah(surahNumber, reciterId);
    }
  }
  
  Future<void> _downloadAndPlaySurah(int surahNumber, String reciterId) async {
    _isDownloading = true;
    
    try {
      // بناء رابط التلاوة (يمكن تعديله حسب API المستخدم)
      final url = _getRecitationUrl(surahNumber, reciterId);
      
      // تحميل الملف
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        // إنشاء مجلد التلاوات إذا لم يكن موجوداً
        final directory = await getApplicationDocumentsDirectory();
        final recitationsDir = Directory('${directory.path}/recitations');
        if (!await recitationsDir.exists()) {
          await recitationsDir.create(recursive: true);
        }
        
        // حفظ الملف محلياً
        final filePath = '${recitationsDir.path}/${reciterId}_${surahNumber}.mp3';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        
        // تشغيل الملف
        await _audioPlayer.setFilePath(filePath);
        await _audioPlayer.play();
      }
    } catch (e) {
      // في حالة حدوث خطأ، حاول تشغيل التلاوة مباشرة من الإنترنت
      try {
        final url = _getRecitationUrl(surahNumber, reciterId);
        await _audioPlayer.setUrl(url);
        await _audioPlayer.play();
      } catch (e) {
        // لا يمكن تشغيل التلاوة
      }
    } finally {
      _isDownloading = false;
    }
  }
  
  String _getRecitationUrl(int surahNumber, String reciterId) {
    // تحويل معرف القارئ إلى معرف API
    final Map<String, String> reciterIds = {
      'ياسر الدوسري': 'yasser_aldosari',
      'عبد الباسط عبد الصمد': 'abdul_basit',
      'ماهر المعيقلي': 'maher_almuaiqly',
      'مشاري راشد العفاسي': 'mishari_rashid_alafasy',
      'سعد الغامدي': 'saad_alghamdi',
    };
    
    final apiReciterId = reciterIds[reciterId] ?? 'yasser_aldosari';
    
    // بناء رابط التلاوة (يمكن تعديله حسب API المستخدم)
    return 'https://api.quran.com/api/v4/recitations/$apiReciterId/by_surah/$surahNumber';
  }
  
  Future<void> pause() async {
    await _audioPlayer.pause();
  }
  
  Future<void> resume() async {
    await _audioPlayer.play();
  }
  
  Future<void> stop() async {
    await _audioPlayer.stop();
  }
  
  Future<void> seekTo(Duration position) async {
    await _audioPlayer.seek(position);
  }
  
  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
