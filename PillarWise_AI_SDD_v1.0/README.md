# PillarWise AI — Software Design Document Pack v1.0

> 目标：把 PRD 转成 Codex 可以直接实现的工程级 SDD。实现完成后应达到“本地可完整跑通、UI/UX 接近 iOS 原生体验、具备 App Store 上线准备”的标准，而不是演示级 MVP。

## 1. 产品定义

**PillarWise AI** 是一个面向欧美市场的 iOS App，用东方四柱/BaZi 作为结构化个性化引擎，将结果翻译成现代用户可理解的 self-discovery、relationship insight、career style、daily reflection 与 AI guide。

产品表层不做“算命工具”，而做：

- AI Self-Discovery
- Relationship Insight
- Life Pattern Reflection
- Daily Personalized Guidance
- Eastern Wisdom, Modern Language

## 2. 技术约束

### Frontend

- Flutter stable channel
- iOS-first UI，使用 Cupertino 体系与 Apple Human Interface Guidelines 的交互习惯
- 状态管理：Riverpod
- 网络：Dio
- 路由：go_router 或自定义 Cupertino router，最终必须保持 iOS 原生转场与返回手势
- 本地缓存：shared_preferences + flutter_secure_storage
- 支付：本地开发使用 FakeEntitlementProvider；上架实现 RevenueCat 或 StoreKit 2 适配层

### Backend

- Java JDK 21
- Spring Boot 3.5.x 或兼容 Java 21 的 Spring Boot 版本
- Spring MVC + Spring JDBC
- SQLite 本地数据库，不引入 PostgreSQL/MySQL
- 运行方式：`./mvnw spring-boot:run`
- 默认 DB：`./data/pillarwise.db`
- 本地 AI mock 默认开启；有环境变量时可切换 OpenAI-compatible API

### Database

- SQLite 文件库
- 必须开启 `PRAGMA foreign_keys = ON`
- 用 text UUID 做主键
- JSON 字段使用 TEXT 存储
- 手写轻量 migration runner，不依赖外部数据库服务

## 3. 文档阅读顺序

Codex 实现时必须按以下顺序读取：

1. `00_SDD_MASTER.md` — 总体工程目标与验收标准
2. `docs/01_ARCHITECTURE.md` — 总体架构
3. `docs/02_LOCAL_DEV_SETUP.md` — 本地运行方式
4. `docs/03_IOS_UIUX_DESIGN_SYSTEM.md` — iOS UI/UX 标准
5. `docs/04_FLUTTER_APP_STRUCTURE.md` — Flutter 工程结构
6. `docs/05_BACKEND_JAVA21_STRUCTURE.md` — Java 后端结构
7. `docs/06_SQLITE_DATA_MODEL.md` — 数据库模型
8. `docs/07_API_CONTRACTS.md` — API 合约
9. `docs/08_AI_ORCHESTRATION.md` — AI 编排与安全
10. `features/*.md` — 按功能实现
11. `appendices/` — 文案、SQL、埋点、验收、Codex 任务拆解

## 4. 交付标准

实现完成后必须满足：

- iOS App 可以从冷启动完成 onboarding、生成报告、查看首页、聊天、关系报告、设置、删除账号。
- 后端本地可跑，SQLite 自动初始化，API 可被 Flutter 调用。
- 所有主要页面有 loading、empty、error、offline、permission、paywall 状态。
- UI 使用 iOS 风格：safe area、large title、Cupertino tab、Cupertino sheet、44pt+ 点击热区、动态字体、暗色模式。
- 不出现“占位按钮、假页面、未实现跳转”。本地 mock 可以存在，但必须有明确 `local`/`production` provider 区分。
- 具备 App Store 上架必需能力：恢复购买、隐私政策入口、服务条款入口、账号删除入口、免责声明、IAP 商品说明、metadata 不误导。

## 5. 工程结构总览

```text
pillarwise-ai/
  app/                         # Flutter iOS-first app
  backend/                     # Java 21 Spring Boot backend
  docs/                        # SDD docs copied into repo root
  scripts/                     # local helper scripts
```

Flutter：

```text
app/lib/
  main.dart
  app.dart
  core/
    config/
    design/
    routing/
    network/
    storage/
    analytics/
    entitlement/
    error/
  features/
    onboarding/
    today/
    blueprint/
    ai_guide/
    relationship/
    paywall/
    me/
    journal/
```

Backend：

```text
backend/src/main/java/com/pillarwise/
  PillarwiseApplication.java
  config/
  common/
  auth/
  profile/
  bazi/
  report/
  ai/
  relationship/
  subscription/
  journal/
  settings/
```

## 6. 非目标

- 不做 Android 首发。
- 不做社区、陌生人匹配、直播大师。
- 不做健康诊断、投资建议、法律建议。
- 不做“确定预测未来”的表达。
- 不做重数据库和复杂云基础设施。

## 7. 版本策略

- `local`：全部在本地跑，AI 与 IAP 使用 mock，SQLite 文件库。
- `staging`：真实 AI，可选真实 StoreKit sandbox。
- `production`：真实 AI、真实 IAP、隐私/删除/恢复购买完整。

本 SDD 的实现目标是：**先以 local 完整跑通，再保留 production adapter 接口，避免日后重构。**
