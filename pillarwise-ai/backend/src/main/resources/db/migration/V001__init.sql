PRAGMA foreign_keys = ON;
PRAGMA journal_mode = WAL;
PRAGMA busy_timeout = 5000;

CREATE TABLE IF NOT EXISTS schema_migrations (
  version TEXT PRIMARY KEY,
  checksum TEXT NOT NULL,
  executed_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS users (
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

CREATE TABLE IF NOT EXISTS auth_sessions (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  token_hash TEXT NOT NULL UNIQUE,
  provider TEXT NOT NULL,
  expires_at TEXT NOT NULL,
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS birth_profiles (
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

CREATE TABLE IF NOT EXISTS bazi_charts (
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

CREATE TABLE IF NOT EXISTS relationship_profiles (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  target_name TEXT NOT NULL,
  relationship_type TEXT NOT NULL,
  target_birth_profile_id TEXT NOT NULL REFERENCES birth_profiles(id) ON DELETE CASCADE,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS reports (
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

CREATE TABLE IF NOT EXISTS daily_insights (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  birth_profile_id TEXT NOT NULL REFERENCES birth_profiles(id) ON DELETE CASCADE,
  insight_date TEXT NOT NULL,
  content_json TEXT NOT NULL,
  prompt_version TEXT NOT NULL,
  model_version TEXT NOT NULL,
  created_at TEXT NOT NULL,
  UNIQUE(user_id, birth_profile_id, insight_date)
);

CREATE TABLE IF NOT EXISTS conversations (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  birth_profile_id TEXT REFERENCES birth_profiles(id) ON DELETE SET NULL,
  topic TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS messages (
  id TEXT PRIMARY KEY,
  conversation_id TEXT NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
  role TEXT NOT NULL,
  content TEXT NOT NULL,
  answer_json TEXT,
  safety_label TEXT,
  tokens_input INTEGER NOT NULL DEFAULT 0,
  tokens_output INTEGER NOT NULL DEFAULT 0,
  cost_usd REAL NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS user_memory (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  memory_type TEXT NOT NULL,
  summary TEXT NOT NULL,
  source TEXT,
  confidence REAL NOT NULL DEFAULT 0.5,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS subscriptions (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  store TEXT NOT NULL,
  product_id TEXT NOT NULL,
  status TEXT NOT NULL,
  expires_at TEXT,
  original_transaction_id TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS purchases (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  product_id TEXT NOT NULL,
  report_id TEXT REFERENCES reports(id) ON DELETE SET NULL,
  store TEXT NOT NULL,
  status TEXT NOT NULL,
  transaction_id TEXT,
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS journal_entries (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  source_type TEXT NOT NULL,
  source_id TEXT,
  prompt TEXT,
  content TEXT NOT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS analytics_events (
  id TEXT PRIMARY KEY,
  user_id TEXT REFERENCES users(id) ON DELETE CASCADE,
  event_name TEXT NOT NULL,
  properties_json TEXT NOT NULL,
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS prompt_templates (
  id TEXT PRIMARY KEY,
  template_key TEXT NOT NULL,
  version TEXT NOT NULL,
  content TEXT NOT NULL,
  active INTEGER NOT NULL DEFAULT 1,
  created_at TEXT NOT NULL,
  UNIQUE(template_key, version)
);

CREATE INDEX IF NOT EXISTS idx_birth_profiles_user ON birth_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_bazi_charts_profile ON bazi_charts(birth_profile_id);
CREATE INDEX IF NOT EXISTS idx_reports_user_type ON reports(user_id, report_type);
CREATE INDEX IF NOT EXISTS idx_daily_insights_user_date ON daily_insights(user_id, insight_date);
CREATE INDEX IF NOT EXISTS idx_messages_conversation ON messages(conversation_id, created_at);
CREATE INDEX IF NOT EXISTS idx_relationship_profiles_user ON relationship_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_journal_user_created ON journal_entries(user_id, created_at);
CREATE INDEX IF NOT EXISTS idx_analytics_user_event ON analytics_events(user_id, event_name);
