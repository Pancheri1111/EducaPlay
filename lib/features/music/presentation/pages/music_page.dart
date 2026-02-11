import 'package:flutter/material.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({Key? key}) : super(key: key);

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  bool _isPlaying = false;
  double _progress = 0.3;
  int _currentSongIndex = 0;

  final List<String> _songs = [
    'Música Infantil #1',
    'Música Infantil #2',
    'Música Infantil #3',
    'Música Infantil #4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎵 Música Infantil Segura'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Player principal
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF0EA5E9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF10B981).withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Artwork (placeholder)
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.music_note,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Song info
                  Text(
                    _songs[_currentSongIndex],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Artista Infantil',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Progress bar
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: _progress,
                          minHeight: 6,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          valueColor: const AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '1:20',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '4:00',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Player buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Botão anterior
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentSongIndex = (_currentSongIndex - 1).clamp(
                              0,
                              _songs.length - 1,
                            );
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.skip_previous,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),

                      // Play/Pause button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPlaying = !_isPlaying;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: const Color(0xFF10B981),
                            size: 40,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),

                      // Botão próximo
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentSongIndex = (_currentSongIndex + 1).clamp(
                              0,
                              _songs.length - 1,
                            );
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.skip_next,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Volume control
                  Row(
                    children: [
                      const Icon(Icons.volume_down, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SliderTheme(
                          data: SliderThemeData(
                            thumbShape: const RoundSliderThumbShape(
                              elevatedValue: true,
                              enabledThumbRadius: 8,
                            ),
                            trackHeight: 4,
                          ),
                          child: Slider(
                            value: 0.7,
                            min: 0,
                            max: 1,
                            activeColor: Colors.white,
                            inactiveColor: Colors.white.withOpacity(0.3),
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.volume_up, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Playlist
            const Text(
              'Próximas Músicas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ..._songs
                .asMap()
                .entries
                .map((entry) {
                  int index = entry.key;
                  String song = entry.value;
                  bool isCurrentSong = index == _currentSongIndex;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isCurrentSong
                            ? const Color(0xFF10B981).withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isCurrentSong
                              ? const Color(0xFF10B981)
                              : Colors.grey.shade200,
                          width: isCurrentSong ? 2 : 1,
                        ),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.music_note,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          song,
                          style: TextStyle(
                            fontWeight: isCurrentSong
                                ? FontWeight.bold
                                : FontWeight.w600,
                          ),
                        ),
                        subtitle: const Text('Artista Infantil'),
                        trailing: Icon(
                          isCurrentSong ? Icons.playing_cards : Icons.add,
                          color:
                              isCurrentSong ? Colors.green : Colors.grey.shade400,
                        ),
                        onTap: () {
                          setState(() {
                            _currentSongIndex = index;
                            _isPlaying = true;
                          });
                        },
                      ),
                    ),
                  );
                })
                .toList(),
          ],
        ),
      ),
    );
  }
}
