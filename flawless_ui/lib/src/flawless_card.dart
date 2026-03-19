import 'package:flawless_theme/flawless_theme.dart';
import 'package:flutter/material.dart';

import 'package:flawless_material3_components/flawless_material3_components.dart';
import 'package:flawless_material3_theme/flawless_material3_theme.dart';

import 'package:flawless_glass_components/flawless_glass_components.dart';
import 'package:flawless_glass_theme/flawless_glass_theme.dart';

export 'package:flawless_core/flawless_core.dart'
    show FlawlessCardVariant, FlawlessCardPadding;

/// A design-system aware card.
///
/// This widget selects the active Flawless implementation based on the current
/// `FlawlessDesignSystem` provided by `flawless_theme`.
class FlawlessCard extends StatelessWidget {
  /// The main content of the card.
  final Widget child;

  /// Optional header content displayed above [child].
  final Widget? header;

  /// Optional footer content displayed below [child].
  final Widget? footer;

  /// Optional media content displayed at the top of the card.
  final Widget? media;

  /// External margin around the card.
  final EdgeInsetsGeometry? margin;

  /// The visual variant of the card.
  final FlawlessCardVariant variant;

  /// The padding token used to resolve internal spacing.
  final FlawlessCardPadding padding;

  /// Called when the card is tapped.
  final VoidCallback? onTap;

  /// Creates a Flawless card.
  const FlawlessCard({
    super.key,
    required this.child,
    this.header,
    this.footer,
    this.media,
    this.margin,
    this.variant = FlawlessCardVariant.elevated,
    this.padding = FlawlessCardPadding.md,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final designSystem = FlawlessTheme.maybeDesignSystemOf(context);

    if (designSystem is GlassDesignSystem) {
      return FlawlessGlassCard(
        child: child,
        header: header,
        footer: footer,
        media: media,
        margin: margin,
        padding: padding,
        onTap: onTap,
      );
    }

    if (designSystem is Material3DesignSystem) {
      return FlawlessMaterial3Card(
        child: child,
        header: header,
        footer: footer,
        media: media,
        margin: margin,
        variant: variant,
        padding: padding,
        onTap: onTap,
      );
    }

    return FlawlessMaterial3Card(
      child: child,
      header: header,
      footer: footer,
      media: media,
      margin: margin,
      variant: variant,
      padding: padding,
      onTap: onTap,
    );
  }
}
