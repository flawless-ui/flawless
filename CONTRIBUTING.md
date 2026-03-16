# Contributing

Thanks for contributing to Flawless.

This repository is a **Dart Pub Workspace** managed with **Melos 7.x**.

## Prerequisites

- Flutter (stable)
- Dart SDK compatible with the workspace constraint (`sdk: ^3.6.0`)

## Workspace commands

From the repo root:

```sh
dart pub get
dart run melos bootstrap
dart run melos run analyze
dart run melos run test
```

## Adding or updating a package

- Add the package directory to the root `workspace:` list in `pubspec.yaml`.
- In the package `pubspec.yaml`:
  - Ensure `resolution: workspace` is set.
  - Ensure `environment.sdk` is compatible with the root.
  - For internal dependencies, depend on the package by name (workspace resolution), not `path:`.

## Making changes

- Keep `flawless_core` pure Dart (no Flutter imports).
- Keep `flawless_ui` as a facade that dispatches to concrete implementations.
- Add tests for public behavior and keep them deterministic.

## Submitting a PR

- Ensure `dart run melos run analyze` and `dart run melos run test` pass.
- Include a short description of the user-facing impact.
