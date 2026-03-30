import 'package:flawless_glass_theme/flawless_glass_theme.dart';
import 'package:flawless_material3_theme/flawless_material3_theme.dart';
import 'package:flawless_theme/flawless_theme.dart';
import 'package:flawless_ui/flawless_ui.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FlawlessUiExampleApp());
}

class FlawlessUiExampleApp extends StatefulWidget {
  const FlawlessUiExampleApp({super.key});

  @override
  State<FlawlessUiExampleApp> createState() => _FlawlessUiExampleAppState();
}

class _FlawlessUiExampleAppState extends State<FlawlessUiExampleApp> {
  bool _useGlass = false;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final designSystem =
        _useGlass ? GlassDesignSystem() : Material3DesignSystem();

    return MaterialApp(
      theme: createMaterial3Theme(designSystem: Material3DesignSystem()),
      darkTheme: createGlassTheme(designSystem: GlassDesignSystem()),
      home: FlawlessTheme(
        designSystem: designSystem,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Flawless UI Example'),
            actions: [
              Row(
                children: [
                  const Text('Glass'),
                  Switch(
                    value: _useGlass,
                    onChanged: (v) => setState(() => _useGlass = v),
                  ),
                ],
              ),
            ],
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const FlawlessCard(
                    child: Text(
                        'FlawlessCard adapts to the active design system.'),
                  ),
                  const SizedBox(height: 16),
                  FlawlessButton(
                    label: 'Primary Button',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: FlawlessBottomNavBar(
            items: [
              FlawlessBottomNavItem(
                label: 'Home',
                iconCodePoint: Icons.home_outlined.codePoint,
              ),
              FlawlessBottomNavItem(
                label: 'Search',
                iconCodePoint: Icons.search_outlined.codePoint,
              ),
              FlawlessBottomNavItem(
                label: 'Profile',
                iconCodePoint: Icons.person_outline.codePoint,
              ),
            ],
            currentIndex: _currentIndex,
            onChanged: (i) => setState(() => _currentIndex = i),
          ),
        ),
      ),
    );
  }
}
