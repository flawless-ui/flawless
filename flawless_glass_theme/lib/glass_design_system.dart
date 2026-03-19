import 'package:flawless_core/flawless_core.dart';

/// Glass (glassmorphism) color tokens for Flawless.
class GlassColorScheme implements FlawlessColorScheme {
  @override
  String get primary => '#0B0F1A';
  @override
  String get secondary => '#6B7280';
  @override
  String get background => '#F3F4F6';
  @override
  String get surface => '#FFFFFF';
  @override
  String get error => '#EF4444';
  @override
  String get onPrimary => '#FFFFFF';
  @override
  String get onSecondary => '#001018';
  @override
  String get onBackground => '#0F172A';
  @override
  String get onSurface => '#0F172A';
  @override
  String get onError => '#FFFFFF';
}

/// Glass typography tokens for Flawless.
class GlassTypography implements FlawlessTypography {
  @override
  FlawlessTextStyle get displayLarge =>
      GlassTextStyle(fontSize: 56, fontWeight: 'bold');
  @override
  FlawlessTextStyle get displayMedium =>
      GlassTextStyle(fontSize: 44, fontWeight: 'bold');
  @override
  FlawlessTextStyle get displaySmall =>
      GlassTextStyle(fontSize: 34, fontWeight: 'bold');
  @override
  FlawlessTextStyle get headlineLarge =>
      GlassTextStyle(fontSize: 30, fontWeight: 'bold');
  @override
  FlawlessTextStyle get headlineMedium =>
      GlassTextStyle(fontSize: 26, fontWeight: 'bold');
  @override
  FlawlessTextStyle get headlineSmall =>
      GlassTextStyle(fontSize: 22, fontWeight: 'bold');
  @override
  FlawlessTextStyle get bodyLarge =>
      GlassTextStyle(fontSize: 16, fontWeight: 'normal');
  @override
  FlawlessTextStyle get bodyMedium =>
      GlassTextStyle(fontSize: 14, fontWeight: 'normal');
  @override
  FlawlessTextStyle get bodySmall =>
      GlassTextStyle(fontSize: 12, fontWeight: 'normal');
}

/// A concrete implementation of [FlawlessTextStyle] for the glass design system.
class GlassTextStyle implements FlawlessTextStyle {
  @override
  final String fontFamily;
  @override
  final double fontSize;
  @override
  final double letterSpacing;
  @override
  final double height;
  @override
  final String fontWeight;

  GlassTextStyle({
    this.fontFamily = 'Roboto',
    required this.fontSize,
    this.letterSpacing = 0.2,
    this.height = 1.25,
    required this.fontWeight,
  });
}

/// Default component properties for glass buttons.
class GlassButtonComponentProperties implements FlawlessComponentProperties {
  @override
  Map<String, dynamic> get properties => {
        'borderRadius': 18.0,
        'disabledOpacity': 0.45,
        'outlineBorderWidth': 1.2,
        'padding': {
          'sm': {'h': 14.0, 'v': 10.0},
          'md': {'h': 18.0, 'v': 12.0},
          'lg': {'h': 22.0, 'v': 14.0},
        },
        'iconGap': 10.0,
        'loaderStrokeWidth': 2.2,
        'glassBlurSigma': 62.0,
        'glassOpacity': 0.045,
        'borderOpacity': 0.10,
        'highlightOpacity': 0.05,
        'shadowOpacity': 0.05,
      };
}

/// Default component properties for glass cards.
class GlassCardComponentProperties implements FlawlessComponentProperties {
  @override
  Map<String, dynamic> get properties => {
        'borderRadius': 24.0,
        'borderWidth': 1.0,
        'glassBlurSigma': 3.0,
        'glassOpacity': 0.02,
        'borderOpacity': 0.18,
        'highlightOpacity': 0.08,
        'shadowOpacity': 0.04,
        'padding': {
          'none': {'h': 0.0, 'v': 0.0},
          'sm': {'h': 14.0, 'v': 14.0},
          'md': {'h': 18.0, 'v': 18.0},
          'lg': {'h': 26.0, 'v': 26.0},
        },
      };
}

/// Default component properties for glass bottom navigation.
class GlassBottomNavComponentProperties implements FlawlessComponentProperties {
  @override
  Map<String, dynamic> get properties => {
        'inactiveOpacity': 0.68,
        'height': 72.0,
        'containerRadius': 28.0,
        'containerPaddingH': 12.0,
        'containerPaddingV': 10.0,
        'itemRadius': 18.0,
        'itemPaddingH': 14.0,
        'itemPaddingV': 10.0,
        'itemGap': 8.0,
        'glassBlurSigma': 3.0,
        'glassOpacity': 0.02,
        'borderOpacity': 0.10,
        'highlightOpacity': 0.14,
        'shadowOpacity': 0.06,
      };
}

/// Glass (glassmorphism) design system implementation for Flawless.
///
/// This provides defaults for color, typography, spacing, motion, and component
/// properties.
class GlassDesignSystem implements FlawlessDesignSystem {
  @override
  FlawlessColorScheme get colorScheme => GlassColorScheme();

  @override
  FlawlessTypography get typography => GlassTypography();

  @override
  Map<String, FlawlessComponentProperties> get componentProperties => {
        'button': GlassButtonComponentProperties(),
        'card': GlassCardComponentProperties(),
        'bottomNav': GlassBottomNavComponentProperties(),
      };

  @override
  FlawlessSpacing get spacing => _GlassSpacing();

  @override
  FlawlessMotion get motion => _GlassMotion();
}

class _GlassSpacing implements FlawlessSpacing {
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

class _GlassMotion implements FlawlessMotion {
  @override
  Duration get fast => const Duration(milliseconds: 160);
  @override
  Duration get normal => const Duration(milliseconds: 280);
  @override
  Duration get slow => const Duration(milliseconds: 420);

  @override
  String get easingStandard => 'glass_standard';
  @override
  String get easingDecelerate => 'glass_decelerate';
  @override
  String get easingAccelerate => 'glass_accelerate';
}
