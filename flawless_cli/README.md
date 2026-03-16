
# flawless_cli

The official CLI for the Flawless theming and component system for Flutter. Scaffold, add, and manage themes and components with ease.

## Architecture & Extensibility

- **Commands**: Each CLI command is implemented in its own class in `lib/src/commands/`, following the `ICommand` interface for consistency and testability.
- **File System**: All file operations are abstracted via `IFileSystem` for easy testing and future extension.
- **Entry Point**: The CLI entry point (`bin/flawless_cli.dart`) only routes commands and awaits their execution.
- **Async & DI**: All commands are async and can accept dependencies for maximum flexibility.

## Usage

Install globally (after publishing):

```sh
dart pub global activate flawless_cli
```

Run commands:

```sh
flawless_cli init
flawless_cli add theme material3
flawless_cli add component button
flawless_cli list
flawless_cli docs
```

## Contributing

- Add new commands by implementing `ICommand` and registering in the entry point.
- Write unit tests for command logic and utilities.
- Document new features and usage in this README.
