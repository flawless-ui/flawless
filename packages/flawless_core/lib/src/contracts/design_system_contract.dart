import 'color_scheme_contract.dart';
import 'typography_contract.dart';
import 'component_properties_contract.dart';
import 'spacing_contract.dart';
import 'motion_contract.dart';

/// Abstract contract for a design system.
abstract class FlawlessDesignSystem {
  FlawlessColorScheme get colorScheme;
  FlawlessTypography get typography;
  Map<String, FlawlessComponentProperties> get componentProperties;
  FlawlessSpacing get spacing;
  FlawlessMotion get motion;
}
