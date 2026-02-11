import 'package:flutter/material.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({Key? key}) : super(key: key);

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  int _totalScore = 0;
  int _starsCollected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎮 Jogos Educativos'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placar do jogador
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.star, color: Colors.white, size: 32),
                        const SizedBox(height: 8),
                        Text(
                          '$_starsCollected',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Estrelas',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEC4899),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.whatshot, color: Colors.white, size: 32),
                        const SizedBox(height: 8),
                        Text(
                          '$_totalScore',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Pontos',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Título de mini-games
            const Text(
              'Escolha um Mini-Game',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Grid de mini-games
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildGameCard(
                  title: 'Memória',
                  emoji: '🧠',
                  color: const Color(0xFF6366F1),
                  onTap: () => _playGame('Memória'),
                ),
                _buildGameCard(
                  title: 'Lógica',
                  emoji: '🔮',
                  color: const Color(0xFFEC4899),
                  onTap: () => _playGame('Lógica'),
                ),
                _buildGameCard(
                  title: 'Matemática',
                  emoji: '🧮',
                  color: const Color(0xFF10B981),
                  onTap: () => _playGame('Matemática'),
                ),
                _buildGameCard(
                  title: 'Palavras',
                  emoji: '📝',
                  color: const Color(0xFFF59E0B),
                  onTap: () => _playGame('Palavras'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Progresso de fases
            const Text(
              'Progresso de Fases',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Fase 1: Iniciante'),
                      Icon(
                        Icons.lock_open,
                        color: Colors.green.shade500,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: 1.0,
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation(Colors.green.shade500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard({
    required String title,
    required String emoji,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Jogar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _playGame(String gameName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Iniciando $gameName...'),
        backgroundColor: const Color(0xFF6366F1),
      ),
    );
  }
}
