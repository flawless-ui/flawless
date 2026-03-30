import 'command_interface.dart';
import '../registry/catalog.dart';
import '../utils/console.dart';

/// Handles the 'list' command for flawless_cli.
class ListCommand implements ICommand {
  @override
  Future<void> run(List<String> args) async {
    final wantsThemes = args.contains('themes');
    final wantsComponents = args.contains('components');
    final wantsPrimitives = args.contains('primitives');
    final wantsPresets = args.contains('presets');

    final hasAnyFilter =
        wantsThemes || wantsComponents || wantsPrimitives || wantsPresets;
    final showThemes = !hasAnyFilter || wantsThemes;
    final showComponents = !hasAnyFilter || wantsComponents;
    final showPrimitives = !hasAnyFilter || wantsPrimitives;
    final showPresets = !hasAnyFilter || wantsPresets;

    if (showThemes) {
      Console.header('Available themes');
      for (final theme in FlawlessCatalog.themes) {
        Console.info('  - $theme');
      }
      Console.info('');
    }

    if (showComponents) {
      Console.header('Available components (free, scaffoldable)');
      for (final c in FlawlessCatalog.freeComponents) {
        Console.info('  - ${c.id.padRight(12)} (${c.addHint})');
      }
      Console.info('');
    }

    if (showPrimitives) {
      Console.header('Available primitives (free, import from package)');
      Console.dim('  Import: ${FlawlessCatalog.primitivesImport}');
      for (final p in FlawlessCatalog.primitives) {
        Console.info('  - $p');
      }
      Console.info('');
    }

    if (showPresets) {
      Console.header('Premium presets');
      Console.dim('Roadmap preview (unlocking requires authentication)');
      for (final preset in FlawlessCatalog.premiumPresets) {
        final line =
            '  - ${preset.id.padRight(16)} (requires ${tierLabel(preset.requiredTier)})';
        Console.dim(line);
        Console.dim('      ${preset.description}');
      }
    }
  }
}
