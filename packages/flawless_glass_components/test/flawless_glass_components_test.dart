import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flawless_glass_components/flawless_glass_components.dart';
import 'package:flawless_glass_theme/flawless_glass_theme.dart';

void main() {
  testWidgets('FlawlessGlassButton renders and responds to tap',
      (WidgetTester tester) async {
    var pressed = false;
    final ds = GlassDesignSystem();

    await tester.pumpWidget(
      MaterialApp(
        theme: createGlassTheme(designSystem: ds),
        home: Scaffold(
          body: FlawlessGlassButton(
            label: 'Glass Button',
            onPressed: () {
              pressed = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Glass Button'), findsOneWidget);
    await tester.tap(find.text('Glass Button'));
    expect(pressed, true);
  });

  testWidgets('FlawlessGlassCard renders child', (WidgetTester tester) async {
    final ds = GlassDesignSystem();

    await tester.pumpWidget(
      MaterialApp(
        theme: createGlassTheme(designSystem: ds),
        home: const Scaffold(
          body: FlawlessGlassCard(
            child: Text('Card Child'),
          ),
        ),
      ),
    );

    expect(find.byType(FlawlessGlassCard), findsOneWidget);
    expect(find.text('Card Child'), findsOneWidget);
  });
}
