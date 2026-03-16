import 'package:flawless_core/flawless_core.dart';
import 'package:flutter/material.dart';
import 'package:flawless_theme/flawless_theme.dart';
import 'package:flawless_material3_theme/flawless_material3_theme.dart';

/// Button visual variants.
export 'package:flawless_core/flawless_core.dart'
    show FlawlessButtonVariant, FlawlessButtonSize;

/// A Material 3 styled button using Flawless contracts.
class FlawlessMaterial3Button extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final FlawlessButtonVariant variant;
  final FlawlessButtonSize size;
  final bool isLoading;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  const FlawlessMaterial3Button({
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
    final theme = Theme.of(context);
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
    final iconGap = buttonProps.doubleValue('iconGap');
    final loaderStrokeWidth = buttonProps.doubleValue('loaderStrokeWidth');

    // Map design tokens to concrete Flutter styles.
    final baseTextStyle = TextStyle(
      fontFamily: textStyleToken.fontFamily,
      fontSize: _fontSizeForSize(textStyleToken.fontSize, size),
      fontWeight: _parseFontWeight(textStyleToken.fontWeight),
    );

    final buttonColors = _resolveColorsForVariant(
      variant,
      colors,
      outlineBorderWidth: outlineBorderWidth,
    );

    final padding = _paddingForSize(size, paddingMap);

    final effectiveOnPressed = isLoading ? null : onPressed;

    final child = _buildContent(
      theme,
      baseTextStyle,
      foreground: buttonColors.foreground,
      iconGap: iconGap,
      loaderStrokeWidth: loaderStrokeWidth,
    );

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColors.background,
        foregroundColor: buttonColors.foreground,
        disabledBackgroundColor:
            buttonColors.background.withValues(alpha: disabledOpacity),
        disabledForegroundColor:
            buttonColors.foreground.withValues(alpha: disabledOpacity),
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(
            color: buttonColors.borderSide.color,
            width: buttonColors.borderSide.style == BorderStyle.none
                ? 0
                : buttonColors.borderSide.width,
            style: buttonColors.borderSide.style,
          ),
        ),
        textStyle: baseTextStyle,
        elevation: buttonColors.elevation,
        animationDuration: motion.fast,
      ),
      onPressed: effectiveOnPressed,
      child: child,
    );
  }

  Widget _buildContent(
    ThemeData theme,
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
              valueColor: AlwaysStoppedAnimation<Color>(
                foreground,
              ),
            ),
          ),
          SizedBox(width: iconGap),
          Text(label),
        ],
      );
    }

    final children = <Widget>[];
    if (leadingIcon != null) {
      children.add(IconTheme(
        data: IconThemeData(size: textStyle.fontSize, color: foreground),
        child: leadingIcon!,
      ));
      children.add(SizedBox(width: iconGap));
    }
    children.add(Text(label));
    if (trailingIcon != null) {
      children.add(SizedBox(width: iconGap));
      children.add(IconTheme(
        data: IconThemeData(size: textStyle.fontSize, color: foreground),
        child: trailingIcon!,
      ));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  _ResolvedButtonColors _resolveColorsForVariant(
    FlawlessButtonVariant variant,
    FlawlessColorScheme colors, {
    required double outlineBorderWidth,
  }) {
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
