# EducaPlay 🎓📱

**Um aplicativo educativo infantil focado em alfabetização e desenvolvimento cognitivo**

---

## 📋 Visão Geral do Projeto

EducaPlay é um app mobile desenvolvido em **Flutter** seguindo **Clean Architecture**, oferecendo:

✅ **Leitura Interativa** - Histórias com narração TTS e karaokê  
✅ **Jogos Educativos** - Mini-games de lógica, memória e matemática  
✅ **Música Infantil Segura** - Player de conteúdo seguro do YouTube  

---

## 📁 Estrutura de Pastas

```
lib/
├── main.dart                          # Entrada do app, configuração de tema
├── core/                              # Lógica compartilhada e configurações
│   ├── constants/
│   │   └── app_constants.dart        # Cores, espaçamentos, API keys
│   ├── theme/                        # Temas e estilos (será expandido)
│   └── di/                           # Injeção de dependência (será expandido)
├── features/                         # Módulos da aplicação
│   ├── reading/                      # Módulo de Leitura Interativa
│   │   ├── data/
│   │   │   ├── datasources/          # APIs, bases de dados
│   │   │   ├── models/               # Modelos de dados
│   │   │   └── repositories/         # Implementação de repositórios
│   │   ├── domain/
│   │   │   ├── entities/             # Entidades (camada pura)
│   │   │   ├── repositories/         # Contratos de repositório (interfaces)
│   │   │   └── usecases/             # Casos de uso
│   │   └── presentation/
│   │       ├── pages/                # Telas
│   │       ├── widgets/              # Widgets reutilizáveis
│   │       ├── providers/            # Riverpod providers
│   │       └── state/                # Gerenciamento de estado
│   ├── games/                        # Módulo de Jogos Educativos
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── music/                        # Módulo de Música
│       ├── data/
│       ├── domain/
│       └── presentation/
└── assets/
    ├── images/                       # Imagens e ícones
    ├── audio/                        # Arquivos de áudio locais
    ├── lottie/                       # Animações Lottie
    └── fonts/                        # Fontes customizadas (Poppins)
```

---

## 🏗️ Arquitetura: Clean Architecture

O projeto segue **Clean Architecture** com 3 camadas principais:

### 1️⃣ **Presentation Layer** 🎨
- **Pages**: Telas principais (HomePage, ReadingPage, GamesPage, MusicPage)
- **Widgets**: Componentes reutilizáveis
- **Providers**: Estados gerenciados com Riverpod
- **Responsabilidade**: UI e interação do usuário

### 2️⃣ **Domain Layer** 🎯
- **Entities**: Objetos puros (sem dependências)
- **Repositories**: Interfaces/contratos
- **Use Cases**: Lógica de negócio independente
- **Responsabilidade**: Regras de negócio

### 3️⃣ **Data Layer** 💾
- **Data Sources**: APIs remotas e bases de dados locais
- **Models**: Entidades com capacidade de serialização
- **Repositories**: Implementação das interfaces da domain
- **Responsabilidade**: Busca e persistência de dados

---

## 📦 Dependências Principais

```yaml
# Gerenciamento de Estado
riverpod: ^2.4.0          # State management reativo
flutter_riverpod: ^2.4.0  # Integração Flutter com Riverpod

# Navegação
go_router: ^13.0.0        # Roteamento tipo file-based (opcional, use se implementar)

# HTTP & Comunicação
dio: ^5.3.0              # Requisições HTTP com interceptors

# Áudio
just_audio: ^0.9.34      # Reprodução de áudio local e streaming
audio_service: ^0.18.13  # Serviço de background audio

# YouTube
youtube_player_flutter: ^8.1.2  # Integração de vídeos YouTube

# Text-to-Speech
flutter_tts: ^0.13.8     # Narração de texto em tempo real

# Animações
lottie: ^2.6.0           # Animações Lottie JSON

# Persistência
hive: ^2.2.3             # Banco de dados NoSQL local
hive_flutter: ^1.1.0     # Integração Hive no Flutter

# UI/UX
flutter_screenutil: ^5.9.0    # Design responsivo
google_fonts: ^6.1.0          # Fontes Google (Poppins)

# Utilitários
intl: ^0.19.0            # Internacionalização
uuid: ^4.0.0             # Geração de UUIDs
logger: ^2.0.0           # Logging melhorado
```

---

## 🎨 Tema Visual

### Paleta de Cores
- **Primária**: Indigo (#6366F1) - Confiante e educativo
- **Secundária**: Rosa (#EC4899) - Lúdico e divertido
- **Terciária**: Verde (#10B981) - Esperança e crescimento
- **Fundo**: Bege suave (#FEF3C7) - Confortável para os olhos

### Tipografia
- **Fonte**: Poppins (Google Fonts)
- **Pesos**: Regular (400), SemiBold (600), Bold (700)
- **Propósito**: Moderna, amigável e legível

### Componentes
- RadiusRounded: 8px a 24px (bem-vindo, não agressivo)
- Elevation: Sombras suaves para hierarquia
- Elevado Button: 32px de padding, border-radius 24px

---

## ⚙️ Como Começar

### 1. Instalar Dependências
```bash
flutter pub get
# Gerar código Hive
flutter pub run build_runner build
```

### 2. Configurar APIs (Opcional)
Editar `lib/core/constants/app_constants.dart`:
```dart
static const String youtubeApiKey = 'SUA_CHAVE_AQUI';
static const String elevenLabsApiKey = 'SUA_CHAVE_AQUI';
```

### 3. Executar o App
```bash
flutter run
```

---

## 🚀 Roadmap (Próximos Passos)

### Phase 1: Estrutura Base ✅
- ✅ Estrutura de pastas (Clean Architecture)
- ✅ Tema customizado
- ✅ BottomNavigationBar com 3 módulos
- ✅ Páginas vazias para cada módulo

### Phase 2: Módulo de Leitura
- [ ] Integração flutter_tts
- [ ] CRUD de histórias (Hive)
- [ ] Karaokê com highlight de palavras
- [ ] API integração (ElevenLabs ou Google TTS)

### Phase 3: Módulo de Jogos
- [ ] Implementar 4 mini-games
- [ ] Sistema de pontuação
- [ ] Desbloqueio de fases
- [ ] Animações Lottie

### Phase 4: Módulo de Música
- [ ] Integração YouTube Player
- [ ] Busca segura de conteúdo
- [ ] Playlists locais
- [ ] Sincronização com Hive

### Phase 5: Polish & Publicação
- [ ] Testes unitários
- [ ] Tests de integração
- [ ] Build Android e iOS
- [ ] Publicação nas stores

---

## 📱 Funcionalidades Detalhadas

### 📖 Módulo de Leitura Interativa

**Objetivo**: Facilitar a leitura e aprendizagem através de narração natural.

**Features**:
- Histórias armazenadas localmente (Hive) e remotas
- Narração automática com flutter_tts
- Destaque de palavras em sincronia com áudio (karaokê)
- Controles de velocidade de leitura
- Histórias favoritadas

**Arquitetura**:
```
domain/
  - Story (Entity)
  - OpenStoryRepository (Interface)
  - ReadStoryUseCase
data/
  - StoryModel (extends Story)
  - LocalStoryDataSource (Hive)
  - ReadStoryRepositoryImpl
presentation/
  - ReadingPage
  - StoryDetailPage
  - providers/reading_provider.dart
```

---

### 🎮 Módulo de Jogos Educativos

**Objetivo**: Desenvolver competências cognitivas através de mini-games lúdicos.

**4 Mini-Games**:
1. **Memória**: Encontrar pares de imagens
2. **Lógica**: Quebra-cabeças e sequências
3. **Matemática**: Contas e raciocínio lógico
4. **Palavras**: Identificar letras e palavras

**Sistema de Gamificação**:
- Pontos por resposta correta: 10 pts
- Estrelas por nível completo: 3 ⭐
- 5 níveis de dificuldade
- Progresso persistido com Hive

**Arquitetura**:
```
domain/
  - Game (Entity)
  - Score (Entity)
  - GameRepository (Interface)
data/
  - GameModel
  - ScoreModel
  - LocalGameDataSource (Hive)
presentation/
  - GamesPage
  - GamePlayPage
  - ScoreBoard
```

---

### 🎵 Módulo de Música

**Objetivo**: Oferecer um player de música seguro para crianças.

**Features**:
- Integração YouTube Player (conteúdo seguro)
- Busca de músicas infantis
- Playlist criação e gerenciamento
- Controles simplificados (Play, Pause, Next, Prev)
- Volume controlado

**Arquitetura**:
```
domain/
  - Song (Entity)
  - Playlist (Entity)
  - MusicRepository (Interface)
data/
  - SongModel
  - PlaylistModel
  - RemoteMusicDataSource (YouTube API)
  - LocalMusicDataSource (Hive)
presentation/
  - MusicPage
  - PlayerControls
  - PlaylistWidget
```

---

## 🔧 Padrões e Boas Práticas

### State Management - Riverpod
```dart
// Exemplo de Provider
final storyProvider = StateNotifierProvider<StoryNotifier, List<Story>>((ref) {
  return StoryNotifier();
});

// Uso em Widget
final stories = ref.watch(storyProvider);
```

### Repository Pattern
```dart
// Domain - Interface
abstract class StoryRepository {
  Future<List<Story>> getStories();
}

// Data - Implementação
class StoryRepositoryImpl implements StoryRepository {
  final LocalDataSource local;
  final RemoteDataSource remote;
  
  @override
  Future<List<Story>> getStories() async {
    // Implementação com fallback
  }
}
```

### Dependency Injection (Riverpod)
```dart
final storyRepositoryProvider = Provider((ref) {
  return StoryRepositoryImpl(
    local: LocalDataSource(),
    remote: RemoteDataSource(),
  );
});
```

---

## 📝 Documentação de Arquivos

| Arquivo | Descrição |
|---------|-----------|
| `main.dart` | Entrada da aplicação, configuração de tema |
| `pubspec.yaml` | Dependências do projeto |
| `app_constants.dart` | Constantes, cores, espaçamentos |
| `home_page.dart` | Navegação principal com BottomNavigationBar |
| `reading_page.dart` | Página do módulo de Leitura |
| `games_page.dart` | Página do módulo de Jogos |
| `music_page.dart` | Página do módulo de Música |

---

## 🤝 Contribuindo

Este é um projeto educativo. Sinta-se livre para:
- Adicionar novos mini-games
- Melhorar a UI/UX
- Implementar novas histórias
- Otimizar performance
- Corrigir bugs

---

## 📜 Licença

MIT License - Use livremente para fins educacionais!

---

## 🆘 Suporte

Para dúvidas ou problemas:
1. Verifique a estrutura de pastas
2. Confirme que todas as dependências foram instaladas
3. Execute `flutter clean` e `flutter pub get`
4. Consulte a documentação oficial: flutter.dev

---

**Desenvolvido com ❤️ para crianças e educadores**
