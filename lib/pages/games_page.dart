import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/settings_provider.dart';

class GamesPage extends ConsumerWidget {
  const GamesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColor = ref.watch(themeColorProvider);
    final langNotifier = ref.read(languageProvider.notifier);
    ref.watch(languageProvider); // Escuta a mudança de idioma

    return Scaffold(
      appBar: AppBar(
        title: Text(langNotifier.translate('games')),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [themeColor.withOpacity(0.1), Colors.white],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _buildGameCard(
              context,
              langNotifier.translate('math'),
              langNotifier.translate('math_sub'),
              Icons.calculate,
              Colors.red,
              '/math_game',
            ),
            const SizedBox(height: 16),
            _buildGameCard(
              context,
              langNotifier.translate('ttt'),
              langNotifier.translate('ttt_sub'),
              Icons.grid_3x3,
              Colors.purple,
              '/tic_tac_toe',
            ),
            const SizedBox(height: 16),
            _buildGameCard(
              context,
              langNotifier.translate('mem'),
              langNotifier.translate('mem_sub'),
              Icons.extension,
              Colors.orange,
              '/memory_game',
            ),
            const SizedBox(height: 16),
            _buildGameCard(
              context,
              langNotifier.translate('wm'),
              langNotifier.translate('wm_sub'),
              Icons.spellcheck,
              Colors.green,
              '/word_match',
            ),
            const SizedBox(height: 16),
            _buildGameCard(
              context,
              langNotifier.translate('tetris'),
              langNotifier.translate('tetris_sub'),
              Icons.layers,
              Colors.blue,
              '/tetris',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, String title, String subtitle, IconData icon, Color color, String route) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black26),
          ],
        ),
      ),
    );
  }
}
