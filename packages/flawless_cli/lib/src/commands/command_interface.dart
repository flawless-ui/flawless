/// Interface for CLI commands to ensure consistency and testability.
abstract class ICommand {
  /// Runs the command with the provided arguments.
  Future<void> run(List<String> args);
}
