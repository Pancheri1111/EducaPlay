import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math';

class MathGamePage extends ConsumerStatefulWidget {
  const MathGamePage({super.key});

  @override
  ConsumerState<MathGamePage> createState() => _MathGamePageState();
}

class _MathGamePageState extends ConsumerState<MathGamePage> {
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
    _highScore = _scoreBox.get('math_highscore', defaultValue: 0);
    _generateProblem();
  }

  void _generateProblem() {
    setState(() {
      _num1 = _random.nextInt(_difficulty);
      _num2 = _random.nextInt(_difficulty);
      _answer = _num1 + _num2;
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
          _scoreBox.put('math_highscore', _highScore);
        }
      });
      _generateProblem();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correto'), backgroundColor: Colors.green, duration: Duration(seconds: 1)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tente novamente'), backgroundColor: Colors.red, duration: Duration(seconds: 1)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matematica'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Pontos: $_score', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Recorde: $_highScore', style: const TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.red, width: 2),
              ),
              child: Text(
                '$_num1 + $_num2 = ?',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 32),
              decoration: const InputDecoration(
                hintText: 'Resposta',
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
                minimumSize: const Size(200, 60),
              ),
              child: const Text('Verificar', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
