import 'dart:ui';

import 'package:flawless_core/flawless_core.dart';
import 'package:flutter/material.dart';

import 'package:flawless_glass_theme/flawless_glass_theme.dart';
import 'package:flawless_theme/flawless_theme.dart';

class FlawlessGlassBottomNavBar extends StatelessWidget {
  final List<FlawlessBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const FlawlessGlassBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final designSystem = FlawlessTheme.designSystemOf(
      context,
      fallback: GlassDesignSystem(),
    );

    final colors = designSystem.colorScheme;
    final motion = designSystem.motion;
    final typography = designSystem.typography;

    final defaults = GlassDesignSystem().componentProperties['bottomNav']!;
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

    final blurSigma = props.doubleValue('glassBlurSigma');
    final glassOpacity = props.doubleValue('glassOpacity');
    final borderOpacity = props.doubleValue('borderOpacity');
    final highlightOpacity = props.doubleValue('highlightOpacity');
    final shadowOpacity = props.doubleValue('shadowOpacity');

    final inactiveOpacity = props.doubleValue('inactiveOpacity');

    final navHeight = props.doubleValue('height');

    final onSurface = _hex(colors.onSurface);

    final inactive = onSurface.withValues(alpha: inactiveOpacity);

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
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: SizedBox(
          height: navHeight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: shadowOpacity),
                      blurRadius: 22,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(radius),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFFFFFFFF)
                                  .withValues(alpha: glassOpacity + 0.02),
                              const Color(0xFFF7F7F7)
                                  .withValues(alpha: glassOpacity),
                            ],
                          ),
                          border: Border.all(
                            color: onSurface.withValues(alpha: borderOpacity),
                            width: 0.9,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(radius),
                            border: Border.all(
                              color: Colors.white
                                  .withValues(alpha: highlightOpacity),
                              width: 0.7,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
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
                                    activeBg:
                                        Colors.black.withValues(alpha: 0.92),
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
