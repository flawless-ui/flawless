/// Component interaction states used by design systems and components.
///
/// This enum lives in the core package so that themes and components can
/// agree on a shared vocabulary for interaction states without depending
/// on Flutter-specific types.
enum FlawlessComponentState {
  enabled,
  hover,
  pressed,
  focused,
  disabled,
}
