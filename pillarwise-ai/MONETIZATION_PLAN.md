# Monetization Plan

## 当前是否已有付费能力
后端已有本地权益激活接口，但这不是 App Store 真实支付能力。当前版本不能把它包装成真实订阅。

## 建议商业模式
首版采用 freemium：免费体验每日洞察和少量 AI 追问，高级版提供完整蓝图、更多追问和深度报告。

## 免费版权益
首份蓝图预览、每日重点、一次或有限 AI 追问、保存反思、基础 Journal。

## 付费版权益
完整 Life Blueprint、更多 AI Guide 追问、关系深度报告、长期历史和更完整的个性化分析。

## 付费触发点
Preview 解锁完整蓝图、Blueprint 锁定章节、Ask 额度耗尽、Me 的 Upgrade information。

## 已实现的前端页面
升级说明 sheet 已改为合规说明。生产模式不展示虚假购买按钮；本地模式明确标注开发测试开通。

## 仍需后端或 IAP 支持
- Apple StoreKit 2 / In-App Purchase。
- App Store 产品 ID、收据校验和服务端 entitlement 同步。
- Restore Purchases 的真实实现。

## 上架合规注意事项
未接入 IAP 前，不应展示真实价格、订阅周期或“开始购买”按钮。数字服务销售必须走 Apple IAP。
