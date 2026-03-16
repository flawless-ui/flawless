<p align="center">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset=".github/assets/logo-dark.svg">
   <source media="(prefers-color-scheme: light)" srcset=".github/assets/logo-light.svg">
   <img alt="Flawless logo" src=".github/assets/logo-light.svg" width="400">
 </picture>
</p>

<p align="center">
  <a href="https://pub.dev/packages/flawless_core"><img src="https://img.shields.io/pub/v/flawless_core?include_prereleases&label=version&color=blue" alt="Pub Version"></a>
  <a href="https://github.com/flawless-ui/flawless/actions/workflows/verify.yml"><img src="https://github.com/flawless-ui/flawless/actions/workflows/verify.yml/badge.svg" alt="Build Status"></a>
  <a href="https://pub.dev/packages/flawless_core"><img src="https://img.shields.io/pub/dt/flawless_core" alt="Pub Downloads"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-green.svg" alt="License"></a>
  <a href="https://discord.gg/J7MuwrAPCT"><img src="https://img.shields.io/discord/1478174538104836227?label=discord&color=7289da" alt="Discord"></a>
  <a href="https://github.com/invertase/melos"><img src="https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square" alt="Melos"></a>
</p>

## Beyond Material & Cupertino

**Flawless** is a headless styling engine for Flutter. You compose UI from **stable contracts and design tokens**, while swapping **concrete implementations** (Material 3, Glass, etc.) without rewriting your app.

### Why "Headless" for Flutter?

- **Design-system first**: tokens + component properties are decoupled from widgets.
- **Portable decisions**: re-skin or A/B test themes without refactoring screens.
- **CLI Orchestration**: managing 8+ packages and design systems at scale becomes a one-command task.

---

### The Flawless Suite

Flawless is composed of 8 modular packages to give you total control over your styling stack:

| Package | Purpose |
| :--- | :--- |
| **`flawless_cli`** | The brain of the operation. Orchestrates onboarding and suite syncing. |
| **`flawless_core`** | Foundational contracts and headless styling primitives. |
| **`flawless_ui`** | Facade widgets that dispatch to the active theme implementation. |
| **`flawless_theme`** | The bridge for standard Flutter theme integration and subtree overrides. |
| **`flawless_glass_theme`** | Tokens and logic for sophisticated glassmorphism. |
| **`flawless_glass_components`** | Glass-styled UI built on Flawless contracts. |
| **`flawless_material3_theme`** | Adaptive bridge for Material 3 design systems. |
| **`flawless_material3_components`** | Material 3 components powered by Flawless logic. |

---

## Quick Start

### 1) Install the CLI

```sh
dart pub global activate flawless_cli
```

### 2) Initialize

From the root of your Flutter project:

```sh
flawless_cli init --with-sample --wire-main
```

### 3) Switch Themes (Example)

```sh
flawless_cli add theme glass
```

---

## Development & Quality

This workspace is managed with Melos.

```sh
dart run melos bootstrap
dart run melos run analyze
dart run melos run test
```

## License

Open-sourced software licensed under the MIT license.
