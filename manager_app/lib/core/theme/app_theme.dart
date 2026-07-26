import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

class AppTheme {
  // A slightly deeper, richer green for primary
  static const Color primaryColor = Color(0xFF226E27);
  // A deeper shade for emphasis/headers
  static const Color primaryDark = Color(0xFF144718);
  // Soft neutral background with subtle green warmth for high card contrast
  static const Color scaffoldBackground = Color(0xFFF2F5F2);

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackground,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        titleLarge: GoogleFonts.inter(fontWeight: FontWeight.w700, letterSpacing: -0.5),
        titleMedium: GoogleFonts.inter(fontWeight: FontWeight.w600, letterSpacing: -0.3),
        bodyLarge: GoogleFonts.inter(fontWeight: FontWeight.w500),
        bodyMedium: GoogleFonts.inter(fontWeight: FontWeight.w400),
        labelLarge: GoogleFonts.inter(fontWeight: FontWeight.w600, letterSpacing: 0.5),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: scaffoldBackground,
        foregroundColor: primaryDark,
        titleTextStyle: GoogleFonts.inter(
          color: primaryDark,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppConstants.cardRadius)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shadowColor: primaryColor.withAlpha(80),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacing24,
            vertical: AppConstants.spacing16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.black.withAlpha(10),
      ),
    );
  }
}
