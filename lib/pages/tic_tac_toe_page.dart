import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum TicTacToeDifficulty { easy, medium, hard }

class TicTacToePage extends ConsumerStatefulWidget {
  const TicTacToePage({super.key});

  @override
  ConsumerState<TicTacToePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends ConsumerState<TicTacToePage> {
  static const List<List<int>> _winningLines = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  late Box _scoreBox;
  List<String> _board = List.filled(9, '');
  bool _isPlayerTurn = true;
  bool _locked = false;
  String _statusText = 'Toque em uma casa para começar.';
  TicTacToeDifficulty _difficulty = TicTacToeDifficulty.easy;
  int _wins = 0;
  int _losses = 0;
  int _ties = 0;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _scoreBox = Hive.box('scores');
    _loadScores();
    _resetBoard();
  }

  void _loadScores() {
    setState(() {
      _wins = _scoreBox.get('tic_tac_toe_wins', defaultValue: 0) as int;
      _losses = _scoreBox.get('tic_tac_toe_losses', defaultValue: 0) as int;
      _ties = _scoreBox.get('tic_tac_toe_ties', defaultValue: 0) as int;
    });
  }

  void _saveScores() {
    _scoreBox.put('tic_tac_toe_wins', _wins);
    _scoreBox.put('tic_tac_toe_losses', _losses);
    _scoreBox.put('tic_tac_toe_ties', _ties);
  }

  void _resetBoard({bool newGame = true}) {
    setState(() {
      _board = List.filled(9, '');
      _isPlayerTurn = true;
      _locked = false;
      _statusText = newGame ? 'Toque em uma casa para começar.' : _statusText;
    });
  }

  String _difficultyName(TicTacToeDifficulty difficulty) {
    switch (difficulty) {
      case TicTacToeDifficulty.easy:
        return 'Fácil';
      case TicTacToeDifficulty.medium:
        return 'Médio';
      case TicTacToeDifficulty.hard:
        return 'Difícil';
    }
  }

  String get _tipText {
    switch (_difficulty) {
      case TicTacToeDifficulty.easy:
        return 'Dica: comece pelo centro ou por um canto para ter mais chances.';
      case TicTacToeDifficulty.medium:
        return 'Dica: bloqueie o adversário quando ele tiver duas em linha.';
      case TicTacToeDifficulty.hard:
        return 'Dica: pense em criar duas ameaças ao mesmo tempo.';
    }
  }

  void _setDifficulty(TicTacToeDifficulty difficulty) {
    setState(() {
      _difficulty = difficulty;
      _statusText = 'Dificuldade ${_difficultyName(difficulty)} selecionada.';
    });
    _resetBoard(newGame: false);
  }

  void _playerMove(int index) {
    if (_locked || !_isPlayerTurn || _board[index].isNotEmpty) return;

    setState(() {
      _board[index] = 'X';
      _isPlayerTurn = false;
    });

    final winner = _checkWinner(_board);
    if (winner != null) {
      _finishGame(winner);
      return;
    }

    if (_board.every((cell) => cell.isNotEmpty)) {
      _finishGame('T');
      return;
    }

    _locked = true;
    Future.delayed(const Duration(milliseconds: 300), _computerMove);
  }

  void _computerMove() {
    final moveIndex = _chooseMove();
    if (moveIndex == -1) {
      _finishGame('T');
      return;
    }

    setState(() {
      _board[moveIndex] = 'O';
    });

    final winner = _checkWinner(_board);
    if (winner != null) {
      _finishGame(winner);
      return;
    }

    if (_board.every((cell) => cell.isNotEmpty)) {
      _finishGame('T');
      return;
    }

    setState(() {
      _isPlayerTurn = true;
      _locked = false;
      _statusText = 'Sua vez. Use a lógica para vencer!';
    });
  }

  int _chooseMove() {
    final emptyIndexes = _board
        .asMap()
        .entries
        .where((entry) => entry.value.isEmpty)
        .map((entry) => entry.key)
        .toList();

    if (emptyIndexes.isEmpty) return -1;

    if (_difficulty == TicTacToeDifficulty.easy) {
      return emptyIndexes[_random.nextInt(emptyIndexes.length)];
    }

    final winMove = _findWinningMove('O');
    if (winMove != -1) return winMove;

    final blockMove = _findWinningMove('X');
    if (blockMove != -1) return blockMove;

    if (_difficulty == TicTacToeDifficulty.hard) {
      if (_board[4].isEmpty) return 4;
      final corners = [0, 2, 6, 8].where((i) => _board[i].isEmpty).toList();
      if (corners.isNotEmpty) return corners[_random.nextInt(corners.length)];
    }

    return emptyIndexes[_random.nextInt(emptyIndexes.length)];
  }

  int _findWinningMove(String symbol) {
    for (final line in _winningLines) {
      final positions = line.map((idx) => _board[idx]).toList();
      if (positions.where((value) => value == symbol).length == 2 &&
          positions.where((value) => value.isEmpty).length == 1) {
        final emptyIndex = line.firstWhere((idx) => _board[idx].isEmpty);
        return emptyIndex;
      }
    }
    return -1;
  }

  String? _checkWinner(List<String> board) {
    for (final line in _winningLines) {
      final a = board[line[0]];
      final b = board[line[1]];
      final c = board[line[2]];
      if (a.isNotEmpty && a == b && b == c) {
        return a;
      }
    }
    return null;
  }

  void _finishGame(String result) {
    if (result == 'X') {
      _wins++;
      _statusText = 'Você venceu! Parabéns!';
    } else if (result == 'O') {
      _losses++;
      _statusText = 'O computador venceu. Tente novamente!';
    } else {
      _ties++;
      _statusText = 'Empate! Experimente outra estratégia.';
    }
    _saveScores();
    setState(() {
      _locked = true;
      _isPlayerTurn = false;
    });
  }

  Widget _buildCell(int index) {
    final symbol = _board[index];
    return GestureDetector(
      onTap: () => _playerMove(index),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: symbol.isEmpty
n              ? const SizedBox.shrink()
              : Icon(
                  symbol == 'X' ? Icons.close : Icons.circle_outlined,
                  color: symbol == 'X' ? Colors.red : Colors.blue,
                  size: 52,
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo da Velha'),
        backgroundColor: Colors.green,
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
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Jogo educativo de lógica',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Escolha um nível de dificuldade e tente vencer o computador usando raciocínio lógico.',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Dificuldade: ${_difficultyName(_difficulty)}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _tipText,
                    style: TextStyle(fontSize: 15, color: Colors.green[900]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: TicTacToeDifficulty.values.map((difficulty) {
                final selected = _difficulty == difficulty;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      onPressed: () => _setDifficulty(difficulty),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selected ? Colors.green : Colors.grey[300],
                        foregroundColor: selected ? Colors.white : Colors.black,
                      ),
                      child: Text(_difficultyName(difficulty)),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: GridView.builder(
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) => _buildCell(index),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_statusText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildScoreItem('Vitórias', _wins, Colors.green),
                      _buildScoreItem('Derrotas', _losses, Colors.red),
                      _buildScoreItem('Empates', _ties, Colors.blue),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _resetBoard(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
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

  Widget _buildScoreItem(String label, int value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(value.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
