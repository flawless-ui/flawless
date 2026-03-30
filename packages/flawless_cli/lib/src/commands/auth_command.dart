import 'dart:convert';
import 'dart:io';

import 'command_interface.dart';
import '../utils/config.dart';
import '../utils/console.dart';

/// Handles the 'auth' command for flawless_cli.
///
/// Usage:
///   flawless_cli auth API_TOKEN
///
/// It calls the SaaS backend endpoint and prints the
/// effective tier and components available for this token.
class AuthCommand implements ICommand {
  @override
  Future<void> run(List<String> args) async {
    if (args.isEmpty) {
      Console.info('Usage: flawless_cli auth <API_TOKEN>');
      return;
    }

    final token = args.first.trim();
    if (token.isEmpty) {
      Console.error('API token cannot be empty.');
      return;
    }

    // Dashboard URL resolution order:
    // 1) FLAWLESS_DASHBOARD_URL env var
    // 2) Value from project .flawless_cli.json
    // 3) Local dev default
    final existingConfig = await loadCliConfig();
    final baseUrl = resolveDashboardBaseUrl(config: existingConfig);

    Uri uri;
    try {
      uri = Uri.parse(baseUrl).resolve('/api/cli/auth');
    } catch (e) {
      Console.error('Invalid dashboard URL: $baseUrl');
      return;
    }

    final client = HttpClient();
    try {
      final request = await client.postUrl(uri);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode({'token': token}));

      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();

      if (response.statusCode != 200) {
        Console.error('Auth failed (HTTP ${response.statusCode}).');
        Console.dim(body);
        return;
      }

      dynamic data;
      try {
        data = jsonDecode(body);
      } catch (_) {
        Console.error('Unexpected response from server.');
        Console.dim(body);
        return;
      }

      if (data is! Map<String, dynamic>) {
        Console.error('Unexpected response shape from server.');
        Console.dim(body);
        return;
      }

      if (data['ok'] != true) {
        Console.error('Auth failed: ${data['error'] ?? 'Unknown error'}');
        return;
      }

      final tier = data['tier'];
      final components = (data['components'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const <String>[];

      // Persist token + dashboard URL for this project so subsequent
      // commands can run without environment variables.
      final newConfig = existingConfig.copyWith(
        apiToken: token,
        dashboardUrl: baseUrl,
      );
      await saveCliConfig(newConfig);

      Console.success('Authenticated successfully.');
      Console.info('Tier: $tier');
      Console.info('Components available: ${components.join(', ')}');
      Console.dim(
        'Saved token and dashboard URL to .flawless_cli.json in this project.',
      );
    } on SocketException catch (e) {
      Console.error('Network error while calling $baseUrl: ${e.message}');
    } catch (e) {
      Console.error('Unexpected error during auth: $e');
    } finally {
      client.close(force: true);
    }
  }
}
