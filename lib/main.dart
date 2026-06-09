import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/menu_page.dart';
import 'pages/music_page.dart';
import 'pages/reading_page.dart';
import 'pages/games_page.dart';
import 'pages/math_game_page.dart';
import 'pages/tic_tac_toe_page.dart';
import 'pages/memory_game_page.dart';
import 'pages/tetris_page.dart';
import 'pages/settings_page.dart';
import 'pages/word_match_game_page.dart';
import 'data/settings_provider.dart';
import 'data/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('scores');
  await AuthService.init(); // Inicializa o Banco de Dados Fake de usuários

  runApp(
    const ProviderScope(
      child: EducaPlayApp(),
    ),
  );
}

class EducaPlayApp extends ConsumerWidget {
  const EducaPlayApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColor = ref.watch(themeColorProvider);

    return MaterialApp(
      title: 'EducaPlay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: themeColor),
        useMaterial3: true,
        textTheme: GoogleFonts.comicNeueTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: themeColor,
          foregroundColor: Colors.white,
        ),
      ),
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/menu': (context) => const MenuPage(),
        '/music': (context) => const MusicPage(),
        '/reading': (context) => const ReadingPage(),
        '/games': (context) => const GamesPage(),
        '/math_game': (context) => const MathGamePage(),
        '/tic_tac_toe': (context) => const TicTacToePage(),
        '/memory_game': (context) => const MemoryGamePage(),
        '/tetris': (context) => const TetrisPage(),
        '/settings': (context) => const SettingsPage(),
        '/word_match': (context) => const WordMatchGamePage(),
      },
    );
  }
}
