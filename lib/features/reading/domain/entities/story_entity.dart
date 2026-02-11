/// Entidade de Domínio - Representa uma História
class Story {
  final String id;
  final String title;
  final String description;
  final String content; // Texto da história
  final String author;
  final String coverImageUrl;
  final int ageMin;
  final int ageMax;
  final Duration duration;
  final double rating;
  final int readCount;
  final DateTime createdAt;
  final bool isFavorite;

  Story({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.author,
    required this.coverImageUrl,
    required this.ageMin,
    required this.ageMax,
    required this.duration,
    required this.rating,
    required this.readCount,
    required this.createdAt,
    required this.isFavorite,
  });

  // Copiar com novos valores
  Story copyWith({
    String? id,
    String? title,
    String? description,
    String? content,
    String? author,
    String? coverImageUrl,
    int? ageMin,
    int? ageMax,
    Duration? duration,
    double? rating,
    int? readCount,
    DateTime? createdAt,
    bool? isFavorite,
  }) {
    return Story(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      author: author ?? this.author,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      ageMin: ageMin ?? this.ageMin,
      ageMax: ageMax ?? this.ageMax,
      duration: duration ?? this.duration,
      rating: rating ?? this.rating,
      readCount: readCount ?? this.readCount,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Story &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          content == other.content;

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ content.hashCode;

  @override
  String toString() => 'Story(id: $id, title: $title, author: $author)';
}
