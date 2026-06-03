import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Tipografía premium de Trinity Gym.
///
/// - Outfit: headlines bold, titulares impactantes.
/// - Inter: cuerpo de texto, legibilidad máxima.
class AppTextStyles {
  const AppTextStyles._();

  // ── Headlines (Outfit) ─────────────────────────────────────
  static TextStyle heroTitle = GoogleFonts.outfit(
    fontSize: 34,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
    height: 1.1,
    letterSpacing: -0.5,
  );

  static TextStyle headline1 = GoogleFonts.outfit(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static TextStyle headline2 = GoogleFonts.outfit(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.25,
  );

  static TextStyle headline3 = GoogleFonts.outfit(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // ── Titles (Outfit) ────────────────────────────────────────
  static TextStyle titleLarge = GoogleFonts.outfit(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle titleMedium = GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle titleSmall = GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // ── Body (Inter) ───────────────────────────────────────────
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
  );

  // ── Labels ─────────────────────────────────────────────────
  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0.3,
  );

  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.textSecondary,
    letterSpacing: 0.3,
  );

  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: AppColors.textMuted,
    letterSpacing: 0.5,
  );

  // ── Motivational ───────────────────────────────────────────
  static TextStyle motivationalQuote = GoogleFonts.outfit(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.3,
    fontStyle: FontStyle.italic,
  );

  static TextStyle timerDisplay = GoogleFonts.outfit(
    fontSize: 56,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
    letterSpacing: 2,
  );

  static TextStyle counterBig = GoogleFonts.outfit(
    fontSize: 42,
    fontWeight: FontWeight.w900,
    color: AppColors.orange,
  );
}
