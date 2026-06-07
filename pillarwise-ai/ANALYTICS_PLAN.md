# Analytics Plan

## 新增事件
- `app_initialized`
- `app_initialize_failed`
- `main_data_loaded`
- `main_data_failed`
- `screen_viewed`
- `onboarding_completed`
- `core_loop_started`
- `core_loop_completed`
- `core_loop_failed`
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

## 埋点页面
App 初始化、Onboarding、Today、Ask、Paywall、Me、本地 Premium 测试、Relationship Beta。

## 是否采集隐私
不采集用户问题正文、出生日期、出生地点、AI 回答正文或 Journal 内容。只采集行为事件和非敏感状态。

## 后续如何接真实分析系统
当前复用后端 `/api/v1/analytics/events`。未来可在该服务端出口同步到 Firebase、Amplitude、PostHog 或自建 BI。

## 如何判断增长机会
重点看：蓝图生成完成率、Today 主按钮点击率、AI 追问完成率、反思保存率、D1 回访、Paywall 曝光到点击率。
