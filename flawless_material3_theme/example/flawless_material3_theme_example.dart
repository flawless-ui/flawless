import 'package:flutter/material.dart';
import 'package:flawless_material3_theme/flawless_material3_theme.dart';
import 'package:flawless_theme/flawless_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final material3DesignSystem = Material3DesignSystem();
    return MaterialApp(
      theme: createMaterial3Theme(designSystem: material3DesignSystem),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<FlawlessThemeExtension>();
    return Scaffold(
      appBar: AppBar(title: const Text('Material 3 Theme Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Primary color: ${ext?.designSystem.colorScheme.primary ?? "N/A"}'),
            Text(
                'Button border radius: ${ext?.designSystem.componentProperties['button']?.properties['borderRadius'] ?? "N/A"}'),
          ],
        ),
      ),
    );
  }
}
