# flawless_theme

`flawless_theme` is the **theme orchestration layer** for Flawless.

It connects your app’s `ThemeData` with an active `FlawlessDesignSystem` and provides:

- `FlawlessThemeController` for runtime theme-mode switching
- `FlawlessThemeControllerProvider` for wiring controllers into the widget tree
- `FlawlessTheme` (InheritedWidget) for **subtree design-system overrides**
- `FlawlessThemeExtension` for storing the active design system in `ThemeData.extensions`

## Usage

Create a `ThemeData` from a concrete theme package (Material 3 or Glass), then read the design system anywhere.

```dart
final designSystem = FlawlessTheme.designSystemOf(context);
```

To override the design system for a subtree:

```dart
FlawlessTheme(
  designSystem: GlassDesignSystem(),
  child: const MyWidgetTree(),
)
```

## Notes

- `flawless_theme` depends on `flawless_core` for contracts.
- Concrete themes add a `FlawlessThemeExtension` via their `create...Theme(...)` helpers.
