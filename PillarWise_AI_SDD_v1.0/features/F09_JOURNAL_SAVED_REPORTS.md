# F09. Journal & Saved Reports

## 1. 目标

让 Daily、AI、Blueprint 的洞察可被保存，增强长期价值与留存。

## 2. 保存入口

- Today Reflection Question
- AI Answer
- Blueprint Card
- Relationship Advice

## 3. Journal 数据

```json
{
  "id": "jnl_...",
  "sourceType": "ai_message",
  "sourceId": "msg_...",
  "prompt": "What would feel lighter if it were finished this week?",
  "content": "I need to finish the proposal before starting another idea.",
  "createdAt": "2026-06-01T12:00:00Z"
}
```

## 4. UI

### Journal list

路径：Me → Saved Journal。

展示：

- 日期
- source badge
- prompt
- content preview

### Journal detail

- prompt
- content
- source link
- edit
- delete

## 5. Saved Reports

路径：Me → Saved Reports。

报告类型：

- Life Blueprint
- Relationship Report
- Daily Insight archive

点击进入原报告详情。

## 6. API

- `POST /api/v1/journal`
- `GET /api/v1/journal`
- `PUT /api/v1/journal/{id}`
- `DELETE /api/v1/journal/{id}`
- `GET /api/v1/reports`

## 7. Empty state

```text
No saved reflections yet.
When an insight resonates, save it here and come back to it later.
```

CTA：Go to Today。

## 8. Acceptance Criteria

- 用户可从 AI answer 保存到 Journal。
- 用户可从 Today 写 reflection 并保存。
- Journal 重启后保留。
- 可编辑/删除。
- Empty state 精致。
- 删除账号时 Journal 删除。
