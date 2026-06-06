# 02. Local Development Setup

## 1. 目标

本地开发者在没有 Docker、没有远程数据库、没有真实 AI key、没有真实 IAP 的情况下，能完整跑通 App：

```text
Onboarding → Chart → Blueprint → Today → AI Guide → Relationship → Paywall mock → Journal → Settings → Delete Account
```

## 2. 目录结构

```text
pillarwise-ai/
  app/
  backend/
  scripts/
  README.md
```

## 3. 后端本地启动

### 3.1 前置要求

- JDK 21
- Maven wrapper 或 Maven 3.9+

### 3.2 初始化

```bash
cd backend
./mvnw clean test
./mvnw spring-boot:run
```

默认配置：

```yaml
server:
  port: 8080
app:
  profile: local
  sqlite:
    path: ./data/pillarwise.db
  ai:
    provider: mock
  auth:
    provider: dev
```

### 3.3 健康检查

```bash
curl http://127.0.0.1:8080/health
```

期望：

```json
{
  "success": true,
  "data": {
    "status": "ok",
    "db": "ok",
    "profile": "local"
  }
}
```

### 3.4 重置本地 DB

```bash
rm -rf backend/data/pillarwise.db
./mvnw spring-boot:run
```

启动时自动执行：

1. 创建 `data/` 目录；
2. 打开 SQLite；
3. 执行 migration；
4. 插入 seed product 与 dev user。

## 4. Flutter 本地启动

### 4.1 前置要求

- Flutter stable channel
- Xcode
- iOS Simulator

### 4.2 安装依赖

```bash
cd app
flutter pub get
flutter test
```

### 4.3 运行

```bash
flutter run \
  --dart-define=API_BASE_URL=http://127.0.0.1:8080 \
  --dart-define=APP_FLAVOR=local
```

### 4.4 iOS 权限

首版不需要定位权限。出生地点通过城市搜索或手动输入。

需要的 iOS 配置：

- `NSAppTransportSecurity` 本地开发允许 `http://127.0.0.1:8080`。
- Release 构建必须使用 HTTPS。
- 不使用 IDFA，不弹 ATT。
- 推送本地阶段可使用 local notification mock，不要求 APNs。

## 5. 本地 mock 规则

### 5.1 Dev Auth

首次启动 Flutter：

```text
GET /api/v1/auth/dev-session
```

后端返回：

```json
{
  "userId": "usr_dev_xxx",
  "accessToken": "dev_xxx",
  "expiresAt": "2099-01-01T00:00:00Z"
}
```

Flutter 保存 token 到 secure storage。所有 API 带：

```http
Authorization: Bearer dev_xxx
```

### 5.2 Mock AI

`AI_PROVIDER=mock` 时，后端不调用外部模型，而是根据 chart + report type 返回稳定、精致、可展示的内容。

要求：

- 同一个输入返回稳定结果。
- 不出现“mock”字样。
- 内容质量接近真实上线文案。

### 5.3 Fake Entitlement

本地付费行为：

- Paywall 点击 Annual：调用 `/api/v1/subscriptions/local/activate`。
- 后端把用户 entitlement 设置为 premium。
- UI 显示 Premium active。
- Restore Purchases 本地返回当前 entitlement。

生产时替换为 StoreKit/RevenueCat。

## 6. 测试命令

Backend：

```bash
cd backend
./mvnw test
```

Flutter：

```bash
cd app
flutter analyze
flutter test
```

建议脚本：

```bash
./scripts/check_all.sh
```

内容：

```bash
#!/usr/bin/env bash
set -e
(cd backend && ./mvnw test)
(cd app && flutter analyze && flutter test)
```

## 7. 本地 demo 数据

后端启动后 seed：

- dev user
- subscription products
- example prompt templates
- sample relationship profile 可选

但 Flutter 第一次启动仍必须走真实 onboarding，不能直接跳过。

## 8. 常见问题

### Flutter 连不上后端

检查：

```bash
curl http://127.0.0.1:8080/health
```

iOS simulator 使用本机 `127.0.0.1`。真机调试需使用 Mac 局域网 IP。

### SQLite locked

本地只运行一个 backend 实例。必要时删除 `backend/data/pillarwise.db-shm` 和 `backend/data/pillarwise.db-wal`。

### AI 返回太快像假内容

Mock provider 必须模拟 500–900ms 延迟，并生成真实可读内容。
