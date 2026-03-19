import 'dart:convert';
import 'dart:io';

/// Default Flawless dashboard base URL used by the CLI.
///
/// You can override this value per-project using [FlawlessCliConfig.dashboardUrl]
/// or per-process using the `FLAWLESS_DASHBOARD_URL` environment variable.
const String flawlessDefaultDashboardUrl = 'https://dashboard.flawless-ui.dev';

/// Resolves the dashboard base URL for the current CLI invocation.
///
/// Precedence:
/// 1) `FLAWLESS_DASHBOARD_URL` environment variable
/// 2) [FlawlessCliConfig.dashboardUrl]
/// 3) [flawlessDefaultDashboardUrl]
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
  /// API token used to authenticate CLI requests.
  final String? apiToken;

  /// Base URL for the Flawless dashboard.
  final String? dashboardUrl;

  /// Creates a CLI configuration value.
  const FlawlessCliConfig({this.apiToken, this.dashboardUrl});

  /// Returns a copy of this config with the provided values replaced.
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
