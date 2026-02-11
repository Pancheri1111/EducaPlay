import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ReadingPage extends StatelessWidget {
  const ReadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📖 Leitura Interativa'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com emoji
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Bem-vindo ao Mundo das Histórias!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Ouça e acompanhe histórias incríveis com narração em tempo real.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Card de história em destaque
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFFEC4899)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '⭐ Destaque Especial',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'A Pequena Cinderela',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Uma história mágica de sonhos e transformação',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.play_circle_fill),
                    label: const Text('Iniciar Leitura'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF6366F1),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Lista de outras histórias
            const Text(
              'Mais Histórias',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...[
              'O Patinho Feio',
              'Rapunzel',
              'Chapeuzinho Vermelho',
            ]
                .map((title) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade200,
                          ),
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFF10B981),
                            child: Icon(
                              Icons.book,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              size: 16),
                          onTap: () {},
                        ),
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
