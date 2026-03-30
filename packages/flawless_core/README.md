
# flawless_core

**flawless_core** is the foundational, platform-agnostic package for the Flawless theming and component library. It defines pure Dart abstract contracts for design systems and component properties, enabling modular, composable, and customizable UI architectures for Flutter and beyond.

## Mission

Provide a source of truth for theming and component properties, with zero Flutter dependencies. All concrete implementations and UI logic are layered above this package.

## Architectural Principles

- **Loose Coupling:** No dependencies on higher layers or concrete implementations.
- **Platform Agnostic:** Pure Dart, no `package:flutter` imports.
- **Composition over Inheritance:** No base component class; contracts are designed for composition.

## Abstract Contracts

- `FlawlessDesignSystem`: Defines the design system, exposing color scheme, typography, and component properties.
- `FlawlessColorScheme`: Abstracts color definitions (primary, secondary, background, etc.).
- `FlawlessTypography`: Abstracts typography styles (display, headline, body, etc.).
- `FlawlessTextStyle`: Abstracts text style properties (font family, size, weight, etc.).
- `FlawlessComponentProperties`: Abstracts component-specific properties as a key-value map.

## Usage Example

Implement these contracts in your own theme or component package:

```dart
class MyDesignSystem implements FlawlessDesignSystem {
 // ...implement required getters
}
```

## Layered Architecture

This package is intended to be used as the base for:

- Theme orchestrator packages (e.g., flawless_theme)
- Concrete theme packages (e.g., flawless_material3_theme)
- Component packages (e.g., flawless_material3_components)

## License & Contribution

Core contracts are free and open source. Contributions and feedback are welcome!
