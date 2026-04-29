import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math';

class SubtractionGamePage extends ConsumerStatefulWidget {
  const SubtractionGamePage({super.key});

  @override
  ConsumerState<SubtractionGamePage> createState() => _SubtractionGamePageState();
}

class _SubtractionGamePageState extends ConsumerState<SubtractionGamePage> {
  int _score = 0;
  int _highScore = 0;
  late int _num1;
  late int _num2;
  late int _answer;
  int _difficulty = 10;
  final TextEditingController _controller = TextEditingController();
  final Random _random = Random();
  late Box _scoreBox;

  @override
  void initState() {
    super.initState();
    _scoreBox = Hive.box('scores');
    _highScore = _scoreBox.get('subtraction_highscore', defaultValue: 0);
    _generateProblem();
  }

  void _generateProblem() {
    setState(() {
      _num1 = _random.nextInt(_difficulty) + _difficulty; // Ensure positive result
      _num2 = _random.nextInt(_num1 + 1);
      _answer = _num1 - _num2;
      _controller.clear();
    });
  }

  void _checkAnswer() {
    final userAnswer = int.tryParse(_controller.text);
    if (userAnswer == _answer) {
      setState(() {
        _score++;
        if (_score % 5 == 0) {
          _difficulty += 5;
        }
        if (_score > _highScore) {
          _highScore = _score;
          _scoreBox.put('subtraction_highscore', _highScore);
        }
      });
      _generateProblem();
    } else {
      setState(() {
        _score = 0;
        _difficulty = 10;
      });
      _generateProblem();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo de Subtração'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[100]!, Colors.white],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quanto é $_num1 - $_num2?',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Digite sua resposta',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkAnswer,
              child: const Text('Verificar'),
            ),
            const SizedBox(height: 20),
            Text(
              'Pontuação: $_score',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'Recorde: $_highScore',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}