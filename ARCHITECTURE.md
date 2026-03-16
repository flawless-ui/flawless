# Architecture

Flawless is organized as layered packages so design decisions can be shared while widget implementations remain swappable.

## Dependency flow

```text
flawless_core
  -> flawless_theme
      -> flawless_ui
          -> flawless_material3_theme
          -> flawless_material3_components
          -> flawless_glass_theme
          -> flawless_glass_components
```

## Layers

- **`flawless_core`** (pure Dart)
  - Contracts for `FlawlessDesignSystem`, tokens, and component properties.

- **`flawless_theme`**
  - Runtime theme mode controller.
  - `FlawlessTheme` (InheritedWidget) for subtree overrides.
  - `FlawlessThemeExtension` for integration with `ThemeData.extensions`.

- **`flawless_ui`**
  - Facade widgets (headless adapters) like `FlawlessButton` and `FlawlessCard`.
  - Dispatches to the correct concrete widget based on the active design system.

- **Concrete implementations**
  - `flawless_material3_theme` + `flawless_material3_components`
  - `flawless_glass_theme` + `flawless_glass_components`

## Subtree overrides

If you need two design systems on the same screen, wrap a subtree:

- Use `FlawlessTheme(designSystem: ...)` around the subtree
- Facade widgets under that subtree will resolve tokens accordingly
