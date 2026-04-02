import 'package:flutter/material.dart';

/// Design token: every color from the stitch design system.
abstract final class AppColors {
  // ── Primary — Deep Forest Green ──────────────────────────────────────────
  static const primary = Color(0xFF154212);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFF2D5A27);
  static const onPrimaryContainer = Color(0xFF9DD090);
  static const primaryFixed = Color(0xFFBCF0AE);
  static const primaryFixedDim = Color(0xFFA1D494);
  static const onPrimaryFixed = Color(0xFF002201);
  static const onPrimaryFixedVariant = Color(0xFF23501E);
  static const inversePrimary = Color(0xFFA1D494);

  // ── Secondary — Arable Soil Brown ────────────────────────────────────────
  static const secondary = Color(0xFF805533);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFFDC39A);
  static const onSecondaryContainer = Color(0xFF794E2E);
  static const secondaryFixed = Color(0xFFFFDCC5);
  static const secondaryFixedDim = Color(0xFFF4BB92);
  static const onSecondaryFixed = Color(0xFF301400);
  static const onSecondaryFixedVariant = Color(0xFF653D1E);

  // ── Tertiary — Harvest Gold ───────────────────────────────────────────────
  static const tertiary = Color(0xFF735C00);
  static const onTertiary = Color(0xFFFFFFFF);
  static const tertiaryContainer = Color(0xFFCCA730);
  static const onTertiaryContainer = Color(0xFF4F3D00);
  static const tertiaryFixed = Color(0xFFFFE088);
  static const tertiaryFixedDim = Color(0xFFE9C349);
  static const onTertiaryFixed = Color(0xFF241A00);
  static const onTertiaryFixedVariant = Color(0xFF574500);

  // ── Error ─────────────────────────────────────────────────────────────────
  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF93000A);

  // ── Surface Hierarchy — Pristine Canvas ───────────────────────────────────
  static const background = Color(0xFFFAF9F8);
  static const onBackground = Color(0xFF1A1C1C);
  static const surface = Color(0xFFFAF9F8);
  static const onSurface = Color(0xFF1A1C1C);
  static const surfaceDim = Color(0xFFDADAD9);
  static const surfaceBright = Color(0xFFFAF9F8);
  static const surfaceVariant = Color(0xFFE3E2E1);
  static const onSurfaceVariant = Color(0xFF42493E);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF4F3F2);
  static const surfaceContainer = Color(0xFFEEEEED);
  static const surfaceContainerHigh = Color(0xFFE9E8E7);
  static const surfaceContainerHighest = Color(0xFFE3E2E1);
  static const inverseSurface = Color(0xFF2F3130);
  static const inverseOnSurface = Color(0xFFF1F0F0);

  // ── Outline ───────────────────────────────────────────────────────────────
  static const outline = Color(0xFF72796E);
  static const outlineVariant = Color(0xFFC2C9BB);

  // ── Transparency helpers ──────────────────────────────────────────────────
  /// rgba(26,28,28,0.06) — ambient card shadow
  static const shadowAmbient = Color(0x0F1A1C1C);
  /// rgba(21,66,18,0.15) — primary glow shadow
  static const shadowPrimary = Color(0x26154212);
}
