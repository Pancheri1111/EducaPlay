import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import '../../features/reading/presentation/pages/reading_page.dart';
import '../../features/games/presentation/pages/games_page.dart';
import '../../features/music/presentation/pages/music_page.dart';

// Provider para controlar o índice do BottomNavigationBar
final navigationIndexProvider = StateProvider<int>((ref) => 0);

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);

    // Lista de páginas para cada aba
    final pages = [
      const ReadingPage(),
      const GamesPage(),
      const MusicPage(),
    ];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(navigationIndexProvider.notifier).state = index;
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 0
                  ? Icons.auto_stories
                  : Icons.auto_stories_outlined,
              size: 28,
            ),
            label: 'Leitura',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 1 ? Icons.sports_esports : Icons.games_outlined,
              size: 28,
            ),
            label: 'Jogos',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 2 ? Icons.music_note : Icons.music_note_outlined,
              size: 28,
            ),
            label: 'Música',
          ),
        ],
      ),
    );
  }
}
