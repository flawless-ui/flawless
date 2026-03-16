import 'command_interface.dart';

/// Handles the 'docs' command for flawless_cli.
class DocsCommand implements ICommand {
  @override
  Future<void> run(List<String> args) async {
    const docsUrl = 'https://flawless.codelabmw.dev/docs';
    print('Flawless documentation:');
    print('  $docsUrl');
    print('Open this URL in your browser to view the docs.');
  }
}
