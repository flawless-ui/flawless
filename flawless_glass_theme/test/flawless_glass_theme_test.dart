import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flawless_glass_theme/flawless_glass_theme.dart';
import 'package:flawless_theme/flawless_theme.dart';

void main() {
  test(
      'createGlassTheme adds FlawlessThemeExtension with the provided design system',
      () {
    final designSystem = GlassDesignSystem();

    final theme = createGlassTheme(designSystem: designSystem);

    final ext =
        theme.extensions[FlawlessThemeExtension] as FlawlessThemeExtension?;
    expect(ext, isNotNull);
    expect(identical(ext!.designSystem, designSystem), true);
  });

  test(
      'createGlassTheme uses the design system background as scaffoldBackgroundColor',
      () {
    final designSystem = GlassDesignSystem();

    final theme = createGlassTheme(designSystem: designSystem);

    final hex = designSystem.colorScheme.background.replaceFirst('#', '');
    final intColor = int.parse('FF$hex', radix: 16);
    expect(theme.scaffoldBackgroundColor, Color(intColor));
  });
}
