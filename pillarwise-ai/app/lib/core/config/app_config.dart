import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppConfig {
  const AppConfig({required this.apiBaseUrl, required this.flavor});

  factory AppConfig.fromEnvironment() {
    return const AppConfig(
      apiBaseUrl: String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://127.0.0.1:8080',
      ),
      flavor: String.fromEnvironment('APP_FLAVOR', defaultValue: 'local'),
    );
  }

  final String apiBaseUrl;
  final String flavor;
}

final appConfigProvider = Provider<AppConfig>(
  (ref) => AppConfig.fromEnvironment(),
);
