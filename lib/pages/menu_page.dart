import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/settings_provider.dart';

class MenuPage extends ConsumerWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColor = ref.watch(themeColorProvider);
    final langNotifier = ref.read(languageProvider.notifier);
    // Watch languageProvider to rebuild when language changes
    ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Principal'),
        centerTitle: true,
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [themeColor.withOpacity(0.2), Colors.white],
          ),
        ),
        child: GridView.count(
          padding: const EdgeInsets.all(20),
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: [
            const SizedBox(height: 40),
            Text(
              langNotifier.translate('welcome'),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: themeColor,
              ),
            ),
            Text(
              langNotifier.translate('choose_activity'),
              style: const TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: [
                  _buildMenuCard(
                    context,
                    langNotifier.translate('music'),
                    Icons.music_note,
                    Colors.blue,
                    '/music',
                  ),
                  _buildMenuCard(
                    context,
                    langNotifier.translate('reading'),
                    Icons.book,
                    Colors.green,
                    '/reading',
                  ),
                  _buildMenuCard(
                    context,
                    langNotifier.translate('games'),
                    Icons.videogame_asset,
                    Colors.red,
                    '/games',
                  ),
                  _buildMenuCard(
                    context,
                    langNotifier.translate('settings'),
                    Icons.settings,
                    Colors.purple,
                    '/settings',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon, Color color, String? route) {
    return InkWell(
      onTap: route != null ? () => Navigator.pushNamed(context, route) : null,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
