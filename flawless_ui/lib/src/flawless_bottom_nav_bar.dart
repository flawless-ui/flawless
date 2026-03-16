import 'package:flawless_theme/flawless_theme.dart';
import 'package:flutter/material.dart';

import 'package:flawless_core/flawless_core.dart';

import 'package:flawless_material3_components/flawless_material3_components.dart';
import 'package:flawless_material3_theme/flawless_material3_theme.dart';

import 'package:flawless_glass_components/flawless_glass_components.dart';
import 'package:flawless_glass_theme/flawless_glass_theme.dart';

export 'package:flawless_core/flawless_core.dart' show FlawlessBottomNavItem;

class FlawlessBottomNavBar extends StatelessWidget {
  final List<FlawlessBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const FlawlessBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final designSystem = FlawlessTheme.maybeDesignSystemOf(context);

    if (designSystem is GlassDesignSystem) {
      return FlawlessGlassBottomNavBar(
        items: items,
        currentIndex: currentIndex,
        onChanged: onChanged,
      );
    }

    if (designSystem is Material3DesignSystem) {
      return FlawlessMaterial3BottomNavBar(
        items: items,
        currentIndex: currentIndex,
        onChanged: onChanged,
      );
    }

    return FlawlessMaterial3BottomNavBar(
      items: items,
      currentIndex: currentIndex,
      onChanged: onChanged,
    );
  }
}
