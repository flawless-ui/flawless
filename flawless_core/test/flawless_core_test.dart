import 'package:flawless_core/flawless_core.dart';
import 'package:test/test.dart';

class ExampleColorScheme implements FlawlessColorScheme {
  @override
  String get primary => '#6200EE';
  @override
  String get secondary => '#03DAC6';
  @override
  String get background => '#FFFFFF';
  @override
  String get surface => '#F5F5F5';
  @override
  String get error => '#B00020';
  @override
  String get onPrimary => '#FFFFFF';
  @override
  String get onSecondary => '#000000';
  @override
  String get onBackground => '#000000';
  @override
  String get onSurface => '#000000';
  @override
  String get onError => '#FFFFFF';
}

class ExampleTypography implements FlawlessTypography {
  @override
  FlawlessTextStyle get displayLarge => ExampleTextStyle();
  @override
  FlawlessTextStyle get displayMedium => ExampleTextStyle();
  @override
  FlawlessTextStyle get displaySmall => ExampleTextStyle();
  @override
  FlawlessTextStyle get headlineLarge => ExampleTextStyle();
  @override
  FlawlessTextStyle get headlineMedium => ExampleTextStyle();
  @override
  FlawlessTextStyle get headlineSmall => ExampleTextStyle();
  @override
  FlawlessTextStyle get bodyLarge => ExampleTextStyle();
  @override
  FlawlessTextStyle get bodyMedium => ExampleTextStyle();
  @override
  FlawlessTextStyle get bodySmall => ExampleTextStyle();
}

class ExampleTextStyle implements FlawlessTextStyle {
  @override
  String get fontFamily => 'Roboto';
  @override
  double get fontSize => 16.0;
  @override
  double get letterSpacing => 0.5;
  @override
  double get height => 1.2;
  @override
  String get fontWeight => 'normal';
}

class ExampleComponentProperties implements FlawlessComponentProperties {
  @override
  Map<String, dynamic> get properties =>
      {'borderRadius': 8.0, 'elevation': 2.0};
}

class ExampleDesignSystem implements FlawlessDesignSystem {
  @override
  FlawlessColorScheme get colorScheme => ExampleColorScheme();
  @override
  FlawlessTypography get typography => ExampleTypography();
  @override
  Map<String, FlawlessComponentProperties> get componentProperties => {
        'button': ExampleComponentProperties(),
        'card': ExampleComponentProperties(),
      };
  @override
  FlawlessSpacing get spacing => _ExampleSpacing();
  @override
  FlawlessMotion get motion => _ExampleMotion();
}

class _ExampleSpacing implements FlawlessSpacing {
  @override
  double get xxs => 4;
  @override
  double get xs => 8;
  @override
  double get sm => 12;
  @override
  double get md => 16;
  @override
  double get lg => 24;
  @override
  double get xl => 32;
  @override
  double get xxl => 40;
}

class _ExampleMotion implements FlawlessMotion {
  @override
  Duration get fast => const Duration(milliseconds: 150);
  @override
  Duration get normal => const Duration(milliseconds: 250);
  @override
  Duration get slow => const Duration(milliseconds: 350);
  @override
  String get easingStandard => 'standard';
  @override
  String get easingDecelerate => 'decelerate';
  @override
  String get easingAccelerate => 'accelerate';
}

void main() {
  group('FlawlessDesignSystem', () {
    final designSystem = ExampleDesignSystem();

    test('Primary color is correct', () {
      expect(designSystem.colorScheme.primary, equals('#6200EE'));
    });

    test('Button border radius is correct', () {
      expect(
          designSystem
              .componentProperties['button']?.properties['borderRadius'],
          equals(8.0));
    });
  });

  group('FlawlessComponentPropertiesReader', () {
    test('prefers active values over defaults', () {
      const reader = FlawlessComponentPropertiesReader(
        defaults: {'borderRadius': 8.0, 'enabled': true, 'label': 'Default'},
        active: {'borderRadius': 12.0, 'label': 'Active'},
      );

      expect(reader.doubleValue('borderRadius'), 12.0);
      expect(reader.boolValue('enabled'), true);
      expect(reader.stringValue('label'), 'Active');
    });

    test('mergedMap merges defaults and active maps', () {
      const reader = FlawlessComponentPropertiesReader(
        defaults: {
          'padding': {'h': 12.0, 'v': 8.0, 'x': 1.0},
        },
        active: {
          'padding': {'h': 16.0},
        },
      );

      final merged = reader.mergedMap('padding');
      expect(merged['h'], 16.0);
      expect(merged['v'], 8.0);
      expect(merged['x'], 1.0);
    });

    test('throws a StateError when a typed getter cannot resolve', () {
      const reader = FlawlessComponentPropertiesReader(
        defaults: {'borderRadius': 'not-a-number'},
      );

      expect(
          () => reader.doubleValue('borderRadius'), throwsA(isA<StateError>()));
    });
  });

  group('Component enums', () {
    test('enums have stable index ordering (smoke)', () {
      expect(FlawlessButtonSize.values, [
        FlawlessButtonSize.sm,
        FlawlessButtonSize.md,
        FlawlessButtonSize.lg,
      ]);

      expect(FlawlessCardPadding.values, [
        FlawlessCardPadding.none,
        FlawlessCardPadding.sm,
        FlawlessCardPadding.md,
        FlawlessCardPadding.lg,
      ]);
    });
  });
}
