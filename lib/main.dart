import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

// Importando as páginas do nosso projeto
import 'pages/login_page.dart';
import 'pages/menu_page.dart';
import 'pages/music_page.dart';
import 'pages/reading_page.dart';
import 'pages/games_page.dart';
import 'pages/math_game_page.dart';

void main() async {
  // Isso aqui é necessário para o app começar direitinho
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializando o banco de dados simples (Hive)
  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('scores');

  // Rodando o app com Riverpod para gerenciar o estado
  runApp(
    const ProviderScope(
      child: MeuAppEducativo(),
    ),
  );
}

class MeuAppEducativo extends StatelessWidget {
  const MeuAppEducativo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EducaPlay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Cores alegres para crianças
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
        textTheme: GoogleFonts.comicNeueTextTheme(),
      ),
      // A primeira tela que aparece é o Login
      home: const LoginPage(),
      // Caminhos para as outras telas
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
