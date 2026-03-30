import 'package:args/args.dart';
import 'package:flawless_cli/src/commands/init_command.dart';
import 'package:flawless_cli/src/commands/add_command.dart';
import 'package:flawless_cli/src/commands/list_command.dart';
import 'package:flawless_cli/src/commands/docs_command.dart';
import 'package:flawless_cli/src/commands/auth_command.dart';
import 'package:flawless_cli/src/version/suite_version.dart';
import 'package:flawless_cli/src/utils/console.dart';

Future<void> main(List<String> arguments) async {
  final initParser = ArgParser()
    ..addFlag(
      'with-sample',
      negatable: false,
      help: 'Generate a sample flawless bootstrap and screen.',
    )
    ..addFlag(
      'wire-main',
      negatable: false,
      help: 'Rewrite lib/main.dart to use the generated FlawlessAppRoot.',
    )
    ..addOption(
      'theme',
      help: 'Initial theme to write to flawless.yaml (e.g. material3, glass).',
    );

  final parser = ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Show usage information.',
    )
    ..addFlag(
      'version',
      abbr: 'v',
      negatable: false,
      help: 'Print the current Flawless suite version.',
    )
    ..addCommand('init', initParser)
    ..addCommand('add')
    ..addCommand('list')
    ..addCommand('docs')
    ..addCommand('auth');

  final result = parser.parse(arguments);

  Future<void> printWelcome() async {
    Console.header('Welcome to Flawless');
    Console.dim('Opinionated architecture. Unopinionated styling.');
    Console.info('Version: $flawlessSuiteVersion');
    Console.info('');
    Console.header('Quick start');
    Console.command(r'$ flawless_cli init --with-sample --wire-main');
    Console.command(r'$ flawless_cli init --theme glass');
    Console.command(r'$ flawless_cli list');
    Console.command(r'$ flawless_cli list themes');
    Console.command(r'$ flawless_cli list components');
    Console.command(r'$ flawless_cli add theme glass');
    Console.command(r'$ flawless_cli add component button');
    Console.info('');
    Console.header('Commands');
    Console.info('init           Scaffold a new flawless-based Flutter app');
    Console.info('add            Add a theme or component to an existing app');
    Console.info('list           List available themes/components');
    Console.info('docs           Open documentation');
    Console.info(
        'auth           Verify an API token with the Flawless dashboard');
    Console.info('');
    Console.dim(
        'Tip: run "flawless_cli --help" to see flags for each command.');
  }

  if (result['version'] == true) {
    Console.info(flawlessSuiteVersion);
    return;
  }

  if (result['help'] == true || result.command == null) {
    await printWelcome();
    return;
  }

  switch (result.command!.name) {
    case 'init':
      await InitCommand().run(result.command!.arguments);
      break;
    case 'add':
      await AddCommand().run(result.command!.arguments);
      break;
    case 'list':
      await ListCommand().run(result.command!.arguments);
      break;
    case 'docs':
      await DocsCommand().run(result.command!.arguments);
      break;
    case 'auth':
      await AuthCommand().run(result.command!.arguments);
      break;
    default:
      Console.error('Unknown command: ${result.command!.name}');
      await printWelcome();
  }
}
