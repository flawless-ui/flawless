import 'package:flawless_theme/flawless_theme.dart';
import 'package:flutter/material.dart';

import 'package:flawless_material3_components/flawless_material3_components.dart';
import 'package:flawless_material3_theme/flawless_material3_theme.dart';

import 'package:flawless_glass_components/flawless_glass_components.dart';
import 'package:flawless_glass_theme/flawless_glass_theme.dart';

export 'package:flawless_core/flawless_core.dart'
    show FlawlessCardVariant, FlawlessCardPadding;

class FlawlessCard extends StatelessWidget {
  final Widget child;
  final Widget? header;
  final Widget? footer;
  final Widget? media;
  final EdgeInsetsGeometry? margin;
  final FlawlessCardVariant variant;
  final FlawlessCardPadding padding;
  final VoidCallback? onTap;

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
