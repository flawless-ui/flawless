# liquid_fintech - Flawless Component Demo

A showcase Flutter application demonstrating the **Flawless UI** component library with blended theme capabilities. This app features a glass-morphism design system shell with Material3 action buttons via subtree theme overrides.

## Features

- **FlawlessCard** - A flexible card component with theme-aware styling
- **FlawlessButton** - Multi-variant button component supporting:
  - Primary, Secondary, Outline, Ghost, and Destructive variants
  - Small, Medium, and Large sizes
  - Configurable border radius tokens (none, sm, md, lg, pill)
  - Leading/trailing icons and loading states
- **Blended Themes** - Glass design system shell with Material3 button overrides

## Architecture

### Subtree Theme Override

The app uses `FlawlessTheme` subtree overrides to achieve blended theming:

```dart
// Glass shell (default theme)
FlawlessTheme(
  designSystem: GlassDesignSystem(),
  child: Scaffold(
    // ... glass UI
    
    // Material3 buttons within glass shell
    FlawlessTheme(
      designSystem: Material3DesignSystem(),
      child: Row(
        children: [
          FlawlessButton(label: 'Send', ...),
          FlawlessButton(label: 'Withdraw', variant: FlawlessButtonVariant.outline, ...),
        ],
      ),
    ),
  ),
)
```

### Token-Based Styling

All styling is driven by design system tokens, not hardcoded UI values:

| Token | Usage |
|-------|-------|
| `radii.md` | Default button border radius |
| `radii.pill` | Fully rounded button corners |
| `colors.primary.background` | Button fill color |
| `colors.primary.foreground` | Button text/icon color |
| `padding.md.h/v` | Button internal spacing |

### Icon-Only Buttons

Icon-only buttons should pass an empty label (`''`) and include an icon:

```dart
FlawlessButton(
  label: '',  // Empty string, not ' ' or null
  leadingIcon: const Icon(Icons.more_horiz),
  variant: FlawlessButtonVariant.outline,
  onPressed: () {},
)
```

## Running the App

```bash
flutter run
```

## Structure

- `lib/flawless_bootstrap.dart` - App entry point with theme configuration
- `lib/flawless_cow_screen.dart` - Main demo screen (C.O.W = Component of the Week)
- `assets/flawless-logo.png` - App logo asset

## Dependencies

- `flawless_ui` - Main UI facade package
- `flawless_theme` - Theme management and context extensions
- `flawless_glass_theme` - Glass design system tokens
- `flawless_material3_theme` - Material3 design system tokens
- `flawless_glass_components` - Glass component implementations
- `flawless_material3_components` - Material3 component implementations
