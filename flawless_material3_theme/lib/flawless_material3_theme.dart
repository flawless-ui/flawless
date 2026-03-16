library;

import 'package:flutter/material.dart';
import 'package:flawless_core/flawless_core.dart';
import 'package:flawless_theme/flawless_theme.dart';
import 'material3_design_system.dart';

export 'material3_design_system.dart';

ThemeData createMaterial3Theme({
  required Material3DesignSystem designSystem,
  Brightness brightness = Brightness.light,
}) {
  final colors = designSystem.colorScheme;
  final typography = designSystem.typography;

  final colorScheme = ColorScheme(
    brightness: brightness,
    primary: _colorFromHex(colors.primary),
    onPrimary: _colorFromHex(colors.onPrimary),
    secondary: _colorFromHex(colors.secondary),
    onSecondary: _colorFromHex(colors.onSecondary),
    error: _colorFromHex(colors.error),
    onError: _colorFromHex(colors.onError),
    surface: _colorFromHex(colors.surface),
    onSurface: _colorFromHex(colors.onSurface),
  );

  final textTheme = TextTheme(
    displayLarge: _textStyleFromFlawless(typography.displayLarge),
    displayMedium: _textStyleFromFlawless(typography.displayMedium),
    displaySmall: _textStyleFromFlawless(typography.displaySmall),
    headlineLarge: _textStyleFromFlawless(typography.headlineLarge),
    headlineMedium: _textStyleFromFlawless(typography.headlineMedium),
    headlineSmall: _textStyleFromFlawless(typography.headlineSmall),
    bodyLarge: _textStyleFromFlawless(typography.bodyLarge),
    bodyMedium: _textStyleFromFlawless(typography.bodyMedium),
    bodySmall: _textStyleFromFlawless(typography.bodySmall),
  );

  return ThemeData(
    colorScheme: colorScheme,
    textTheme: textTheme,
    useMaterial3: true,
    scaffoldBackgroundColor: _colorFromHex(colors.background),
    extensions: [FlawlessThemeExtension(designSystem: designSystem)],
  );
}

Color _colorFromHex(String hex) {
  var value = hex.replaceFirst('#', '');
  if (value.length == 6) {
    value = 'FF$value';
  }
  return Color(int.parse(value, radix: 16));
}

TextStyle _textStyleFromFlawless(FlawlessTextStyle style) {
  return TextStyle(
    fontFamily: style.fontFamily,
    fontSize: style.fontSize,
    letterSpacing: style.letterSpacing,
    height: style.height,
    fontWeight: _fontWeightFromString(style.fontWeight),
  );
}

FontWeight _fontWeightFromString(String weight) {
  switch (weight) {
    case 'bold':
      return FontWeight.bold;
    case 'w100':
      return FontWeight.w100;
    case 'w200':
      return FontWeight.w200;
    case 'w300':
      return FontWeight.w300;
    case 'w400':
      return FontWeight.w400;
    case 'w500':
      return FontWeight.w500;
    case 'w600':
      return FontWeight.w600;
    case 'w700':
      return FontWeight.w700;
    case 'w800':
      return FontWeight.w800;
    case 'w900':
      return FontWeight.w900;
    default:
      return FontWeight.normal;
  }
}
