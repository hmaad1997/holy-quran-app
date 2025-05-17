import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../services/audio_player_service.dart';
import 'package:provider/provider.dart';

class AudioPlayerWidget extends StatefulWidget {
  final int surahNumber;
  final String surahName;
  
  const AudioPlayerWidget({
    Key? key,
    required this.surahNumber,
    required this.surahName,
  }) : super(key: key);

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  
  @override
  void initState() {
    super.initState();
    _setupAudioPlayer();
  }
  
  void _setupAudioPlayer() {
    final audioPlayerService = Provider.of<AudioPlayerService>(context, listen: false);
    
    audioPlayerService.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
        });
      }
    });
    
    audioPlayerService.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final audioPlayerService = Provider.of<AudioPlayerService>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    _duration = audioPlayerService.duration;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // معلومات السورة
          Text(
            'سورة ${widget.surahName}',
            style: isDarkMode ? AppTheme.darkSubheadingStyle : AppTheme.subheadingStyle,
          ),
          const SizedBox(height: 16),
          // شريط التقدم
          Slider(
            value: _position.inSeconds.toDouble(),
            min: 0,
            max: _duration.inSeconds.toDouble() > 0 ? _duration.inSeconds.toDouble() : 1,
            activeColor: isDarkMode ? AppTheme.darkAccentColor : AppTheme.accentColor,
            inactiveColor: isDarkMode ? Colors.grey[700] : Colors.grey[300],
            onChanged: (value) {
              audioPlayerService.seekTo(Duration(seconds: value.toInt()));
            },
          ),
          // الوقت المنقضي والمتبقي
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_position),
                  style: TextStyle(
                    color: isDarkMode ? AppTheme.darkSecondaryTextColor : AppTheme.secondaryTextColor,
                  ),
                ),
                Text(
                  _formatDuration(_duration),
                  style: TextStyle(
                    color: isDarkMode ? AppTheme.darkSecondaryTextColor : AppTheme.secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // أزرار التحكم
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10),
                iconSize: 32,
                color: isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                onPressed: () {
                  final newPosition = _position - const Duration(seconds: 10);
                  audioPlayerService.seekTo(newPosition.isNegative ? Duration.zero : newPosition);
                },
              ),
              const SizedBox(width: 16),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                ),
                child: IconButton(
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  iconSize: 36,
                  color: Colors.white,
                  onPressed: () {
                    if (_isPlaying) {
                      audioPlayerService.pause();
                    } else {
                      audioPlayerService.resume();
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.forward_10),
                iconSize: 32,
                color: isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                onPressed: () {
                  final newPosition = _position + const Duration(seconds: 10);
                  audioPlayerService.seekTo(newPosition > _duration ? _duration : newPosition);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
