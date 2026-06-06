# 00. SDD Master — PillarWise AI

## 1. 文档目的

这份 SDD 是给 Codex/工程实现使用的，不是商业 PRD。它定义：

- 页面与交互细节
- Flutter 工程结构
- Java 21 后端结构
- SQLite 数据模型
- API 合约
- AI 编排与 prompt
- 支付、隐私、账号删除、免责声明等上线必需能力
- 每个功能的验收标准

实现者不得只做“演示逻辑”。如果一个功能暂时需要 mock，必须：

1. mock 能被本地完整使用；
2. 有生产接口适配层；
3. UI 不显示“coming soon / placeholder”；
4. 用户体验像真实 App。

## 2. 产品目标

PillarWise AI 通过用户出生日期、时间、地点生成结构化 BaZi chart，再以现代英语输出用户可理解的洞察：

- Life Blueprint
- Daily Insight
- AI Guide
- Relationship Report
- Journal / Saved Reports
- Subscription / Reports Paywall

## 3. 上线级质量条款

### 3.1 功能完整性

每个 P0 功能必须包含：

- 正常路径
- 输入校验
- loading 状态
- empty 状态
- error 状态
- retry 行为
- 本地缓存或失败降级
- 埋点事件
- accessibility label
- 单元测试或 widget/API 测试

### 3.2 UI/UX 质量

UI 必须符合以下标准：

- iOS-first，优先 Cupertino 控件。
- 页面结构清晰，底部 Tab 固定 5 个：Today、Blueprint、Ask、Love、Me。
- 不使用 Android 风格 AppBar、FloatingActionButton、Material Snackbar 作为主要体验。
- 所有点击热区不小于 44x44pt。
- 支持 Dynamic Type，最小字号 12，正文 15–17，标题 28–34。
- 支持浅色/深色模式。
- 重要完成动作使用轻量 haptic feedback。
- 页面转场使用 iOS push/pop、modal sheet、bottom action sheet。
- 所有输入页键盘避让、safe area、安全返回。

### 3.3 后端质量

- 启动自动创建 SQLite DB 与表。
- API 返回统一 envelope。
- 所有 ID 使用 UUID。
- 所有用户输入做 validation。
- 所有可失败外部能力通过 port/provider 抽象。
- 错误不泄露内部堆栈。
- 本地环境不需要 Docker、不需要外部数据库。

### 3.4 安全与合规

- 不承诺预测未来。
- 不提供医疗、法律、金融建议。
- 不输出死亡、疾病、灾难的确定性判断。
- 有免责声明。
- 有账号删除。
- 有恢复购买。
- 有隐私政策与服务条款入口。
- 用户可删除 birth profile 与聊天记录。

## 4. P0 功能列表

| Code | 功能 | 文档 |
|---|---|---|
| F01 | Onboarding & Birth Profile | `features/F01_ONBOARDING_BIRTH_PROFILE.md` |
| F02 | BaZi Engine | `features/F02_BAZI_ENGINE.md` |
| F03 | Life Blueprint | `features/F03_LIFE_BLUEPRINT.md` |
| F04 | Today / Daily Insight | `features/F04_TODAY_DAILY_INSIGHT.md` |
| F05 | AI Guide | `features/F05_AI_GUIDE.md` |
| F06 | Relationship Report | `features/F06_RELATIONSHIP_REPORT.md` |
| F07 | Paywall & Subscription | `features/F07_PAYWALL_SUBSCRIPTION.md` |
| F08 | Me / Settings / Privacy | `features/F08_ME_SETTINGS_PRIVACY.md` |
| F09 | Journal & Saved Reports | `features/F09_JOURNAL_SAVED_REPORTS.md` |
| F10 | Analytics & Quality Gates | `features/F10_ANALYTICS_QUALITY.md` |

## 5. 完整用户路径

```text
Cold Start
→ Welcome
→ Disclaimer
→ Birth Date
→ Birth Time
→ Birth Place
→ Traditional Calculation Option
→ User Goal
→ Generate Chart
→ Free Blueprint Preview
→ Paywall or Continue Free
→ Today Home
→ Blueprint Detail
→ Ask AI
→ Add Relationship
→ Relationship Preview
→ Relationship Paywall / Unlock
→ Save Reflection
→ Me Settings
→ Delete Account / Restore Purchases
```

## 6. Codex 实现硬性规则

实现时必须遵守：

1. 先建 repo 结构，再实现 vertical slice。
2. API 合约优先，前后端按同一 JSON schema 对齐。
3. Flutter UI 不允许先做粗糙 Material 页面再“以后美化”。第一版就按 design system 写。
4. 所有 mock provider 必须有生产接口同名实现或 TODO-free adapter。
5. 不允许把 BaZi 计算交给 LLM。
6. 不允许在 UI 写“功能开发中”。
7. 不允许将隐私、删除账号、恢复购买放到后续。
8. 所有文案默认英文，因为目标市场是欧美。
9. 所有后台返回时间使用 ISO-8601 UTC；前端按设备 locale 展示。
10. 所有价格文案从 entitlement/payment provider 读取，本地 mock 可硬编码。

## 7. Definition of Done

一个功能完成必须满足：

- API：实现并通过 curl 示例。
- Flutter：页面可访问、状态完整、无 placeholder。
- 数据：SQLite 落库，可重启后保留。
- 错误：断网/后端异常/输入非法有友好提示。
- 测试：至少有核心服务单测与关键 widget 测试。
- 文档：若实现偏离 SDD，必须在 `IMPLEMENTATION_NOTES.md` 记录原因。

## 8. 里程碑

### Milestone 1：可运行骨架

- Backend 启动
- SQLite migration
- Flutter 启动
- `/health` 可访问
- Dev login 可创建本地用户

### Milestone 2：完整 onboarding + chart

- 用户创建 birth profile
- 后端生成 chart
- Flutter 展示 preview

### Milestone 3：核心内容闭环

- Life Blueprint
- Today Insight
- AI Guide
- Journal save

### Milestone 4：商业闭环

- Paywall
- Local entitlement
- Relationship report
- Restore purchases UI

### Milestone 5：上线准备

- Privacy / Terms / Delete Account
- App review checklist
- Store metadata copy
- Performance & crash gates
