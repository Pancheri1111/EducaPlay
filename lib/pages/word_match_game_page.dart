import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/settings_provider.dart';

class WordMatchGamePage extends ConsumerStatefulWidget {
  const WordMatchGamePage({super.key});

  @override
  ConsumerState<WordMatchGamePage> createState() => _WordMatchGamePageState();
}

class _WordMatchGamePageState extends ConsumerState<WordMatchGamePage> {
  // LISTA GIGANTE DE 150 ITENS (A IA cuida das imagens profissionais via rede para você!)
  final List<String> _items = [
    'apple', 'banana', 'orange', 'strawberry', 'grape', 'pineapple', 'watermelon', 'cherry', 'mango', 'pear', 
    'lemon', 'broccoli', 'carrot', 'corn', 'tomato', 'potato', 'eggplant', 'cucumber', 'mushroom', 'bread', 
    'pizza', 'burger', 'hot-dog', 'cake', 'cookie', 'ice-cream', 'donut', 'chocolate', 'egg', 'milk', 
    'cheese', 'chicken', 'fish', 'meat', 'crab', 'shrimp', 'octopus', 'whale', 'dolphin', 'shark', 
    'penguin', 'owl', 'eagle', 'parrot', 'bee', 'butterfly', 'ant', 'spider', 'scorpion', 'snake', 
    'turtle', 'frog', 'lion', 'tiger', 'bear', 'panda', 'koala', 'kangaroo', 'elephant', 'giraffe', 
    'zebra', 'monkey', 'horse', 'cow', 'pig', 'sheep', 'rabbit', 'cat', 'dog', 'mouse', 
    'sun', 'moon', 'star', 'cloud', 'rainbow', 'rain', 'snow', 'fire', 'water', 'tree', 
    'flower', 'leaf', 'house', 'car', 'bicycle', 'train', 'airplane', 'boat', 'rocket', 'bus', 
    'truck', 'motorcycle', 'ambulance', 'fire-truck', 'police-car', 'taxi', 'tractor', 'key', 'lock', 'clock', 
    'watch', 'phone', 'computer', 'laptop', 'camera', 'tv', 'radio', 'book', 'pencil', 'pen', 
    'scissors', 'hammer', 'wrench', 'screwdriver', 'ball', 'soccer-ball', 'basketball', 'guitar', 'piano', 'violin',
    'drum', 'trumpet', 'bell', 'whistle', 'gift', 'balloon', 'hat', 'shirt', 'pants', 'shoes', 
    'socks', 'dress', 'skirt', 'coat', 'umbrella', 'glasses', 'ring', 'crown', 'diamond', 'sword', 
    'shield', 'axe', 'bomb', 'magnet', 'battery', 'light-bulb', 'candle', 'compass', 'telescope', 'microscope', 
    'ruler', 'calculator'
  ];

  late List<String> _currentOptions;
  late String _targetKey;
  int _score = 0;
  int _level = 1;

  @override
  void initState() {
    super.initState();
    _nextRound();
  }

  void _nextRound() {
    setState(() {
      final random = Random();
      final shuffled = List<String>.from(_items)..shuffle();
      _currentOptions = shuffled.take(4).toList();
      _targetKey = _currentOptions[random.nextInt(4)];
    });
  }

  void _checkAnswer(String selectedKey) {
    final lang = ref.read(languageProvider.notifier);
    if (selectedKey == _targetKey) {
      setState(() {
        _score++;
        if (_score % 5 == 0) _level++;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🌟'), duration: Duration(milliseconds: 500)));
      _nextRound();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(lang.translate('try_again')), duration: Duration(milliseconds: 500)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = ref.watch(themeColorProvider);
    final lang = ref.read(languageProvider.notifier);
    ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('${lang.translate('wm')} - ${lang.translate('level')} $_level'),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(lang.translate('wm_q'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              decoration: BoxDecoration(color: themeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: themeColor, width: 2)),
              child: Text(
                lang.translate(_targetKey), 
                style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: themeColor),
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20),
                itemCount: 4,
                itemBuilder: (context, index) {
                  final key = _currentOptions[index];
                  // BUSCA IMAGENS REAIS DA NUVEM (Icons8)
                  return InkWell(
                    onTap: () => _checkAnswer(key),
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Image.network(
                          'https://img.icons8.com/color/200/$key.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => 
                            Center(child: Text(lang.translate(key).toUpperCase(), style: const TextStyle(fontSize: 14, color: Colors.grey))),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Text('${lang.translate('score')}: $_score', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
