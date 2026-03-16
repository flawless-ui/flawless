import 'dart:convert';
import 'dart:io';

import '../registry/catalog.dart';
import '../utils/config.dart';

/// Resolve the current user tier by calling the SaaS CLI auth endpoint.
///
/// Uses the project .flawless_cli.json config if present. Falls back to
/// the FLAWLESS_API_TOKEN environment variable. If nothing is configured or
/// the call fails, this returns [FlawlessTier.free].
Future<FlawlessTier> resolveUserTierFromBackend() async {
  final config = await loadCliConfig();
  final token = config.apiToken ?? Platform.environment['FLAWLESS_API_TOKEN'];
  if (token == null || token.isEmpty) {
    return FlawlessTier.free;
  }

  final baseUrl = resolveDashboardBaseUrl(config: config);

  Uri uri;
  try {
    uri = Uri.parse(baseUrl).resolve('/api/cli/auth');
  } catch (_) {
    return FlawlessTier.free;
  }

  final client = HttpClient();
  try {
    final request = await client.postUrl(uri);
    request.headers.contentType = ContentType.json;
    request.write(jsonEncode({'token': token}));

    final response = await request.close();
    if (response.statusCode != 200) {
      return FlawlessTier.free;
    }

    final body = await response.transform(utf8.decoder).join();
    final decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic>) {
      return FlawlessTier.free;
    }
    if (decoded['ok'] != true) {
      return FlawlessTier.free;
    }

    final tierString = decoded['tier']?.toString() ?? 'free';
    return tierFromString(tierString);
  } catch (_) {
    return FlawlessTier.free;
  } finally {
    client.close(force: true);
  }
}
