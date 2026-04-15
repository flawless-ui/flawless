import 'package:flawless_material3_theme/material3_design_system.dart';
import 'package:flawless_theme/flawless_theme.dart';
import 'package:flutter/material.dart';
import 'package:flawless_ui/flawless_ui.dart';

class FlawlessCowScreen extends StatelessWidget {
  const FlawlessCowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/flawless-logo.png',
                    width: MediaQuery.of(context).size.width * 0.4,
                  ),
                  const Spacer(),
                  Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: cs.onSurface.withValues(alpha: 0.04),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications_none_outlined,
                      color: cs.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FlawlessCard(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ACCOUNT BALANCE:',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          letterSpacing: 0.4,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface.withValues(alpha: 0.55),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            r'$21,530.86',
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            height: 44,
                            width: 44,
                            decoration: BoxDecoration(
                              color: cs.onSurface.withValues(alpha: 0.04),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.visibility_outlined,
                              color: cs.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      FlawlessTheme(
                        designSystem: Material3DesignSystem(),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                height: 44,
                                child: FlawlessButton(
                                  label: 'Send',
                                  radius: FlawlessButtonRadius.pill,
                                  variant: FlawlessButtonVariant.primary,
                                  leadingIcon: const Icon(Icons.north_east),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                height: 44,
                                child: FlawlessButton(
                                  label: 'Withdraw',
                                  variant: FlawlessButtonVariant.surface,
                                  radius: FlawlessButtonRadius.pill,
                                  onPressed: () {},
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              height: 44,
                              width: 44,
                              child: FlawlessButton(
                                label: '',
                                variant: FlawlessButtonVariant.surface,
                                radius: FlawlessButtonRadius.pill,
                                leadingIcon: const Icon(Icons.more_horiz),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: IntrinsicWidth(
                  child: SizedBox(
                    height: 40,
                    child: FlawlessButton(
                      label: 'Transaction History',
                      variant: FlawlessButtonVariant.ghost,
                      size: FlawlessButtonSize.sm,
                      trailingIcon: const Icon(Icons.chevron_right),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
