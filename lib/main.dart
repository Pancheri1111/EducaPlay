import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/login_page.dart';
import 'pages/menu_page.dart';
import 'pages/music_page.dart';
import 'pages/reading_page.dart';
import 'pages/games_page.dart';
import 'pages/math_game_page.dart';

void main() async {
  // Inicializacao do Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  // Banco de dados Hive para salvar dados
  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('scores');

  runApp(
    const ProviderScope(
      child: EducaPlayApp(),
    ),
  );
}

class EducaPlayApp extends StatelessWidget {
  const EducaPlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EducaPlay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
        textTheme: GoogleFonts.comicNeueTextTheme(),
      ),
      home: const LoginPage(),
      routes: {
        '/menu': (context) => const MenuPage(),
        '/music': (context) => const MusicPage(),
        '/reading': (context) => const ReadingPage(),
        '/games': (context) => const GamesPage(),
        '/math_game': (context) => const MathGamePage(),
      },
    );
  }
}
