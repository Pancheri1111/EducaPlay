import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/settings_provider.dart';

class TicTacToePage extends ConsumerStatefulWidget {
  const TicTacToePage({super.key});

  @override
  ConsumerState<TicTacToePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends ConsumerState<TicTacToePage> {
  List<String> displayElement = ['', '', '', '', '', '', '', '', ''];
  int filledBoxes = 0;
  String winnerKey = '';
  int _difficulty = 1; 
  bool _gameStarted = false;

  void _tapped(int index) {
    if (winnerKey != '' || displayElement[index] != '') return;

    setState(() {
      displayElement[index] = 'O';
      filledBoxes++;
      if (_checkWinner('O')) {
        winnerKey = 'ttt_win';
      } else if (filledBoxes < 9) {
        _computerMove();
      } else {
        winnerKey = 'ttt_draw';
      }
    });
  }

  void _computerMove() {
    int move = -1;
    if (_difficulty == 1) {
      move = _getRandomMove();
    } else if (_difficulty == 2) {
      move = _getWinningOrBlockingMove('X') ?? _getWinningOrBlockingMove('O') ?? _getRandomMove();
    } else {
      move = _getBestMove();
    }

    if (move != -1) {
      displayElement[move] = 'X';
      filledBoxes++;
      if (_checkWinner('X')) {
        winnerKey = 'ttt_lose';
      } else if (filledBoxes == 9 && winnerKey == '') {
        winnerKey = 'ttt_draw';
      }
    }
  }

  int _getRandomMove() {
    var emptyIndices = <int>[];
    for (int i = 0; i < displayElement.length; i++) {
      if (displayElement[i] == '') emptyIndices.add(i);
    }
    return emptyIndices.isNotEmpty ? emptyIndices[Random().nextInt(emptyIndices.length)] : -1;
  }

  int? _getWinningOrBlockingMove(String player) {
    var winConditions = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]];
    for (var condition in winConditions) {
      int count = 0; int? empty;
      for (int i in condition) {
        if (displayElement[i] == player) count++;
        if (displayElement[i] == '') empty = i;
      }
      if (count == 2 && empty != null) return empty;
    }
    return null;
  }

  int _getBestMove() {
    int bestScore = -1000; int move = -1;
    for (int i = 0; i < 9; i++) {
      if (displayElement[i] == '') {
        displayElement[i] = 'X';
        int score = _minimax(displayElement, 0, false);
        displayElement[i] = '';
        if (score > bestScore) { bestScore = score; move = i; }
      }
    }
    return move;
  }

  int _minimax(List<String> board, int depth, bool isMaximizing) {
    if (_checkWinner('X')) return 10;
    if (_checkWinner('O')) return -10;
    if (board.every((element) => element != '')) return 0;
    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == '') {
          board[i] = 'X';
          int score = _minimax(board, depth + 1, false);
          board[i] = '';
          bestScore = max(score, bestScore);
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == '') {
          board[i] = 'O';
          int score = _minimax(board, depth + 1, true);
          board[i] = '';
          bestScore = min(score, bestScore);
        }
      }
      return bestScore;
    }
  }

  bool _checkWinner(String player) {
    var winConditions = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]];
    for (var cond in winConditions) {
      if (displayElement[cond[0]] == player && displayElement[cond[1]] == player && displayElement[cond[2]] == player) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.read(languageProvider.notifier);
    final themeColor = ref.watch(themeColorProvider);
    ref.watch(languageProvider);

    if (!_gameStarted) {
      return Scaffold(
        appBar: AppBar(title: Text(lang.translate('setup')), backgroundColor: themeColor),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(lang.translate('ttt_cpu'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _diffBtn(1, lang.translate('easy'), Colors.green),
              const SizedBox(height: 12),
              _diffBtn(2, lang.translate('medium'), Colors.orange),
              const SizedBox(height: 12),
              _diffBtn(3, lang.translate('hard'), Colors.red),
              const Spacer(),
              ElevatedButton(
                onPressed: () => setState(() => _gameStarted = true),
                style: ElevatedButton.styleFrom(backgroundColor: themeColor, minimumSize: const Size(0, 60)),
                child: Text(lang.translate('play'), style: const TextStyle(color: Colors.white, fontSize: 20)),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.translate('ttt')),
        backgroundColor: themeColor,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => setState(() => _gameStarted = false)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(winnerKey == '' ? lang.translate('ttt_turn') : lang.translate(winnerKey),
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: themeColor)),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: 9,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemBuilder: (ctx, i) => GestureDetector(
                onTap: () => _tapped(i),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: themeColor.withOpacity(0.2))),
                  child: Center(child: Text(displayElement[i], style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: displayElement[i] == 'O' ? Colors.blue : Colors.red))),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => setState(() { displayElement = List.filled(9, ''); filledBoxes = 0; winnerKey = ''; }),
            child: Text(lang.translate('reset')),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _diffBtn(int v, String t, Color c) {
    bool s = _difficulty == v;
    return ElevatedButton(
      onPressed: () => setState(() => _difficulty = v),
      style: ElevatedButton.styleFrom(backgroundColor: s ? c : Colors.grey[200], foregroundColor: s ? Colors.white : Colors.black),
      child: Text(t),
    );
  }
}
