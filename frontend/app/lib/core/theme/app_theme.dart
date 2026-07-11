import 'package:flutter/material.dart';

/// T028: WCAG 2.1 AA theming (constitution Technology & Standards) plus bar-mode
/// theme tokens (R17 — a dedicated high-contrast, large-type theme; T126 builds the
/// bar-mode UI itself on top of this). Material 3's tonal `ColorScheme.fromSeed`
/// palettes are designed to meet WCAG AA contrast for standard role pairings
/// (onSurface/surface, onPrimary/primary, etc.); the full accessibility audit
/// (automated + manual) is T138 — this establishes the tokens that audit checks.
abstract final class SpecPourTheme {
  /// Deep purple: arbitrary but fixed brand seed — every tonal color in both themes
  /// derives from this one value, so changing brand color means changing one line.
  static const Color _seedColor = Colors.deepPurple;

  /// Minimum touch target per Material's accessibility guidelines.
  static const double minTouchTarget = 48;

  /// Bar mode's oversized touch target (R17: "wet-hands operation" — large targets
  /// for imprecise/gloved/wet-fingered taps), used by T126's bar-mode UI.
  static const double barModeMinTouchTarget = 64;

  static ThemeData light() =>
      _base(colorScheme: ColorScheme.fromSeed(seedColor: _seedColor));

  static ThemeData dark() => _base(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    ),
  );

  /// High-contrast, large-type theme for hands-free/low-attention bar service
  /// (T126). Pure black/white maximizes contrast beyond AA's minimum; type scale is
  /// enlarged uniformly so a step-through recipe view is readable at arm's length.
  static ThemeData barMode() {
    const barModeScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.white,
      onPrimary: Colors.black,
      secondary: Colors.white,
      onSecondary: Colors.black,
      error: Color(0xFFFF6B6B),
      onError: Colors.black,
      surface: Colors.black,
      onSurface: Colors.white,
    );

    final base = _base(colorScheme: barModeScheme);
    return base.copyWith(
      textTheme: base.textTheme.apply(fontSizeFactor: 1.5),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(barModeMinTouchTarget, barModeMinTouchTarget),
          textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  static ThemeData _base({required ColorScheme colorScheme}) => ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(minTouchTarget, minTouchTarget),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        minimumSize: const Size(minTouchTarget, minTouchTarget),
      ),
    ),
  );
}
