# flawless_glass_theme

Glassmorphism design system implementation for Flawless.

This package provides:

- `GlassDesignSystem` tokens
- `createGlassTheme(...)` which returns a `ThemeData` containing a `FlawlessThemeExtension`

## Usage

```dart
final ds = GlassDesignSystem();

MaterialApp(
  theme: createGlassTheme(designSystem: ds),
  home: const Scaffold(body: Text('Hello')),
);
```
