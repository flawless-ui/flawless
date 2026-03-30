import 'package:flawless_cli/flawless_cli.dart';

void main(List<String> args) {
  final url = resolveDashboardBaseUrl(config: const FlawlessCliConfig());
  print('Flawless dashboard: $url');
  print('Flawless suite version: $flawlessSuiteVersion');
}
