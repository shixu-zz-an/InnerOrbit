# ANALYTICS_PLAN

## 1. 新增或确认的事件

- `app_initialized`
- `app_initialize_failed`
- `main_data_loaded`
- `main_data_failed`
- `screen_viewed`
- `core_loop_started`
- `core_loop_completed`
- `core_loop_failed`
- `onboarding_completed`
- `core_action_started`
- `core_action_completed`
- `core_action_failed`
- `retention_action_completed`
- `retention_action_failed`
- `paywall_viewed`
- `paywall_triggered`
- `upgrade_tapped`
- `upgrade_completed`
- `upgrade_failed`
- `relationship_preview_created`
- `relationship_preview_failed`

## 2. 埋点在哪些页面

- App 启动和主数据加载：`AppController.initialize/loadMainData`。
- Onboarding 生成 blueprint：`generateProfileAndPreview`。
- Preview 完成进入主界面：`enterMain`。
- Today 保存反思：`saveReflection`。
- Ask 提问：`askGuide`。
- Paywall 曝光和升级点击：`showPaywall`。
- Tab 曝光：`selectTab`。
- Relationship preview：`addRelationship`。

## 3. 是否采集隐私

当前事件不采集出生日期、问题正文、Journal 正文或 AI 回答正文。属性只包含 action、source、reason、计数、locale 等低敏信息。错误 reason 需要保持用户友好，避免把后端堆栈写入 analytics。

## 4. 后续如何接真实分析系统

保留 `trackEvent(eventName, properties)` 统一入口，将当前后端写库实现替换或并行发送到 Firebase、Amplitude、PostHog 或自建分析即可。接入前需要事件 schema、用户匿名 ID、隐私开关和数据保留策略。

## 5. 如何判断产品是否有机会做到营收增长

核心漏斗：

1. install -> `app_initialized`
2. onboarding start -> `core_loop_started`
3. activation -> `core_loop_completed`
4. day 1 retention -> `main_data_loaded` on next day
5. value proof -> `retention_action_completed`
6. monetization interest -> `paywall_viewed`
7. intent -> `upgrade_tapped`
8. paid conversion -> IAP transaction completed after StoreKit integration

如果 `core_loop_completed` 和 `retention_action_completed` 低，先改产品价值；如果 `paywall_viewed` 高但 `upgrade_tapped` 低，改权益和定价；如果 `upgrade_tapped` 高但付费低，检查 IAP、价格和信任。
