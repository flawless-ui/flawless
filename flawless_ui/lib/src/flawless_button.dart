import 'package:flawless_theme/flawless_theme.dart';
import 'package:flutter/material.dart';

import 'package:flawless_material3_components/flawless_material3_components.dart';
import 'package:flawless_material3_theme/flawless_material3_theme.dart';

import 'package:flawless_glass_components/flawless_glass_components.dart';
import 'package:flawless_glass_theme/flawless_glass_theme.dart';

export 'package:flawless_core/flawless_core.dart'
    show FlawlessButtonVariant, FlawlessButtonSize;

class FlawlessButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final FlawlessButtonVariant variant;
  final FlawlessButtonSize size;
  final bool isLoading;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  const FlawlessButton({
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
    final designSystem = FlawlessTheme.maybeDesignSystemOf(context);

    if (designSystem is GlassDesignSystem) {
      return FlawlessGlassButton(
        label: label,
        onPressed: onPressed,
        variant: variant,
        size: size,
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
      isLoading: isLoading,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
    );
  }
}
