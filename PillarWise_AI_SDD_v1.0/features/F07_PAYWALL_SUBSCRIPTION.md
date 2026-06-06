# F07. Paywall & Subscription

## 1. 目标

实现可上线的付费体验结构：清晰价格、清晰权益、恢复购买、订阅管理、local mock 与 production adapter。

## 2. 产品

| Product ID | Type | Price copy |
|---|---|---|
| premium_monthly | subscription | $14.99/month |
| premium_annual | subscription | $79.99/year |
| relationship_deep | one-time | $19.99 |
| career_deep | one-time | $14.99 |
| year_ahead | one-time | $19.99 |

## 3. Entitlement model

```dart
class Entitlement {
  final bool premiumActive;
  final String plan;
  final DateTime? expiresAt;
  final bool fullBlueprint;
  final bool aiUnlimited;
  final bool relationshipReportsIncluded;
}
```

后端同样保存。

## 4. Provider 抽象

Flutter：

```dart
abstract class EntitlementProvider {
  Future<List<ProductOffer>> getOffers();
  Future<PurchaseResult> purchase(String productId);
  Future<Entitlement> restorePurchases();
  Future<Entitlement> getCurrentEntitlement();
}
```

实现：

- `FakeEntitlementProvider`
- `RevenueCatEntitlementProvider` 或 `StoreKitEntitlementProvider`

Local：点击 purchase 调后端 local activate。

Production：走 StoreKit/RevenueCat。

## 5. Paywall UI

### Paywall A — Full Blueprint

Title：

```text
Unlock your full Life Blueprint
```

Benefits：

- Full personality reading
- Love & relationship patterns
- Career and money style
- Daily personalized insights
- Unlimited AI follow-up
- Relationship reports

Plans：

1. Annual — Best value — $79.99/year
2. Monthly — $14.99/month

Buttons：

- `Start Annual Plan`
- `Continue Monthly`
- `Restore Purchases`
- `Not now`

Legal copy：

```text
Subscription renews automatically unless canceled at least 24 hours before the end of the current period. You can manage or cancel in your App Store account settings.
```

### Paywall B — Relationship

Title：

```text
Unlock the full relationship pattern
```

Options：

- One-time report $19.99
- Or unlock Premium Annual

## 6. App Store requirements

必须：

- 显示价格。
- 显示周期。
- 显示自动续订说明。
- 有 Restore Purchases。
- 有 Terms / Privacy links。
- 不隐藏取消方式。
- 不强迫评分/分享/下载其他 App。

## 7. Local backend endpoints

- `GET /api/v1/subscriptions/entitlement`
- `POST /api/v1/subscriptions/local/activate`
- `POST /api/v1/purchases/local/unlock`

## 8. Purchase states

UI 必须处理：

- loading
- success
- user cancelled
- payment failed
- network failed
- already purchased
- restore no purchases
- restore success

## 9. Unlock behavior

Premium active 后：

- Full Blueprint unlocked。
- AI quota unlimited/fair-use。
- Relationship full report included。
- Paywall 不再主动弹。

One-time relationship purchase：

- 只解锁当前 report。
- 不解锁 AI unlimited。

## 10. Acceptance Criteria

- 本地点击订阅后 entitlement 变 premium。
- App 重启后 premium 状态仍在。
- Restore Purchases 有 UI 与本地行为。
- Paywall 有 Not now，不阻断免费功能。
- 价格和权益文案清楚。
- 付费状态变化后页面自动刷新。
