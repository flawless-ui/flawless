import 'package:flawless_core/flawless_core.dart';

/// Concrete Material 3 implementation of FlawlessColorScheme
class Material3ColorScheme implements FlawlessColorScheme {
  @override
  String get primary => '#0B0F1A';
  @override
  String get secondary => '#6B7280';
  @override
  String get background => '#F3F4F6';
  @override
  String get surface => '#FFFFFF';
  @override
  String get error => '#B3261E';
  @override
  String get onPrimary => '#FFFFFF';
  @override
  String get onSecondary => '#000000';
  @override
  String get onBackground => '#1C1B1F';
  @override
  String get onSurface => '#1C1B1F';
  @override
  String get onError => '#FFFFFF';
}

/// Material 3 typography tokens for Flawless.
class Material3Typography implements FlawlessTypography {
  @override
  FlawlessTextStyle get displayLarge =>
      Material3TextStyle(fontSize: 57, fontWeight: 'bold');
  @override
  FlawlessTextStyle get displayMedium =>
      Material3TextStyle(fontSize: 45, fontWeight: 'bold');
  @override
  FlawlessTextStyle get displaySmall =>
      Material3TextStyle(fontSize: 36, fontWeight: 'bold');
  @override
  FlawlessTextStyle get headlineLarge =>
      Material3TextStyle(fontSize: 32, fontWeight: 'bold');
  @override
  FlawlessTextStyle get headlineMedium =>
      Material3TextStyle(fontSize: 28, fontWeight: 'bold');
  @override
  FlawlessTextStyle get headlineSmall =>
      Material3TextStyle(fontSize: 24, fontWeight: 'bold');
  @override
  FlawlessTextStyle get bodyLarge =>
      Material3TextStyle(fontSize: 16, fontWeight: 'normal');
  @override
  FlawlessTextStyle get bodyMedium =>
      Material3TextStyle(fontSize: 14, fontWeight: 'normal');
  @override
  FlawlessTextStyle get bodySmall =>
      Material3TextStyle(fontSize: 12, fontWeight: 'normal');
}

/// A concrete implementation of [FlawlessTextStyle] for the Material 3 design system.
class Material3TextStyle implements FlawlessTextStyle {
  @override
  final String fontFamily;
  @override
  final double fontSize;
  @override
  final double letterSpacing;
  @override
  final double height;
  @override
  final String fontWeight;

  Material3TextStyle({
    this.fontFamily = 'Roboto',
    required this.fontSize,
    this.letterSpacing = 0.0,
    this.height = 1.2,
    required this.fontWeight,
  });
}

/// Default Material 3 component property values.
class Material3ComponentProperties implements FlawlessComponentProperties {
  @override
  Map<String, dynamic> get properties => {
        'borderRadius': 12.0,
        'elevation': 1.0,
      };
}

/// Component properties for the Material 3 button implementation.
class Material3ButtonComponentProperties
    implements FlawlessComponentProperties {
  @override
  Map<String, dynamic> get properties => {
        'borderRadius': 12.0,
        'radii': {
          'none': 0.0,
          'sm': 10.0,
          'md': 12.0,
          'lg': 16.0,
          'pill': 999.0,
        },
        'disabledOpacity': 0.6,
        'outlineBorderWidth': 1.0,
        'padding': {
          'sm': {'h': 12.0, 'v': 8.0},
          'md': {'h': 16.0, 'v': 10.0},
          'lg': {'h': 20.0, 'v': 12.0},
        },
        'iconGap': 8.0,
        'loaderStrokeWidth': 2.0,
        'colors': {
          'primary': {
            'background': '#000000',
            'foreground': '#FFFFFF',
            'border': '#000000',
          },
          'secondary': {
            'background': '#6B7280',
            'foreground': '#FFFFFF',
            'border': '#6B7280',
          },
          'surface': {
            'background': '#FFFFFF',
            'foreground': '#000000',
            'border': '#E5E7EB',
          },
          'outline': {
            'background': 'transparent',
            'foreground': '#000000',
            'border': '#000000',
          },
          'ghost': {
            'background': 'transparent',
            'foreground': '#0B0F1A',
            'border': 'transparent',
          },
          'destructive': {
            'background': '#B3261E',
            'foreground': '#FFFFFF',
            'border': '#B3261E',
          },
          'inverse': {
            'background': '#0B0F1A',
            'foreground': '#FFFFFF',
            'border': '#0B0F1A',
          },
        },
      };
}

/// Component properties for the Material 3 card implementation.
class Material3CardComponentProperties implements FlawlessComponentProperties {
  @override
  Map<String, dynamic> get properties => {
        'borderRadius': 12.0,
        'elevation': 1.0,
        'borderWidth': 1.0,
        'filledSurfaceOpacity': 0.96,
        'borderOpacityOutline': 0.12,
        'borderOpacityFilled': 0.06,
        'borderOpacityElevated': 0.06,
        'shadowOpacity': 0.12,
        'padding': {
          'none': {'h': 0.0, 'v': 0.0},
          'sm': {'h': 12.0, 'v': 12.0},
          'md': {'h': 16.0, 'v': 16.0},
          'lg': {'h': 24.0, 'v': 24.0},
        },
        'clipAntiAlias': true,
      };
}

/// Component properties for the Material 3 checkbox implementation.
class Material3CheckboxComponentProperties
    implements FlawlessComponentProperties {
  @override
  Map<String, dynamic> get properties => {
        'borderOpacity': 0.4,
        'borderWidth': 1.4,
        'radius': 12.0,
        'tapPaddingH': 4.0,
        'tapPaddingV': 4.0,
        'labelGap': 8.0,
      };
}

/// Component properties for the Material 3 dropdown implementation.
class Material3DropdownComponentProperties
    implements FlawlessComponentProperties {
  @override
  Map<String, dynamic> get properties => {
        'onSurfaceOpacity': 0.8,
        'borderOpacity': 0.5,
        'borderWidth': 1.0,
        'focusedBorderWidth': 1.5,
        'borderRadius': 12.0,
        'contentPaddingH': 16.0,
        'contentPaddingV': 12.0,
      };
}

/// Component properties for the Material 3 text field implementation.
class Material3TextFieldComponentProperties
    implements FlawlessComponentProperties {
  @override
  Map<String, dynamic> get properties => {
        'onSurfaceOpacity': 0.8,
        'borderOpacity': 0.5,
        'borderWidth': 1.0,
        'focusedBorderWidth': 1.5,
        'filledSurfaceOpacity': 0.7,
        'underlineFocusedBorderWidth': 2.0,
        'underlineErrorBorderWidth': 2.0,
        'borderRadius': 12.0,
        'contentPaddingH': 16.0,
        'contentPaddingV': 12.0,
        'outerPaddingV': 8.0,
      };
}

/// Component properties for the Material 3 text area implementation.
class Material3TextAreaComponentProperties
    implements FlawlessComponentProperties {
  @override
  Map<String, dynamic> get properties => {
        'onSurfaceOpacity': 0.8,
        'borderOpacity': 0.5,
        'borderWidth': 1.0,
        'focusedBorderWidth': 1.4,
        'defaultMinLines': 3,
        'defaultMaxLines': 5,
        'borderRadius': 12.0,
        'contentPaddingH': 16.0,
        'contentPaddingV': 12.0,
        'outerPaddingV': 8.0,
      };
}

/// Component properties for the Material 3 progress indicator implementation.
class Material3ProgressComponentProperties
    implements FlawlessComponentProperties {
  @override
  Map<String, dynamic> get properties => {
        'linearMinHeight': 4.0,
        'trackOpacity': 0.7,
        'circularStrokeWidth': 3.0,
        'circularDefaultSize': 24.0,
      };
}

/// Component properties for the Material 3 tabs implementation.
class Material3TabsComponentProperties implements FlawlessComponentProperties {
  @override
  Map<String, dynamic> get properties => {
        'selectedBackgroundOpacity': 0.1,
        'unselectedTextOpacity': 0.7,
        'containerRadius': 24.0,
        'itemRadius': 16.0,
        'containerPadding': 8.0,
        'itemMarginH': 4.0,
        'itemPaddingV': 8.0,
      };
}

/// Component properties for the Material 3 navigation bar implementation.
class Material3NavbarComponentProperties
    implements FlawlessComponentProperties {
  @override
  Map<String, dynamic> get properties => {
        'inactiveOpacity': 0.6,
        'activeBackgroundOpacity': 0.1,
        'containerRadius': 24.0,
        'containerPaddingH': 16.0,
        'containerPaddingV': 12.0,
        'itemRadius': 16.0,
        'itemPadding': 4.0,
        'iconLabelPaddingH': 12.0,
        'iconLabelPaddingV': 8.0,
        'labelTopPadding': 8.0,
        'splitCenterPaddingH': 12.0,
        'sidebarPadding': 12.0,
        'sidebarInnerPaddingH': 16.0,
        'sidebarInnerPaddingV': 12.0,
        'sidebarInnerRadius': 16.0,
        'profileGap': 12.0,
        'collapsingPadding': 12.0,
      };
}

/// Component properties for the Material 3 bottom navigation implementation.
class Material3BottomNavComponentProperties
    implements FlawlessComponentProperties {
  @override
  Map<String, dynamic> get properties => {
        'inactiveOpacity': 0.62,
        'height': 72.0,
        'containerRadius': 26.0,
        'containerPaddingH': 12.0,
        'containerPaddingV': 10.0,
        'itemRadius': 18.0,
        'itemPaddingH': 14.0,
        'itemPaddingV': 10.0,
        'itemGap': 8.0,
      };
}

/// Component properties for the Material 3 divider implementation.
class Material3DividerComponentProperties
    implements FlawlessComponentProperties {
  @override
  Map<String, dynamic> get properties => {
        'opacity': 0.12,
        'horizontalPadding': 16.0,
        'height': 16.0,
      };
}

/// Component properties for the Material 3 list item implementation.
class Material3ListItemComponentProperties
    implements FlawlessComponentProperties {
  @override
  Map<String, dynamic> get properties => {
        'paddingH': 16.0,
        'paddingV': 8.0,
      };
}

/// Component properties for the Material 3 switch implementation.
class Material3SwitchComponentProperties
    implements FlawlessComponentProperties {
  @override
  Map<String, dynamic> get properties => {
        'radius': 12.0,
        'paddingH': 8.0,
        'paddingV': 8.0,
        'gap': 8.0,
        'descriptionTopPadding': 4.0,
      };
}

/// Component properties for the Material 3 radio implementation.
class Material3RadioComponentProperties implements FlawlessComponentProperties {
  @override
  Map<String, dynamic> get properties => {
        'paddingH': 12.0,
        'paddingV': 8.0,
        'gap': 8.0,
        'descriptionTopPadding': 4.0,
      };
}

/// Component properties for the Material 3 modal implementation.
class Material3ModalComponentProperties implements FlawlessComponentProperties {
  @override
  Map<String, dynamic> get properties => {
        'titleFontSize': 18.0,
        'radius': 24.0,
        'padding': 16.0,
        'titleBottomPadding': 12.0,
        'actionsSpacing': 12.0,
        'outerPadding': 16.0,
      };
}

/// Component properties for the Material 3 snackbar implementation.
class Material3SnackbarComponentProperties
    implements FlawlessComponentProperties {
  @override
  Map<String, dynamic> get properties => {
        'margin': 16.0,
        'radius': 16.0,
        'actionTextOpacity': 1.0,
      };
}

/// Component properties for the Material 3 alert implementation.
class Material3AlertComponentProperties implements FlawlessComponentProperties {
  @override
  Map<String, dynamic> get properties => {
        'backgroundOpacity': 0.08,
        'borderOpacity': 0.4,
        'descriptionOpacity': 0.9,
        'iconSize': 18.0,
        'borderRadius': 16.0,
        'padding': 12.0,
        'iconPaddingRight': 12.0,
        'iconPaddingTop': 8.0,
        'descriptionTopPadding': 8.0,
        'trailingGap': 12.0,
      };
}

/// Component properties for the Material 3 avatar implementation.
class Material3AvatarComponentProperties
    implements FlawlessComponentProperties {
  @override
  Map<String, dynamic> get properties => {
        'sizes': {
          'xs': 24.0,
          'sm': 32.0,
          'md': 40.0,
          'lg': 48.0,
          'xl': 64.0,
        },
        'borderWidth': 1.0,
        'softBackgroundOpacity': 0.14,
        'borderOpacity': 0.08,
        'outlineBorderOpacity': 0.6,
        'textScale': 0.38,
        'groupMaxVisible': 4,
        'groupOverlap': 0.32,
      };
}

/// Component properties for the Material 3 badge implementation.
class Material3BadgeComponentProperties implements FlawlessComponentProperties {
  @override
  Map<String, dynamic> get properties => {
        'dotSize': 6.0,
        'iconSize': 14.0,
        'gap': 6.0,
        'borderWidth': 1.0,
        'maxCount': 99,
        'softBackgroundOpacity': 0.12,
        'softBorderOpacity': 0.12,
        'outlineBorderOpacity': 0.55,
        'padding': {
          'sm': {'h': 8.0, 'v': 4.0},
          'md': {'h': 12.0, 'v': 6.0},
          'lg': {'h': 12.0, 'v': 8.0},
        },
        'radius': {
          'sm': 16.0,
          'md': 18.0,
          'lg': 24.0,
        },
      };
}

/// Material 3 design system implementation for Flawless.
///
/// This provides defaults for color, typography, spacing, motion, and component
/// properties.
class Material3DesignSystem implements FlawlessDesignSystem {
  @override
  FlawlessColorScheme get colorScheme => Material3ColorScheme();
  @override
  FlawlessTypography get typography => Material3Typography();
  @override
  Map<String, FlawlessComponentProperties> get componentProperties => {
        'button': Material3ButtonComponentProperties(),
        'card': Material3CardComponentProperties(),
        'avatar': Material3AvatarComponentProperties(),
        'badge': Material3BadgeComponentProperties(),
        'checkbox': Material3CheckboxComponentProperties(),
        'dropdown': Material3DropdownComponentProperties(),
        'radio': Material3RadioComponentProperties(),
        'switch': Material3SwitchComponentProperties(),
        'textField': Material3TextFieldComponentProperties(),
        'textArea': Material3TextAreaComponentProperties(),
        'progress': Material3ProgressComponentProperties(),
        'tabs': Material3TabsComponentProperties(),
        'navbar': Material3NavbarComponentProperties(),
        'bottomNav': Material3BottomNavComponentProperties(),
        'divider': Material3DividerComponentProperties(),
        'listItem': Material3ListItemComponentProperties(),
        'modal': Material3ModalComponentProperties(),
        'snackbar': Material3SnackbarComponentProperties(),
        'alert': Material3AlertComponentProperties(),
      };
  @override
  FlawlessSpacing get spacing => _Material3Spacing();
  @override
  FlawlessMotion get motion => _Material3Motion();
}

class _Material3Spacing implements FlawlessSpacing {
  @override
  double get xxs => 4;
  @override
  double get xs => 8;
  @override
  double get sm => 12;
  @override
  double get md => 16;
  @override
  double get lg => 24;
  @override
  double get xl => 32;
  @override
  double get xxl => 40;
}

class _Material3Motion implements FlawlessMotion {
  @override
  Duration get fast => const Duration(milliseconds: 180);
  @override
  Duration get normal => const Duration(milliseconds: 320);
  @override
  Duration get slow => const Duration(milliseconds: 480);
  @override
  String get easingStandard => 'spring';
  @override
  String get easingDecelerate => 'emphasized_decelerate';
  @override
  String get easingAccelerate => 'emphasized_accelerate';
}
