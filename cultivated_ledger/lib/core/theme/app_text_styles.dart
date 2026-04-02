import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography tokens — Manrope (headlines) + Work Sans (body/labels)
/// Loaded via google_fonts package (works on web + mobile, no local TTFs needed).
abstract final class AppTextStyles {
  // ── Manrope Display & Headlines ──────────────────────────────────────────
  static TextStyle get displayLg => GoogleFonts.manrope(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.0,
        height: 1.1,
        color: AppColors.onBackground,
      );

  static TextStyle get headlineXl => GoogleFonts.manrope(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        height: 1.1,
        color: AppColors.onBackground,
      );

  static TextStyle get headlineLg => GoogleFonts.manrope(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
        color: AppColors.onBackground,
      );

  static TextStyle get headlineMd => GoogleFonts.manrope(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: AppColors.onBackground,
      );

  static TextStyle get headlineSm => GoogleFonts.manrope(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: AppColors.onBackground,
      );

  // ── Work Sans Body ────────────────────────────────────────────────────────
  static TextStyle get bodyLg => GoogleFonts.workSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: AppColors.onSurface,
      );

  static TextStyle get bodyMd => GoogleFonts.workSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.onSurface,
      );

  // ── Work Sans Labels ──────────────────────────────────────────────────────
  static TextStyle get labelLg => GoogleFonts.workSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: AppColors.onSurface,
      );

  static TextStyle get labelMd => GoogleFonts.workSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: AppColors.onSurface,
      );

  static TextStyle get labelSm => GoogleFonts.workSans(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: AppColors.onSurfaceVariant,
      );

  static TextStyle get labelXs => GoogleFonts.workSans(
        fontSize: 9,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        color: AppColors.onSurfaceVariant,
      );
}
