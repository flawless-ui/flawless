# flawless_ui

`flawless_ui` is the **facade layer** for Flawless.

It exposes a stable, headless API (e.g. `FlawlessButton`, `FlawlessCard`) and **dispatches** to a concrete implementation depending on the active design system resolved by `flawless_theme`.

## Usage

Add a theme implementation (Material3 or Glass) and wrap your app with a `ThemeData` created by that theme package.

```dart
MaterialApp(
  theme: createMaterial3Theme(designSystem: Material3DesignSystem()),
  home: const Scaffold(
    body: FlawlessButton(label: 'Continue'),
  ),
);
```

## Notes

- If a concrete design system is not present, `flawless_ui` falls back to Material 3.
