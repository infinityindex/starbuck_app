import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Cached typography styles for performance optimization.
/// Styles are cached per theme mode to avoid creating new TextStyle objects on every build.
class AppTypography {
  AppTypography._();

  // Cache base Sora font to avoid repeated GoogleFonts calls
  static final _soraBase = GoogleFonts.sora();

  // Pre-cached base styles (theme-independent)
  static final _displayLargeBase = _soraBase.copyWith(fontSize: 40, fontWeight: FontWeight.w700, height: 1.1);
  static final _displayMediumBase = _soraBase.copyWith(fontSize: 32, fontWeight: FontWeight.w700, height: 1.2);
  static final _headingLargeBase = _soraBase.copyWith(fontSize: 24, fontWeight: FontWeight.w700, height: 1.3);
  static final _headingMediumBase = _soraBase.copyWith(fontSize: 20, fontWeight: FontWeight.w600, height: 1.3);
  static final _headingSmallBase = _soraBase.copyWith(fontSize: 18, fontWeight: FontWeight.w600, height: 1.4);
  static final _bodyLargeBase = _soraBase.copyWith(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5);
  static final _bodyMediumBase = _soraBase.copyWith(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5);
  static final _bodySmallBase = _soraBase.copyWith(fontSize: 12, fontWeight: FontWeight.w400, height: 1.4);
  static final _labelLargeBase = _soraBase.copyWith(fontSize: 16, fontWeight: FontWeight.w600, height: 1.2);
  static final _labelMediumBase = _soraBase.copyWith(fontSize: 14, fontWeight: FontWeight.w600, height: 1.2);
  static final _labelSmallBase = _soraBase.copyWith(fontSize: 12, fontWeight: FontWeight.w600, height: 1.2);
  static final _captionBase = _soraBase.copyWith(fontSize: 11, fontWeight: FontWeight.w400, height: 1.3);
  static final _priceBase = _soraBase.copyWith(fontSize: 18, fontWeight: FontWeight.w700, height: 1.2, color: const Color(0xFF00704A));
  static final _priceLargeBase = _soraBase.copyWith(fontSize: 24, fontWeight: FontWeight.w700, height: 1.2, color: const Color(0xFF00704A));

  // Cached themed styles
  static final Map<bool, Map<String, TextStyle>> _cache = {true: {}, false: {}};

  // Theme colors
  static const _lightTextPrimary = Color(0xFF1E3932);
  static const _lightTextSecondary = Color(0xFF6B7280);
  static const _lightTextHint = Color(0xFFADB5BD);
  static const _darkTextPrimary = Colors.white;
  static final _darkTextSecondary = Colors.white70;
  static final _darkTextHint = Colors.white54;

  static Color textPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? _darkTextPrimary : _lightTextPrimary;

  static Color textSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? _darkTextSecondary : _lightTextSecondary;

  static Color textHint(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? _darkTextHint : _lightTextHint;

  static TextStyle _getCached(BuildContext context, String key, TextStyle base, Color Function(BuildContext) colorFn) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeCache = _cache[isDark]!;
    return themeCache.putIfAbsent(key, () => base.copyWith(color: colorFn(context)));
  }

  // Context-aware styles with caching
  static TextStyle displayLarge(BuildContext context) => 
      _getCached(context, 'displayLarge', _displayLargeBase, textPrimary);

  static TextStyle displayMedium(BuildContext context) => 
      _getCached(context, 'displayMedium', _displayMediumBase, textPrimary);

  static TextStyle headingLarge(BuildContext context) => 
      _getCached(context, 'headingLarge', _headingLargeBase, textPrimary);

  static TextStyle headingMedium(BuildContext context) => 
      _getCached(context, 'headingMedium', _headingMediumBase, textPrimary);

  static TextStyle headingSmall(BuildContext context) => 
      _getCached(context, 'headingSmall', _headingSmallBase, textPrimary);

  static TextStyle bodyLarge(BuildContext context) => 
      _getCached(context, 'bodyLarge', _bodyLargeBase, textPrimary);

  static TextStyle bodyMedium(BuildContext context) => 
      _getCached(context, 'bodyMedium', _bodyMediumBase, textPrimary);

  static TextStyle bodySmall(BuildContext context) => 
      _getCached(context, 'bodySmall', _bodySmallBase, textSecondary);

  static TextStyle labelLarge(BuildContext context) => 
      _getCached(context, 'labelLarge', _labelLargeBase, textPrimary);

  static TextStyle labelMedium(BuildContext context) => 
      _getCached(context, 'labelMedium', _labelMediumBase, textPrimary);

  static TextStyle labelSmall(BuildContext context) => 
      _getCached(context, 'labelSmall', _labelSmallBase, textSecondary);

  static TextStyle caption(BuildContext context) => 
      _getCached(context, 'caption', _captionBase, textHint);

  // Price styles don't need theme color (always green)
  static TextStyle price(BuildContext context) => _priceBase;

  static TextStyle priceLarge(BuildContext context) => _priceLargeBase;
}
