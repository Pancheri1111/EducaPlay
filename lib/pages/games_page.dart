import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GamesPage extends ConsumerWidget {
  const GamesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Central de Jogos'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: [
          _buildGameCard(
            context,
            'Desafio de Matemática',
            Icons.calculate,
            Colors.red,
            '/math_game',
          ),
          _buildGameCard(
            context,
            'Jogo de Subtração',
            Icons.remove,
            Colors.blue,
            '/subtraction_game',
          ),
          _buildGameCard(
            context,
            'Jogo da Memória',
            Icons.memory,
            Colors.purple,
            '/memory_game',
          ),
          _buildGameCard(
            context,
            'Jogo da Velha',
            Icons.grid_3x3,
            Colors.green,
            '/tic_tac_toe',
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, String title, IconData icon, Color color, String? route) {
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
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
