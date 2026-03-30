import 'package:flutter_test/flutter_test.dart';
import 'package:flawless_material3_theme/flawless_material3_theme.dart';
import 'package:flawless_theme/flawless_theme.dart';

void main() {
  group('Material3DesignSystem', () {
    final designSystem = Material3DesignSystem();

    test('primary color is correct', () {
      expect(designSystem.colorScheme.primary, '#0B0F1A');
    });

    test('button border radius is correct', () {
      expect(
          designSystem
              .componentProperties['button']?.properties['borderRadius'],
          12.0);
    });
  });

  group('FlawlessThemeExtension', () {
    final ext1 = FlawlessThemeExtension(designSystem: Material3DesignSystem());
    final ext2 = FlawlessThemeExtension(designSystem: Material3DesignSystem());

    test('copyWith returns new instance', () {
      final ext3 = ext1.copyWith();
      expect(ext3, isA<FlawlessThemeExtension>());
    });

    test('lerp returns correct instance', () {
      expect(ext1.lerp(ext2, 0.0), ext1);
      expect(ext1.lerp(ext2, 1.0), ext2);
    });
  });
}
