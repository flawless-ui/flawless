import 'dart:ui';

import 'package:flawless_core/flawless_core.dart';
import 'package:flawless_theme/flawless_theme.dart';
import 'package:flutter/material.dart';
import 'package:flawless_glass_theme/flawless_glass_theme.dart';

export 'package:flawless_core/flawless_core.dart'
    show FlawlessButtonVariant, FlawlessButtonSize, FlawlessButtonRadius;

class FlawlessGlassButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final FlawlessButtonVariant variant;
  final FlawlessButtonSize size;
  final FlawlessButtonRadius radius;
  final bool isLoading;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  const FlawlessGlassButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = FlawlessButtonVariant.primary,
    this.size = FlawlessButtonSize.md,
    this.radius = FlawlessButtonRadius.md,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final designSystem = FlawlessTheme.designSystemOf(
      context,
      fallback: GlassDesignSystem(),
    );

    final colors = designSystem.colorScheme;
    final motion = designSystem.motion;
    final textStyleToken = designSystem.typography.bodyLarge;

    final defaultButtonComponent =
        GlassDesignSystem().componentProperties['button']!;
    final activeButtonComponent = designSystem.componentProperties['button'];
    final props = FlawlessComponentPropertiesReader.fromComponentProperties(
      defaults: defaultButtonComponent,
      active: activeButtonComponent,
    );

    final borderRadius = props.doubleValue('borderRadius');
    final disabledOpacity = props.doubleValue('disabledOpacity');
    final outlineBorderWidth = props.doubleValue('outlineBorderWidth');
    final paddingMap = props.mapValue('padding');
    final radiiMap = props.mapValue('radii');
    final iconGap = props.doubleValue('iconGap');
    final loaderStrokeWidth = props.doubleValue('loaderStrokeWidth');
    final blurSigma = props.doubleValue('glassBlurSigma');
    final glassOpacity = props.doubleValue('glassOpacity');
    final variantFillOpacityMap = props.mapValue('variantFillOpacity');
    final borderOpacity = props.doubleValue('borderOpacity');
    final variantBorderOpacityMap = props.mapValue('variantBorderOpacity');
    final highlightOpacity = props.doubleValue('highlightOpacity');
    final shadowOpacity = props.doubleValue('shadowOpacity');
    final variantShadowOpacityMap = props.mapValue('variantShadowOpacity');

    final baseTextStyle = TextStyle(
      fontFamily: textStyleToken.fontFamily,
      fontSize: _fontSizeForSize(textStyleToken.fontSize, size),
      fontWeight: _parseFontWeight(textStyleToken.fontWeight),
    );

    final colorsByVariant = props.mergedMap('colors');

    final resolved = _resolveColors(
      variant,
      colors,
      colorsByVariant: colorsByVariant,
      outlineBorderWidth: outlineBorderWidth,
    );

    final variantKey = switch (variant) {
      FlawlessButtonVariant.primary => 'primary',
      FlawlessButtonVariant.secondary => 'secondary',
      FlawlessButtonVariant.surface => 'surface',
      FlawlessButtonVariant.ghost => 'ghost',
      FlawlessButtonVariant.outline => 'outline',
      FlawlessButtonVariant.destructive => 'destructive',
      FlawlessButtonVariant.inverse => 'inverse',
    };

    double mapOpacity(Map<String, dynamic> map, String key, double fallback) {
      final v = map[key];
      if (v is num) return v.toDouble();
      return fallback;
    }

    final effectiveFillOpacity =
        mapOpacity(variantFillOpacityMap, variantKey, glassOpacity);
    final effectiveShadowOpacity =
        mapOpacity(variantShadowOpacityMap, variantKey, shadowOpacity);
    final effectiveBorderOpacity =
        mapOpacity(variantBorderOpacityMap, variantKey, borderOpacity);

    final resolvedRadius = _radiusForToken(
      radius,
      radiiMap,
      fallback: borderRadius,
    );

    final padding = _paddingForSize(size, paddingMap);
    final effectiveOnPressed = isLoading ? null : onPressed;

    final child = _buildContent(
      baseTextStyle,
      foreground: resolved.foreground,
      iconGap: iconGap,
      loaderStrokeWidth: loaderStrokeWidth,
    );

    final buttonBody = AnimatedOpacity(
      duration: motion.fast,
      opacity: effectiveOnPressed == null ? disabledOpacity : 1.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(resolvedRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(resolvedRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: effectiveShadowOpacity),
                  blurRadius: 22,
                  spreadRadius: 0,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(resolvedRadius),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          resolved.background.withValues(
                              alpha: (effectiveFillOpacity * 1.15)
                                  .clamp(0.0, 1.0)),
                          resolved.background.withValues(
                              alpha: (effectiveFillOpacity * 0.70)
                                  .clamp(0.0, 1.0)),
                        ],
                      ),
                      border: Border.all(
                        color: resolved.border
                            .withValues(alpha: effectiveBorderOpacity),
                        width: resolved.borderWidth,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(resolvedRadius),
                        border: Border.all(
                          color:
                              Colors.white.withValues(alpha: highlightOpacity),
                          width: 0.8,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: padding,
                  child: DefaultTextStyle.merge(
                    style: baseTextStyle.copyWith(color: resolved.foreground),
                    child: IconTheme(
                      data: IconThemeData(
                          color: resolved.foreground,
                          size: baseTextStyle.fontSize),
                      child: Center(child: child),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return GestureDetector(
      onTap: effectiveOnPressed,
      child: buttonBody,
    );
  }

  Widget _buildContent(
    TextStyle textStyle, {
    required Color foreground,
    required double iconGap,
    required double loaderStrokeWidth,
  }) {
    final hasLabel = label.trim().isNotEmpty;

    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: textStyle.fontSize,
            height: textStyle.fontSize,
            child: CircularProgressIndicator(
              strokeWidth: loaderStrokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(foreground),
            ),
          ),
          if (hasLabel) ...[
            SizedBox(width: iconGap),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ),
          ],
        ],
      );
    }

    final children = <Widget>[];
    if (leadingIcon != null) {
      children.add(IconTheme(
        data: IconThemeData(size: textStyle.fontSize, color: foreground),
        child: leadingIcon!,
      ));
      if (hasLabel || trailingIcon != null) {
        children.add(SizedBox(width: iconGap));
      }
    }
    if (hasLabel) {
      children.add(
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ),
      );
    }
    if (trailingIcon != null) {
      if (hasLabel || leadingIcon != null) {
        children.add(SizedBox(width: iconGap));
      }
      children.add(IconTheme(
        data: IconThemeData(size: textStyle.fontSize, color: foreground),
        child: trailingIcon!,
      ));
    }

    // For single-icon-only buttons, avoid Row constraints that can overflow
    if (children.length == 1 && leadingIcon != null) {
      return Center(
        child: SizedBox(
          width: textStyle.fontSize,
          height: textStyle.fontSize,
          child: FittedBox(
            fit: BoxFit.contain,
            child: children.first,
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  double _radiusForToken(
    FlawlessButtonRadius token,
    Map<String, dynamic> radiiMap, {
    required double fallback,
  }) {
    final key = switch (token) {
      FlawlessButtonRadius.none => 'none',
      FlawlessButtonRadius.sm => 'sm',
      FlawlessButtonRadius.md => 'md',
      FlawlessButtonRadius.lg => 'lg',
      FlawlessButtonRadius.pill => 'pill',
    };

    final entry = radiiMap[key];
    if (entry is num) return entry.toDouble();
    return fallback;
  }

  _ResolvedGlassButtonColors _resolveColors(
    FlawlessButtonVariant variant,
    FlawlessColorScheme colors, {
    required Map<String, dynamic> colorsByVariant,
    required double outlineBorderWidth,
  }) {
    final key = switch (variant) {
      FlawlessButtonVariant.primary => 'primary',
      FlawlessButtonVariant.secondary => 'secondary',
      FlawlessButtonVariant.surface => 'surface',
      FlawlessButtonVariant.ghost => 'ghost',
      FlawlessButtonVariant.outline => 'outline',
      FlawlessButtonVariant.destructive => 'destructive',
      FlawlessButtonVariant.inverse => 'inverse',
    };

    final entry = colorsByVariant[key];
    if (entry is Map) {
      final map = entry.cast<String, dynamic>();
      final bg = map['background'];
      final fg = map['foreground'];
      final border = map['border'];

      final background = _tokenColor(bg, fallback: Colors.transparent);
      final foreground = _tokenColor(
        fg,
        fallback: _hexToColor(colors.onSurface),
      );
      final borderColor = _tokenColor(border, fallback: Colors.transparent);

      return _ResolvedGlassButtonColors(
        background: background,
        foreground: foreground,
        border: borderColor,
        borderWidth: outlineBorderWidth,
      );
    }

    // Fallbacks
    Color hex(String h) {
      h = h.replaceFirst('#', '');
      if (h.length == 6) h = 'FF$h';
      return Color(int.parse(h, radix: 16));
    }

    final primary = hex(colors.primary);
    final secondary = hex(colors.secondary);
    final onSurface = hex(colors.onSurface);
    final surface = hex(colors.surface);

    switch (variant) {
      case FlawlessButtonVariant.secondary:
        return _ResolvedGlassButtonColors(
          background: secondary,
          foreground: hex(colors.onSecondary),
          border: secondary,
          borderWidth: outlineBorderWidth,
        );
      case FlawlessButtonVariant.ghost:
        return _ResolvedGlassButtonColors(
          background: Colors.transparent,
          foreground: primary,
          border: Colors.transparent,
          borderWidth: outlineBorderWidth,
        );
      case FlawlessButtonVariant.outline:
        return _ResolvedGlassButtonColors(
          background: Colors.transparent,
          foreground: primary,
          border: primary,
          borderWidth: outlineBorderWidth,
        );
      case FlawlessButtonVariant.destructive:
        final err = hex(colors.error);
        return _ResolvedGlassButtonColors(
          background: err,
          foreground: hex(colors.onError),
          border: err,
          borderWidth: outlineBorderWidth,
        );
      case FlawlessButtonVariant.primary:
        return _ResolvedGlassButtonColors(
          background: primary,
          foreground: hex(colors.onPrimary),
          border: primary,
          borderWidth: outlineBorderWidth,
        );
      case FlawlessButtonVariant.surface:
        return _ResolvedGlassButtonColors(
          background: surface,
          foreground: onSurface,
          border: surface,
          borderWidth: outlineBorderWidth,
        );
      case FlawlessButtonVariant.inverse:
        return _ResolvedGlassButtonColors(
          background: onSurface,
          foreground: surface,
          border: onSurface,
          borderWidth: outlineBorderWidth,
        );
    }
  }

  EdgeInsetsGeometry _paddingForSize(
    FlawlessButtonSize size,
    Map<String, dynamic> paddingMap,
  ) {
    final key = switch (size) {
      FlawlessButtonSize.sm => 'sm',
      FlawlessButtonSize.md => 'md',
      FlawlessButtonSize.lg => 'lg',
    };

    final entry = paddingMap[key];
    if (entry is Map) {
      final casted = entry.cast<String, dynamic>();
      final h = casted['h'];
      final v = casted['v'];
      if (h is num && v is num) {
        return EdgeInsets.symmetric(
            horizontal: h.toDouble(), vertical: v.toDouble());
      }
    }

    return EdgeInsets.zero;
  }

  double _fontSizeForSize(double baseSize, FlawlessButtonSize size) {
    switch (size) {
      case FlawlessButtonSize.sm:
        return baseSize - 2;
      case FlawlessButtonSize.lg:
        return baseSize + 2;
      case FlawlessButtonSize.md:
        return baseSize;
    }
  }

  FontWeight _parseFontWeight(String weight) {
    switch (weight) {
      case 'bold':
        return FontWeight.bold;
      case 'w100':
        return FontWeight.w100;
      case 'w200':
        return FontWeight.w200;
      case 'w300':
        return FontWeight.w300;
      case 'w400':
        return FontWeight.w400;
      case 'w500':
        return FontWeight.w500;
      case 'w600':
        return FontWeight.w600;
      case 'w700':
        return FontWeight.w700;
      case 'w800':
        return FontWeight.w800;
      case 'w900':
        return FontWeight.w900;
      case 'normal':
      default:
        return FontWeight.normal;
    }
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  Color _tokenColor(Object? token, {required Color fallback}) {
    if (token is String) {
      if (token == 'transparent') return Colors.transparent;
      if (token.startsWith('#')) return _hexToColor(token);
    }
    return fallback;
  }
}

class _ResolvedGlassButtonColors {
  final Color background;
  final Color foreground;
  final Color border;
  final double borderWidth;

  _ResolvedGlassButtonColors({
    required this.background,
    required this.foreground,
    required this.border,
    required this.borderWidth,
  });
}
