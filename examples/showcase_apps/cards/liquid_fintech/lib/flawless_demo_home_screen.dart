import 'package:flutter/material.dart';
import 'package:flawless_ui/flawless_ui.dart';

import 'flawless_active_theme.dart';

import 'flawless_bottom_nav_demo_screen.dart';
import 'flawless_mixed_theme_demo_screen.dart';

class FlawlessDemoHomeScreen extends StatelessWidget {
  const FlawlessDemoHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isGlass = flawlessActiveTheme == 'glass';

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
          children: [
            _BrandHeader(isGlass: isGlass),
            const SizedBox(height: 14),
            _WelcomeCard(isGlass: isGlass),
            const SizedBox(height: 14),
            _SectionTitle('Start here'),
            const SizedBox(height: 10),
            _TutorialStep(
              icon: Icons.bolt_outlined,
              title: 'One-command theme swap',
              subtitle: isGlass
                  ? 'Volla! You swapped the entire app shell to Glass.'
                  : 'Run one CLI command and come back to see the UI change.',
              command: isGlass ? null : r'flawless_cli add theme glass',
              tag: isGlass ? 'Done' : 'Try it',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const FlawlessBottomNavDemoScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _TutorialStep(
              icon: Icons.layers_outlined,
              title: 'Mix themes in one screen',
              subtitle:
                  'Glass at the root. Material 3 in a subtree. Same facade widgets, different implementations.',
              command: r'FlawlessTheme(designSystem: ...) // subtree override',
              tag: 'Overrides',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const FlawlessMixedThemeDemoScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _SectionTitle('Quick tips'),
            const SizedBox(height: 10),
            FlawlessCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'We provide the scaffolding; you provide the brand.',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _TipLine(
                      title: 'Edit tokens',
                      value: 'DesignSystem.colorScheme + componentProperties',
                    ),
                    const SizedBox(height: 8),
                    _TipLine(
                      title: 'Swap theme',
                      value: 'flawless_active_theme.dart (generated)',
                    ),
                    const SizedBox(height: 8),
                    _TipLine(
                      title: 'Add components',
                      value: r'flawless_cli add component button',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  final bool isGlass;
  const _BrandHeader({required this.isGlass});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  'https://raw.githubusercontent.com/flawless-ui/flawless/main/.github/assets/flawless.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Text(
                        'F',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to Flawless',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isGlass ? 'Theme: Glass' : 'Theme: Material 3',
                    style: textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Headless UI, in Flutter.',
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  final bool isGlass;
  const _WelcomeCard({required this.isGlass});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return FlawlessCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'So glad to have you here.',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            isGlass
                ? 'Nice. You’re running the Glass implementation. Now explore overrides and tweak the design system tokens.'
                : 'This starter app is your mini tutorial hub. Start by swapping the theme using one CLI command—then come back and feel the difference.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.72),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w900,
        letterSpacing: 0.2,
      ),
    );
  }
}

class _TutorialStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? command;
  final String tag;
  final VoidCallback onTap;

  const _TutorialStep({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.command,
    required this.tag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return FlawlessCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.black.withValues(alpha: 0.04),
                ),
                child: Icon(icon, color: cs.onSurface.withValues(alpha: 0.7)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: Colors.black.withValues(alpha: 0.04),
                ),
                child: Text(
                  tag,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.72),
              height: 1.3,
            ),
          ),
          if (command != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                command!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  color: Colors.white.withValues(alpha: 0.92),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TipLine extends StatelessWidget {
  final String title;
  final String value;
  const _TipLine({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 92,
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.72),
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}
