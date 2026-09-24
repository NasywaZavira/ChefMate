import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Palet warna ChefMate. Oranye jadi aksen utama, hijau untuk status
/// "bahan tersedia", merah untuk "bahan belum ada".
class AppColors {
  AppColors._();

  static const Color orange = Color(0xFFE8600C);
  static const Color orangeLight = Color(0xFFFCE3D1);
  static const Color ink = Color(0xFF2B1B12);
  static const Color cream = Color(0xFFFFF8F0);
  static const Color green = Color(0xFF4A7C59);
  static const Color greenLight = Color(0xFFE4EEE3);
  static const Color red = Color(0xFFC9432B);
  static const Color muted = Color(0xFF8A7A6D);
  static const Color line = Color(0xFFEFE2D3);
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.cream,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.orange,
        onPrimary: Colors.white,
        secondary: AppColors.green,
        surface: Colors.white,
        error: AppColors.red,
      ),
      textTheme: TextTheme(
        // Judul besar pakai serif (Fraunces) supaya terasa seperti buku resep.
        displayLarge: GoogleFonts.fraunces(
          fontSize: 30,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
          height: 1.25,
        ),
        headlineMedium: GoogleFonts.fraunces(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
        // Teks UI pakai sans-serif (Inter) supaya tetap fungsional dan mudah dibaca.
        bodyLarge: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.ink,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppColors.muted,
          height: 1.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orange,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          minimumSize: const Size.fromHeight(52),
          side: const BorderSide(color: AppColors.line, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.orange, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.red),
        ),
        labelStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.muted),
      ),
    );
  }
}