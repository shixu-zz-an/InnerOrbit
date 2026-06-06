# F01. Onboarding & Birth Profile

## 1. 目标

用户首次打开 App 后，在 3 分钟内完成出生信息输入并生成第一份免费 reading preview。

核心体验：

```text
I entered my birth info → the app feels premium → the first reading feels surprisingly personal.
```

## 2. 页面列表

1. Welcome
2. Disclaimer
3. Birth Date
4. Birth Time
5. Birth Place
6. Traditional Calculation Option
7. User Goal
8. Generating
9. Free Reading Preview
10. Paywall / Continue Free

## 3. Screen 1 — Welcome

### UI

- Warm background。
- 中心上方小图形：抽象 Four Pillars symbol，用自定义 Flutter painter 或 SF Symbol 风格，不要宗教化。
- Title：`Decode your inner patterns.`
- Subtitle：`AI self-discovery powered by Eastern wisdom.`
- Primary CTA：`Start My Blueprint`
- Secondary text button：`I already have a profile`（本地无 profile 时隐藏或 disabled）

### 行为

点击 CTA → Disclaimer。

### 埋点

- `onboarding_welcome_viewed`
- `onboarding_start_tapped`

## 4. Screen 2 — Disclaimer

### 文案

```text
PillarWise is for self-reflection and personal insight.
It does not provide medical, legal, financial, or mental health advice.
Your readings are not deterministic predictions. They are designed to help you reflect on patterns and choices.
```

Checkbox：

```text
I understand and want to continue.
```

CTA：`Continue`

### 验收

- 未勾选不能继续。
- Checkbox 44pt 点击区。
- 文案支持 VoiceOver。

## 5. Screen 3 — Birth Date

### UI

- Title：`When were you born?`
- Subtitle：`Your date helps us map your core blueprint.`
- 使用 `CupertinoDatePicker`，mode date。
- 日期范围：1900-01-01 到当前日期。
- CTA：`Continue`

### Validation

- required
- 不允许未来日期
- 小于 1900 显示错误：`Please choose a date after 1900.`

## 6. Screen 4 — Birth Time

### UI

Title：`What time were you born?`

选项：

1. Exact time
2. Approximate time
3. I don’t know

若选择 exact/approximate：显示 `CupertinoDatePicker` mode time。

说明：

```text
An exact time improves relationship and timing insights. If you don’t know it, we can still create a partial blueprint.
```

### Data

```dart
enum BirthTimePrecision { exact, approximate, unknown }
```

## 7. Screen 5 — Birth Place

### UI

Title：`Where were you born?`

字段：

- City or birthplace
- Country/region
- Timezone

首版本地实现可以使用手动输入 + 常见城市 suggestion，不依赖付费地图 API。

### Local city seed

内置 30 个常见城市：

- New York
- Los Angeles
- San Francisco
- Toronto
- Vancouver
- London
- Sydney
- Melbourne
- Paris
- Berlin
- Singapore
- Hong Kong
- Taipei
- Tokyo
- Seoul
- Beijing
- Shanghai
- Shenzhen

每个包含：

```json
{
  "city": "Los Angeles",
  "country": "US",
  "lat": 34.0522,
  "lng": -118.2437,
  "timezone": "America/Los_Angeles"
}
```

如果用户输入不在 seed 中：

- 允许手动继续。
- latitude/longitude 可为空。
- timezone 必须选择。
- confidence.location = approximate。

### 未来生产

可接 Google Places / Apple MapKit，但 SDD 首版不依赖。

## 8. Screen 6 — Traditional Calculation Option

Title：`One traditional calculation detail`

文案：

```text
For some traditional cycle calculations, BaZi uses sex assigned at birth. This is used only for timing math and does not define your gender identity.
```

选项：

- Female
- Male
- Prefer not to say

如果 Prefer not to say：

- timeline precision 降级。
- 不阻塞。

## 9. Screen 7 — User Goal

Title：`What do you want to understand first?`

多选 chips：

- Myself
- Love & relationships
- Career direction
- Money patterns
- Life timing
- Emotional growth

至少选 1 个，最多 3 个。

## 10. Screen 8 — Generating

### UI

全屏生成动画，显示步骤：

```text
Mapping your Four Pillars…
Reading your elemental balance…
Finding your core patterns…
Preparing your first insight…
```

每 600–900ms 切换一句。

### 行为

- 调用 `POST /api/v1/birth-profiles`。
- 成功后调用 `POST /api/v1/reports/life-blueprint` mode preview。
- 即使 API 很快，动画至少展示 1.2s。
- 失败显示 error view，可 retry。

## 11. Screen 9 — Free Reading Preview

展示 5 张卡：

1. Core Archetype
2. Hidden Strength
3. Relationship Pattern
4. Current Growth Theme
5. Reflection Question

底部 CTA：

- `Unlock Full Blueprint`
- `Continue with Free Preview`

### Paywall 触发

点击 Unlock → Paywall A。

点击 Continue → Main Tabs / Today。

## 12. State model

```dart
class OnboardingDraft {
  DateTime? birthDate;
  TimeOfDay? birthTime;
  BirthTimePrecision birthTimePrecision;
  String? birthPlaceText;
  double? latitude;
  double? longitude;
  String? timezone;
  SexForTraditionalCycle? sexForTraditionalCycle;
  bool trueSolarTimeEnabled;
  List<UserGoal> goals;
}
```

草稿每一步保存到 local cache，App 重启后恢复。

## 13. Backend endpoints

- `POST /api/v1/birth-profiles`
- `POST /api/v1/reports/life-blueprint`

## 14. Acceptance Criteria

- 新用户从 Welcome 到 Preview 可以完整走通。
- 不知道出生时间也可以生成 preview。
- 手动城市也可以继续，但 confidence 降级。
- 表单错误有明确提示。
- 重新打开 App 恢复 onboarding 草稿。
- 生成失败可重试，不丢输入。
- Preview UI 精致，不像 debug JSON。
- 通过 VoiceOver 可理解每个输入项。
