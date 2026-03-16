import 'package:flutter/material.dart';
import 'package:flawless_core/flawless_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Orchestrator for theme state and persistence.
/// Abstract persistence interface for theme mode.
abstract class ThemePersistence {
  Future<ThemeMode?> loadThemeMode();
  Future<void> saveThemeMode(ThemeMode mode);
}

/// Default persistence using shared_preferences.
class SharedPreferencesThemePersistence implements ThemePersistence {
  static const _themeModeKey = 'flawless_theme_mode';

  @override
  Future<ThemeMode?> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final modeIndex = prefs.getInt(_themeModeKey);
    if (modeIndex != null) {
      return ThemeMode.values[modeIndex];
    }
    return null;
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, mode.index);
  }
}

/// Orchestrator for theme state and persistence.
class FlawlessThemeController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  final ThemePersistence _persistence;

  FlawlessThemeController({ThemePersistence? persistence})
      : _persistence = persistence ?? SharedPreferencesThemePersistence() {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final mode = await _persistence.loadThemeMode();
    if (mode != null) {
      _themeMode = mode;
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    await _persistence.saveThemeMode(mode);
  }
}

class FlawlessThemeControllerProvider
    extends InheritedNotifier<FlawlessThemeController> {
  const FlawlessThemeControllerProvider({
    super.key,
    required FlawlessThemeController controller,
    required super.child,
  }) : super(notifier: controller);

  static FlawlessThemeController of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<FlawlessThemeControllerProvider>();
    assert(provider != null,
        'No FlawlessThemeControllerProvider found in context');
    final controller = provider!.notifier;
    assert(
        controller != null, 'FlawlessThemeControllerProvider has no notifier');
    return controller!;
  }
}

class FlawlessThemeExtension extends ThemeExtension<FlawlessThemeExtension> {
  final FlawlessDesignSystem designSystem;

  const FlawlessThemeExtension({required this.designSystem});

  @override
  FlawlessThemeExtension copyWith({FlawlessDesignSystem? designSystem}) {
    return FlawlessThemeExtension(
      designSystem: designSystem ?? this.designSystem,
    );
  }

  @override
  FlawlessThemeExtension lerp(
      ThemeExtension<FlawlessThemeExtension>? other, double t) {
    if (other is! FlawlessThemeExtension) return this;
    return t < 0.5 ? this : other;
  }
}

class FlawlessTheme extends InheritedWidget {
  final FlawlessDesignSystem designSystem;

  const FlawlessTheme({
    super.key,
    required this.designSystem,
    required super.child,
  });

  static FlawlessDesignSystem? maybeDesignSystemOf(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<FlawlessTheme>();
    if (inherited != null) return inherited.designSystem;

    final ext = Theme.of(context).extension<FlawlessThemeExtension>();
    return ext?.designSystem;
  }

  static FlawlessDesignSystem designSystemOf(
    BuildContext context, {
    required FlawlessDesignSystem fallback,
  }) {
    return maybeDesignSystemOf(context) ?? fallback;
  }

  @override
  bool updateShouldNotify(FlawlessTheme oldWidget) {
    return !identical(oldWidget.designSystem, designSystem);
  }
}
