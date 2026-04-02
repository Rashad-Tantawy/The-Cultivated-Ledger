import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.surface,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        shadow: AppColors.shadowAmbient,
        inverseSurface: AppColors.inverseSurface,
        onInverseSurface: AppColors.inverseOnSurface,
        inversePrimary: AppColors.inversePrimary,
      ),
      // Input decoration defaults — ghost border rule
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerLowest,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.20),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.20),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        hintStyle: GoogleFonts.workSans(
          color: AppColors.outline,
          fontSize: 14,
        ),
        labelStyle: GoogleFonts.workSans(
          color: AppColors.onSurfaceVariant,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      // Text theme — set global defaults
      textTheme: GoogleFonts.workSansTextTheme().copyWith(
        displayLarge: GoogleFonts.manrope(fontWeight: FontWeight.w800),
        displayMedium: GoogleFonts.manrope(fontWeight: FontWeight.w800),
        displaySmall: GoogleFonts.manrope(fontWeight: FontWeight.w700),
        headlineLarge: GoogleFonts.manrope(fontWeight: FontWeight.w700),
        headlineMedium: GoogleFonts.manrope(fontWeight: FontWeight.w700),
        headlineSmall: GoogleFonts.manrope(fontWeight: FontWeight.w700),
        titleLarge: GoogleFonts.manrope(fontWeight: FontWeight.w700),
      ),
      // Status bar
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
    );
  }
}

/// Shared shadow constants from the design system.
abstract final class AppShadows {
  static const ambientCard = [
    BoxShadow(
      offset: Offset(0, 12),
      blurRadius: 32,
      color: AppColors.shadowAmbient,
    ),
  ];

  static const primaryGlow = [
    BoxShadow(
      offset: Offset(0, 12),
      blurRadius: 32,
      color: AppColors.shadowPrimary,
    ),
  ];
}

/// Shared gradients from the stitch design system.
abstract final class AppGradients {
  static const primaryButton = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary, AppColors.primaryContainer],
  );
}
