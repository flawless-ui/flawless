import 'dart:io';

import 'package:pubspec_parse/pubspec_parse.dart';

Future<void> main(List<String> args) async {
  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    stderr
        .writeln('pubspec.yaml not found. Run from flawless_cli package root.');
    exitCode = 2;
    return;
  }

  final pubspec = Pubspec.parse(pubspecFile.readAsStringSync());
  final version = pubspec.version;
  if (version == null) {
    stderr.writeln('pubspec.yaml has no version.');
    exitCode = 2;
    return;
  }

  final target = File('lib/src/version/suite_version.dart');
  target.createSync(recursive: true);
  target.writeAsStringSync("const String flawlessSuiteVersion = '$version';\n");

  stdout.writeln('Synced flawlessSuiteVersion=$version');
}
