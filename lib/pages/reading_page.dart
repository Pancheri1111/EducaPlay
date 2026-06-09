import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:file_picker/file_picker.dart';
import '../data/settings_provider.dart';

class ReadingPage extends ConsumerStatefulWidget {
  const ReadingPage({super.key});

  @override
  ConsumerState<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends ConsumerState<ReadingPage> {
  late Box _storyBox;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _storyBox = Hive.box('settings');
    _loadDefaultStories();
  }

  void _loadDefaultStories() {
    if (_storyBox.get('stories') == null) {
      _storyBox.put('stories', [
        {
          'title': 'Bem-vindo ao EducaPlay', 
          'content': 'Aqui você pode ler histórias incríveis ou importar seus próprios arquivos de texto!',
        },
      ]);
    }
  }

  // FUNÇÃO DE UPLOAD PARA LIVROS (TXT, PDF, PNG, JPG)
  Future<void> _importDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt', 'pdf', 'png', 'jpg', 'jpeg'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final fileName = result.files.single.name;

      if (fileName.toLowerCase().endsWith('.txt')) {
        // Se for texto, lê o arquivo e coloca no conteúdo
        try {
          String content = await file.readAsString();
          setState(() {
            _titleController.text = fileName;
            _contentController.text = content;
          });
        } catch (e) {
          _showError("Erro ao ler o arquivo de texto.");
        }
      } else {
        // Para PDF ou Imagem, criamos um registro de importação
        setState(() {
          _titleController.text = fileName;
          _contentController.text = "Documento importado: $fileName\nLocal: ${result.files.single.path}";
        });
      }
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _addStory(LanguageNotifier lang) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Novo Livro ou Documento'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _importDocument().then((_) => _addStory(lang));
                },
                icon: const Icon(Icons.upload_file),
                label: const Text('Fazer Upload de Arquivo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[100],
                  foregroundColor: Colors.blue[900],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('ou digite manualmente:', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ),
              TextField(controller: _titleController, decoration: InputDecoration(labelText: lang.translate('title'))),
              const SizedBox(height: 12),
              TextField(controller: _contentController, decoration: InputDecoration(labelText: lang.translate('content')), maxLines: 5),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(lang.translate('cancel'))),
          ElevatedButton(
            onPressed: () {
              if (_titleController.text.isNotEmpty) {
                final stories = List.from(_storyBox.get('stories', defaultValue: []));
                stories.add({'title': _titleController.text, 'content': _contentController.text});
                _storyBox.put('stories', stories);
                _titleController.clear();
                _contentController.clear();
                Navigator.pop(context);
                setState(() {});
              }
            },
            child: Text(lang.translate('save')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List stories = _storyBox.get('stories', defaultValue: []);
    final themeColor = ref.watch(themeColorProvider);
    final lang = ref.read(languageProvider.notifier);
    ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.translate('reading')),
        backgroundColor: themeColor,
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
              leading: Icon(Icons.menu_book, color: themeColor),
              title: Text(story['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(story['content'], maxLines: 2, overflow: TextOverflow.ellipsis),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () => _showStoryDetail(story, themeColor),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addStory(lang),
        backgroundColor: themeColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showStoryDetail(Map story, Color color) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(story['title'], style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: color)),
            const Divider(height: 30),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  story['content'], 
                  style: const TextStyle(fontSize: 18, height: 1.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
