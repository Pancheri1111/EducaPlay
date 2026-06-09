import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/settings_provider.dart';

class TetrisPage extends ConsumerStatefulWidget {
  const TetrisPage({super.key});

  @override
  ConsumerState<TetrisPage> createState() => _TetrisPageState();
}

enum Direction { left, right, down }

class _TetrisPageState extends ConsumerState<TetrisPage> {
  static const int row = 15;
  static const int col = 10;
  
  List<int> currentPiece = [4, 5, 14, 15]; 
  List<int> landedPieces = [];
  Timer? timer;
  int score = 0;
  bool isGameOver = false;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    landedPieces.clear();
    score = 0;
    isGameOver = false;
    _createNewPiece();
    timer?.cancel();
    timer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      setState(() {
        _movePiece(Direction.down);
      });
    });
  }

  void _createNewPiece() {
    Random r = Random();
    int start = r.nextInt(col - 2);
    int type = r.nextInt(2);
    if (type == 0) { 
      currentPiece = [start, start + 1, start + col, start + col + 1];
    } else { 
      currentPiece = [start, start + 1, start + 2, start + 3];
    }

    if (_checkCollision()) {
      isGameOver = true;
      timer?.cancel();
    }
  }

  void _movePiece(Direction dir) {
    if (isGameOver) return;
    List<int> nextPos = [];
    switch (dir) {
      case Direction.left:
        if (currentPiece.any((p) => p % col == 0)) return;
        nextPos = currentPiece.map((p) => p - 1).toList();
        break;
      case Direction.right:
        if (currentPiece.any((p) => p % col == col - 1)) return;
        nextPos = currentPiece.map((p) => p + 1).toList();
        break;
      case Direction.down:
        nextPos = currentPiece.map((p) => p + col).toList();
        break;
    }

    if (!_checkCollision(nextPos)) {
      currentPiece = nextPos;
    } else if (dir == Direction.down) {
      _landPiece();
    }
  }

  bool _checkCollision([List<int>? pos]) {
    List<int> p = pos ?? currentPiece;
    return p.any((index) => index >= row * col || landedPieces.contains(index));
  }

  void _landPiece() {
    landedPieces.addAll(currentPiece);
    _checkRows();
    _createNewPiece();
  }

  void _checkRows() {
    for (int i = 0; i < row; i++) {
      bool full = true;
      for (int j = 0; j < col; j++) {
        if (!landedPieces.contains(i * col + j)) {
          full = false;
          break;
        }
      }
      if (full) {
        setState(() {
          score++;
          landedPieces.removeWhere((p) => p >= i * col && p < (i + 1) * col);
          landedPieces = landedPieces.map((p) => p < i * col ? p + col : p).toList();
        });
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = ref.watch(themeColorProvider);
    final lang = ref.read(languageProvider.notifier);
    ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(title: Text(lang.translate('tetris')), backgroundColor: themeColor, foregroundColor: Colors.white),
      backgroundColor: Colors.black87,
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: row * col,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: col),
              itemBuilder: (context, index) {
                Color c = Colors.grey[900]!;
                if (currentPiece.contains(index)) c = themeColor;
                else if (landedPieces.contains(index)) c = themeColor.withOpacity(0.5);
                return Container(
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(4)),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white, size: 40), onPressed: () => setState(() => _movePiece(Direction.left))),
                IconButton(icon: const Icon(Icons.arrow_downward, color: Colors.white, size: 40), onPressed: () => setState(() => _movePiece(Direction.down))),
                IconButton(icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 40), onPressed: () => setState(() => _movePiece(Direction.right))),
              ],
            ),
          ),
          if (isGameOver)
            ElevatedButton(onPressed: _startGame, child: Text(lang.translate('reset'))),
          Text('${lang.translate('score')}: $score', style: const TextStyle(color: Colors.white, fontSize: 24)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
