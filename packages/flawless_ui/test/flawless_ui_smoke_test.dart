import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flawless_ui/flawless_ui.dart';

import 'package:flawless_glass_components/flawless_glass_components.dart';
import 'package:flawless_glass_theme/flawless_glass_theme.dart';

import 'package:flawless_material3_components/flawless_material3_components.dart';
import 'package:flawless_material3_theme/flawless_material3_theme.dart';

void main() {
  testWidgets(
      'FlawlessButton dispatches to Glass button when Glass theme is active',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: createGlassTheme(designSystem: GlassDesignSystem()),
        home: const Scaffold(
          body: FlawlessButton(label: 'Tap'),
        ),
      ),
    );

    expect(find.byType(FlawlessGlassButton), findsOneWidget);
  });

  testWidgets(
      'FlawlessButton dispatches to Material3 button when Material3 theme is active',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: createMaterial3Theme(designSystem: Material3DesignSystem()),
        home: const Scaffold(
          body: FlawlessButton(label: 'Tap'),
        ),
      ),
    );

    expect(find.byType(FlawlessMaterial3Button), findsOneWidget);
  });

  testWidgets(
      'FlawlessCard dispatches to Glass card when Glass theme is active',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: createGlassTheme(designSystem: GlassDesignSystem()),
        home: const Scaffold(
          body: FlawlessCard(child: Text('Child')),
        ),
      ),
    );

    expect(find.byType(FlawlessGlassCard), findsOneWidget);
  });

  testWidgets(
      'FlawlessCard dispatches to Material3 card when Material3 theme is active',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: createMaterial3Theme(designSystem: Material3DesignSystem()),
        home: const Scaffold(
          body: FlawlessCard(child: Text('Child')),
        ),
      ),
    );

    expect(find.byType(FlawlessMaterial3Card), findsOneWidget);
  });
}
