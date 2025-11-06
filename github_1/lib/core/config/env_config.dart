import 'dart:io';

class EnvConfig {
  static final Map<String, String> _envVars = {};

  static Future<void> load([String? environment]) async {
    environment ??= const String.fromEnvironment(
      'ENVIRONMENT',
      defaultValue: 'qa',
    );

    final envFile = File('.env.$environment');
    if (await envFile.exists()) {
      final contents = await envFile.readAsString();
      _parseEnvFile(contents);
    }
  }

  static void _parseEnvFile(String contents) {
    for (final line in contents.split('\n')) {
      if (line.trim().isEmpty || line.startsWith('#')) continue;

      final parts = line.split('=');
      if (parts.length >= 2) {
        final key = parts[0].trim();
        final value = parts.sublist(1).join('=').trim();
        _envVars[key] = value;
      }
    }
  }

  static String get baseUrl =>
      _envVars['BASE_URL'] ?? 'https://apiqa.cibanco.com';
  static String get basicAuth => _envVars['BASIC_AUTH'] ?? '';
  static String get environment => _envVars['ENVIRONMENT'] ?? 'qa';
}
