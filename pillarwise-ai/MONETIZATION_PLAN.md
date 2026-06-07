# MONETIZATION_PLAN

## 1. 当前是否已有付费能力

没有可上线的真实 iOS 付费能力。后端存在 local subscription/purchase 测试接口，App 的 local flavor 可启用 Premium 测试；生产构建未接入 Apple IAP，不能收款。

## 2. 建议商业模式

首版采用 freemium：

- 免费版建立信任和留存。
- 高级版以订阅为主，后续可加入一次性购买单份报告。

## 3. 免费版权益

首份 blueprint preview、Today、基础 Ask、Journal 保存、数据导出、删除账号、语言和法律页面。

## 4. 付费版权益

完整 Life Blueprint、更高 AI 问答额度或 unlimited、relationship deep report、未来历史洞察和 Journal 分析。

## 5. 付费触发点

- Preview 的 `Unlock Full Blueprint`。
- Blueprint locked section。
- Ask 免费额度耗尽后的 `ENTITLEMENT_REQUIRED`。
- Relationship full report。
- Me 的 plan card。

## 6. 已实现的前端页面和组件

- `showPaywall`：高级版说明 sheet，区分 local 和 production。
- `AppProBadge`：高级版标识。
- `AppFeatureLock` / `AppLockedState`：锁定能力状态。
- `AppPlanCard`：Me 页权益说明。

## 7. 仍需后端或 IAP 支持的部分

- StoreKit 2 商品配置。
- iOS 端购买、恢复购买、交易监听。
- 服务端 App Store transaction/receipt 校验。
- entitlement 与 Apple 原始交易 ID 绑定。
- 退款、过期、宽限期、家庭共享策略。

## 8. 上架合规注意事项

- 生产环境不能显示本地开通入口。
- 不能展示未配置 IAP 的价格或购买按钮。
- 不能承诺医疗、法律、财务或心理健康效果。
- 若销售数字内容/服务，必须使用 Apple IAP。
- 外链不能引导用户绕过 IAP 购买数字服务。
