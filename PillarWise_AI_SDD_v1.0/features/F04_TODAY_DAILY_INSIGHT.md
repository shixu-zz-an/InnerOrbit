# F04. Today / Daily Insight

## 1. 目标

Today 是留存核心。用户每天打开后 15 秒内获得一个和自己相关的具体洞察。

## 2. 页面结构

```text
Today
  Greeting
  Today’s Focus hero card
  Challenge card
  Opportunity card
  Reflection question
  Ask AI CTA
  Weekly Theme
  Saved Journal shortcut
```

## 3. API

`GET /api/v1/today?birthProfileId={id}&date=YYYY-MM-DD`

如果当天 insight 不存在，后端生成并保存。

## 4. Content schema

```json
{
  "date": "2026-06-01",
  "greeting": "Good morning",
  "focus": {
    "title": "Choose clarity over guessing.",
    "body": "Today is better for direct signals than emotional interpretation."
  },
  "challenge": {
    "title": "Over-reading silence",
    "body": "You may fill gaps with stories before asking for facts."
  },
  "opportunity": {
    "title": "A cleaner conversation",
    "body": "One direct question can save you hours of emotional noise."
  },
  "action": "Ask one direct question before assuming intent.",
  "reflectionQuestion": "Where are you turning uncertainty into a story?",
  "weeklyTheme": "Stability before expansion"
}
```

## 5. Generation logic

输入：

- chart
- mapped insight
- local date
- annual cycle if available
- user goal

Mock generation：

- 根据 weekday + element emphasis 选择 focus 模板。
- 同一用户同一天稳定返回。

Production AI：

- max 500 tokens。
- 温度 0.6。
- JSON 输出。

## 6. UI 细节

### Today Focus Hero

- 大卡片，占宽。
- Label：`Today’s Focus`
- Title 22 bold。
- Body 16。
- 右上角 subtle symbol。
- CTA：`Ask about this`

### Reflection

卡片下方提供：

- 文本输入：`Write a quick reflection…`
- Save 按钮。
- 可跳转 Journal。

### Weekly Theme

较小卡片：

```text
This week’s theme
Stability before expansion
```

## 7. Push Notification

本地阶段：

- 可实现 local notification mock 或只保留设置项。

生产：

- 每天最多 1 条。
- 默认关闭，用户 opt-in。

文案：

```text
Your daily reflection is ready.
Today’s focus: choose clarity over guessing.
```

禁止：

```text
Something bad may happen today.
Your soulmate is near.
```

## 8. Frontend states

### No birth profile

```text
Your daily insight needs a blueprint first.
```

CTA：Start My Blueprint。

### Loading

Skeleton hero + cards。

### Offline

如果有缓存，展示最近一次并标注：

```text
Last saved insight
```

如果无缓存：显示 offline error。

## 9. 埋点

- `today_viewed`
- `today_focus_expanded`
- `today_ask_ai_tapped`
- `reflection_started`
- `reflection_saved`
- `weekly_theme_viewed`

## 10. Acceptance Criteria

- 用户每天进入 Today 有内容。
- 同一天重复刷新内容稳定，不随机乱变。
- 可保存 reflection。
- 可从 focus 跳 AI。
- 无 profile / offline / error 状态完整。
- 内容不制造恐惧。
