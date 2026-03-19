import 'package:flawless_glass_theme/flawless_glass_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const GlassThemeExampleApp());
}

class GlassThemeExampleApp extends StatelessWidget {
  const GlassThemeExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = createGlassTheme(designSystem: GlassDesignSystem());

    return MaterialApp(
      theme: theme,
      home: Scaffold(
        appBar: AppBar(title: const Text('Glass Theme Example')),
        body: const Center(
          child: Text('createGlassTheme() produces a ThemeData for Flutter apps.'),
        ),
      ),
    );
  }
}
