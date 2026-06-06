# F10. Analytics & Quality Gates

## 1. 目标

即使本地首版，也要埋点接口完整，方便日后接 PostHog/Amplitude。

## 2. Analytics Provider

Flutter：

```dart
abstract class Analytics {
  Future<void> track(String event, Map<String, Object?> properties);
  Future<void> identify(String userId, Map<String, Object?> traits);
}
```

实现：

- `LocalAnalytics`：打印 debug + 可发后端。
- `PostHogAnalytics`：生产预留。

## 3. 后端 analytics_events

本地可保存关键事件。

```sql
CREATE TABLE analytics_events (
  id TEXT PRIMARY KEY,
  user_id TEXT REFERENCES users(id) ON DELETE CASCADE,
  event_name TEXT NOT NULL,
  properties_json TEXT NOT NULL,
  created_at TEXT NOT NULL
);
```

## 4. 关键事件

### Activation

- app_opened
- onboarding_started
- birth_profile_created
- blueprint_preview_viewed

### Revenue

- paywall_viewed
- purchase_started
- purchase_success
- purchase_cancelled
- restore_purchases_tapped

### Retention

- today_viewed
- reflection_saved
- ai_message_sent
- relationship_preview_viewed

### Quality

- api_error_seen
- ai_safety_blocked
- report_generation_failed

## 5. Event properties

禁止上传完整 PII。

可以：

```json
{
  "screen": "today",
  "flavor": "local",
  "isPremium": false,
  "birthTimePrecision": "exact",
  "confidence": "high"
}
```

不可以：

```json
{
  "birthDate": "1994-08-21",
  "birthTime": "14:30",
  "message": "full user text"
}
```

## 6. Quality Gates

上线前：

- flutter analyze 0 error。
- backend test 通过。
- 主要页面无 overflow。
- iPhone SE / 15 / 15 Pro Max simulator 检查。
- dark mode 检查。
- VoiceOver 关键流程检查。
- 后端断开时 Flutter 有错误状态。

## 7. Acceptance Criteria

- 所有 P0 事件被 track。
- 本地 analytics 可关闭。
- 不采集敏感字段。
- 错误事件包含 requestId。
