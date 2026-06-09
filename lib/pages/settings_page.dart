import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/settings_provider.dart';
import '../data/auth_service.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColor = ref.watch(themeColorProvider);
    final language = ref.watch(languageProvider);
    final langNotifier = ref.read(languageProvider.notifier);
    final authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: Text(langNotifier.translate('settings')),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            langNotifier.translate('settings'),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListTile(
            title: Text(langNotifier.translate('app_color')),
            trailing: CircleAvatar(backgroundColor: themeColor),
            onTap: () => _showColorPicker(context, ref),
          ),
          ListTile(
            title: Text(langNotifier.translate('language')),
            subtitle: Text(language),
            leading: const Icon(Icons.language),
            onTap: () => _showLanguagePicker(context, ref),
          ),
          const Divider(height: 40),
          ListTile(
            title: Text(langNotifier.translate('logout')),
            leading: const Icon(Icons.logout, color: Colors.red),
            onTap: () {
              authService.logout();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
      ),
    );
  }

  void _showColorPicker(BuildContext context, WidgetRef ref) {
    final colors = [
      Colors.orange,
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.pink,
      Colors.teal,
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Color'),
        content: Wrap(
          spacing: 10,
          children: colors.map((color) {
            return GestureDetector(
              onTap: () {
                ref.read(themeColorProvider.notifier).changeColor(color);
                Navigator.pop(context);
              },
              child: CircleAvatar(backgroundColor: color, radius: 25),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    final languages = ['Português', 'English', 'Español'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((lang) {
            return ListTile(
              title: Text(lang),
              onTap: () {
                ref.read(languageProvider.notifier).changeLanguage(lang);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
