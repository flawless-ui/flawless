import 'package:flawless_core/flawless_core.dart';
import 'package:flutter/material.dart';
import 'package:flawless_theme/flawless_theme.dart';
import 'package:flawless_material3_theme/flawless_material3_theme.dart';

export 'package:flawless_core/flawless_core.dart'
    show FlawlessCardVariant, FlawlessCardPadding;

/// A Material 3 styled card using Flawless contracts
class FlawlessMaterial3Card extends StatelessWidget {
  final Widget child;
  final Widget? header;
  final Widget? footer;
  final Widget? media;
  final EdgeInsetsGeometry? margin;
  final FlawlessCardVariant variant;
  final FlawlessCardPadding padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final BorderSide? border;
  final double? borderRadius;
  final double? elevation;
  final Clip? clipBehavior;

  const FlawlessMaterial3Card({
    super.key,
    required this.child,
    this.header,
    this.footer,
    this.media,
    this.margin,
    this.variant = FlawlessCardVariant.elevated,
    this.padding = FlawlessCardPadding.md,
    this.onTap,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.elevation,
    this.clipBehavior,
  });

  const FlawlessMaterial3Card.section({
    super.key,
    required this.child,
    this.header,
    this.footer,
    this.media,
    this.margin,
    this.variant = FlawlessCardVariant.filled,
    this.padding = FlawlessCardPadding.lg,
    this.onTap,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.elevation,
    this.clipBehavior,
  });

  @override
  Widget build(BuildContext context) {
    final designSystem = FlawlessTheme.designSystemOf(
      context,
      fallback: Material3DesignSystem(),
    );
    final colors = designSystem.colorScheme;

    final defaultCardComponent =
        Material3DesignSystem().componentProperties['card']!;
    final activeCardComponent = designSystem.componentProperties['card'];
    final cardProps = FlawlessComponentPropertiesReader.fromComponentProperties(
      defaults: defaultCardComponent,
      active: activeCardComponent,
    );

    final paddingMap = cardProps.mapValue('padding');

    final borderWidth = cardProps.doubleValue('borderWidth');
    final filledSurfaceOpacity = cardProps.doubleValue('filledSurfaceOpacity');
    final borderOpacityOutline = cardProps.doubleValue('borderOpacityOutline');
    final borderOpacityFilled = cardProps.doubleValue('borderOpacityFilled');
    final borderOpacityElevated =
        cardProps.doubleValue('borderOpacityElevated');
    final shadowOpacity = cardProps.doubleValue('shadowOpacity');
    final clipAntiAlias = cardProps.boolValue('clipAntiAlias');

    final resolvedRadius =
        borderRadius ?? cardProps.doubleValue('borderRadius');
    final baseElevation = elevation ?? cardProps.doubleValue('elevation');

    final bg = backgroundColor ?? _hex(colors.surface);
    final onSurface = _hex(colors.onSurface);

    final resolved = _resolveCardStyle(
      variant: variant,
      bg: bg,
      onSurface: onSurface,
      baseElevation: baseElevation,
      borderWidth: borderWidth,
      filledSurfaceOpacity: filledSurfaceOpacity,
      borderOpacityOutline: borderOpacityOutline,
      borderOpacityFilled: borderOpacityFilled,
      borderOpacityElevated: borderOpacityElevated,
      shadowOpacity: shadowOpacity,
    );

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

    final card = Card(
      margin: margin,
      elevation: resolved.elevation,
      color: resolved.background,
      shadowColor: resolved.shadowColor,
      clipBehavior:
          clipBehavior ?? (clipAntiAlias == false ? Clip.none : Clip.antiAlias),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(resolvedRadius),
        side: border ?? resolved.border,
      ),
      child: content,
    );

    if (onTap == null) return card;
    return InkWell(
      borderRadius: BorderRadius.circular(resolvedRadius),
      onTap: onTap,
      child: card,
    );
  }

  _ResolvedCardStyle _resolveCardStyle({
    required FlawlessCardVariant variant,
    required Color bg,
    required Color onSurface,
    required double baseElevation,
    required double borderWidth,
    required double filledSurfaceOpacity,
    required double borderOpacityOutline,
    required double borderOpacityFilled,
    required double borderOpacityElevated,
    required double shadowOpacity,
  }) {
    final resolvedBorderWidth = borderWidth;
    switch (variant) {
      case FlawlessCardVariant.outline:
        return _ResolvedCardStyle(
          background: bg,
          border: BorderSide(
            color: onSurface.withValues(alpha: borderOpacityOutline),
            width: resolvedBorderWidth,
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        );
      case FlawlessCardVariant.filled:
        return _ResolvedCardStyle(
          background: bg.withValues(alpha: filledSurfaceOpacity),
          border: BorderSide(
            color: onSurface.withValues(alpha: borderOpacityFilled),
            width: resolvedBorderWidth,
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        );
      case FlawlessCardVariant.elevated:
        return _ResolvedCardStyle(
          background: bg,
          border: BorderSide(
            color: onSurface.withValues(alpha: borderOpacityElevated),
            width: resolvedBorderWidth,
          ),
          elevation: baseElevation,
          shadowColor: Colors.black.withValues(alpha: shadowOpacity),
        );
    }
  }

  EdgeInsets _paddingFor(FlawlessCardPadding padding, Object? paddingMap) {
    final Map<String, dynamic>? pad =
        paddingMap is Map<String, dynamic> ? paddingMap : null;
    final key = switch (padding) {
      FlawlessCardPadding.none => 'none',
      FlawlessCardPadding.sm => 'sm',
      FlawlessCardPadding.md => 'md',
      FlawlessCardPadding.lg => 'lg',
    };

    final entry = pad?[key];
    if (entry is Map<String, dynamic>) {
      final h = (entry['h'] as num?)?.toDouble();
      final v = (entry['v'] as num?)?.toDouble();
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

class _ResolvedCardStyle {
  final Color background;
  final BorderSide border;
  final double elevation;
  final Color shadowColor;

  const _ResolvedCardStyle({
    required this.background,
    required this.border,
    required this.elevation,
    required this.shadowColor,
  });
}
