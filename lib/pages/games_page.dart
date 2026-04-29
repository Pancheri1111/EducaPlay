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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red[50]!, Colors.white],
          ),
        ),
        child: GridView.count(
          padding: const EdgeInsets.all(24),
          crossAxisCount: 1, // Um por linha para dar mais destaque
          mainAxisSpacing: 20,
          childAspectRatio: 2.5,
          children: [
            _buildGameCard(
              context,
              'Super Matemática',
              'Soma, Subtração, Multiplicação e Divisão!',
              Icons.calculate,
              Colors.red,
              '/math_game',
            ),
            _buildGameCard(
              context,
              'Em breve...',
              'Novos jogos estão sendo preparados!',
              Icons.auto_awesome,
              Colors.orange,
              null,
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
