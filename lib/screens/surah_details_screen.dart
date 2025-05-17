import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/quran_service.dart';
import '../models/surah.dart';
import '../models/ayah.dart';
import '../services/audio_player_service.dart';
import '../services/settings_service.dart';

class SurahDetailsScreen extends StatefulWidget {
  final Surah surah;
  
  const SurahDetailsScreen({Key? key, required this.surah}) : super(key: key);

  @override
  State<SurahDetailsScreen> createState() => _SurahDetailsScreenState();
}

class _SurahDetailsScreenState extends State<SurahDetailsScreen> {
  List<Ayah> _ayahs = [];
  bool _isLoading = true;
  bool _isPlaying = false;
  
  @override
  void initState() {
    super.initState();
    _loadAyahs();
  }
  
  Future<void> _loadAyahs() async {
    final quranService = Provider.of<QuranService>(context, listen: false);
    
    setState(() {
      _isLoading = true;
    });
    
    final ayahs = await quranService.getAyahs(widget.surah.number);
    
    setState(() {
      _ayahs = ayahs;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayerService = Provider.of<AudioPlayerService>(context);
    final settingsService = Provider.of<SettingsService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surah.arabicName),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: () {
              _togglePlayback(audioPlayerService, settingsService);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildBismillah(),
                Expanded(
                  child: _buildAyahsList(),
                ),
              ],
            ),
    );
  }
  
  Widget _buildBismillah() {
    // لا نعرض البسملة في سورة التوبة (رقم 9) وفي سورة الفاتحة (رقم 1) لأنها جزء من الآيات
    if (widget.surah.number == 9 || widget.surah.number == 1) {
      return const SizedBox.shrink();
    }
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: const Text(
        'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
  
  Widget _buildAyahsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _ayahs.length,
      itemBuilder: (context, index) {
        final ayah = _ayahs[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      child: Text(ayah.number.toString()),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {
                        _shareAyah(ayah);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(
                  ayah.text,
                  style: const TextStyle(
                    fontSize: 22.0,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.right,
                ),
                if (ayah.translation.isNotEmpty) ...[
                  const Divider(),
                  Text(
                    ayah.translation,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
  
  void _togglePlayback(AudioPlayerService audioPlayerService, SettingsService settingsService) {
    if (_isPlaying) {
      audioPlayerService.pause();
    } else {
      audioPlayerService.playSurah(
        widget.surah.number,
        settingsService.selectedReciter,
      );
    }
    
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }
  
  void _shareAyah(Ayah ayah) {
    // تنفيذ مشاركة الآية
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تمت مشاركة الآية ${ayah.number} من سورة ${widget.surah.arabicName}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
