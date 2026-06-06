# 05. Backend Java 21 Structure

## 1. 技术选型

- Java 21
- Spring Boot 3.5.x
- Spring MVC
- Spring JDBC
- SQLite JDBC
- Maven
- JUnit 5
- Mockito

不用 JPA 的原因：SQLite 方言、迁移与 JSON 字段处理会增加不必要复杂度。首版使用 Spring JDBC 更可控。

## 2. Maven 依赖

`backend/pom.xml` 核心：

```xml
<properties>
  <java.version>21</java.version>
</properties>

<dependencies>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
  </dependency>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-validation</artifactId>
  </dependency>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-jdbc</artifactId>
  </dependency>
  <dependency>
    <groupId>org.xerial</groupId>
    <artifactId>sqlite-jdbc</artifactId>
    <version>3.53.1.0</version>
  </dependency>
  <dependency>
    <groupId>cn.6tail</groupId>
    <artifactId>lunar</artifactId>
    <version>1.7.7</version>
  </dependency>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
  </dependency>
</dependencies>
```

如 Codex 发现版本不可用，使用 Maven Central 当前可用兼容版本，但必须保留功能。

## 3. 目录结构

```text
backend/src/main/java/com/pillarwise/
  PillarwiseApplication.java
  config/
    AppProperties.java
    SqliteConfig.java
    WebConfig.java
    MigrationRunner.java
  common/
    api/ApiResponse.java
    api/ApiError.java
    api/RequestIdFilter.java
    error/GlobalExceptionHandler.java
    error/AppException.java
    json/JsonMapper.java
    time/ClockProvider.java
    validation/Validators.java
  auth/
    AuthController.java
    AuthService.java
    CurrentUser.java
    DevAuthProvider.java
    AppleAuthProvider.java
    AuthRepository.java
  profile/
    BirthProfileController.java
    BirthProfileService.java
    BirthProfileRepository.java
    BirthProfile.java
    dto/
  bazi/
    BaziController.java
    BaziService.java
    BaziEngine.java
    LunarJavaBaziEngine.java
    InsightMapper.java
    model/
  report/
    ReportController.java
    ReportService.java
    ReportRepository.java
    ReportGenerator.java
    model/
  ai/
    AiController.java
    AiService.java
    AiProvider.java
    MockAiProvider.java
    OpenAiCompatibleProvider.java
    PromptBuilder.java
    SafetyGuard.java
    MemoryService.java
  relationship/
    RelationshipController.java
    RelationshipService.java
    RelationshipRepository.java
    CompatibilityEngine.java
  subscription/
    SubscriptionController.java
    SubscriptionService.java
    EntitlementService.java
    LocalSubscriptionService.java
  journal/
    JournalController.java
    JournalService.java
    JournalRepository.java
  settings/
    SettingsController.java
    AccountDeletionService.java
```

## 4. 配置

`application.yml`：

```yaml
server:
  port: ${SERVER_PORT:8080}

app:
  profile: ${APP_PROFILE:local}
  sqlite:
    path: ${SQLITE_PATH:./data/pillarwise.db}
  ai:
    provider: ${AI_PROVIDER:mock}
    base-url: ${AI_BASE_URL:}
    api-key: ${AI_API_KEY:}
    model: ${AI_MODEL:}
  auth:
    provider: ${AUTH_PROVIDER:dev}
```

## 5. SQLite DataSource

SQLite 连接创建后必须执行：

```sql
PRAGMA foreign_keys = ON;
PRAGMA journal_mode = WAL;
PRAGMA busy_timeout = 5000;
```

实现建议：

```java
@Bean
DataSource dataSource(AppProperties props) {
  SQLiteDataSource ds = new SQLiteDataSource();
  ds.setUrl("jdbc:sqlite:" + props.sqlite().path());
  return ds;
}
```

如果使用 Hikari，需要 connection init sql。

## 6. Migration Runner

不要依赖 Flyway。实现 `MigrationRunner implements ApplicationRunner`：

1. 创建 `schema_migrations` 表；
2. 读取 `classpath:/db/migration/*.sql`；
3. 按文件名排序；
4. 对未执行脚本逐个执行；
5. 成功后记录 version、checksum、executed_at。

表：

```sql
CREATE TABLE IF NOT EXISTS schema_migrations (
  version TEXT PRIMARY KEY,
  checksum TEXT NOT NULL,
  executed_at TEXT NOT NULL
);
```

## 7. API Response

```java
public record ApiResponse<T>(
    boolean success,
    T data,
    ApiError error,
    ApiMeta meta
) {
  public static <T> ApiResponse<T> ok(T data, String requestId) { ... }
  public static ApiResponse<Void> fail(ApiError error, String requestId) { ... }
}
```

## 8. Exception Handling

`GlobalExceptionHandler` 映射：

- MethodArgumentNotValidException → VALIDATION_ERROR
- AppException → 对应 code/http status
- Exception → INTERNAL_ERROR

错误消息必须用户友好，不输出堆栈。

## 9. Authentication

### Local

`GET /api/v1/auth/dev-session`

- 如果没有 dev user，创建。
- 返回 long-lived dev token。
- token 存 `auth_sessions`。

### Production placeholder

接口必须存在：

`POST /api/v1/auth/apple`

request：

```json
{
  "identityToken": "...",
  "authorizationCode": "...",
  "fullName": "optional",
  "email": "optional"
}
```

本地可以返回 `NOT_CONFIGURED`，但代码结构必须有 `AppleAuthProvider`。

## 10. Logging

日志不要输出：

- 完整出生日期 + 时间 + 地点组合
- AI 完整聊天内容
- token
- payment transaction id

可以输出：

- userId hash
- requestId
- endpoint
- latency
- error code

## 11. Testing

Backend 必须有：

- MigrationRunnerTest
- BirthProfileServiceTest
- BaziEngineGoldenTest
- ReportServiceTest
- AiSafetyGuardTest
- RelationshipServiceTest
- AccountDeletionServiceTest

## 12. curl 验收

```bash
TOKEN=$(curl -s http://127.0.0.1:8080/api/v1/auth/dev-session | jq -r '.data.accessToken')

curl -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name":"Me","birthDate":"1994-08-21","birthTime":"14:30","birthTimePrecision":"exact","birthPlaceText":"Los Angeles, CA, US","latitude":34.0522,"longitude":-118.2437,"timezone":"America/Los_Angeles","sexForTraditionalCycle":"female","trueSolarTimeEnabled":true}' \
  http://127.0.0.1:8080/api/v1/birth-profiles
```
