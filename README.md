<p align="center">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset=".github/assets/logo-dark.svg">
   <source media="(prefers-color-scheme: light)" srcset=".github/assets/logo-light.svg">
   <img alt="Flawless logo" src=".github/assets/logo-light.svg" width="400">
 </picture>
</p>

<p align="center">
  <a href="https://pub.dev/packages/flawless_cli"><img src="https://img.shields.io/pub/v/flawless_cli?include_prereleases&label=version&color=blue" alt="Pub Version"></a>
  <a href="https://github.com/flawless-ui/flawless/actions/workflows/verify.yml"><img src="https://github.com/flawless-ui/flawless/actions/workflows/verify.yml/badge.svg" alt="Build Status"></a>
  <a href="https://pub.dev/packages/flawless_cli"><img src="https://img.shields.io/pub/dm/flawless_cli?logo=dart" alt="Pub Downloads"></a>
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

## Project Structure Evolution

Flawless has been reorganized to separate core logic from community-driven innovation.

```text
flawless/
├── packages/           # 📦 Core Suite (160/160 Quality Score)
│   ├── flawless_core   # Headless contracts & primitives
│   ├── flawless_cli    # Orchestration tool
│   └── ...             # Theme & Component implementations
├── community/          # 🤝 Community Lab
│   ├── proposals/      # RFCs & Markdown specs for new components
│   └── experimental/   # Unfinished/Voted community builds
└── examples/           # 🚀 Showroom
    └── showcase_apps/  # Full-scale sample apps (e.g., Liquid Fintech)
```

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

## Contributing

Thank you for considering contributing to the Flawless suite! But make sure to check the [CONTRIBUTING.md](CONTRIBUTING.md) file first.

## Code of Conduct

In order to ensure that the Flawless community is welcoming to all, please review and abide by the [Code of Conduct](https://www.contributor-covenant.org/version/3/0/code_of_conduct/). Any violations of the code of conduct may be reported to Flawless Team (flawless@codelabmw.dev):

> - Participants will be tolerant of opposing views.
> - Participants must ensure that their language and actions are free of personal attacks and disparaging personal remarks.
> - When interpreting the words and actions of others, participants should always assume good intentions.
> - Behavior that can be reasonably considered harassment will not be tolerated.

## Security Vulnerabilities

If you discover a security vulnerability within Flawless, please send an e-mail to Flawless Team via [flawless@codelabmw.dev](mailto:flawless@codelabmw.dev). All security vulnerabilities will be promptly addressed.

## License

Open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).
