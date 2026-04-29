import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum MathType { addition, subtraction, multiplication, division }

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
  int _difficulty = 1; // 1 = Fácil, 2 = Médio, 3 = Difícil
  int _level = 1;
  late int _num1;
  late int _num2;
  late int _answer;
  bool _gameStarted = false;

  @override
  void initState() {
    super.initState();
    _scoreBox = Hive.box('scores');
  }

  void _startGame() {
    setState(() {
      _gameStarted = true;
      _score = 0;
      _level = 1;
      _generateProblem();
    });
  }

  void _generateProblem() {
    setState(() {
      // Ajuste de base conforme dificuldade e nível
      int baseRange = 10 * _difficulty;
      int growth = (_level - 1) * 5;
      int range = baseRange + growth;

      switch (_type) {
        case MathType.addition:
          _num1 = _random.nextInt(range) + 1;
          _num2 = _random.nextInt(range) + 1;
          _answer = _num1 + _num2;
          break;
        case MathType.subtraction:
          _num1 = _random.nextInt(range) + 5;
          _num2 = _random.nextInt(_num1) + 1;
          _answer = _num1 - _num2;
          break;
        case MathType.multiplication:
          int mRange = 5 + _difficulty + (_level ~/ 2);
          _num1 = _random.nextInt(mRange) + 1;
          _num2 = _random.nextInt(10 * _difficulty) + 1;
          _answer = _num1 * _num2;
          break;
        case MathType.division:
          // Garante que a divisão seja exata para crianças
          _num2 = _random.nextInt(5 * _difficulty) + 1;
          _answer = _random.nextInt(10 * _difficulty) + 1;
          _num1 = _num2 * _answer;
          break;
      }
      _controller.clear();
    });
  }

  void _checkAnswer() {
    final userAnswer = int.tryParse(_controller.text);
    if (userAnswer == _answer) {
      setState(() {
        _score++;
        if (_score % 3 == 0) _level++;
      });
      _generateProblem();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ops! Tente de novo! ✍️'), backgroundColor: Colors.orange),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_gameStarted) {
      return _buildSetupScreen();
    }
    return _buildGameScreen();
  }

  // TELA DE ESCOLHA (Dificuldade e Tipo)
  Widget _buildSetupScreen() {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurar Jogo'), backgroundColor: Colors.red, foregroundColor: Colors.white),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('O que vamos praticar?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Wrap(
              spacing: 10,
              children: MathType.values.map((type) {
                return ChoiceChip(
                  label: Text(_typeName(type)),
                  selected: _type == type,
                  onSelected: (val) => setState(() => _type = type),
                  selectedColor: Colors.red[100],
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            const Text('Qual o nível de desafio?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Row(
              children: [
                _difficultyCard(1, 'Fácil', Colors.green),
                const SizedBox(width: 10),
                _difficultyCard(2, 'Médio', Colors.orange),
                const SizedBox(width: 10),
                _difficultyCard(3, 'Difícil', Colors.red),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('COMEÇAR DESAFIO!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _difficultyCard(int value, String label, Color color) {
    bool isSelected = _difficulty == value;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _difficulty = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: isSelected ? color.withOpacity(0.5) : Colors.transparent, width: 3),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // TELA DO JOGO EM SI
  Widget _buildGameScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_typeName(_type)} - Nível $_level'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => setState(() => _gameStarted = false)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: const Color(0xFF2E4D2E),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.brown, width: 8),
              ),
              child: Text(
                '$_num1 ${_typeChar(_type)} $_num2 = ?',
                style: const TextStyle(fontSize: 50, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              autofocus: true,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: '?',
                filled: true,
                fillColor: Colors.red[50],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onSubmitted: (_) => _checkAnswer(),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 70),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('CONFERIR', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Text('Acertos nesta rodada: $_score', style: const TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  String _typeName(MathType type) {
    switch (type) {
      case MathType.addition: return 'Soma';
      case MathType.subtraction: return 'Subtração';
      case MathType.multiplication: return 'Multiplicação';
      case MathType.division: return 'Divisão';
    }
  }

  String _typeChar(MathType type) {
    switch (type) {
      case MathType.addition: return '+';
      case MathType.subtraction: return '-';
      case MathType.multiplication: return '×';
      case MathType.division: return '÷';
    }
  }
}
