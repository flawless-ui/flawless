import 'dart:convert';
import 'dart:io';

const String flawlessDefaultDashboardUrl = 'https://flawless.codelabmw.dev';

String resolveDashboardBaseUrl({FlawlessCliConfig? config}) {
  final cfg = config;
  return Platform.environment['FLAWLESS_DASHBOARD_URL'] ??
      cfg?.dashboardUrl ??
      flawlessDefaultDashboardUrl;
}

/// Project-level CLI configuration.
///
/// Stored as a small JSON file in the current working directory.
class FlawlessCliConfig {
  final String? apiToken;
  final String? dashboardUrl;

  const FlawlessCliConfig({this.apiToken, this.dashboardUrl});

  FlawlessCliConfig copyWith({String? apiToken, String? dashboardUrl}) {
    return FlawlessCliConfig(
      apiToken: apiToken ?? this.apiToken,
      dashboardUrl: dashboardUrl ?? this.dashboardUrl,
    );
  }

  Map<String, dynamic> toJson() => {
        if (apiToken != null) 'apiToken': apiToken,
        if (dashboardUrl != null) 'dashboardUrl': dashboardUrl,
      };

  static FlawlessCliConfig fromJson(Map<String, dynamic> json) {
    return FlawlessCliConfig(
      apiToken: json['apiToken'] as String?,
      dashboardUrl: json['dashboardUrl'] as String?,
    );
  }
}

const _configFileName = '.flawless_cli.json';

Future<FlawlessCliConfig> loadCliConfig() async {
  final file = File(_configFileName);
  if (!await file.exists()) {
    return const FlawlessCliConfig();
  }

  try {
    final contents = await file.readAsString();
    final jsonMap = jsonDecode(contents);
    if (jsonMap is! Map<String, dynamic>) {
      return const FlawlessCliConfig();
    }
    return FlawlessCliConfig.fromJson(jsonMap);
  } catch (_) {
    return const FlawlessCliConfig();
  }
}

Future<void> saveCliConfig(FlawlessCliConfig config) async {
  final file = File(_configFileName);
  final jsonString =
      const JsonEncoder.withIndent('  ').convert(config.toJson());
  await file.writeAsString(jsonString);
}
