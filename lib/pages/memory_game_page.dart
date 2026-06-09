import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/settings_provider.dart';

class MemoryGamePage extends ConsumerStatefulWidget {
  const MemoryGamePage({super.key});

  @override
  ConsumerState<MemoryGamePage> createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends ConsumerState<MemoryGamePage> {
  late Box _scoreBox;
  List<int> _cards = [];
  List<bool> _revealed = [];
  List<bool> _matched = [];
  List<String> _imagePaths = [];
  int? _firstSelected;
  bool _waiting = false;
  int _moves = 0;
  int _matches = 0;
  int _bestScore = 0;
  int _currentPairs = 8;
  bool _gameStarted = false;
  bool _loadingImages = true;

  @override
  void initState() {
    super.initState();
    _scoreBox = Hive.box('scores');
    _bestScore = _scoreBox.get('memory_best_score', defaultValue: 0) as int;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadingImages) {
      _loadMemoryImages();
    }
  }

  // ALGORITMO QUE DETECTA QUALQUER PNG NA PASTA AUTOMATICAMENTE
  Future<void> _loadMemoryImages() async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);
      
      // Busca TODAS as imagens na pasta memory/ que você criou
      final images = manifestMap.keys
          .where((key) => key.startsWith('assets/images/memory/'))
          .where((key) => key.toLowerCase().endsWith('.png') || 
                          key.toLowerCase().endsWith('.jpg') || 
                          key.toLowerCase().endsWith('.jpeg'))
          .where((key) => !key.contains('2.0x') && !key.contains('3.0x')) // Ignora pastas de sistema
          .toList();

      if (mounted) {
        setState(() {
          _imagePaths = images;
          _loadingImages = false;
        });
      }
    } catch (e) {
      debugPrint('Erro ao carregar imagens: $e');
      if (mounted) setState(() => _loadingImages = false);
    }
  }

  void _startNewGame(int pairs) {
    if (_imagePaths.isEmpty) return;

    setState(() {
      // Usa o número de fotos que você tem ou o que você pediu (o que for menor)
      _currentPairs = min(pairs, _imagePaths.length);

      final ids = List.generate(_imagePaths.length, (index) => index);
      ids.shuffle();
      final selectedIds = ids.take(_currentPairs).toList();
      final pairIds = [...selectedIds, ...selectedIds];
      pairIds.shuffle();

      _cards = pairIds;
      _revealed = List.filled(pairIds.length, false);
      _matched = List.filled(pairIds.length, false);
      _firstSelected = null;
      _waiting = false;
      _moves = 0;
      _matches = 0;
      _gameStarted = true;
    });
  }

  void _onCardTap(int index) {
    if (_waiting || _matched[index] || _revealed[index]) return;

    setState(() => _revealed[index] = true);

    if (_firstSelected == null) {
      _firstSelected = index;
      return;
    }

    _moves++;
    int first = _firstSelected!;
    if (_cards[first] == _cards[index]) {
      setState(() {
        _matched[first] = true;
        _matched[index] = true;
        _matches++;
        _firstSelected = null;
      });
      if (_matches == _currentPairs) {
        if (_bestScore == 0 || _moves < _bestScore) {
          _bestScore = _moves;
          _scoreBox.put('memory_best_score', _bestScore);
        }
        _showWinDialog();
      }
    } else {
      _waiting = true;
      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) {
          setState(() {
            _revealed[first] = false;
            _revealed[index] = false;
            _firstSelected = null;
            _waiting = false;
          });
        }
      });
    }
  }

  void _showWinDialog() {
    final lang = ref.read(languageProvider.notifier);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Icon(Icons.stars, size: 60, color: Colors.amber),
        content: Text(lang.translate('mem_win'), textAlign: TextAlign.center),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() => _gameStarted = false);
              },
              child: Text(lang.translate('play')),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.read(languageProvider.notifier);
    final themeColor = ref.watch(themeColorProvider);
    ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.translate('mem')),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
      ),
      body: _loadingImages 
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16),
            child: _gameStarted ? _buildGrid(lang, themeColor) : _buildSetup(lang, themeColor),
          ),
    );
  }

  Widget _buildSetup(LanguageNotifier lang, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        Text(lang.translate('mem_pairs'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        if (_imagePaths.isEmpty)
          Card(
            color: Colors.red[50],
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('⚠️ Nenhuma imagem encontrada em assets/images/memory/!\n\n1. Cole suas fotos na pasta.\n2. Clique em "Pub Get" no topo do Android Studio.\n3. Reinicie o App totalmente.', 
                textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          )
        else
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [4, 8, 12, 20, 30].map((p) => ChoiceChip(
              label: Text(p.toString()),
              selected: _currentPairs == p,
              onSelected: (s) => setState(() => _currentPairs = p),
              selectedColor: color.withOpacity(0.3),
            )).toList(),
          ),
        const Spacer(),
        ElevatedButton(
          onPressed: _imagePaths.isEmpty ? null : () => _startNewGame(_currentPairs),
          style: ElevatedButton.styleFrom(
            backgroundColor: color, 
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          child: Text(lang.translate('play'), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildGrid(LanguageNotifier lang, Color color) {
    int crossAxisCount = _currentPairs <= 8 ? 4 : (_currentPairs <= 20 ? 5 : 6);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${lang.translate('score')}: $_moves', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('${lang.translate('high_score')}: $_bestScore', style: const TextStyle(fontSize: 18, color: Colors.blue)),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: GridView.builder(
            itemCount: _cards.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount, 
              crossAxisSpacing: 8, mainAxisSpacing: 8),
            itemBuilder: (ctx, i) {
              bool isUp = _revealed[i] || _matched[i];
              return GestureDetector(
                onTap: () => _onCardTap(i),
                child: Container(
                  decoration: BoxDecoration(
                    color: isUp ? Colors.white : color,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withOpacity(0.2)),
                    boxShadow: [if(!isUp) const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                  ),
                  child: isUp 
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(_imagePaths[_cards[i]], fit: BoxFit.cover))
                    : const Center(child: Icon(Icons.help_outline, color: Colors.white, size: 30)),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => setState(() => _gameStarted = false),
          child: Text(lang.translate('back'))
        ),
      ],
    );
  }
}
