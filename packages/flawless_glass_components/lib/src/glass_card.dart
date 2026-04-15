import 'dart:ui';

import 'package:flawless_core/flawless_core.dart';
import 'package:flawless_theme/flawless_theme.dart';
import 'package:flutter/material.dart';
import 'package:flawless_glass_theme/flawless_glass_theme.dart';

export 'package:flawless_core/flawless_core.dart'
    show FlawlessCardVariant, FlawlessCardPadding;

class FlawlessGlassCard extends StatelessWidget {
  final Widget child;
  final Widget? header;
  final Widget? footer;
  final Widget? media;
  final EdgeInsetsGeometry? margin;
  final FlawlessCardPadding padding;
  final VoidCallback? onTap;

  const FlawlessGlassCard({
    super.key,
    required this.child,
    this.header,
    this.footer,
    this.media,
    this.margin,
    this.padding = FlawlessCardPadding.md,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final designSystem = FlawlessTheme.designSystemOf(
      context,
      fallback: GlassDesignSystem(),
    );

    final colors = designSystem.colorScheme;

    final defaultCardComponent =
        GlassDesignSystem().componentProperties['card']!;
    final activeCardComponent = designSystem.componentProperties['card'];
    final props = FlawlessComponentPropertiesReader.fromComponentProperties(
      defaults: defaultCardComponent,
      active: activeCardComponent,
    );

    final paddingMap = props.mapValue('padding');

    final radius = props.doubleValue('borderRadius');
    final borderWidth = props.doubleValue('borderWidth');
    final blurSigma = props.doubleValue('glassBlurSigma');
    final glassOpacity = props.doubleValue('glassOpacity');
    final tintColorToken = props.value('tintColor');
    final borderColorToken = props.value('borderColor');
    final borderOpacity = props.doubleValue('borderOpacity');
    final highlightColorToken = props.value('highlightColor');
    final highlightOpacity = props.doubleValue('highlightOpacity');
    final shadowOpacity = props.doubleValue('shadowOpacity');

    final bg =
        tintColorToken is String ? _hex(tintColorToken) : _hex(colors.surface);
    final borderBase = borderColorToken is String
        ? _hex(borderColorToken)
        : _hex(colors.onSurface);
    final borderColor = borderBase.withValues(alpha: borderOpacity);
    final highlightBase = highlightColorToken is String
        ? _hex(highlightColorToken)
        : Colors.white;

    final contentPadding = _paddingFor(padding, paddingMap);

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (media != null) media!,
        if (header != null)
          Padding(
            padding: contentPadding,
            child: header!,
          ),
        Padding(
          padding: contentPadding,
          child: child,
        ),
        if (footer != null)
          Padding(
            padding: contentPadding,
            child: footer!,
          ),
      ],
    );

    final card = Container(
      margin: margin,
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
                  blurRadius: 26,
                  spreadRadius: 0,
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
                          bg.withValues(
                              alpha: (glassOpacity * 1.15).clamp(0.0, 1.0)),
                          bg.withValues(
                              alpha: (glassOpacity * 0.70).clamp(0.0, 1.0)),
                        ],
                      ),
                      border:
                          Border.all(color: borderColor, width: borderWidth),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(radius),
                        border: Border.all(
                          color:
                              highlightBase.withValues(alpha: highlightOpacity),
                          width: 0.9,
                        ),
                      ),
                    ),
                  ),
                ),
                content,
              ],
            ),
          ),
        ),
      ),
    );

    if (onTap == null) return card;
    return GestureDetector(onTap: onTap, child: card);
  }

  EdgeInsets _paddingFor(
      FlawlessCardPadding padding, Map<String, dynamic> paddingMap) {
    final key = switch (padding) {
      FlawlessCardPadding.none => 'none',
      FlawlessCardPadding.sm => 'sm',
      FlawlessCardPadding.md => 'md',
      FlawlessCardPadding.lg => 'lg',
    };

    final entry = paddingMap[key];
    if (entry is Map) {
      final m = entry.cast<String, dynamic>();
      final h = (m['h'] as num?)?.toDouble();
      final v = (m['v'] as num?)?.toDouble();
      if (h != null && v != null) {
        return EdgeInsets.symmetric(horizontal: h, vertical: v);
      }
    }

    return EdgeInsets.zero;
  }

  Color _hex(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}
