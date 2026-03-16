# flawless_material3_theme

Material 3 design system implementation for Flawless.

This package provides:

- `Material3DesignSystem` tokens (colors, typography, spacing, motion, component properties)
- `createMaterial3Theme(...)` which builds a `ThemeData` and installs a `FlawlessThemeExtension`

## Usage

```dart
MaterialApp(
  theme: createMaterial3Theme(designSystem: Material3DesignSystem()),
  home: const Scaffold(body: Text('Hello')),
);
```

## Works with

- `flawless_theme` for design system resolution
- `flawless_ui` facade widgets
- `flawless_material3_components` concrete widget implementations
