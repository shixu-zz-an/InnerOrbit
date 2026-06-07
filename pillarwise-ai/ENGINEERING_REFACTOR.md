# ENGINEERING_REFACTOR

## 1. 重构了哪些目录

本轮没有做大规模目录迁移，原因是当前单文件虽长但编译稳定，强行拆分会扩大回归面。保留现有目录：

- `app/lib/core/theme`
- `app/lib/core/widgets`
- `app/lib/core/network`
- `app/lib/core/storage`
- `backend/src/main/java/com/pillarwise`

## 2. 重构或确认的组件

- `AppLoadingState`
- `AppEmptyState`
- `AppErrorState`
- `AppSuccessState`
- `AppOfflineState`
- `AppPermissionState`
- `AppLockedState`
- `AppRetryButton`
- `AppProBadge`
- `AppFeatureLock`

## 3. 删除了哪些废弃代码

本轮未删除旧 onboarding page class，因为它们仍被 enum switch 引用，直接删除会改变路由结构。建议下一轮把 enum 收敛为 active flow，再删除未使用屏幕。

## 4. 抽象了哪些公共能力

现有公共能力已覆盖状态展示、按钮、卡片、列表、输入、标签、锁定状态和升级说明。Analytics 当前由 `AppController.trackEvent` 统一进入后端 `/api/v1/analytics/events`。

## 5. 本轮实际代码修复

- 确认 `OnboardingDraft` 默认不序列化样例出生资料，避免用户在未确认时提交假数据。
- 修复草稿恢复时 `birthTime` 不解析的问题，并保留生成前必填校验。

## 6. 是否影响业务逻辑

影响是正向的：生成 blueprint 的请求体更完整，避免首次核心动作失败。没有改变 API 路径、模型字段或主导航。

## 7. 潜在风险

- `app.dart` 接近 3000 行，应逐步拆分为 onboarding、tabs、sheets、helpers。
- `AppController` 同时承担状态、API、analytics，后续应拆 service/view model。
- 错误文案仍有部分硬编码英文，应逐步进入 l10n。
- Relationship 表单缺少日期格式校验和地点选择器。
