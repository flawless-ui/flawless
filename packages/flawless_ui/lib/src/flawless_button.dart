import 'package:flawless_theme/flawless_theme.dart';
import 'package:flutter/material.dart';

import 'package:flawless_material3_components/flawless_material3_components.dart';
import 'package:flawless_material3_theme/flawless_material3_theme.dart';

import 'package:flawless_glass_components/flawless_glass_components.dart';
import 'package:flawless_glass_theme/flawless_glass_theme.dart';

export 'package:flawless_core/flawless_core.dart'
    show FlawlessButtonVariant, FlawlessButtonSize, FlawlessButtonRadius;

/// A design-system aware button.
///
/// This widget selects the active Flawless implementation based on the current
/// `FlawlessDesignSystem` provided by `flawless_theme`.
class FlawlessButton extends StatelessWidget {
  /// The text label displayed inside the button.
  final String label;

  /// Called when the user taps the button.
  ///
  /// When `null`, the button is considered disabled.
  final VoidCallback? onPressed;

  /// The visual style variant of the button.
  final FlawlessButtonVariant variant;

  /// The size token used to resolve padding and typography.
  final FlawlessButtonSize size;

  /// The corner radius token used to resolve button rounding.
  final FlawlessButtonRadius radius;

  /// Whether to show a loading indicator.
  final bool isLoading;

  /// Optional leading icon shown before the label.
  final Widget? leadingIcon;

  /// Optional trailing icon shown after the label.
  final Widget? trailingIcon;

  /// Creates a Flawless button.
  const FlawlessButton({
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
    final designSystem = FlawlessTheme.maybeDesignSystemOf(context);

    if (designSystem is GlassDesignSystem) {
      return FlawlessGlassButton(
        label: label,
        onPressed: onPressed,
        variant: variant,
        size: size,
        radius: radius,
        isLoading: isLoading,
        leadingIcon: leadingIcon,
        trailingIcon: trailingIcon,
      );
    }

    if (designSystem is Material3DesignSystem) {
      return FlawlessMaterial3Button(
        label: label,
        onPressed: onPressed,
        variant: variant,
        size: size,
        radius: radius,
        isLoading: isLoading,
        leadingIcon: leadingIcon,
        trailingIcon: trailingIcon,
      );
    }

    return FlawlessMaterial3Button(
      label: label,
      onPressed: onPressed,
      variant: variant,
      size: size,
      radius: radius,
      isLoading: isLoading,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
    );
  }
}
