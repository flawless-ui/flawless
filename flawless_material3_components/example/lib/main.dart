import 'package:flawless_core/flawless_core.dart';
import 'package:flawless_material3_components/flawless_material3_components.dart';
import 'package:flawless_material3_theme/flawless_material3_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Material3ComponentsExampleApp());
}

class Material3ComponentsExampleApp extends StatefulWidget {
  const Material3ComponentsExampleApp({super.key});

  @override
  State<Material3ComponentsExampleApp> createState() =>
      _Material3ComponentsExampleAppState();
}

class _Material3ComponentsExampleAppState
    extends State<Material3ComponentsExampleApp> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final designSystem = Material3DesignSystem();

    return MaterialApp(
      theme: createMaterial3Theme(designSystem: designSystem),
      home: Scaffold(
        appBar: AppBar(title: const Text('Material 3 Components Example')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FlawlessMaterial3Card(
                  header: const Text('Card Header'),
                  child: const Text(
                      'FlawlessMaterial3Card uses Material 3 styling.'),
                ),
                const SizedBox(height: 16),
                FlawlessMaterial3Button(
                  label: 'Primary Button',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: FlawlessMaterial3BottomNavBar(
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
    );
  }
}
