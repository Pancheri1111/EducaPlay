import 'package:flutter/material.dart';

/// Cores do tema EducaPlay
class AppColors {
  // Cores primárias
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color secondary = Color(0xFFEC4899); // Rosa/Pink
  static const Color tertiary = Color(0xFF10B981); // Verde
  
  // Cores de fundo
  static const Color background = Color(0xFFFEF3C7); // Bege suave
  static const Color accentBackground = Color(0xFFFEF2F2); // Rosa suave
  
  // Cores de texto
  static const Color textPrimary = Color(0xFF1F2937); // Escuro
  static const Color textSecondary = Color(0xFF6B7280); // Cinza
  static const Color textTertiary = Color(0xFF9CA3AF); // Cinza claro
  
  // Cores de status
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF0EA5E9);
}

/// Paleta de cores para mini-games
class GameColors {
  static const Color memory = Color(0xFF6366F1);
  static const Color logic = Color(0xFFEC4899);
  static const Color math = Color(0xFF10B981);
  static const Color words = Color(0xFFF59E0B);
}

/// Padding e espaçamentos padrão
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

/// Raios de borda padrão
class AppBorderRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double circle = 50.0;
}

/// Tamanhos de fonte
class AppFontSizes {
  static const double xs = 10.0;
  static const double sm = 12.0;
  static const double md = 14.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
}

/// URLs e constantes de API
class AppConstants {
  // YouTube API
  static const String youtubeApiKey = 'YOUR_YOUTUBE_API_KEY_HERE';
  static const String youtubeApiBaseUrl = 'https://www.googleapis.com/youtube/v3';
  
  // ElevenLabs TTS API
  static const String elevenLabsApiKey = 'YOUR_ELEVENLABS_API_KEY_HERE';
  static const String elevenLabsBaseUrl = 'https://api.elevenlabs.io/v1';
  
  // Números de tentativas e timeouts
  static const int maxRetries = 3;
  static const Duration requestTimeout = Duration(seconds: 30);
  
  // Gamificação
  static const int pointsPerCorrectAnswer = 10;
  static const int starsPerLevel = 3;
  static const int totalLevels = 5;
}

/// Duração padrão de animações
class AnimationDurations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);
}
