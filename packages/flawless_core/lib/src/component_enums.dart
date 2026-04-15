enum FlawlessAvatarPresetSize { xs, sm, md, lg, xl }

enum FlawlessAvatarVariant { solid, soft, outline }

enum FlawlessBadgeVariant { soft, solid, outline }

enum FlawlessBadgeSize { sm, md, lg }

enum FlawlessCardVariant { elevated, filled, outline }

enum FlawlessCardPadding { none, sm, md, lg }

enum FlawlessButtonVariant {
  primary,
  secondary,
  surface,
  outline,
  ghost,
  destructive,
  inverse
}

enum FlawlessButtonSize { sm, md, lg }

enum FlawlessButtonRadius { none, sm, md, lg, pill }

enum FlawlessAlertVariant { success, error, info, warning }

enum FlawlessTextFieldVariant { outlined, filled, underlined }

enum FlawlessModalVariant { dialog, bottomSheet, fullScreen }

enum FlawlessNavbarVariant {
  iconsOnly,
  iconWithLabel,
  splitWithCenterButton,
  sidebarWithProfile,
  collapsing,
}

class FlawlessBottomNavItem {
  final int iconCodePoint;
  final String label;

  const FlawlessBottomNavItem({
    required this.iconCodePoint,
    required this.label,
  });
}
