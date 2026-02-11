import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Modelo simples de Score para jogos
class GameScore {
  final String gameId;
  final String gameName;
  final int points;
  final int stars;
  final DateTime timestamp;

  GameScore({
    required this.gameId,
    required this.gameName,
    required this.points,
    required this.stars,
    required this.timestamp,
  });

  GameScore copyWith({
    String? gameId,
    String? gameName,
    int? points,
    int? stars,
    DateTime? timestamp,
  }) {
    return GameScore(
      gameId: gameId ?? this.gameId,
      gameName: gameName ?? this.gameName,
      points: points ?? this.points,
      stars: stars ?? this.stars,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

/// StateNotifier para gerenciar estado de scores
class GameScoreNotifier extends StateNotifier<List<GameScore>> {
  GameScoreNotifier() : super([]);

  /// Adicionar um novo score
  void addScore(GameScore score) {
    state = [...state, score];
  }

  /// Obter pontuação total
  int getTotalPoints() {
    return state.isEmpty
        ? 0
        : state.fold<int>(0, (total, score) => total + score.points);
  }

  /// Obter total de estrelas
  int getTotalStars() {
    return state.isEmpty
        ? 0
        : state.fold<int>(0, (total, score) => total + score.stars);
  }

  /// Limpar todos os scores (reset)
  void clearScores() {
    state = [];
  }

  /// Obter scores de um jogo específico
  List<GameScore> getScoresForGame(String gameId) {
    return state.where((score) => score.gameId == gameId).toList();
  }
}

/// Provider do Notifier de Scores
final gameScoreProvider =
    StateNotifierProvider<GameScoreNotifier, List<GameScore>>((ref) {
  return GameScoreNotifier();
});

/// Provider do total de pontos (computed)
final totalPointsProvider = Provider<int>((ref) {
  final scores = ref.watch(gameScoreProvider);
  return scores.fold<int>(0, (total, score) => total + score.points);
});

/// Provider do total de estrelas (computed)
final totalStarsProvider = Provider<int>((ref) {
  final scores = ref.watch(gameScoreProvider);
  return scores.fold<int>(0, (total, score) => total + score.stars);
});

/// Provider de nível atual baseado em pontos
final currentLevelProvider = Provider<int>((ref) {
  final totalPoints = ref.watch(totalPointsProvider);
  // Cada nível requer 100 pontos
  return (totalPoints ~/ 100) + 1;
});

/// Exemplo de uso em um widget:
/// 
/// ```dart
/// class ScoreboardWidget extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final totalPoints = ref.watch(totalPointsProvider);
///     final totalStars = ref.watch(totalStarsProvider);
///     final currentLevel = ref.watch(currentLevelProvider);
///     
///     return Column(
///       children: [
///         Text('Pontos: $totalPoints'),
///         Text('Estrelas: $totalStars'),
///         Text('Nível: $currentLevel'),
///       ],
///     );
///   }
/// }
/// 
/// // Para adicionar um score:
/// ref.read(gameScoreProvider.notifier).addScore(
///   GameScore(
///     gameId: 'memory_1',
///     gameName: 'Memória',
///     points: 50,
///     stars: 2,
///     timestamp: DateTime.now(),
///   ),
/// );
/// ```
