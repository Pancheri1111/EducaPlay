# 🚀 Guia Prático de Implementação - EducaPlay

Bem-vindo! Este guia passo a passo ajudará você a continuar desenvolvendo os módulos baseado na arquitetura já estabelecida.

---

## ✨ O Que Já Foi Feito

✅ Estrutura de pastas seguindo **Clean Architecture**  
✅ `pubspec.yaml` com todas as dependências necessárias  
✅ Tema global (cores, tipografia, componentes)  
✅ Navegação com `BottomNavigationBar` e Riverpod  
✅ 3 páginas base para cada módulo  
✅ Exemplo de Entity (Story)  
✅ Exemplo de Provider (GameScore)  
✅ Exemplo de DataSource com Dio  

---

## 🔧 Próximos Passos por Prioridade

### 1️⃣ **Instalação e Setup Inicial**

```bash
# Navegar até a pasta do projeto
cd c:\Users\adrif\Documents\flutter_application_1

# Instalar dependências
flutter pub get

# Gerar código Hive (para persistência)
flutter pub run build_runner build

# Executar o app
flutter run
```

Se encontrar erros, execute:
```bash
flutter clean
flutter pub get
```

---

### 2️⃣ **Implementação do Módulo de Leitura Interativa** 📖

#### Passo 1: Criar o Model de Story

**Arquivo**: `lib/features/reading/data/models/story_model.dart`

```dart
import '../../domain/entities/story_entity.dart';

class StoryModel extends Story {
  StoryModel({
    required String id,
    required String title,
    required String description,
    required String content,
    required String author,
    required String coverImageUrl,
    required int ageMin,
    required int ageMax,
    required Duration duration,
    required double rating,
    required int readCount,
    required DateTime createdAt,
    required bool isFavorite,
  }) : super(
    id: id,
    title: title,
    description: description,
    content: content,
    author: author,
    coverImageUrl: coverImageUrl,
    ageMin: ageMin,
    ageMax: ageMax,
    duration: duration,
    rating: rating,
    readCount: readCount,
    createdAt: createdAt,
    isFavorite: isFavorite,
  );

  // Converter de JSON (para API ou Hive)
  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      author: json['author'] ?? '',
      coverImageUrl: json['coverImageUrl'] ?? '',
      ageMin: json['ageMin'] ?? 0,
      ageMax: json['ageMax'] ?? 0,
      duration: Duration(seconds: json['durationSeconds'] ?? 0),
      rating: (json['rating'] ?? 0).toDouble(),
      readCount: json['readCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  // Converter para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'author': author,
      'coverImageUrl': coverImageUrl,
      'ageMin': ageMin,
      'ageMax': ageMax,
      'durationSeconds': duration.inSeconds,
      'rating': rating,
      'readCount': readCount,
      'createdAt': createdAt.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }
}
```

#### Passo 2: Criar Local Data Source com Hive

**Arquivo**: `lib/features/reading/data/datasources/local_story_data_source.dart`

```dart
import 'package:hive_flutter/hive_flutter.dart';
import '../models/story_model.dart';

abstract class LocalStoryDataSource {
  Future<List<StoryModel>> getCachedStories();
  Future<void> cacheStories(List<StoryModel> stories);
  Future<StoryModel?> getStoryById(String id);
  Future<void> toggleFavorite(String storyId);
  Future<List<StoryModel>> getFavoriteStories();
}

class LocalStoryDataSourceImpl implements LocalStoryDataSource {
  static const String boxName = 'stories';
  late Box<Map> _storiesBox;

  Future<void> init() async {
    _storiesBox = await Hive.openBox<Map>(boxName);
  }

  @override
  Future<List<StoryModel>> getCachedStories() async {
    try {
      final List<StoryModel> stories = [];
      for (var value in _storiesBox.values) {
        stories.add(StoryModel.fromJson(Map<String, dynamic>.from(value)));
      }
      return stories;
    } catch (e) {
      print('Erro ao carregar histórias: $e');
      return [];
    }
  }

  @override
  Future<void> cacheStories(List<StoryModel> stories) async {
    try {
      await _storiesBox.clear();
      for (var story in stories) {
        await _storiesBox.put(story.id, story.toJson());
      }
    } catch (e) {
      print('Erro ao cachear histórias: $e');
    }
  }

  @override
  Future<StoryModel?> getStoryById(String id) async {
    try {
      final data = _storiesBox.get(id);
      if (data != null) {
        return StoryModel.fromJson(Map<String, dynamic>.from(data));
      }
      return null;
    } catch (e) {
      print('Erro ao buscar história: $e');
      return null;
    }
  }

  @override
  Future<void> toggleFavorite(String storyId) async {
    try {
      final data = _storiesBox.get(storyId);
      if (data != null) {
        final story = StoryModel.fromJson(Map<String, dynamic>.from(data));
        final updated = story.copyWith(isFavorite: !story.isFavorite);
        await _storiesBox.put(storyId, updated.toJson());
      }
    } catch (e) {
      print('Erro ao favoritar história: $e');
    }
  }

  @override
  Future<List<StoryModel>> getFavoriteStories() async {
    try {
      final stories = await getCachedStories();
      return stories.where((story) => story.isFavorite).toList();
    } catch (e) {
      print('Erro ao buscar favoritos: $e');
      return [];
    }
  }
}
```

#### Passo 3: Criar Repository (Contrato + Implementação)

**Arquivo**: `lib/features/reading/domain/repositories/story_repository.dart`

```dart
import '../entities/story_entity.dart';

abstract class StoryRepository {
  Future<List<Story>> getStories();
  Future<Story?> getStoryById(String id);
  Future<List<Story>> searchStories(String query);
  Future<void> toggleFavorite(String storyId);
  Future<List<Story>> getFavoriteStories();
}
```

**Arquivo**: `lib/features/reading/data/repositories/story_repository_impl.dart`

```dart
import 'package:dartz/dartz.dart'; // Para Either (tratamento de erros)
import '../../domain/entities/story_entity.dart';
import '../../domain/repositories/story_repository.dart';
import '../datasources/local_story_data_source.dart';
import '../datasources/remote_story_data_source.dart';
import '../models/story_model.dart';

class StoryRepositoryImpl implements StoryRepository {
  final RemoteStoryDataSource remoteDataSource;
  final LocalStoryDataSource localDataSource;

  StoryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Story>> getStories() async {
    try {
      // Tentar carregar do remoto primeiro
      final remoteStories = await remoteDataSource.fetchStories();
      final stories = remoteStories
          .map((json) => StoryModel.fromJson(json))
          .toList();
      
      // Cachear localmente
      await localDataSource.cacheStories(stories);
      
      return stories;
    } catch (e) {
      // Se falhar, usar cache local
      return await localDataSource.getCachedStories();
    }
  }

  @override
  Future<Story?> getStoryById(String id) async {
    try {
      final remoteStory = await remoteDataSource.fetchStoryById(id);
      return StoryModel.fromJson(remoteStory);
    } catch (e) {
      return await localDataSource.getStoryById(id);
    }
  }

  @override
  Future<List<Story>> searchStories(String query) async {
    try {
      final results = await remoteDataSource.searchStories(query);
      return results.map((json) => StoryModel.fromJson(json)).toList();
    } catch (e) {
      // Busca local como fallback
      final allStories = await localDataSource.getCachedStories();
      return allStories
          .where((story) =>
              story.title.toLowerCase().contains(query.toLowerCase()) ||
              story.author.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  @override
  Future<void> toggleFavorite(String storyId) async {
    await localDataSource.toggleFavorite(storyId);
  }

  @override
  Future<List<Story>> getFavoriteStories() async {
    return await localDataSource.getFavoriteStories();
  }
}
```

> **Nota**: Adicione `dartz: ^0.10.1` ao pubspec.yaml para usar Either (tratamento de erros funcional)

#### Passo 4: Criar Use Cases

**Arquivo**: `lib/features/reading/domain/usecases/get_all_stories_usecase.dart`

```dart
import '../entities/story_entity.dart';
import '../repositories/story_repository.dart';

class GetAllStoriesUseCase {
  final StoryRepository repository;

  GetAllStoriesUseCase({required this.repository});

  Future<List<Story>> call() async {
    return await repository.getStories();
  }
}
```

---

### 3️⃣ **Implementação do Módulo de Jogos** 🎮

#### Estrutura Similar a Leitura

1. Criar `GameModel` em `data/models/`
2. Criar `LocalGameDataSource` em `data/datasources/`
3. Criar `GameRepository` em `domain/repositories/`
4. Implementar `GameRepositoryImpl`
5. Criar use cases em `domain/usecases/`

**Exemplo rápido**:

```dart
// Entity
class Game {
  final String id;
  final String name;
  final String description;
  final int level;
  final Duration duration;
  // ... outros campos
}

// Provider Riverpod
final currentGameProvider = StateProvider<Game?>((ref) => null);
final gameScoresProvider = StateNotifierProvider<...>(...);
```

---

### 4️⃣ **Implementação do Módulo de Música** 🎵

#### Integração YouTube Player

**Instalar**:
```bash
flutter pub add youtube_player_flutter
```

**Uso básico**:

```dart
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MusicPlayerPage extends StatefulWidget {
  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'dQw4w9WgXcQ', // Video ID
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.blueAccent,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

---

## 🎨 Padrões de Código

### Consumer Widget com Riverpod

```dart
class MyConsumerWidget extends ConsumerWidget {
  const MyConsumerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stories = ref.watch(storiesProvider);

    return stories.when(
      data: (data) => ListView(...),
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('Erro: $err'),
    );
  }
}
```

### AsyncValue pattern

```dart
ref.watch(storiesProvider).whenData((stories) {
  // Usar stories
});
```

---

## 📚 Recursos Úteis

| Recurso | Link |
|---------|------|
| Flutter Docs | https://flutter.dev/docs |
| Riverpod Docs | https://riverpod.dev |
| Clean Architecture | https://resocoder.com/clean-architecture |
| Dio HTTP | https://pub.dev/packages/dio |
| Hive Database | https://pub.dev/packages/hive |
| YouTube Player | https://pub.dev/packages/youtube_player_flutter |

---

## 🐛 Troubleshooting

### Erro: "RemoteStoryDataSource não encontrado"
- Certifique-se de que o arquivo está em `lib/features/reading/data/datasources/`
- Importe corretamente: `import 'datasources/remote_story_data_source.dart';`

### Erro: "Hive box não inicializado"
- Chame `await localDataSource.init();` antes de usar
- Adicione no main: `await Hive.initFlutter();`

### Erro: "Widget não encontra Provider"
- Envolva na árvore de widgets com `ProviderScope`
- Use `ConsumerWidget` ou `ConsumerStatefulWidget`

---

## 🚀 Deploy & Build

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

---

## 📋 Checklist de Conclusão

- [ ] Modulo Leitura implementado completo
- [ ] Modulo Jogos implementado completo
- [ ] Modulo Música implementado completo
- [ ] Testes unitários escritos
- [ ] Testes de integração passando
- [ ] App compilado sem erros
- [ ] Build APK/IPA funcionando
- [ ] Publicado nas stores

---

**Boa sorte! Qualquer dúvida, consulte a documentação ou o README_EDUCAPLAY.md** 🚀
