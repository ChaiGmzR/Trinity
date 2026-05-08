import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData dark() {
    const scheme = ColorScheme.dark(
      primary: Color(0xFFE55338),
      onPrimary: Color(0xFF1B1D22),
      secondary: Color(0xFF36D1A7),
      onSecondary: Color(0xFF101216),
      tertiary: Color(0xFFF4C430),
      surface: Color(0xFF1B1F26),
      onSurface: Color(0xFFF1F3F5),
      surfaceContainerHighest: Color(0xFF252B33),
      outline: Color(0xFF46505C),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFF101216),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Color(0xFF101216),
        foregroundColor: Color(0xFFF1F3F5),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFF2B323C)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF20252D),
        selectedColor: scheme.primary,
        disabledColor: const Color(0xFF181B20),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        secondaryLabelStyle: const TextStyle(
          color: Color(0xFF16191E),
          fontWeight: FontWeight.w700,
        ),
        side: const BorderSide(color: Color(0xFF38424E)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1B1F26),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF2B323C)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF2B323C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.secondary, width: 1.5),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF15181D),
        indicatorColor: scheme.primary,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontWeight: FontWeight.w700,
            color: states.contains(WidgetState.selected)
                ? const Color(0xFF101216)
                : const Color(0xFFCDD3DB),
          ),
        ),
      ),
    );
  }
}
