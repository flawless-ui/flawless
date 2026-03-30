import 'text_style_contract.dart';

/// Abstract contract for typography.
///
abstract class FlawlessTypography {
  FlawlessTextStyle get displayLarge;
  FlawlessTextStyle get displayMedium;
  FlawlessTextStyle get displaySmall;
  FlawlessTextStyle get headlineLarge;
  FlawlessTextStyle get headlineMedium;
  FlawlessTextStyle get headlineSmall;
  FlawlessTextStyle get bodyLarge;
  FlawlessTextStyle get bodyMedium;
  FlawlessTextStyle get bodySmall;
}
