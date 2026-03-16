import 'dart:convert';
import 'dart:io';

import 'command_interface.dart';
import '../utils/file_system.dart';
import '../utils/config.dart';
import '../registry/catalog.dart';
import '../utils/console.dart';

/// Handles the 'add' command for flawless_cli.
class AddCommand implements ICommand {
  final IFileSystem fileSystem;

  AddCommand({IFileSystem? fileSystem})
      : fileSystem = fileSystem ?? DefaultFileSystem();

  @override
  Future<void> run(List<String> args) async {
    if (args.isEmpty) {
      Console.info('Usage: flawless_cli add <theme|component> <name>');
      return;
    }
    final type = args[0];
    final name = args.length > 1 ? args[1] : null;
    if (name == null) {
      Console.warning(
          'Please specify the name of the theme or component to add.');
      return;
    }
    const configPath = 'flawless.yaml';
    if (!await fileSystem.fileExists(configPath)) {
      Console.error(
          'flawless.yaml config file not found. Run "flawless_cli init" first.');
      return;
    }
    final configContent = await fileSystem.readFile(configPath);
    String updatedConfig = configContent;

    final knownThemes = FlawlessCatalog.themes;
    if (type == 'theme') {
      updatedConfig =
          updatedConfig.replaceFirst(RegExp(r'theme:.*'), 'theme: $name');
      Console.success('Set theme to "$name" in flawless.yaml.');
      await _writeActiveThemeFile(name);
      if (!knownThemes.contains(name)) {
        Console.warning(
            '"$name" is not in the list of known themes (${knownThemes.join(', ')}).');
      }
      Console.dim(
          'Add the theme package to your pubspec.yaml and import it in your app.');
    } else if (type == 'component') {
      // First, check if this is a known premium preset. If so, attempt to
      // scaffold it from the Flawless SaaS backend.
      final preset = FlawlessCatalog.findPremiumPreset(name);

      if (preset != null) {
        await _scaffoldPremiumPreset(preset);
        return;
      }

      if (!FlawlessCatalog.isFreeComponentAvailable(name)) {
        Console.warning(
            'This component is not yet available in the Private Beta.');
        return;
      }

      if (!updatedConfig.contains('components:')) {
        updatedConfig += '\ncomponents:\n';
      }
      final alreadyInConfig = updatedConfig.contains('- $name');
      if (!alreadyInConfig) {
        updatedConfig =
            updatedConfig.replaceFirst('components:', 'components:\n  - $name');
        Console.success('Added "$name" to components in flawless.yaml.');
      } else {
        Console.info('Component "$name" already exists in flawless.yaml.');
      }

      Console.dim(
          'Add the component package to your pubspec.yaml and import it in your app.');

      await _scaffoldFreeComponentExample(name);
    } else {
      Console.error('Unknown type: $type. Use "theme" or "component".');
      return;
    }
    await fileSystem.writeFile(configPath, updatedConfig);
    Console.dim('Updated flawless.yaml config file.');
  }

  Future<void> _writeActiveThemeFile(String themeName) async {
    await fileSystem.createDirectory('lib');

    const targetPath = 'lib/flawless_active_theme.dart';
    final normalized = themeName.trim().toLowerCase();
    final content = "const String flawlessActiveTheme = '$normalized';\n";
    await fileSystem.writeFile(targetPath, content);

    Console.success('Updated $targetPath (one-command theme swap).');
  }

  Future<void> _scaffoldFreeComponentExample(String name) async {
    // All paths are relative to the project root where flawless.yaml lives.
    await fileSystem.createDirectory('lib/widgets');

    switch (name) {
      case 'button':
        if (await fileSystem
            .fileExists('lib/widgets/flawless_button_example.dart')) {
          Console.dim(
              'Example already exists: lib/widgets/flawless_button_example.dart');
          break;
        }
        await fileSystem.writeFile(
          'lib/widgets/flawless_button_example.dart',
          '''import 'package:flutter/material.dart';
import 'package:flawless_ui/flawless_ui.dart';

class FlawlessButtonExample extends StatelessWidget {
  const FlawlessButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: const [
        FlawlessButton(label: 'Primary'),
        FlawlessButton(
          label: 'Secondary',
          variant: FlawlessButtonVariant.secondary,
        ),
        FlawlessButton(
          label: 'Outline',
          variant: FlawlessButtonVariant.outline,
        ),
      ],
    );
  }
}
''',
        );
        Console.info('Wrote lib/widgets/flawless_button_example.dart');
        break;
      case 'card':
        if (await fileSystem
            .fileExists('lib/widgets/flawless_card_example.dart')) {
          Console.dim(
              'Example already exists: lib/widgets/flawless_card_example.dart');
          break;
        }
        await fileSystem.writeFile(
          'lib/widgets/flawless_card_example.dart',
          '''import 'package:flutter/material.dart';
import 'package:flawless_ui/flawless_ui.dart';

class FlawlessCardExample extends StatelessWidget {
  const FlawlessCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const FlawlessCard(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text('This card swaps with your active Flawless design system.'),
      ),
    );
  }
}
''',
        );
        Console.info('Wrote lib/widgets/flawless_card_example.dart');
        break;
      case 'bottom_nav':
        if (await fileSystem
            .fileExists('lib/widgets/flawless_bottom_nav_example.dart')) {
          Console.dim(
              'Example already exists: lib/widgets/flawless_bottom_nav_example.dart');
          break;
        }
        await fileSystem.writeFile(
          'lib/widgets/flawless_bottom_nav_example.dart',
          '''import 'package:flutter/material.dart';
import 'package:flawless_ui/flawless_ui.dart';

class FlawlessBottomNavExample extends StatefulWidget {
  const FlawlessBottomNavExample({super.key});

  @override
  State<FlawlessBottomNavExample> createState() => _FlawlessBottomNavExampleState();
}

class _FlawlessBottomNavExampleState extends State<FlawlessBottomNavExample> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: FlawlessBottomNavBar(
        items: [
          FlawlessBottomNavItem(iconCodePoint: Icons.home_outlined.codePoint, label: 'Home'),
          FlawlessBottomNavItem(iconCodePoint: Icons.pie_chart_outline.codePoint, label: 'Portfolio'),
          FlawlessBottomNavItem(iconCodePoint: Icons.person_outline.codePoint, label: 'Profile'),
        ],
        currentIndex: _index,
        onChanged: (i) => setState(() => _index = i),
      ),
      body: Center(
        child: Text('Selected tab: \$_index'),
      ),
    );
  }
}
''',
        );
        Console.info('Wrote lib/widgets/flawless_bottom_nav_example.dart');
        break;
    }
  }

  Future<void> _scaffoldPremiumPreset(PremiumPreset preset) async {
    final config = await loadCliConfig();
    final token = config.apiToken ?? Platform.environment['FLAWLESS_API_TOKEN'];
    if (token == null || token.isEmpty) {
      Console.error(
          'No API token configured. Run "flawless_cli auth <API_TOKEN>" in this project first.');
      return;
    }

    final baseUrl = resolveDashboardBaseUrl(config: config);

    Uri uri;
    try {
      uri = Uri.parse(baseUrl).resolve('/api/cli/presets/${preset.id}');
    } catch (e) {
      print('Error: Invalid FLAWLESS_DASHBOARD_URL: $baseUrl');
      return;
    }

    final client = HttpClient();
    try {
      final request = await client.postUrl(uri);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode({'token': token}));

      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();

      if (response.statusCode != 200) {
        Console.error(
            'Failed to scaffold preset "${preset.id}" (HTTP ${response.statusCode}).');
        Console.dim(body);
        return;
      }

      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) {
        Console.error('Unexpected response when scaffolding preset.');
        Console.dim(body);
        return;
      }

      final files = decoded['files'];
      if (files is! List) {
        Console.error('Preset response did not include any files.');
        return;
      }

      for (final f in files) {
        if (f is! Map<String, dynamic>) continue;
        final path = f['path']?.toString();
        final content = f['content']?.toString();
        if (path == null || content == null) continue;

        // Ensure directory exists.
        final lastSlash = path.lastIndexOf('/');
        if (lastSlash > 0) {
          final dirPath = path.substring(0, lastSlash);
          await fileSystem.createDirectory(dirPath);
        }

        await fileSystem.writeFile(path, content);
        Console.info('Wrote $path');
      }

      Console.success(
          'Scaffolded premium preset "${preset.id}". Import the generated widgets into your Flutter app as needed.');
    } on SocketException catch (e) {
      Console.error('Network error while calling $baseUrl: ${e.message}');
    } catch (e) {
      Console.error('Unexpected error while scaffolding preset: $e');
    } finally {
      client.close(force: true);
    }
  }
}
