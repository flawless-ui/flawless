import 'dart:io';
import 'package:flawless_cli/flawless_cli.dart';
import 'package:test/test.dart';

void main() {
  group('versioning', () {
    test('flawlessSuiteVersion is non-empty', () {
      expect(flawlessSuiteVersion.trim().isNotEmpty, isTrue);
    });

    test('flawlessSuiteVersion looks like a semver string', () {
      final semverLike = RegExp(r'^\d+\.\d+\.\d+(-[0-9A-Za-z.-]+)?$');
      expect(semverLike.hasMatch(flawlessSuiteVersion), isTrue);
    });
  });

  group('dashboard url resolution', () {
    test('defaults to flawlessDefaultDashboardUrl when config has none', () {
      expect(
        resolveDashboardBaseUrl(config: const FlawlessCliConfig()),
        flawlessDefaultDashboardUrl,
      );
    });

    test('uses config.dashboardUrl when provided', () {
      const cfg = FlawlessCliConfig(dashboardUrl: 'https://example.com');
      expect(resolveDashboardBaseUrl(config: cfg), 'https://example.com');
    });
  });

  group('config file operations', () {
    late Directory tempDir;
    late Directory originalDir;

    setUp(() {
      // A sandboxed temp directory
      tempDir = Directory.systemTemp.createTempSync('flawless_test_');

      // Temporarily override the current working directory so the CLI
      // reads/writes to the sandbox
      originalDir = Directory.current;
      Directory.current = tempDir;
    });

    tearDown(() {
      // Restore the real working directory and nuke the sandbox
      Directory.current = originalDir;
      tempDir.deleteSync(recursive: true);
    });

    test('successfully saves and loads flawless config', () async {
      const testConfig =
          FlawlessCliConfig(dashboardUrl: 'https://api.flawless.dev');

      await saveCliConfig(testConfig);

      final loadedConfig = await loadCliConfig();

      expect(loadedConfig.dashboardUrl, equals('https://api.flawless.dev'));
    });
  });
}
