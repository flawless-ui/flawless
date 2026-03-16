/// Abstract contract for a spacing scale.
///
/// Implementations typically map these semantic sizes to concrete logical
/// pixel values (e.g. 4, 8, 12, 16, ...).
abstract class FlawlessSpacing {
  double get xxs;
  double get xs;
  double get sm;
  double get md;
  double get lg;
  double get xl;
  double get xxl;
}
