import 'package:flawless_core/flawless_core.dart';

// Example implementation of the abstract contracts
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
  final designSystem = ExampleDesignSystem();
  print('Primary color: \\${designSystem.colorScheme.primary}');
  print(
      'Button border radius: \\${designSystem.componentProperties['button']?.properties['borderRadius']}');
}
