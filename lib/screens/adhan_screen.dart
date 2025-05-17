import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/adhan_service.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';

class AdhanScreen extends StatefulWidget {
  const AdhanScreen({Key? key}) : super(key: key);

  @override
  State<AdhanScreen> createState() => _AdhanScreenState();
}

class _AdhanScreenState extends State<AdhanScreen> {
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
  }
  
  Future<void> _loadPrayerTimes() async {
    final adhanService = Provider.of<AdhanService>(context, listen: false);
    
    setState(() {
      _isLoading = true;
    });
    
    await adhanService.updatePrayerTimes();
    
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final adhanService = Provider.of<AdhanService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('مواقيت الصلاة'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPrayerTimes,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildNextPrayerCard(adhanService),
                Expanded(
                  child: _buildPrayerTimesList(adhanService),
                ),
              ],
            ),
    );
  }
  
  Widget _buildNextPrayerCard(AdhanService adhanService) {
    final nextPrayer = adhanService.getNextPrayer();
    
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'الصلاة القادمة',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              nextPrayer,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPrayerTimesList(AdhanService adhanService) {
    final prayerNames = {
      Prayer.fajr: 'الفجر',
      Prayer.sunrise: 'الشروق',
      Prayer.dhuhr: 'الظهر',
      Prayer.asr: 'العصر',
      Prayer.maghrib: 'المغرب',
      Prayer.isha: 'العشاء',
    };
    
    final prayers = [
      Prayer.fajr,
      Prayer.sunrise,
      Prayer.dhuhr,
      Prayer.asr,
      Prayer.maghrib,
      Prayer.isha,
    ];
    
    return ListView.builder(
      itemCount: prayers.length,
      itemBuilder: (context, index) {
        final prayer = prayers[index];
        final prayerName = prayerNames[prayer];
        final prayerTime = adhanService.getFormattedPrayerTime(prayer);
        
        return ListTile(
          leading: _getPrayerIcon(prayer),
          title: Text(
            prayerName!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          trailing: Text(
            prayerTime,
            style: const TextStyle(
              fontSize: 18.0,
            ),
          ),
        );
      },
    );
  }
  
  Widget _getPrayerIcon(Prayer prayer) {
    IconData iconData;
    
    switch (prayer) {
      case Prayer.fajr:
        iconData = Icons.nightlight_round;
        break;
      case Prayer.sunrise:
        iconData = Icons.wb_sunny_outlined;
        break;
      case Prayer.dhuhr:
        iconData = Icons.wb_sunny;
        break;
      case Prayer.asr:
        iconData = Icons.wb_twighlight;
        break;
      case Prayer.maghrib:
        iconData = Icons.nights_stay_outlined;
        break;
      case Prayer.isha:
        iconData = Icons.nights_stay;
        break;
      default:
        iconData = Icons.access_time;
    }
    
    return CircleAvatar(
      child: Icon(iconData),
    );
  }
}
