import 'package:flawless_core/flawless_core.dart';
import 'package:flutter/material.dart';
import 'package:flawless_theme/flawless_theme.dart';
import 'package:flawless_material3_theme/flawless_material3_theme.dart';

/// Button visual variants.
export 'package:flawless_core/flawless_core.dart'
    show FlawlessButtonVariant, FlawlessButtonSize, FlawlessButtonRadius;

/// A Material 3 styled button using Flawless contracts.
class FlawlessMaterial3Button extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final FlawlessButtonVariant variant;
  final FlawlessButtonSize size;
  final FlawlessButtonRadius radius;
  final bool isLoading;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  const FlawlessMaterial3Button({
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
      fallback: Material3DesignSystem(),
    );

    final colors = designSystem.colorScheme;
    final motion = designSystem.motion;
    final textStyleToken = designSystem.typography.bodyLarge;

    final defaultButtonComponent =
        Material3DesignSystem().componentProperties['button']!;
    final activeButtonComponent = designSystem.componentProperties['button'];
    final buttonProps =
        FlawlessComponentPropertiesReader.fromComponentProperties(
      defaults: defaultButtonComponent,
      active: activeButtonComponent,
    );
    final borderRadius = buttonProps.doubleValue('borderRadius');
    final disabledOpacity = buttonProps.doubleValue('disabledOpacity');
    final outlineBorderWidth = buttonProps.doubleValue('outlineBorderWidth');
    final paddingMap = buttonProps.mapValue('padding');
    final radiiMap = buttonProps.mapValue('radii');
    final iconGap = buttonProps.doubleValue('iconGap');
    final loaderStrokeWidth = buttonProps.doubleValue('loaderStrokeWidth');
    final colorsByVariant = buttonProps.mergedMap('colors');

    final resolvedRadius = _radiusForToken(
      radius,
      radiiMap,
      fallback: borderRadius,
    );

    // Map design tokens to concrete Flutter styles.
    final baseTextStyle = TextStyle(
      fontFamily: textStyleToken.fontFamily,
      fontSize: _fontSizeForSize(textStyleToken.fontSize, size),
      fontWeight: _parseFontWeight(textStyleToken.fontWeight),
    );

    final buttonColors = _resolveColorsForVariant(
      variant,
      colors,
      colorsByVariant: colorsByVariant,
      outlineBorderWidth: outlineBorderWidth,
    );

    final padding = _paddingForSize(size, paddingMap);

    final effectiveOnPressed = isLoading ? null : onPressed;

    final isDisabled = effectiveOnPressed == null;
    final background = isDisabled
        ? buttonColors.background.withValues(alpha: disabledOpacity)
        : buttonColors.background;
    final foreground = isDisabled
        ? buttonColors.foreground.withValues(alpha: disabledOpacity)
        : buttonColors.foreground;

    final child = _buildContent(
      baseTextStyle,
      foreground: foreground,
      iconGap: iconGap,
      loaderStrokeWidth: loaderStrokeWidth,
    );

    return AnimatedOpacity(
      duration: motion.fast,
      opacity: isDisabled ? disabledOpacity : 1.0,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: effectiveOnPressed,
          borderRadius: BorderRadius.circular(resolvedRadius),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(resolvedRadius),
              border: Border.all(
                color: buttonColors.borderSide.color,
                width: buttonColors.borderSide.style == BorderStyle.none
                    ? 0
                    : buttonColors.borderSide.width,
                style: buttonColors.borderSide.style,
              ),
            ),
            child: Padding(
              padding: padding,
              child: DefaultTextStyle.merge(
                style: baseTextStyle.copyWith(color: foreground),
                child: IconTheme(
                  data: IconThemeData(
                      size: baseTextStyle.fontSize, color: foreground),
                  child: Center(child: child),
                ),
              ),
            ),
          ),
        ),
      ),
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
              valueColor: AlwaysStoppedAnimation<Color>(
                foreground,
              ),
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
      children.add(leadingIcon!);
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
      children.add(trailingIcon!);
    }

    // For single-icon-only buttons, avoid Row constraints that can overflow
    if (children.length == 1 && leadingIcon != null) {
      return Center(child: children.first);
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

  _ResolvedButtonColors _resolveColorsForVariant(
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

      final needsBorder = variant == FlawlessButtonVariant.outline ||
          borderColor != Colors.transparent;
      return _ResolvedButtonColors(
        background: background,
        foreground: foreground,
        borderSide: needsBorder
            ? BorderSide(color: borderColor, width: outlineBorderWidth)
            : BorderSide.none,
        elevation: 0,
      );
    }

    switch (variant) {
      case FlawlessButtonVariant.secondary:
        return _ResolvedButtonColors(
          background: _hexToColor(colors.secondary),
          foreground: _hexToColor(colors.onSecondary),
        );
      case FlawlessButtonVariant.ghost:
        return _ResolvedButtonColors(
          background: Colors.transparent,
          foreground: _hexToColor(colors.primary),
          elevation: 0,
        );
      case FlawlessButtonVariant.outline:
        final primary = _hexToColor(colors.primary);
        return _ResolvedButtonColors(
          background: Colors.transparent,
          foreground: primary,
          borderSide: BorderSide(color: primary, width: outlineBorderWidth),
          elevation: 0,
        );
      case FlawlessButtonVariant.destructive:
        return _ResolvedButtonColors(
          background: _hexToColor(colors.error),
          foreground: _hexToColor(colors.onError),
        );
      case FlawlessButtonVariant.primary:
        return _ResolvedButtonColors(
          background: _hexToColor(colors.primary),
          foreground: _hexToColor(colors.onPrimary),
        );
      case FlawlessButtonVariant.surface:
        final surface = _hexToColor(colors.surface);
        return _ResolvedButtonColors(
          background: surface,
          foreground: _hexToColor(colors.onSurface),
        );
      case FlawlessButtonVariant.inverse:
        final onSurface = _hexToColor(colors.onSurface);
        return _ResolvedButtonColors(
          background: onSurface,
          foreground: _hexToColor(colors.surface),
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
          horizontal: h.toDouble(),
          vertical: v.toDouble(),
        );
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

class _ResolvedButtonColors {
  final Color background;
  final Color foreground;
  final BorderSide borderSide;
  final double elevation;

  _ResolvedButtonColors({
    required this.background,
    required this.foreground,
    BorderSide? borderSide,
    double? elevation,
  })  : borderSide = borderSide ?? BorderSide.none,
        elevation = elevation ?? 0.0;
}
