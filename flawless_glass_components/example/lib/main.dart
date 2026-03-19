import 'package:flawless_core/flawless_core.dart';
import 'package:flawless_glass_components/flawless_glass_components.dart';
import 'package:flawless_glass_theme/flawless_glass_theme.dart';
import 'package:flawless_theme/flawless_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const GlassComponentsExampleApp());
}

class GlassComponentsExampleApp extends StatefulWidget {
  const GlassComponentsExampleApp({super.key});

  @override
  State<GlassComponentsExampleApp> createState() => _GlassComponentsExampleAppState();
}

class _GlassComponentsExampleAppState extends State<GlassComponentsExampleApp> {
  bool _loading = false;
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: createGlassTheme(designSystem: GlassDesignSystem()),
      home: FlawlessTheme(
        designSystem: GlassDesignSystem(),
        child: Scaffold(
          appBar: AppBar(title: const Text('Glass Components Example')),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FlawlessGlassCard(
                    header: const Text('Card Header'),
                    child: const Text('FlawlessGlassCard renders the glass style.'),
                  ),
                  const SizedBox(height: 16),
                  FlawlessGlassButton(
                    label: _loading ? 'Loading' : 'Toggle Loading',
                    isLoading: _loading,
                    onPressed: () => setState(() => _loading = !_loading),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: FlawlessGlassBottomNavBar(
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
            currentIndex: _index,
            onChanged: (i) => setState(() => _index = i),
          ),
        ),
      ),
    );
  }
}
