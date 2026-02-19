import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ReadingPage extends ConsumerStatefulWidget {
  const ReadingPage({super.key});

  @override
  ConsumerState<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends ConsumerState<ReadingPage> {
  late FlutterTts _flutterTts;
  late Box _storyBox;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _flutterTts = FlutterTts();
    _storyBox = Hive.box('settings'); // Usando o box já aberto no main
    _initTts();
    _loadDefaultStories();
  }

  void _initTts() async {
    await _flutterTts.setLanguage("pt-BR");
    await _flutterTts.setSpeechRate(0.5);
  }

  void _loadDefaultStories() {
    if (_storyBox.get('stories') == null) {
      _storyBox.put('stories', [
        {'title': 'A Corujinha Sabida', 'content': 'Era uma vez uma corujinha que adorava ler livros mágicos.'},
        {'title': 'O Robô Amigo', 'content': 'O robô Beto gosta de ajudar as crianças a aprender matemática.'},
      ]);
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _addStory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Novo Livro'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Título')),
            TextField(controller: _contentController, decoration: const InputDecoration(labelText: 'História'), maxLines: 3),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              final stories = List.from(_storyBox.get('stories', defaultValue: []));
              stories.add({'title': _titleController.text, 'content': _contentController.text});
              _storyBox.put('stories', stories);
              _titleController.clear();
              _contentController.clear();
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List stories = _storyBox.get('stories', defaultValue: []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Livros Mágicos'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              title: Text(story['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(story['content'], maxLines: 2, overflow: TextOverflow.ellipsis),
              trailing: IconButton(
                icon: const Icon(Icons.volume_up, color: Colors.green),
                onPressed: () => _flutterTts.speak(story['content']),
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => Container(
                    padding: const EdgeInsets.all(24),
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Column(
                      children: [
                        Text(story['title'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const Divider(),
                        Expanded(child: SingleChildScrollView(child: Text(story['content'], style: const TextStyle(fontSize: 18)))),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () => _flutterTts.speak(story['content']),
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Ouvir tudo'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addStory,
        backgroundColor: Colors.green,
        child: const Icon(Icons.library_add, color: Colors.white),
      ),
    );
  }
}
