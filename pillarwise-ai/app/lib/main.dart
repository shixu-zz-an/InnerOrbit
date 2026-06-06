import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/app_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(AppConfig.fromEnvironment()),
      ],
      child: const PillarWiseApp(),
    ),
  );
}
