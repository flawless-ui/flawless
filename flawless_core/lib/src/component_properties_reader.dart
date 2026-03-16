import 'contracts/component_properties_contract.dart';

class FlawlessComponentPropertiesReader {
  final Map<String, dynamic> _defaults;
  final Map<String, dynamic>? _active;

  const FlawlessComponentPropertiesReader({
    required Map<String, dynamic> defaults,
    Map<String, dynamic>? active,
  })  : _defaults = defaults,
        _active = active;

  Object? value(String key) {
    final active = _active;
    if (active != null && active.containsKey(key)) {
      return active[key];
    }
    return _defaults[key];
  }

  double doubleValue(String key) {
    final active = _active;
    final activeValue = active != null ? active[key] : null;
    if (activeValue is num) return activeValue.toDouble();

    final defaultValue = _defaults[key];
    if (defaultValue is num) return defaultValue.toDouble();

    throw StateError(
        'Expected num for "$key" but got ${defaultValue.runtimeType}.');
  }

  int intValue(String key) {
    final active = _active;
    final activeValue = active != null ? active[key] : null;
    if (activeValue is int) return activeValue;

    final defaultValue = _defaults[key];
    if (defaultValue is int) return defaultValue;

    throw StateError(
        'Expected int for "$key" but got ${defaultValue.runtimeType}.');
  }

  bool boolValue(String key) {
    final active = _active;
    final activeValue = active != null ? active[key] : null;
    if (activeValue is bool) return activeValue;

    final defaultValue = _defaults[key];
    if (defaultValue is bool) return defaultValue;

    throw StateError(
        'Expected bool for "$key" but got ${defaultValue.runtimeType}.');
  }

  String stringValue(String key) {
    final active = _active;
    final activeValue = active != null ? active[key] : null;
    if (activeValue is String) return activeValue;

    final defaultValue = _defaults[key];
    if (defaultValue is String) return defaultValue;

    throw StateError(
        'Expected String for "$key" but got ${defaultValue.runtimeType}.');
  }

  Map<String, dynamic> mapValue(String key) {
    final active = _active;
    final activeValue = active != null ? active[key] : null;
    if (activeValue is Map<String, dynamic>) return activeValue;
    if (activeValue is Map) return activeValue.cast<String, dynamic>();

    final defaultValue = _defaults[key];
    if (defaultValue is Map<String, dynamic>) return defaultValue;
    if (defaultValue is Map) return defaultValue.cast<String, dynamic>();

    throw StateError(
        'Expected Map<String, dynamic> for "$key" but got ${defaultValue.runtimeType}.');
  }

  Map<String, dynamic> mergedMap(String key) {
    final defaultsValue = _defaults[key];
    final active = _active;
    final activeValue = active != null ? active[key] : null;

    final defaultMap = defaultsValue is Map
        ? defaultsValue.cast<String, dynamic>()
        : const <String, dynamic>{};
    final activeMap = activeValue is Map
        ? activeValue.cast<String, dynamic>()
        : const <String, dynamic>{};

    return <String, dynamic>{
      ...defaultMap,
      ...activeMap,
    };
  }

  static FlawlessComponentPropertiesReader fromComponentProperties({
    required FlawlessComponentProperties defaults,
    FlawlessComponentProperties? active,
  }) {
    return FlawlessComponentPropertiesReader(
      defaults: defaults.properties,
      active: active?.properties,
    );
  }
}
