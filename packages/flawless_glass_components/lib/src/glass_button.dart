import 'dart:ui';

import 'package:flawless_core/flawless_core.dart';
import 'package:flawless_theme/flawless_theme.dart';
import 'package:flutter/material.dart';
import 'package:flawless_glass_theme/flawless_glass_theme.dart';

export 'package:flawless_core/flawless_core.dart'
    show FlawlessButtonVariant, FlawlessButtonSize;

class FlawlessGlassButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final FlawlessButtonVariant variant;
  final FlawlessButtonSize size;
  final bool isLoading;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  const FlawlessGlassButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = FlawlessButtonVariant.primary,
    this.size = FlawlessButtonSize.md,
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
    final iconGap = props.doubleValue('iconGap');
    final loaderStrokeWidth = props.doubleValue('loaderStrokeWidth');
    final blurSigma = props.doubleValue('glassBlurSigma');
    final glassOpacity = props.doubleValue('glassOpacity');
    final borderOpacity = props.doubleValue('borderOpacity');
    final highlightOpacity = props.doubleValue('highlightOpacity');
    final shadowOpacity = props.doubleValue('shadowOpacity');

    final baseTextStyle = TextStyle(
      fontFamily: textStyleToken.fontFamily,
      fontSize: _fontSizeForSize(textStyleToken.fontSize, size),
      fontWeight: _parseFontWeight(textStyleToken.fontWeight),
    );

    final resolved =
        _resolveColors(variant, colors, outlineBorderWidth: outlineBorderWidth);

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
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: shadowOpacity),
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
                      borderRadius: BorderRadius.circular(borderRadius),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          resolved.background.withValues(
                              alpha: (glassOpacity * 1.15).clamp(0.0, 1.0)),
                          resolved.background.withValues(
                              alpha: (glassOpacity * 0.70).clamp(0.0, 1.0)),
                        ],
                      ),
                      border: Border.all(
                        color: resolved.border.withValues(alpha: borderOpacity),
                        width: resolved.borderWidth,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius),
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
          SizedBox(width: iconGap),
          Text(label),
        ],
      );
    }

    final children = <Widget>[];
    if (leadingIcon != null) {
      children.add(leadingIcon!);
      children.add(SizedBox(width: iconGap));
    }
    children.add(Text(label));
    if (trailingIcon != null) {
      children.add(SizedBox(width: iconGap));
      children.add(trailingIcon!);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  _ResolvedGlassButtonColors _resolveColors(
    FlawlessButtonVariant variant,
    FlawlessColorScheme colors, {
    required double outlineBorderWidth,
  }) {
    Color hex(String h) {
      h = h.replaceFirst('#', '');
      if (h.length == 6) h = 'FF$h';
      return Color(int.parse(h, radix: 16));
    }

    final primary = hex(colors.primary);
    final secondary = hex(colors.secondary);
    final onSurface = hex(colors.onSurface);

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
          background: onSurface,
          foreground: primary,
          border: primary,
          borderWidth: outlineBorderWidth,
        );
      case FlawlessButtonVariant.outline:
        return _ResolvedGlassButtonColors(
          background: onSurface,
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
