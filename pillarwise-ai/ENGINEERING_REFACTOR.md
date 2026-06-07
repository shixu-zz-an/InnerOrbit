# Engineering Refactor

## 重构目录
本轮不做大规模目录迁移，避免影响上线稳定性。

## 重构组件
- 新增 `AppRetryButton`
- 新增 `AppSuccessState`
- 新增 `AppOfflineState`
- 新增 `AppPermissionState`
- 新增 `AppLockedState`
- 新增 `AppProBadge`
- 新增 `AppFeatureLock`

## 删除或弱化代码
未删除旧 onboarding 子页面，当前作为低风险回退保留；默认流程已切到 Profile Setup。

## 抽象公共能力
在 `AppController` 中新增轻量 analytics tracking，统一关键事件上报。

## 是否影响业务逻辑
不影响接口协议和数据模型。修改集中在 UI 流程、导航优先级、状态展示和埋点。

## 潜在风险
旧 onboarding 页面暂未拆除，后续可在真机确认新流程稳定后删除。`app.dart` 仍是后续工程拆分重点。
