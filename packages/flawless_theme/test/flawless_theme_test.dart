import 'package:flutter_test/flutter_test.dart';
import 'package:flawless_theme/flawless_theme.dart';
import 'package:flutter/material.dart';
import 'package:flawless_core/flawless_core.dart';

class MockThemePersistence implements ThemePersistence {
  ThemeMode? _mode;
  @override
  Future<ThemeMode?> loadThemeMode() async => _mode;
  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    _mode = mode;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('FlawlessThemeController', () {
    test('default theme mode is system', () async {
      final controller =
          FlawlessThemeController(persistence: MockThemePersistence());
      expect(controller.themeMode, ThemeMode.system);
    });

    test('setThemeMode updates and persists', () async {
      final mockPersistence = MockThemePersistence();
      final controller = FlawlessThemeController(persistence: mockPersistence);
      await controller.setThemeMode(ThemeMode.dark);
      expect(controller.themeMode, ThemeMode.dark);
      expect(await mockPersistence.loadThemeMode(), ThemeMode.dark);
    });

    test('setThemeMode notifies listeners', () async {
      final controller =
          FlawlessThemeController(persistence: MockThemePersistence());
      var notified = 0;
      controller.addListener(() {
        notified += 1;
      });

      await controller.setThemeMode(ThemeMode.light);
      expect(notified, greaterThanOrEqualTo(1));
    });
  });

  group('FlawlessThemeControllerProvider', () {
    testWidgets('of(context) returns the provided controller', (tester) async {
      final controller =
          FlawlessThemeController(persistence: MockThemePersistence());

      await tester.pumpWidget(
        MaterialApp(
          home: FlawlessThemeControllerProvider(
            controller: controller,
            child: Builder(
              builder: (context) {
                final resolved = FlawlessThemeControllerProvider.of(context);
                expect(identical(resolved, controller), true);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
    });
  });

  group('FlawlessTheme nested overrides', () {
    testWidgets(
        'inherited FlawlessTheme overrides ThemeExtension design system',
        (tester) async {
      final rootDesignSystem = _TestDesignSystem('root');
      final nestedDesignSystem = _TestDesignSystem('nested');

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [
              FlawlessThemeExtension(designSystem: rootDesignSystem)
            ],
          ),
          home: FlawlessTheme(
            designSystem: nestedDesignSystem,
            child: Builder(
              builder: (context) {
                final resolved = FlawlessTheme.designSystemOf(
                  context,
                  fallback: _TestDesignSystem('fallback'),
                );
                expect(identical(resolved, nestedDesignSystem), true);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
    });
  });
}

class _TestDesignSystem implements FlawlessDesignSystem {
  final String id;
  const _TestDesignSystem(this.id);

  @override
  FlawlessColorScheme get colorScheme => _TestColorScheme(id);

  @override
  FlawlessTypography get typography => _TestTypography();

  @override
  Map<String, FlawlessComponentProperties> get componentProperties => const {};

  @override
  FlawlessSpacing get spacing => _TestSpacing();

  @override
  FlawlessMotion get motion => _TestMotion();
}

class _TestColorScheme implements FlawlessColorScheme {
  final String seed;
  const _TestColorScheme(this.seed);

  @override
  String get primary => seed;
  @override
  String get secondary => seed;
  @override
  String get background => seed;
  @override
  String get surface => seed;
  @override
  String get error => seed;
  @override
  String get onPrimary => seed;
  @override
  String get onSecondary => seed;
  @override
  String get onBackground => seed;
  @override
  String get onSurface => seed;
  @override
  String get onError => seed;
}

class _TestTypography implements FlawlessTypography {
  @override
  FlawlessTextStyle get displayLarge => const _TestTextStyle();
  @override
  FlawlessTextStyle get displayMedium => const _TestTextStyle();
  @override
  FlawlessTextStyle get displaySmall => const _TestTextStyle();
  @override
  FlawlessTextStyle get headlineLarge => const _TestTextStyle();
  @override
  FlawlessTextStyle get headlineMedium => const _TestTextStyle();
  @override
  FlawlessTextStyle get headlineSmall => const _TestTextStyle();
  @override
  FlawlessTextStyle get bodyLarge => const _TestTextStyle();
  @override
  FlawlessTextStyle get bodyMedium => const _TestTextStyle();
  @override
  FlawlessTextStyle get bodySmall => const _TestTextStyle();
}

class _TestTextStyle implements FlawlessTextStyle {
  const _TestTextStyle();

  @override
  String get fontFamily => 'Roboto';
  @override
  double get fontSize => 14;
  @override
  double get letterSpacing => 0;
  @override
  double get height => 1;
  @override
  String get fontWeight => 'normal';
}

class _TestSpacing implements FlawlessSpacing {
  @override
  double get xxs => 1;
  @override
  double get xs => 2;
  @override
  double get sm => 3;
  @override
  double get md => 4;
  @override
  double get lg => 5;
  @override
  double get xl => 6;
  @override
  double get xxl => 7;
}

class _TestMotion implements FlawlessMotion {
  @override
  Duration get fast => const Duration(milliseconds: 1);
  @override
  Duration get normal => const Duration(milliseconds: 2);
  @override
  Duration get slow => const Duration(milliseconds: 3);
  @override
  String get easingStandard => 'standard';
  @override
  String get easingDecelerate => 'decelerate';
  @override
  String get easingAccelerate => 'accelerate';
}
