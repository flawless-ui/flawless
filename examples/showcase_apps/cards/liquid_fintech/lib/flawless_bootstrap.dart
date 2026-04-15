import 'package:flutter/material.dart';
import 'package:flawless_theme/flawless_theme.dart';
import 'package:flawless_material3_theme/flawless_material3_theme.dart';
import 'package:flawless_glass_theme/flawless_glass_theme.dart';
import 'flawless_cow_screen.dart';
import 'flawless_active_theme.dart';

class FlawlessAppRoot extends StatefulWidget {
  const FlawlessAppRoot({super.key});

  @override
  State<FlawlessAppRoot> createState() => _FlawlessAppRootState();
}

class _FlawlessAppRootState extends State<FlawlessAppRoot> {
  late final FlawlessThemeController _controller;
  late final Material3DesignSystem _material3DesignSystem;
  late final GlassDesignSystem _glassDesignSystem;

  @override
  void initState() {
    super.initState();
    _controller = FlawlessThemeController();
    _material3DesignSystem = Material3DesignSystem();
    _glassDesignSystem = GlassDesignSystem();
  }

  ThemeData _createTheme(Brightness brightness) {
    if (flawlessActiveTheme == 'glass') {
      return createGlassTheme(
        designSystem: _glassDesignSystem,
        brightness: brightness,
      );
    }

    return createMaterial3Theme(
      designSystem: _material3DesignSystem,
      brightness: brightness,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlawlessThemeControllerProvider(
      controller: _controller,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return MaterialApp(
            themeMode: _controller.themeMode,
            theme: _createTheme(Brightness.light),
            darkTheme: _createTheme(Brightness.dark),
            home: const FlawlessCowScreen(),
          );
        },
      ),
    );
  }
}
