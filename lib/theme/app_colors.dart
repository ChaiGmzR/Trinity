import 'package:flutter/material.dart';

/// Paleta de colores de Trinity Gym basada en psicología del fitness.
///
/// - Naranja energético: activación, acción, motivación.
/// - Cyan eléctrico: frescura, progreso, flow.
/// - Dorado: logro, confianza, victoria.
/// - Rojo profundo: intensidad, potencia, desafío.
class AppColors {
  const AppColors._();

  // ── Primarios ──────────────────────────────────────────────
  static const Color orange = Color(0xFFFF6B35);
  static const Color orangeLight = Color(0xFFFF8F5E);
  static const Color orangeDark = Color(0xFFCC4A1A);

  static const Color cyan = Color(0xFF00E5FF);
  static const Color cyanLight = Color(0xFF6EFFFF);
  static const Color cyanDark = Color(0xFF00B2CC);

  static const Color gold = Color(0xFFFFD600);
  static const Color goldLight = Color(0xFFFFE54C);
  static const Color goldDark = Color(0xFFC7A600);

  // ── Fondos ──────────────────────────────────────────────────
  static const Color bgDeep = Color(0xFF0A0E14);
  static const Color bgCard = Color(0xFF141B24);
  static const Color bgCardLight = Color(0xFF1A2332);
  static const Color bgElevated = Color(0xFF1E2A38);
  static const Color bgSurface = Color(0xFF243040);

  // ── Texto ──────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF1F3F5);
  static const Color textSecondary = Color(0xFFAAB4C0);
  static const Color textMuted = Color(0xFF6B7888);

  // ── Bordes y divisores ─────────────────────────────────────
  static const Color border = Color(0xFF2A3545);
  static const Color borderLight = Color(0xFF3A4A5C);
  static const Color divider = Color(0xFF1E2832);

  // ── Semánticos ─────────────────────────────────────────────
  static const Color success = Color(0xFF4ADE80);
  static const Color error = Color(0xFFFF5252);
  static const Color warning = Color(0xFFFFB74D);

  // ── Gradientes ─────────────────────────────────────────────
  static const LinearGradient gradientOrangeCyan = LinearGradient(
    colors: [orange, cyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient gradientOrange = LinearGradient(
    colors: [orangeDark, orange, orangeLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient gradientCyan = LinearGradient(
    colors: [cyanDark, cyan, cyanLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient gradientDarkOverlay = LinearGradient(
    colors: [Color(0xCC0A0E14), Color(0x660A0E14), Color(0x000A0E14)],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  static const LinearGradient gradientDarkFull = LinearGradient(
    colors: [Color(0xEE0A0E14), Color(0xAA0A0E14)],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  static const LinearGradient gradientCard = LinearGradient(
    colors: [Color(0xFF141B24), Color(0xFF1A2332)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Glassmorphism ──────────────────────────────────────────
  static Color glassWhite = Colors.white.withValues(alpha: 0.06);
  static Color glassBorder = Colors.white.withValues(alpha: 0.10);
  static Color glassShadow = Colors.black.withValues(alpha: 0.25);
}
