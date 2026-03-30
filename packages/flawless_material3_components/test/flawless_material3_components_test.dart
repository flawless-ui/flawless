import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flawless_material3_theme/flawless_material3_theme.dart';
import 'package:flawless_material3_components/flawless_material3_components.dart';

void main() {
  testWidgets('FlawlessMaterial3Button renders and responds to tap',
      (WidgetTester tester) async {
    bool pressed = false;
    final material3DesignSystem = Material3DesignSystem();
    await tester.pumpWidget(
      MaterialApp(
        theme: createMaterial3Theme(designSystem: material3DesignSystem),
        home: Scaffold(
          body: FlawlessMaterial3Button(
            label: 'Test Button',
            onPressed: () {
              pressed = true;
            },
          ),
        ),
      ),
    );
    expect(find.text('Test Button'), findsOneWidget);
    await tester.tap(find.text('Test Button'));
    expect(pressed, isTrue);
  });
}
