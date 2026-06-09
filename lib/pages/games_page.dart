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

  Widget _buildGameCard(BuildContext context, String title, String subtitle, IconData icon, Color color, String? route) {
    return InkWell(
      onTap: route != null ? () => Navigator.pushNamed(context, route) : null,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, size: 40, color: color),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
