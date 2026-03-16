import 'command_interface.dart';

/// Handles the 'init' command for flawless_cli.
import '../utils/file_system.dart';
import '../utils/console.dart';
import '../registry/catalog.dart';

import 'package:yaml_edit/yaml_edit.dart';

import '../version/suite_version.dart';

String? _readOptionValue(List<String> args, String optionName) {
  final flag = '--$optionName';
  for (var i = 0; i < args.length; i++) {
    final a = args[i];
    if (a == flag) {
      if (i + 1 < args.length) return args[i + 1];
      return null;
    }
    if (a.startsWith('$flag=')) {
      return a.substring(flag.length + 1);
    }
  }
  return null;
}

class InitCommand implements ICommand {
  final IFileSystem fileSystem;

  InitCommand({IFileSystem? fileSystem})
      : fileSystem = fileSystem ?? DefaultFileSystem();

  @override
  Future<void> run(List<String> args) async {
    final withSample = args.contains('--with-sample');
    final wireMain = args.contains('--wire-main');
    final requestedTheme = _readOptionValue(args, 'theme');
    final theme =
        (requestedTheme ?? FlawlessCatalog.themes.first).trim().toLowerCase();
    if (!FlawlessCatalog.themes.contains(theme)) {
      Console.error(
        'Unknown theme "$theme". Available themes: ${FlawlessCatalog.themes.join(', ')}',
      );
      return;
    }

    Console.header('Welcome to Flawless');
    Console.dim('For commands list, run: flawless_cli --help');
    Console.info('');

    // Check for pubspec.yaml in current directory
    const pubspecPath = 'pubspec.yaml';
    if (!await fileSystem.fileExists(pubspecPath)) {
      Console.error(
        'No pubspec.yaml found. Run this command in the root of a Flutter project.',
      );
      return;
    }
    Console.info('Setting up Flawless in your Flutter project...');

    await _ensureCliConfigIsGitignored();

    // Add flawless_core, flawless_theme, and concrete theme/component packages to pubspec.yaml
    final pubspecContent = await fileSystem.readFile(pubspecPath);
    final didChange =
        await _ensureFlawlessDependencies(pubspecPath, pubspecContent);
    if (didChange) {
      Console.success('Updated pubspec.yaml with Flawless dependencies.');
    } else {
      Console.dim('pubspec.yaml already contains Flawless dependencies.');
    }
    // Create a flawless config file
    const configPath = 'flawless.yaml';
    if (!await fileSystem.fileExists(configPath)) {
      await fileSystem.writeFile(
        configPath,
        '# Flawless configuration\n'
        'theme: $theme\n'
        'components:\n',
      );
      Console.success('Created flawless.yaml config file.');
    } else {
      Console.dim('flawless.yaml already exists.');
    }
    Console.success('Flawless setup complete.');
    Console.info('');
    Console.command(r'$ flutter pub get');
    if (withSample) {
      await _writeActiveThemeFile(theme);
      await _generateSampleFiles();
      if (wireMain) {
        await _wireMainToFlawlessBootstrap();
      }
    } else if (wireMain) {
      Console.warning(
        '--wire-main has no effect without --with-sample. Skipping main.dart changes.',
      );
    }
  }

  Future<void> _writeActiveThemeFile(String themeName) async {
    await fileSystem.createDirectory('lib');

    const targetPath = 'lib/flawless_active_theme.dart';
    final normalized = themeName.trim().toLowerCase();
    final content = "const String flawlessActiveTheme = '$normalized';\n";
    await fileSystem.writeFile(targetPath, content);
  }

  Future<void> _ensureCliConfigIsGitignored() async {
    const gitignorePath = '.gitignore';
    const entry = '.flawless_cli.json';

    final exists = await fileSystem.fileExists(gitignorePath);
    final current = exists ? await fileSystem.readFile(gitignorePath) : '';

    if (current.split('\n').any((l) => l.trim() == entry)) {
      return;
    }

    final needsNewline = current.isNotEmpty && !current.endsWith('\n');
    final updated = '$current${needsNewline ? '\n' : ''}$entry\n';

    await fileSystem.writeFile(gitignorePath, updated);
    Console.success('Added $entry to .gitignore (token safety).');
  }

  Future<bool> _ensureFlawlessDependencies(
    String pubspecPath,
    String pubspecContent,
  ) async {
    final editor = YamlEditor(pubspecContent);

    Object? deps;
    try {
      deps = editor.parseAt(['dependencies']).value;
    } catch (_) {
      deps = null;
    }

    if (deps == null) {
      editor.update(['dependencies'], <String, Object?>{});
    } else if (deps is! Map) {
      Console.error('pubspec.yaml has an invalid dependencies section.');
      return false;
    }

    final versionConstraint = '^$flawlessSuiteVersion';
    final desired = <String, Object?>{
      'flawless_core': versionConstraint,
      'flawless_theme': versionConstraint,
      'flawless_ui': versionConstraint,
      'flawless_material3_theme': versionConstraint,
      'flawless_material3_components': versionConstraint,
      'flawless_glass_theme': versionConstraint,
      'flawless_glass_components': versionConstraint,
    };

    var changed = false;
    for (final entry in desired.entries) {
      final key = entry.key;
      final value = entry.value;
      Object? existing;
      try {
        existing = editor.parseAt(['dependencies', key]).value;
      } catch (_) {
        existing = null;
      }

      if (existing == null) {
        editor.update(['dependencies', key], value);
        changed = true;
      }
    }

    if (!changed) return false;

    await fileSystem.writeFile(pubspecPath, editor.toString());
    return true;
  }

  Future<void> _generateSampleFiles() async {
    await fileSystem.createDirectory('lib');

    const bootstrapPath = 'lib/flawless_bootstrap.dart';
    const demoHomePath = 'lib/flawless_demo_home_screen.dart';
    const bottomNavDemoPath = 'lib/flawless_bottom_nav_demo_screen.dart';
    const mixedThemeDemoPath = 'lib/flawless_mixed_theme_demo_screen.dart';
    const activeThemePath = 'lib/flawless_active_theme.dart';

    const activeThemeContent =
        "const String flawlessActiveTheme = 'material3';\n";

    const bootstrapContent = '''
import 'package:flutter/material.dart';
import 'package:flawless_theme/flawless_theme.dart';
import 'package:flawless_material3_theme/flawless_material3_theme.dart';
import 'package:flawless_glass_theme/flawless_glass_theme.dart';
import 'flawless_demo_home_screen.dart';
import 'flawless_active_theme.dart';

class FlawlessAppRoot extends StatefulWidget {
  const FlawlessAppRoot({super.key});

  @override
  State<FlawlessAppRoot> createState() => _FlawlessAppRootState();
}

class _FlawlessAppRootState extends State<FlawlessAppRoot> {
  late final FlawlessThemeController _controller;
  late final Material3DesignSystem _material3DesignSystem;
  late final GlassDesignSystem _glassDesignSystem;

  @override
  void initState() {
    super.initState();
    _controller = FlawlessThemeController();
    _material3DesignSystem = Material3DesignSystem();
    _glassDesignSystem = GlassDesignSystem();
  }

  ThemeData _createTheme(Brightness brightness) {
    if (flawlessActiveTheme == 'glass') {
      return createGlassTheme(
        designSystem: _glassDesignSystem,
        brightness: brightness,
      );
    }

    return createMaterial3Theme(
      designSystem: _material3DesignSystem,
      brightness: brightness,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlawlessThemeControllerProvider(
      controller: _controller,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return MaterialApp(
            themeMode: _controller.themeMode,
            theme: _createTheme(Brightness.light),
            darkTheme: _createTheme(Brightness.dark),
            home: const FlawlessDemoHomeScreen(),
          );
        },
      ),
    );
  }
}
''';

    const demoHomeContent = '''
import 'package:flutter/material.dart';
import 'package:flawless_ui/flawless_ui.dart';

import 'flawless_active_theme.dart';

import 'flawless_bottom_nav_demo_screen.dart';
import 'flawless_mixed_theme_demo_screen.dart';

class FlawlessDemoHomeScreen extends StatelessWidget {
  const FlawlessDemoHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isGlass = flawlessActiveTheme == 'glass';

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
          children: [
            _BrandHeader(
              isGlass: isGlass,
            ),
            const SizedBox(height: 14),
            _WelcomeCard(
              isGlass: isGlass,
            ),
            const SizedBox(height: 14),
            _SectionTitle('Start here'),
            const SizedBox(height: 10),
            _TutorialStep(
              icon: Icons.bolt_outlined,
              title: 'One-command theme swap',
              subtitle: isGlass
                  ? 'Volla! You swapped the entire app shell to Glass.'
                  : 'Run one CLI command and come back to see the UI change.',
              command: isGlass ? null : r'flawless_cli add theme glass',
              tag: isGlass ? 'Done' : 'Try it',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const FlawlessBottomNavDemoScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            _TutorialStep(
              icon: Icons.layers_outlined,
              title: 'Mix themes in one screen',
              subtitle:
                  'Glass at the root. Material 3 in a subtree. Same facade widgets, different implementations.',
              command: r'FlawlessTheme(designSystem: ...) // subtree override',
              tag: 'Overrides',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const FlawlessMixedThemeDemoScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            _SectionTitle('Quick tips'),
            const SizedBox(height: 10),
            FlawlessCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'We provide the scaffolding; you provide the brand.',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 10),
                    _TipLine(
                      title: 'Edit tokens',
                      value: 'DesignSystem.colorScheme + componentProperties',
                    ),
                    const SizedBox(height: 8),
                    _TipLine(
                      title: 'Swap theme',
                      value: 'flawless_active_theme.dart (generated)',
                    ),
                    const SizedBox(height: 8),
                    _TipLine(
                      title: 'Add components',
                      value: r'flawless_cli add component button',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  final bool isGlass;
  const _BrandHeader({required this.isGlass});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  'https://raw.githubusercontent.com/flawless-ui/flawless/main/.github/assets/flawless.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Text('F', style: TextStyle(fontWeight: FontWeight.w900)),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to Flawless',
                    style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isGlass ? 'Theme: Glass' : 'Theme: Material 3',
                    style: textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Headless UI, in Flutter.',
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  final bool isGlass;
  const _WelcomeCard({required this.isGlass});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return FlawlessCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'So glad to have you here.',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            isGlass
                ? 'Nice. You’re running the Glass implementation. Now explore overrides and tweak the design system tokens.'
                : 'This starter app is your mini tutorial hub. Start by swapping the theme using one CLI command—then come back and feel the difference.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.72),
                  height: 1.35,
                ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 0.2,
          ),
    );
  }
}

class _TutorialStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? command;
  final String tag;
  final VoidCallback onTap;

  const _TutorialStep({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.command,
    required this.tag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return FlawlessCard(
      onTap: onTap,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.black.withValues(alpha: 0.04),
                  ),
                  child: Icon(icon, color: cs.onSurface.withValues(alpha: 0.7)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: Colors.black.withValues(alpha: 0.04),
                  ),
                  child: Text(
                    tag,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: cs.onSurface.withValues(alpha: 0.7),
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.72),
                    height: 1.3,
                  ),
            ),
            if (command != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  command!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        color: Colors.white.withValues(alpha: 0.92),
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ],
      ),
    );
  }
}

class _TipLine extends StatelessWidget {
  final String title;
  final String value;
  const _TipLine({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 92,
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: cs.onSurface.withValues(alpha: 0.7),
                ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.72),
                  height: 1.25,
                ),
          ),
        ),
      ],
    );
  }
}
''';

    const bottomNavDemoContent = '''
import 'package:flutter/material.dart';
import 'package:flawless_ui/flawless_ui.dart';

import 'flawless_active_theme.dart';

class FlawlessBottomNavDemoScreen extends StatefulWidget {
  const FlawlessBottomNavDemoScreen({super.key});

  @override
  State<FlawlessBottomNavDemoScreen> createState() => _FlawlessBottomNavDemoScreenState();
}

class _FlawlessBottomNavDemoScreenState extends State<FlawlessBottomNavDemoScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final isGlass = flawlessActiveTheme == 'glass';
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      extendBody: true,
      backgroundColor: cs.surface,
      appBar: AppBar(title: const Text('One-command swap')),
      bottomNavigationBar: FlawlessBottomNavBar(
        items: [
          FlawlessBottomNavItem(iconCodePoint: Icons.home_outlined.codePoint, label: 'Home'),
          FlawlessBottomNavItem(iconCodePoint: Icons.pie_chart_outline.codePoint, label: 'Portfolio'),
          FlawlessBottomNavItem(iconCodePoint: Icons.person_outline.codePoint, label: 'Profile'),
        ],
        currentIndex: _index,
        onChanged: (i) => setState(() => _index = i),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 160),
            children: [
              Text(
                'This is your app shell. Swap themes without refactoring screens.',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 10),
              _PromptTile(text: 'How much did I spend last month?'),
              const SizedBox(height: 10),
              _PromptTile(text: 'What categories did I spend the most on?'),
              const SizedBox(height: 10),
              _PromptTile(text: 'What’s my current savings streak?'),
              const SizedBox(height: 10),
              _PromptTile(text: 'How much did I save last month?'),
              const SizedBox(height: 22),
              FlawlessCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isGlass ? 'You have tried it now!' : 'Try the swap',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isGlass
                            ? 'Nice. Now open Glass tokens and make it yours.'
                            : 'Run the command below, then hot-restart the app.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: cs.onSurface.withValues(alpha: 0.72),
                              height: 1.3,
                            ),
                      ),
                      if (!isGlass) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            r'flawless_cli add theme glass',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontFamily: 'monospace',
                                  color: Colors.white.withValues(alpha: 0.92),
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height * 0.15,
            child: IgnorePointer(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    isGlass ? 'Volla! Theme swapped → Glass' : 'Swap theme with 1 command →',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PromptTile extends StatelessWidget {
  final String text;
  const _PromptTile({required this.text});

  @override
  Widget build(BuildContext context) {
    return FlawlessCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}

''';

    const mixedThemeDemoContent = '''
import 'package:flutter/material.dart';
import 'package:flawless_glass_theme/flawless_glass_theme.dart';
import 'package:flawless_material3_theme/flawless_material3_theme.dart';
import 'package:flawless_theme/flawless_theme.dart';
import 'package:flawless_ui/flawless_ui.dart';

class FlawlessMixedThemeDemoScreen extends StatefulWidget {
  const FlawlessMixedThemeDemoScreen({super.key});

  @override
  State<FlawlessMixedThemeDemoScreen> createState() => _FlawlessMixedThemeDemoScreenState();
}

class _FlawlessMixedThemeDemoScreenState extends State<FlawlessMixedThemeDemoScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final glass = GlassDesignSystem();
    final material3 = Material3DesignSystem();

    final items = <FlawlessBottomNavItem>[
      FlawlessBottomNavItem(iconCodePoint: Icons.home_outlined.codePoint, label: 'Home'),
      FlawlessBottomNavItem(iconCodePoint: Icons.pie_chart_outline.codePoint, label: 'Portfolio'),
      FlawlessBottomNavItem(iconCodePoint: Icons.person_outline.codePoint, label: 'Profile'),
    ];

    return FlawlessTheme(
      designSystem: glass,
      child: Builder(
        builder: (context) {
          return Scaffold(
            extendBody: true,
            backgroundColor: const Color(0xFFF2F2F2),
            appBar: AppBar(title: const Text('Mixed Themes Demo')),
            bottomNavigationBar: FlawlessBottomNavBar(
              items: items,
              currentIndex: _index,
              onChanged: (i) => setState(() => _index = i),
            ),
            body: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.86),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'Glass root • Material 3 subtree',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FlawlessCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Theme overrides, but still one API',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Your app uses Flawless facade widgets. The active design system decides the visuals. Below, a Material 3 subtree is embedded inside a Glass shell.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.72),
                                height: 1.3,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FlawlessButton(label: 'Glass button', onPressed: () {}, variant: FlawlessButtonVariant.secondary,),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Material 3 cards (subtree override)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                FlawlessTheme(
                  designSystem: material3,
                  child: Column(
                    children: [
                      for (var i = 0; i < 10; i++) ...[
                        FlawlessCard(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Material 3 card #\${i + 1}',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'This subtree is forced to Material 3 via FlawlessTheme override.',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.72),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

''';

    await fileSystem.writeFile(activeThemePath, activeThemeContent);
    await fileSystem.writeFile(bootstrapPath, bootstrapContent);
    await fileSystem.writeFile(demoHomePath, demoHomeContent);
    await fileSystem.writeFile(bottomNavDemoPath, bottomNavDemoContent);
    await fileSystem.writeFile(mixedThemeDemoPath, mixedThemeDemoContent);
    Console.success('Generated sample app in lib/.');
  }

  Future<void> _wireMainToFlawlessBootstrap() async {
    const mainPath = 'lib/main.dart';
    if (!await fileSystem.fileExists(mainPath)) {
      Console.warning(
          'lib/main.dart not found, cannot wire main automatically.');
      return;
    }

    const mainContent = '''
import 'package:flutter/material.dart';
import 'flawless_bootstrap.dart';

void main() {
  runApp(const FlawlessAppRoot());
}
''';

    await fileSystem.writeFile(mainPath, mainContent);
    Console.success('Rewrote lib/main.dart to use FlawlessAppRoot.');
  }
}
