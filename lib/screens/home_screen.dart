import 'package:flutter/material.dart';
import '../services/quran_service.dart';
import '../services/adhan_service.dart';
import '../services/audio_player_service.dart';
import '../services/settings_service.dart';
import 'quran_screen.dart';
import 'adhan_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [];
  
  @override
  void initState() {
    super.initState();
    _initScreens();
  }
  
  void _initScreens() {
    _screens.addAll([
      const QuranScreen(),
      const AdhanScreen(),
      const SettingsScreen(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'القرآن',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'الأذان',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'الإعدادات',
          ),
        ],
      ),
    );
  }
}
