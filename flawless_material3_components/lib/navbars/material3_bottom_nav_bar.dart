import 'package:flawless_core/flawless_core.dart';
import 'package:flutter/material.dart';

import 'package:flawless_material3_theme/flawless_material3_theme.dart';
import 'package:flawless_theme/flawless_theme.dart';

class FlawlessMaterial3BottomNavBar extends StatelessWidget {
  final List<FlawlessBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const FlawlessMaterial3BottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedDesignSystem = FlawlessTheme.designSystemOf(
      context,
      fallback: Material3DesignSystem(),
    );

    final designSystem = resolvedDesignSystem is Material3DesignSystem
        ? resolvedDesignSystem
        : Material3DesignSystem();

    final colors = designSystem.colorScheme;
    final motion = designSystem.motion;
    final typography = designSystem.typography;

    final defaults = Material3DesignSystem().componentProperties['bottomNav']!;
    final active = designSystem.componentProperties['bottomNav'];

    final props = FlawlessComponentPropertiesReader.fromComponentProperties(
      defaults: defaults,
      active: active,
    );

    final radius = props.doubleValue('containerRadius');
    final paddingH = props.doubleValue('containerPaddingH');
    final paddingV = props.doubleValue('containerPaddingV');
    final itemRadius = props.doubleValue('itemRadius');
    final itemPaddingH = props.doubleValue('itemPaddingH');
    final itemPaddingV = props.doubleValue('itemPaddingV');
    final itemGap = props.doubleValue('itemGap');
    final inactiveOpacity = props.doubleValue('inactiveOpacity');
    final navHeight = props.doubleValue('height');

    final bg = _hex(colors.surface);
    final inactive = _hex(colors.onSurface).withValues(alpha: inactiveOpacity);

    final labelStyle = TextStyle(
      fontFamily: typography.bodyMedium.fontFamily,
      fontSize: typography.bodyMedium.fontSize,
      fontWeight: FontWeight.w600,
      height: typography.bodyMedium.height,
      letterSpacing: typography.bodyMedium.letterSpacing,
    );

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: SizedBox(
          height: navHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(radius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 22,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: paddingH, vertical: paddingV),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (var i = 0; i < items.length; i++)
                      Expanded(
                        child: Center(
                          child: _NavItem(
                            item: items[i],
                            isActive: i == currentIndex,
                            onTap: () => onChanged(i),
                            activeBg: Colors.black,
                            activeFg: Colors.white,
                            inactiveFg: inactive,
                            itemRadius: itemRadius,
                            paddingH: itemPaddingH,
                            paddingV: itemPaddingV,
                            gap: itemGap,
                            motion: motion.fast,
                            labelStyle: labelStyle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _hex(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}

class _NavItem extends StatelessWidget {
  final FlawlessBottomNavItem item;
  final bool isActive;
  final VoidCallback onTap;

  final Color activeBg;
  final Color activeFg;
  final Color inactiveFg;

  final double itemRadius;
  final double paddingH;
  final double paddingV;
  final double gap;
  final Duration motion;
  final TextStyle labelStyle;

  const _NavItem({
    required this.item,
    required this.isActive,
    required this.onTap,
    required this.activeBg,
    required this.activeFg,
    required this.inactiveFg,
    required this.itemRadius,
    required this.paddingH,
    required this.paddingV,
    required this.gap,
    required this.motion,
    required this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    final fg = isActive ? activeFg : inactiveFg;

    return AnimatedContainer(
      duration: motion,
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
      decoration: BoxDecoration(
        color: isActive ? activeBg : Colors.transparent,
        borderRadius: BorderRadius.circular(itemRadius),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(itemRadius),
        onTap: onTap,
        child: AnimatedDefaultTextStyle(
          duration: motion,
          style: labelStyle.copyWith(color: fg),
          child: IconTheme(
            data: IconThemeData(color: fg, size: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(IconData(item.iconCodePoint, fontFamily: 'MaterialIcons')),
                if (isActive) ...[
                  SizedBox(width: gap),
                  Flexible(
                    child: Text(
                      item.label,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
