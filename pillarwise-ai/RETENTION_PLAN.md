# Retention Plan

## 当前留存问题
用户生成首次蓝图后，回访理由依赖 Today，但首页没有把“继续上次反思”作为明显入口。

## 新增或优化的留存机制
- Today 首页展示最近一次 Journal。
- 保存反思作为核心留存事件。
- AI 回答可保存到 Journal。
- Me 中保留 Saved Journal 入口和数量。

## 修改文件
- `app/lib/app.dart`
- `app/lib/app_state.dart`
- `app/lib/core/widgets/app_components.dart`

## 是否需要权限
当前不请求通知权限。后续如果做提醒，需要先解释价值，并允许用户主动开启。

## 是否影响隐私合规
埋点不采集出生信息、问题正文、AI 回答正文或敏感个人内容。

## 后续增强点
每日提醒、周回顾、Journal 搜索、连续反思趋势、用户主动设定关注主题。
