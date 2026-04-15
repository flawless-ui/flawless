import 'package:flutter/material.dart';
import 'package:flawless_ui/flawless_ui.dart';

import 'flawless_active_theme.dart';

class FlawlessBottomNavDemoScreen extends StatefulWidget {
  const FlawlessBottomNavDemoScreen({super.key});

  @override
  State<FlawlessBottomNavDemoScreen> createState() =>
      _FlawlessBottomNavDemoScreenState();
}

class _FlawlessBottomNavDemoScreenState
    extends State<FlawlessBottomNavDemoScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final isGlass = flawlessActiveTheme == 'glass';
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      extendBody: true,
      backgroundColor: cs.surface,
      appBar: AppBar(title: const Text('One-command swap')),
      bottomNavigationBar: FlawlessBottomNavBar(
        items: [
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
        ],
        currentIndex: _index,
        onChanged: (i) => setState(() => _index = i),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 160),
            children: [
              Text(
                'This is your app shell. Swap themes without refactoring screens.',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 10),
              _PromptTile(text: 'How much did I spend last month?'),
              const SizedBox(height: 10),
              _PromptTile(text: 'What categories did I spend the most on?'),
              const SizedBox(height: 10),
              _PromptTile(text: 'What’s my current savings streak?'),
              const SizedBox(height: 10),
              _PromptTile(text: 'How much did I save last month?'),
              const SizedBox(height: 22),
              FlawlessCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isGlass ? 'You have tried it now!' : 'Try the swap',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isGlass
                            ? 'Nice. Now open Glass tokens and make it yours.'
                            : 'Run the command below, then hot-restart the app.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.72),
                          height: 1.3,
                        ),
                      ),
                      if (!isGlass) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            r'flawless_cli add theme glass',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontFamily: 'monospace',
                                  color: Colors.white.withValues(alpha: 0.92),
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height * 0.15,
            child: IgnorePointer(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    isGlass
                        ? 'Volla! Theme swapped → Glass'
                        : 'Swap theme with 1 command →',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PromptTile extends StatelessWidget {
  final String text;
  const _PromptTile({required this.text});

  @override
  Widget build(BuildContext context) {
    return FlawlessCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
