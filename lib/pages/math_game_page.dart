import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum MathType { addition, subtraction, multiplication }

class MathGamePage extends ConsumerStatefulWidget {
  const MathGamePage({super.key});

  @override
  ConsumerState<MathGamePage> createState() => _MathGamePageState();
}

class _MathGamePageState extends ConsumerState<MathGamePage> {
  int _score = 0;
  final TextEditingController _controller = TextEditingController();
  final Random _random = Random();
  late Box _scoreBox;

  MathType _type = MathType.addition;
  int _difficulty = 1; // 1 = fácil, 2 = médio, 3 = difícil
  int _level = 1;
  late int _num1;
  late int _num2;
  late int _answer;
  final Map<MathType, int> _highScores = {
    MathType.addition: 0,
    MathType.subtraction: 0,
    MathType.multiplication: 0,
  };

  @override
  void initState() {
    super.initState();
    _scoreBox = Hive.box('scores');
    _loadState();
    _generateProblem();
  }

  void _loadState() {
    _type = MathType.values[_scoreBox.get('math_type', defaultValue: 0) as int];
    _difficulty = _scoreBox.get('math_difficulty', defaultValue: 1) as int;
    _level = _scoreBox.get('math_level', defaultValue: 1) as int;

    for (final type in MathType.values) {
      _highScores[type] = _scoreBox.get(_highScoreKey(type), defaultValue: 0) as int;
    }
  }

  String _highScoreKey(MathType type) {
    return 'math_highscore_${type.name}';
  }

  String _typeName(MathType type) {
    switch (type) {
      case MathType.addition:
        return 'Soma';
      case MathType.subtraction:
        return 'Subtração';
      case MathType.multiplication:
        return 'Multiplicação';
    }
  }

  String _difficultyName(int difficulty) {
    switch (difficulty) {
      case 1:
        return 'Fácil';
      case 2:
        return 'Médio';
      default:
        return 'Difícil';
    }
  }

  void _generateProblem() {
    setState(() {
      final int base = _difficulty * 5 + (_level - 1) * 3;
      final int maxValue = max(5, base);

      if (_type == MathType.addition) {
        _num1 = _random.nextInt(maxValue) + 1;
        _num2 = _random.nextInt(maxValue) + 1;
        _answer = _num1 + _num2;
      } else if (_type == MathType.subtraction) {
        _num1 = _random.nextInt(maxValue) + 1;
        _num2 = _random.nextInt(_num1) + 1;
        _answer = _num1 - _num2;
      } else {
        _num1 = _random.nextInt(max(4, maxValue ~/ 2)) + 1;
        _num2 = _random.nextInt(max(4, maxValue ~/ 2)) + 1;
        _answer = _num1 * _num2;
      }
      _controller.clear();
    });
  }

  void _saveState() {
    _scoreBox.put('math_type', _type.index);
    _scoreBox.put('math_difficulty', _difficulty);
    _scoreBox.put('math_level', _level);
    _scoreBox.put(_highScoreKey(_type), _highScores[_type]);
  }

  void _changeType(MathType type) {
    setState(() {
      _type = type;
      _score = 0;
      _level = 1;
      _saveState();
      _generateProblem();
    });
  }

  void _setDifficulty(int difficulty) {
    setState(() {
      _difficulty = difficulty;
      _score = 0;
      _saveState();
      _generateProblem();
    });
  }

  void _changeLevel(int delta) {
    final newLevel = (_level + delta).clamp(1, 5);
    if (newLevel != _level) {
      setState(() {
        _level = newLevel;
        _score = 0;
        _saveState();
        _generateProblem();
      });
    }
  }

  void _checkAnswer() {
    final userAnswer = int.tryParse(_controller.text);
    if (userAnswer == _answer) {
      setState(() {
        _score++;
        if (_score > _highScores[_type]!) {
          _highScores[_type] = _score;
        }
        if (_score % 3 == 0 && _level < 5) {
          _level++;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Parabéns! Você passou para o nível $_level.'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
        _saveState();
      });
      _generateProblem();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tente novamente'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Widget _buildTypeButton(MathType type) {
    final selected = _type == type;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          onPressed: () => _changeType(type),
          style: ElevatedButton.styleFrom(
            backgroundColor: selected ? Colors.orange : Colors.grey[300],
            foregroundColor: selected ? Colors.white : Colors.black,
          ),
          child: Text(_typeName(type)),
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(int difficulty) {
    final selected = _difficulty == difficulty;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          onPressed: () => _setDifficulty(difficulty),
          style: ElevatedButton.styleFrom(
            backgroundColor: selected ? Colors.blue : Colors.grey[300],
            foregroundColor: selected ? Colors.white : Colors.black,
          ),
          child: Text(_difficultyName(difficulty)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final highScore = _highScores[_type] ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matemática'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Escolha o tipo de jogo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(children: MathType.values.map(_buildTypeButton).toList()),
            const SizedBox(height: 20),
            const Text('Dificuldade', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(children: [1, 2, 3].map(_buildDifficultyButton).toList()),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _level > 1 ? () => _changeLevel(-1) : null,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[200], foregroundColor: Colors.black),
                    child: const Text('Anterior'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _level < 5 ? () => _changeLevel(1) : null,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[200], foregroundColor: Colors.black),
                    child: const Text('Próximo'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Nível $_level de 5', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(height: 40, thickness: 1),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.red, width: 2),
              ),
              child: Text(
                '$_num1 ${_type == MathType.addition ? '+' : _type == MathType.subtraction ? '-' : '×'} $_num2 = ?',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28),
              decoration: const InputDecoration(
                hintText: 'Digite sua resposta',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _checkAnswer(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(55),
              ),
              child: const Text('Verificar', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pontuação: $_score', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Recorde: $highScore', style: const TextStyle(fontSize: 18, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 10),
            Text('Progresso salvo para ${_typeName(_type)}', style: const TextStyle(fontSize: 16, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
