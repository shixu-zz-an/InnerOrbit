# F08. Me / Settings / Privacy

## 1. 目标

Me 页面负责信任与合规。它必须完整，包括账号、订阅、数据、隐私、删除账号、法律入口。

## 2. Me 页面结构

使用 `CupertinoListSection.insetGrouped`。

分组：

### Account

- Profile
- Birth Details

### Subscription

- Current Plan
- Restore Purchases
- Manage Subscription

### Data & Privacy

- Export My Data
- Delete Birth Profile
- Delete Account

### Support

- Contact Support
- Send Feedback

### Legal

- Privacy Policy
- Terms of Use
- Disclaimer

底部显示：

```text
PillarWise AI v1.0.0
```

## 3. Birth Details

用户可查看与编辑：

- birth date
- birth time
- birth place
- traditional option
- true solar time toggle

编辑后必须：

- 提示会重新生成 chart/report。
- 保存后重新计算 chart。
- 旧报告保留，但标注 `Based on previous birth details` 或直接重新生成。

首版建议：编辑后清空旧 daily insight 与 preview，重新生成。

## 4. Delete Birth Profile

如果用户只有一个 birth profile：

- 删除后回到 onboarding。

确认弹窗：

```text
Delete this birth profile?
This will remove its chart and saved readings. Your account will remain active.
```

按钮：

- Delete Birth Profile
- Cancel

## 5. Delete Account

路径：

```text
Me → Data & Privacy → Delete Account
```

页面文案：

```text
Deleting your account removes your birth profiles, charts, reports, conversations, journal entries, and local subscription state from PillarWise records.
This action can’t be undone.
```

输入确认：`DELETE`

调用：`DELETE /api/v1/me`

成功后：

- 清除 secure storage。
- 清除 local cache。
- 回到 Welcome。

## 6. Privacy Policy / Terms

本地阶段可以打开内置 markdown 页面或外部 URL。

Release 前必须替换为真实 hosted URL。

Privacy 页面必须说明：

- 收集出生日期、时间、地点用于生成 chart。
- 聊天用于提供 AI guidance。
- 不出售个人数据。
- 删除账号方法。
- 第三方 AI/payment provider。

## 7. Disclaimer

```text
PillarWise is designed for self-reflection, entertainment, and personal insight. It does not provide medical, legal, financial, or mental health advice. Readings are not deterministic predictions.
```

## 8. Export My Data

本地首版：

- 调用 `GET /api/v1/me/export`。
- 返回 JSON。
- Flutter 使用 share sheet 或复制到 clipboard。

## 9. Acceptance Criteria

- Me 页面所有入口可点击。
- Delete Account 真正删除后端数据与本地 token。
- Restore Purchases 存在。
- 隐私/条款/免责声明可访问。
- 编辑 birth details 后 chart 重新计算。
- 页面符合 iOS grouped settings 风格。
