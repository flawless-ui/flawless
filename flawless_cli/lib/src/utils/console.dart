import 'dart:io';

/// Simple console helper for colored / structured output.
class Console {
  static bool get _supportsAnsi => stdout.supportsAnsiEscapes;

  static void info(String message) => _print(message);

  static void success(String message) =>
      _print(message, color: _AnsiColor.green, prefix: '✓ ');

  static void warning(String message) =>
      _print(message, color: _AnsiColor.yellow, prefix: '! ');

  static void error(String message) =>
      _print(message, color: _AnsiColor.red, prefix: '✗ ');

  static void header(String message) {
    _print('\n$message', color: _AnsiColor.cyan);
  }

  static void dim(String message) {
    _print(message, color: _AnsiColor.dim);
  }

  static void command(String message) {
    _print(message, color: _AnsiColor.blue, prefix: '\u001b[1m');
  }

  static void _print(String message, {String? prefix, _AnsiColor? color}) {
    final out = StringBuffer();
    if (prefix != null) out.write(prefix);

    if (!_supportsAnsi || color == null) {
      out.write(message);
      stdout.writeln(out.toString());
      return;
    }

    stdout.writeln('${color.code}$out$message\u001b[0m');
  }
}

enum _AnsiColor {
  red('\u001b[31m'),
  green('\u001b[32m'),
  yellow('\u001b[33m'),
  blue('\u001b[34m'),
  cyan('\u001b[36m'),
  dim('\u001b[2m');

  const _AnsiColor(this.code);
  final String code;
}
