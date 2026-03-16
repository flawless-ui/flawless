/// Abstract contract for motion and animation tokens.
///
/// Durations live here in core so platforms can map them to their own
/// animation systems without introducing framework dependencies.
abstract class FlawlessMotion {
  Duration get fast;
  Duration get normal;
  Duration get slow;

  /// A general-purpose easing identifier (e.g. "standard").
  String get easingStandard;

  /// Easing used when elements decelerate into place.
  String get easingDecelerate;

  /// Easing used when elements accelerate out.
  String get easingAccelerate;
}
