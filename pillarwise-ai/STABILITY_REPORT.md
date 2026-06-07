# STABILITY_REPORT

## 1. 已检查项

- Flutter analyze：通过。
- Flutter test：通过。
- Backend Maven tests：通过。
- Flutter run：已在 iPhone 17 Pro 模拟器启动成功，随后清理本次 run 进程。
- Onboarding draft serialization：默认不提交样例出生资料，用户提供资料可正确序列化，测试通过。

## 2. 首页启动是否过重

`initialize` 后如已有 profile 会串行加载 profile、entitlement、today、reports、relationships、journal。首版可接受，但后续应并行化或分层加载，避免弱网下首页等待过久。

## 3. rebuild 和列表

当前列表规模小，`ListView` 可接受。Journal 和 messages 未来增长后需要分页或懒加载。

## 4. 图片和资源

当前几乎无图片资产，启动和内存压力低。未来 App Store 视觉资产不应直接塞入首屏运行时。

## 5. 网络请求

`loadMainData` 每次刷新会拉多个端点。建议后续增加缓存、分段 loading 和失败局部恢复。

## 6. 重复提交

Ask、Relationship、Paywall、Delete、Export、Save Reflection 都有 loading 或 local guard。Profile generate 依赖全局 loading，已通过生成页锁定。

## 7. setState after dispose

主要异步弹窗使用 `mounted` 检查；`TodayScreen` 保存后有 `context.mounted` 检查。未发现明显高风险。

## 8. 空指针风险

已确认 `OnboardingDraft` 默认不提交样例出生数据；其他 JSON map 读取多数通过 `_asMap/_asList/_copy` 防御。

## 9. 弱网体验

已有错误状态和重试，但首页主数据是整体失败。后续建议 Today/Journal/Blueprint 分块显示，避免一个接口失败拖垮整页。

## 10. 高风险待办

- IAP 未接入，不能上线收费。
- 地点选择有限，可能导致用户无法创建准确资料。
- `loadMainData` 串行请求较多。

## 11. 低风险已修复

- 生成前校验出生日期/时间/地点/时区。
- 草稿恢复未恢复 `birthTime`。
