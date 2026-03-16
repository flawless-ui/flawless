import 'package:flutter/material.dart';
import 'material3_design_system.dart';

/// ThemeExtension for Material3DesignSystem
class Material3ThemeExtension extends ThemeExtension<Material3ThemeExtension> {
  final Material3DesignSystem designSystem;

  const Material3ThemeExtension({required this.designSystem});

  @override
  Material3ThemeExtension copyWith({Material3DesignSystem? designSystem}) {
    return Material3ThemeExtension(
      designSystem: designSystem ?? this.designSystem,
    );
  }

  @override
  Material3ThemeExtension lerp(
      ThemeExtension<Material3ThemeExtension>? other, double t) {
    if (other is! Material3ThemeExtension) return this;
    // For simplicity, do not interpolate design system properties
    return t < 0.5 ? this : other;
  }
}
