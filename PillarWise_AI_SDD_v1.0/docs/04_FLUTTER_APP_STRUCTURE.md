# 04. Flutter App Structure

## 1. Flutter 工程目标

iOS-first、可维护、功能完整。不要把所有页面写进 `main.dart`。

## 2. 推荐依赖

`pubspec.yaml`：

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter/cupertino.dart:
    sdk: flutter
  flutter_riverpod: ^2.6.0
  dio: ^5.7.0
  go_router: ^14.6.0
  freezed_annotation: ^2.4.0
  json_annotation: ^4.9.0
  shared_preferences: ^2.3.0
  flutter_secure_storage: ^9.2.0
  intl: ^0.20.0
  uuid: ^4.5.0
  url_launcher: ^6.3.0
  package_info_plus: ^8.1.0
  connectivity_plus: ^6.1.0
  haptic_feedback: ^0.5.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.0
  freezed: ^2.5.0
  json_serializable: ^6.9.0
  mocktail: ^1.0.0
  flutter_lints: ^5.0.0
```

说明：如果版本冲突，使用当前 Flutter stable 可兼容版本，但不能移除核心能力。

## 3. 目录结构

```text
app/lib/
  main.dart
  app.dart
  core/
    config/
      app_config.dart
      flavor.dart
    design/
      pillar_colors.dart
      pillar_theme.dart
      pillar_typography.dart
      pillar_space.dart
      components/
        pillar_button.dart
        insight_card.dart
        premium_card.dart
        form_field.dart
        loading_view.dart
        error_view.dart
        empty_view.dart
    routing/
      app_router.dart
      route_names.dart
    network/
      api_client.dart
      api_envelope.dart
      api_error.dart
      auth_interceptor.dart
    storage/
      secure_store.dart
      local_cache.dart
    analytics/
      analytics.dart
      analytics_event.dart
    entitlement/
      entitlement_provider.dart
      fake_entitlement_provider.dart
      production_entitlement_provider.dart
    error/
      app_exception.dart
      error_mapper.dart
    utils/
      date_formatters.dart
      haptics.dart
      validators.dart
  features/
    auth/
    onboarding/
    today/
    blueprint/
    ai_guide/
    relationship/
    paywall/
    me/
    journal/
```

每个 feature 结构：

```text
feature_name/
  data/
    dto/
    repository_impl.dart
  domain/
    models/
    repository.dart
    usecases/
  presentation/
    screens/
    widgets/
    providers/
```

## 4. App 启动流程

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = AppConfig.fromEnvironment();
  final container = ProviderContainer(
    overrides: [appConfigProvider.overrideWithValue(config)],
  );
  runApp(UncontrolledProviderScope(
    container: container,
    child: const PillarWiseApp(),
  ));
}
```

启动逻辑：

1. 读取 flavor 与 API URL。
2. 初始化 secure storage。
3. 检查 dev token。
4. 如果没有 token，调用 dev auth。
5. 检查是否存在 birth profile。
6. 决定进入 onboarding 或 main tabs。

## 5. Routing

推荐：

```text
/splash
/onboarding/welcome
/onboarding/disclaimer
/onboarding/birth-date
/onboarding/birth-time
/onboarding/birth-place
/onboarding/traditional-option
/onboarding/goal
/onboarding/generating
/onboarding/preview
/paywall
/main/today
/main/blueprint
/main/ask
/main/love
/main/me
/relationship/add
/relationship/:id/preview
/relationship/:id/report
/settings/privacy
/settings/delete-account
```

要求：

- Onboarding 是线性 flow，禁止用户跳到后续页。
- Main Tabs 使用 CupertinoTabScaffold，不要用 Material BottomNavigationBar。
- Modal：paywall、disclaimer detail、delete confirmation。

## 6. API Client

`ApiClient` 封装 Dio：

- baseUrl
- auth interceptor
- requestId header
- timeout
- envelope parsing
- error mapping

伪代码：

```dart
class ApiClient {
  Future<T> get<T>(String path, T Function(Object json) parse);
  Future<T> post<T>(String path, Object body, T Function(Object json) parse);
}
```

所有 repository 不直接使用 Dio。

## 7. 状态管理

使用 Riverpod：

- `AsyncNotifier` 负责异步状态。
- `StateNotifier` 可用于表单。
- 页面只消费 provider，不拼业务逻辑。

示例：

```dart
final todayControllerProvider = AsyncNotifierProvider<TodayController, TodayState>(
  TodayController.new,
);
```

UI 必须处理：

```dart
state.when(
  data: ...,
  loading: ...,
  error: ...,
)
```

## 8. UI Components

### 8.1 PillarButton

属性：

```dart
enum PillarButtonStyle { primary, secondary, ghost, destructive }

class PillarButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final PillarButtonStyle style;
  final bool isLoading;
  final Widget? leading;
}
```

### 8.2 InsightCard

```dart
class InsightCard extends StatelessWidget {
  final String? label;
  final String title;
  final String body;
  final String? actionText;
  final VoidCallback? onAction;
  final IconData? symbol;
  final bool locked;
}
```

### 8.3 LockedOverlay

用于 free 用户看到 preview：

```text
Blurred lower content
Gold lock icon
Unlock full reading CTA
```

## 9. 本地缓存策略

缓存对象：

- current user
- birth profile summary
- last blueprint preview
- last today insight
- entitlement

不要缓存：

- 完整聊天记录到 shared_preferences
- AI API key
- Apple identity token

## 10. Offline 行为

如果后端不可用：

- Splash 尝试加载缓存。
- 有缓存的报告可以查看。
- 创建/聊天/购买显示 offline error。
- Error view：

```text
You’re offline.
Your saved readings are still available. Reconnect to generate new insights.
```

## 11. Testing

Flutter 至少实现：

- validator unit tests
- API envelope parsing tests
- onboarding form tests
- paywall UI snapshot/widget tests
- main tab navigation widget test
- error state widget test

## 12. 禁止事项

- 不要在 widget 里写 API URL。
- 不要把 JSON map 到 `dynamic` 到处传。
- 不要用 `setState` 管复杂业务状态。
- 不要写死用户出生信息。
- 不要用 Material Scaffold 做主 UI。
- 不要让 UI 依赖 mock-only 字段。
