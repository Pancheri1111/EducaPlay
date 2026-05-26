import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MemoryGamePage extends ConsumerStatefulWidget {
  const MemoryGamePage({super.key});

  @override
  ConsumerState<MemoryGamePage> createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends ConsumerState<MemoryGamePage> {
  static const int totalImages = 30;
  static const int minPairs = 8;
  static const int maxPairs = 30;

  late Box _scoreBox;
  late List<int> _cards;
  late List<bool> _revealed;
  late List<bool> _matched;
  int? _firstSelected;
  bool _waiting = false;
  int _moves = 0;
  int _matches = 0;
  int _bestScore = 0;
  int _currentPairs = 8;
  String _statusText = 'Toque em uma carta para começar.';
  bool _gameStarted = false;

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _scoreBox = Hive.box('scores');
    _bestScore = _scoreBox.get('memory_best_score', defaultValue: 0) as int;
    _resetGame();
  }

  void _resetGame() {
    final ids = List.generate(totalImages, (index) => index + 1);
    ids.shuffle(_random);
    final selectedIds = ids.take(_currentPairs).toList();
    final pairIds = [...selectedIds, ...selectedIds];
    pairIds.shuffle(_random);

    setState(() {
      _cards = pairIds;
      _revealed = List.filled(pairIds.length, false);
      _matched = List.filled(pairIds.length, false);
      _firstSelected = null;
      _waiting = false;
      _moves = 0;
      _matches = 0;
      _statusText = 'Toque em uma carta para começar.';
      _gameStarted = true;
    });
  }

  void _onCardTap(int index) {
    if (_waiting || _matched[index] || _revealed[index]) return;

    setState(() {
      _revealed[index] = true;
    });

    if (_firstSelected == null) {
      _firstSelected = index;
      _statusText = 'Agora escolha outra carta para encontrar o par.';
      return;
    }

    _moves++;
    final firstIndex = _firstSelected!;

    if (_cards[firstIndex] == _cards[index]) {
      setState(() {
        _matched[firstIndex] = true;
        _matched[index] = true;
        _matches++;
        _firstSelected = null;
        _statusText = 'Acertou! Continue assim.';
      });

      if (_matches == _currentPairs) {
        _finishGame();
      }
      return;
    }

    _waiting = true;
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _revealed[firstIndex] = false;
        _revealed[index] = false;
        _firstSelected = null;
        _waiting = false;
        _statusText = 'Tente lembrar onde estava aquela imagem.';
      });
    });
  }

  void _finishGame() {
    final score = _moves;
    final newBest = _bestScore == 0 || score < _bestScore;
    if (newBest) {
      _bestScore = score;
      _scoreBox.put('memory_best_score', _bestScore);
    }

    setState(() {
      _statusText = 'Você terminou em $score movimentos com $_currentPairs pares!';
    });
  }

  Widget _buildCard(int index) {
    final isFaceUp = _revealed[index] || _matched[index];
    final imageName = 'assets/images/imagememoria${_cards[index]}.png';

    return GestureDetector(
      onTap: () => _onCardTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: isFaceUp ? Colors.white : Colors.orange[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.orange.shade300, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: isFaceUp
            ? ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  imageName,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.image_not_supported, size: 42, color: Colors.black54),
                    );
                  },
                ),
              )
            : const Center(
                child: Icon(
                  Icons.help_outline,
                  size: 40,
                  color: Colors.orange,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo da Memória'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.purple.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Treine sua memória visual',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'O computador escolhe pares aleatórios entre muitas imagens. Cada nova rodada mistura o tabuleiro para não repetir.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Melhor pontuação: ${_bestScore == 0 ? '-' : '$_bestScore movimentos'}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (!_gameStarted)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.purple.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Escolha a dificuldade (pares):', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() => _currentPairs = 8);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _currentPairs == 8 ? Colors.purple : Colors.grey[300],
                              foregroundColor: _currentPairs == 8 ? Colors.white : Colors.black,
                            ),
                            child: const Text('Fácil\n(8)'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() => _currentPairs = 15);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _currentPairs == 15 ? Colors.purple : Colors.grey[300],
                              foregroundColor: _currentPairs == 15 ? Colors.white : Colors.black,
                            ),
                            child: const Text('Médio\n(15)'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() => _currentPairs = 30);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _currentPairs == 30 ? Colors.purple : Colors.grey[300],
                              foregroundColor: _currentPairs == 30 ? Colors.white : Colors.black,
                            ),
                            child: const Text('Difícil\n(30)'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _resetGame(),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: const Text('Começar Jogo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            if (_gameStarted)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusItem('Movimentos', _moves, Colors.purple),
                  _buildStatusItem('Pares', _matches, Colors.green),
                  _buildStatusItem('Total', _currentPairs, Colors.blue),
                ],
              ),
            const SizedBox(height: 16),
            if (_gameStarted)
              Expanded(
                child: GridView.builder(
                  itemCount: _currentPairs * 2,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) => _buildCard(index),
                ),
              ),
            if (_gameStarted) const SizedBox(height: 12),
            if (_gameStarted)
              Text(
                _statusText,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            if (_gameStarted) const SizedBox(height: 12),
            if (_gameStarted)
              ElevatedButton(
                onPressed: () => _resetGame(),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text('Reiniciar Jogo', style: TextStyle(fontSize: 16)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String label, int value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 6),
            Text(value.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
