import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/quran_service.dart';
import '../models/surah.dart';
import '../models/ayah.dart';
import '../services/audio_player_service.dart';
import '../services/settings_service.dart';
import 'surah_details_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({Key? key}) : super(key: key);

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  List<Surah> _surahs = [];
  List<Surah> _filteredSurahs = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _loadSurahs();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  Future<void> _loadSurahs() async {
    final quranService = Provider.of<QuranService>(context, listen: false);
    
    setState(() {
      _isLoading = true;
    });
    
    await quranService.init();
    
    setState(() {
      _surahs = quranService.surahs;
      _filteredSurahs = _surahs;
      _isLoading = false;
    });
  }
  
  void _filterSurahs(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredSurahs = _surahs;
      });
      return;
    }
    
    final normalizedQuery = query.trim().toLowerCase();
    setState(() {
      _filteredSurahs = _surahs.where((surah) {
        return surah.name.toLowerCase().contains(normalizedQuery) ||
               surah.arabicName.contains(normalizedQuery) ||
               surah.number.toString() == normalizedQuery;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('القرآن الكريم'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'ابحث عن سورة...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterSurahs,
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredSurahs.length,
                    itemBuilder: (context, index) {
                      final surah = _filteredSurahs[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(surah.number.toString()),
                        ),
                        title: Text(
                          surah.arabicName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        subtitle: Text(
                          'عدد الآيات: ${surah.ayahCount}',
                          textAlign: TextAlign.right,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.play_arrow),
                          onPressed: () {
                            _playSurah(surah);
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SurahDetailsScreen(surah: surah),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
  
  void _playSurah(Surah surah) {
    final audioPlayerService = Provider.of<AudioPlayerService>(context, listen: false);
    final settingsService = Provider.of<SettingsService>(context, listen: false);
    
    audioPlayerService.playSurah(
      surah.number,
      settingsService.selectedReciter,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري تشغيل سورة ${surah.arabicName} بصوت ${settingsService.selectedReciter}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
