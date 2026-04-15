import 'package:flutter/material.dart';
import 'package:flawless_glass_theme/flawless_glass_theme.dart';
import 'package:flawless_material3_theme/flawless_material3_theme.dart';
import 'package:flawless_theme/flawless_theme.dart';
import 'package:flawless_ui/flawless_ui.dart';

class FlawlessMixedThemeDemoScreen extends StatefulWidget {
  const FlawlessMixedThemeDemoScreen({super.key});

  @override
  State<FlawlessMixedThemeDemoScreen> createState() =>
      _FlawlessMixedThemeDemoScreenState();
}

class _FlawlessMixedThemeDemoScreenState
    extends State<FlawlessMixedThemeDemoScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final glass = GlassDesignSystem();
    final material3 = Material3DesignSystem();

    final items = <FlawlessBottomNavItem>[
      FlawlessBottomNavItem(
        iconCodePoint: Icons.home_outlined.codePoint,
        label: 'Home',
      ),
      FlawlessBottomNavItem(
        iconCodePoint: Icons.pie_chart_outline.codePoint,
        label: 'Portfolio',
      ),
      FlawlessBottomNavItem(
        iconCodePoint: Icons.person_outline.codePoint,
        label: 'Profile',
      ),
    ];

    return FlawlessTheme(
      designSystem: glass,
      child: Builder(
        builder: (context) {
          return Scaffold(
            extendBody: true,
            backgroundColor: const Color(0xFFF2F2F2),
            appBar: AppBar(title: const Text('Mixed Themes Demo')),
            bottomNavigationBar: FlawlessBottomNavBar(
              items: items,
              currentIndex: _index,
              onChanged: (i) => setState(() => _index = i),
            ),
            body: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.86),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'Glass root • Material 3 subtree',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FlawlessCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Theme overrides, but still one API',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Your app uses Flawless facade widgets. The active design system decides the visuals. Below, a Material 3 subtree is embedded inside a Glass shell.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.72),
                                height: 1.3,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FlawlessButton(
                        label: 'Glass button',
                        onPressed: () {},
                        variant: FlawlessButtonVariant.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Material 3 cards (subtree override)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                FlawlessTheme(
                  designSystem: material3,
                  child: Column(
                    children: [
                      for (var i = 0; i < 10; i++) ...[
                        FlawlessCard(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Material 3 card #${i + 1}',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'This subtree is forced to Material 3 via FlawlessTheme override.',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.72),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
