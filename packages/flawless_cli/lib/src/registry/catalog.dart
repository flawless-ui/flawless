class FreeComponent {
  final String id;
  final String label;
  final String addHint;

  const FreeComponent({
    required this.id,
    required this.label,
    required this.addHint,
  });
}

enum FlawlessTier {
  free,
  premiumStatic,
  premiumMotion,
  team,
}

class PremiumPreset {
  final String id;
  final String label;
  final FlawlessTier requiredTier;
  final String description;

  const PremiumPreset({
    required this.id,
    required this.label,
    required this.requiredTier,
    required this.description,
  });
}

FlawlessTier tierFromString(String raw) {
  switch (raw) {
    case 'premium_static':
      return FlawlessTier.premiumStatic;
    case 'premium_motion':
      return FlawlessTier.premiumMotion;
    case 'team':
      return FlawlessTier.team;
    case 'free':
    default:
      return FlawlessTier.free;
  }
}

String tierLabel(FlawlessTier tier) {
  switch (tier) {
    case FlawlessTier.free:
      return 'free';
    case FlawlessTier.premiumStatic:
      return 'premium_static';
    case FlawlessTier.premiumMotion:
      return 'premium_motion';
    case FlawlessTier.team:
      return 'team';
  }
}

bool tierSatisfies(FlawlessTier user, FlawlessTier required) {
  const order = [
    FlawlessTier.free,
    FlawlessTier.premiumStatic,
    FlawlessTier.premiumMotion,
    FlawlessTier.team,
  ];
  return order.indexOf(user) >= order.indexOf(required);
}

class FlawlessCatalog {
  static const themes = <String>[
    'material3',
    'glass',
  ];

  /// Free components.
  static const freeComponents = <FreeComponent>[
    FreeComponent(
      id: 'button',
      label: 'Button',
      addHint: 'flawless_cli add component button',
    ),
    FreeComponent(
      id: 'card',
      label: 'Card',
      addHint: 'flawless_cli add component card',
    ),
    FreeComponent(
      id: 'bottom_nav',
      label: 'Bottom navigation',
      addHint: 'flawless_cli add component bottom_nav',
    ),
  ];

  static const primitivesImport = 'package:flawless_ui/flawless_ui.dart';

  /// Stable primitives (non-scaffolded).
  static const primitives = <String>[
    'FlawlessButton (auto-swaps by active design system)',
    'FlawlessCard (auto-swaps by active design system)',
    'FlawlessBottomNavBar (auto-swaps by active design system)',
  ];

  static const premiumPresets = <PremiumPreset>[
    PremiumPreset(
      id: 'chat_input',
      label: 'Chat / Ask / Search input',
      requiredTier: FlawlessTier.premiumMotion,
      description:
          'Multi-label chat input with Ask/Search/Chat presets and smooth focus motion.',
    ),
    PremiumPreset(
      id: 'animated_counter',
      label: 'Animated metric counter',
      requiredTier: FlawlessTier.premiumMotion,
      description:
          'Animated number counter for stats and KPIs with float support.',
    ),
    PremiumPreset(
      id: 'expandable_card',
      label: 'Expandable card',
      requiredTier: FlawlessTier.premiumMotion,
      description:
          'Card that expands/collapses with subtle motion for details.',
    ),
    PremiumPreset(
      id: 'animated_list',
      label: 'Animated list',
      requiredTier: FlawlessTier.premiumMotion,
      description: 'Vertically scrolling list with staggered item motion.',
    ),
    PremiumPreset(
      id: 'team_zipper_list',
      label: 'Team zipper list',
      requiredTier: FlawlessTier.team,
      description: 'Two-column zipper list with coordinated scroll animations.',
    ),
    PremiumPreset(
      id: 'deletable_bin_card',
      label: 'Deletable bin card',
      requiredTier: FlawlessTier.team,
      description:
          'Bin card for deleted/archived items with restore and empty actions.',
    ),
    PremiumPreset(
      id: 'project_dashboard',
      label: 'Project dashboard layout',
      requiredTier: FlawlessTier.team,
      description:
          'Sidebar + header + responsive grid layout for project dashboards.',
    ),
    PremiumPreset(
      id: 'static_chat_input',
      label: 'Static chat / ask / search input',
      requiredTier: FlawlessTier.premiumStatic,
      description:
          'Chat / ask / search input without motion, built from M3 primitives.',
    ),
    PremiumPreset(
      id: 'search_input',
      label: 'Search input with suggestions',
      requiredTier: FlawlessTier.premiumStatic,
      description: 'Search bar with inline suggestions dropdown.',
    ),
    PremiumPreset(
      id: 'price_slider',
      label: 'Price range slider',
      requiredTier: FlawlessTier.premiumStatic,
      description: 'Double-thumb price range selector with labels.',
    ),
    PremiumPreset(
      id: 'sidebar',
      label: 'Sidebar with collapsible sections',
      requiredTier: FlawlessTier.premiumStatic,
      description: 'App sidebar with expandable groups and active item state.',
    ),
    PremiumPreset(
      id: 'dashboard_card',
      label: 'Dashboard stats card',
      requiredTier: FlawlessTier.premiumStatic,
      description: 'Metric + trend + actions dashboard card preset.',
    ),
  ];

  static bool isFreeComponentAvailable(String id) {
    final normalized = id.trim().toLowerCase();
    return freeComponents.any((c) => c.id == normalized);
  }

  static PremiumPreset? findPremiumPreset(String id) {
    final normalized = id.trim().toLowerCase();
    for (final p in FlawlessCatalog.premiumPresets) {
      if (p.id == normalized) return p;
    }
    return null;
  }
}
