import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

/// Configuração centralizada de tema
class AppTheme {
  /// Tema claro (padrão para EducaPlay)
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
        background: AppColors.background,
      ),
      
      // Tipografia
      textTheme: _buildTextTheme(),
      
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: AppFontSizes.xxl,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      
      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          ),
          elevation: 8,
          textStyle: GoogleFonts.poppins(
            fontSize: AppFontSizes.lg,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // FloatingActionButton
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
        ),
      ),
      
      // BottomNavigationBar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        elevation: 12,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: AppFontSizes.sm,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: AppFontSizes.sm,
        ),
      ),
      
      // Card
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        ),
      ),
      
      // InputDecoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        hintStyle: GoogleFonts.poppins(
          color: AppColors.textTertiary,
        ),
        labelStyle: GoogleFonts.poppins(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
      ),
      
      // Scaffold
      scaffoldBackgroundColor: AppColors.background,
      
      // Divider
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade200,
        thickness: 1,
        space: AppSpacing.md,
      ),
    );
  }

  /// Construir tema de texto com Poppins
  static TextTheme _buildTextTheme() {
    return GoogleFonts.poppinsTextTheme(
      ThemeData.light().textTheme,
    ).copyWith(
      displayLarge: GoogleFonts.poppins(
        fontSize: AppFontSizes.xxxl,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: AppFontSizes.xxl,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: AppFontSizes.xl,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: AppFontSizes.lg,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: AppFontSizes.lg,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: AppFontSizes.md,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: AppFontSizes.sm,
        fontWeight: FontWeight.normal,
        color: AppColors.textTertiary,
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: AppFontSizes.md,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}
