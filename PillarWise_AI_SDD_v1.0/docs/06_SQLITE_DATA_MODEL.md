# 06. SQLite Data Model

## 1. 数据库原则

- SQLite 本地文件库。
- 所有主键为 TEXT UUID。
- 所有时间为 ISO-8601 UTC TEXT。
- JSON 存 TEXT，后端用 Jackson 序列化。
- 外键必须开启并声明。
- 删除账号时级联删除用户数据。

## 2. 表清单

| Table | 用途 |
|---|---|
| schema_migrations | migration 记录 |
| users | 用户 |
| auth_sessions | dev/production session |
| birth_profiles | 出生档案 |
| bazi_charts | 结构化 BaZi chart |
| reports | Life/relationship/career 等报告 |
| daily_insights | 每日洞察 |
| conversations | AI 会话 |
| messages | AI 消息 |
| user_memory | AI 长期记忆摘要 |
| relationship_profiles | 用户添加的关系对象 |
| subscriptions | 订阅/权益状态 |
| purchases | 单次报告购买 |
| journal_entries | 保存的反思 |
| analytics_events | 本地分析事件，可后续对接远程 |
| prompt_templates | prompt 版本 |

## 3. Migration SQL

完整 SQL 见：`db/V001__init.sql`。

关键字段说明：

### users

```sql
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT,
  apple_user_id TEXT UNIQUE,
  display_name TEXT,
  locale TEXT NOT NULL DEFAULT 'en-US',
  country TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  deleted_at TEXT
);
```

### birth_profiles

```sql
CREATE TABLE birth_profiles (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  birth_date TEXT NOT NULL,
  birth_time TEXT,
  birth_time_precision TEXT NOT NULL,
  birth_place_text TEXT NOT NULL,
  latitude REAL,
  longitude REAL,
  timezone TEXT NOT NULL,
  sex_for_traditional_cycle TEXT,
  true_solar_time_enabled INTEGER NOT NULL DEFAULT 1,
  is_primary INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
```

`birth_time_precision` 枚举：

- exact
- approximate
- unknown

`sex_for_traditional_cycle` 枚举：

- female
- male
- prefer_not_to_say
- null

### bazi_charts

```sql
CREATE TABLE bazi_charts (
  id TEXT PRIMARY KEY,
  birth_profile_id TEXT NOT NULL REFERENCES birth_profiles(id) ON DELETE CASCADE,
  calc_version TEXT NOT NULL,
  year_stem TEXT NOT NULL,
  year_branch TEXT NOT NULL,
  month_stem TEXT NOT NULL,
  month_branch TEXT NOT NULL,
  day_stem TEXT NOT NULL,
  day_branch TEXT NOT NULL,
  hour_stem TEXT,
  hour_branch TEXT,
  day_master TEXT NOT NULL,
  element_distribution_json TEXT NOT NULL,
  ten_gods_json TEXT NOT NULL,
  hidden_stems_json TEXT NOT NULL,
  luck_cycles_json TEXT NOT NULL,
  annual_cycles_json TEXT NOT NULL,
  confidence_json TEXT NOT NULL,
  created_at TEXT NOT NULL
);
```

### reports

```sql
CREATE TABLE reports (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  birth_profile_id TEXT REFERENCES birth_profiles(id) ON DELETE SET NULL,
  relationship_profile_id TEXT REFERENCES relationship_profiles(id) ON DELETE SET NULL,
  report_type TEXT NOT NULL,
  status TEXT NOT NULL,
  free_preview_json TEXT NOT NULL,
  full_report_json TEXT,
  model_version TEXT,
  prompt_version TEXT,
  paid_required INTEGER NOT NULL DEFAULT 0,
  unlocked INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
```

## 4. 索引

必须创建：

```sql
CREATE INDEX idx_birth_profiles_user ON birth_profiles(user_id);
CREATE INDEX idx_bazi_charts_profile ON bazi_charts(birth_profile_id);
CREATE INDEX idx_reports_user_type ON reports(user_id, report_type);
CREATE INDEX idx_daily_insights_user_date ON daily_insights(user_id, insight_date);
CREATE INDEX idx_messages_conversation ON messages(conversation_id, created_at);
CREATE INDEX idx_relationship_profiles_user ON relationship_profiles(user_id);
```

## 5. 删除策略

Delete account：

1. 标记 users.deleted_at；
2. 删除/匿名化所有 PII 与内容表；
3. 删除 auth_sessions；
4. 删除 birth_profiles 触发级联；
5. 保留汇总级别 analytics 可选，但本地首版直接删除。

本地实现可直接硬删除 user 及级联数据。

## 6. 数据版本

- `bazi_charts.calc_version`：如 `bazi-v1-lunarjava-1.7.7`。
- `reports.prompt_version`：如 `life-blueprint-v1.0.0`。
- `reports.model_version`：如 `mock-v1` 或 `gpt-xxx`。

后续算法或 prompt 升级后，旧报告仍可追溯。

## 7. SQLite 注意事项

后端每次打开连接后必须设置：

```sql
PRAGMA foreign_keys = ON;
```

否则 SQLite 可能不会强制执行外键。

建议设置：

```sql
PRAGMA journal_mode = WAL;
PRAGMA busy_timeout = 5000;
```

## 8. Seed 数据

`V002__seed_local.sql` 或启动 service 插入：

- products
- prompt_templates

Products：

```text
premium_monthly    $14.99/month
premium_annual     $79.99/year
relationship_deep  $19.99 one-time
career_deep        $14.99 one-time
year_ahead         $19.99 one-time
```
