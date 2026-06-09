import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import '../data/settings_provider.dart';

class MusicPage extends ConsumerStatefulWidget {
  const MusicPage({super.key});

  @override
  ConsumerState<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends ConsumerState<MusicPage> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  String? _selectedMusicPath;
  String? _selectedMusicName;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _pickMusic() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'mp4', 'm4a', 'wav'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedMusicPath = result.files.single.path;
        _selectedMusicName = result.files.single.name;
        _isPlaying = false;
      });
      await _audioPlayer.stop();
    }
  }

  Future<void> _playMusic() async {
    if (_selectedMusicPath == null) return;
    
    await _audioPlayer.play(DeviceFileSource(_selectedMusicPath!));
    setState(() => _isPlaying = true);
  }

  Future<void> _stopMusic() async {
    await _audioPlayer.stop();
    setState(() => _isPlaying = false);
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = ref.watch(themeColorProvider);
    final lang = ref.read(languageProvider.notifier);
    ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.translate('music')),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.music_note, size: 120, color: themeColor),
              const SizedBox(height: 20),
              
              if (_selectedMusicName != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Música: $_selectedMusicName',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )
              else
                Text(
                  lang.translate('music_player'),
                  style: const TextStyle(fontSize: 18),
                ),
                
              const SizedBox(height: 40),
              
              ElevatedButton.icon(
                onPressed: _pickMusic,
                icon: const Icon(Icons.upload_file),
                label: const Text('Selecionar Música (MP3/MP4)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 50),
                ),
              ),
              
              const SizedBox(height: 30),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: (_selectedMusicPath != null && !_isPlaying) ? _playMusic : null,
                    icon: const Icon(Icons.play_arrow),
                    label: Text(lang.translate('start_music')),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: _isPlaying ? _stopMusic : null,
                    icon: const Icon(Icons.stop),
                    label: Text(lang.translate('stop_music')),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
