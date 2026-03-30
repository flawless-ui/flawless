# flawless_material3_components

Material 3 component implementations for Flawless.

These widgets render a concrete Material 3 UI, reading tokens from the active `FlawlessDesignSystem` (via `flawless_theme`).

## Usage

```dart
MaterialApp(
  theme: createMaterial3Theme(designSystem: Material3DesignSystem()),
  home: const Scaffold(
    body: FlawlessMaterial3Button(label: 'Continue'),
  ),
);
```

## Pairs with

- `flawless_material3_theme` for `ThemeData` + design system tokens
- `flawless_ui` facade widgets (recommended for app code)
