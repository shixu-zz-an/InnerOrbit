# 08. AI Orchestration

## 1. 原则

AI 是解释层，不是计算层。

禁止：

- 让 LLM 计算四柱。
- 让 LLM 决定用户是否会发财、结婚、生病、死亡。
- 输出“guaranteed / destined / doomed / you will definitely”。
- 提供医疗、金融、法律建议。

允许：

- 解释人格模式。
- 提供反思问题。
- 提供关系沟通建议。
- 提供职业风格建议。
- 用 “may / suggests / consider / often” 降低确定性。

## 2. AI Provider 接口

```java
public interface AiProvider {
  AiCompletion complete(AiRequest request);
}

public record AiRequest(
  String systemPrompt,
  List<AiMessage> messages,
  String responseFormat,
  double temperature,
  int maxTokens
) {}
```

实现：

- `MockAiProvider`：本地默认。
- `OpenAiCompatibleProvider`：生产适配。

## 3. Prompt Builder 输入

```json
{
  "user": {
    "locale": "en-US",
    "goal": "love_relationships"
  },
  "chart": {
    "dayMaster": "Ji Earth",
    "elementDistribution": {},
    "coreArchetype": "Grounded Strategist",
    "relationshipPattern": {},
    "careerStyle": {},
    "currentPhase": {}
  },
  "memory": [
    {"type":"preference","summary":"User is considering a career transition."}
  ],
  "currentQuestion": "Why do I feel stuck?"
}
```

## 4. System Prompt

```text
You are PillarWise AI, a warm and grounded self-discovery guide.
You use Chinese BaZi / Four Pillars symbolism only as a reflective framework.
Do not present any insight as deterministic fate.
Do not use Chinese metaphysical jargon unless the user asks for it.
Do not provide medical, legal, investment, or emergency mental health advice.
Do not predict death, illness, disasters, pregnancy, marriage dates, or guaranteed wealth.
Use modern, emotionally intelligent English.
Always include one practical next step and one reflection question.
If the user asks for deterministic prediction, reframe into patterns, timing themes, and choices.
If the user expresses self-harm or immediate danger, respond with supportive language and advise contacting local emergency services or a trusted professional.
```

## 5. Response Schema

所有 AI 响应用 JSON，后端解析后再返回前端。

```json
{
  "headline": "string",
  "summary": "string",
  "sections": [
    {
      "title": "string",
      "body": "string"
    }
  ],
  "practicalStep": "string",
  "reflectionQuestion": "string",
  "safetyNote": "optional string"
}
```

后端必须 validate：

- headline 非空。
- sections 1–5 个。
- 每个 body < 900 chars。
- practicalStep 非空。
- reflectionQuestion 非空。

## 6. Mock AI 内容生成

Mock 不能像占位符。它必须根据 chart 生成稳定内容。

规则：

```text
dayMaster contains Earth → stability, structure, boundaries
Wood high → growth pressure, ideals, expansion
Fire high → visibility, recognition, expression
Metal high → standards, precision, boundaries
Water high → intuition, imagination, fear, adaptability
```

Mock 输出也必须走 SafetyGuard。

## 7. SafetyGuard

### 7.1 Pre-check

关键词分级：

Hard block：

```text
suicide, kill myself, self harm, overdose, die soon, death date
```

Reframe：

```text
will I get rich, when will I marry, will I get cancer, exact death, lottery, stock, diagnosis
```

### 7.2 Post-check

输出不得包含：

```text
you will definitely
guaranteed
doomed
must break up
will die
will get cancer
buy this stock
stop medication
```

若出现，重新生成一次；仍失败则返回安全模板。

## 8. Memory

每 8–10 轮对话生成 memory summary。

表：`user_memory`

字段：

- memory_type: preference / concern / relationship_context / career_context / boundary
- summary
- confidence

Memory 不保存敏感原文，只保存摘要。

示例：

```text
User is exploring whether to change careers and prefers practical, structured advice.
```

## 9. Quota

Free：

- 1 AI question/day
- 5 deep questions/month

Premium：

- Fair-use，默认 100 questions/month
- 超过后提示：

```text
You’ve reached this month’s fair-use limit. Your saved readings are still available.
```

本地可不强制，但 UI 要显示 quota 逻辑。

## 10. AI Cost Logging

每次 AI 调用记录：

- user_id
- provider
- model
- input_tokens
- output_tokens
- estimated_cost_usd
- latency_ms
- safety_label

不要记录完整 prompt 与回答到日志；数据库 messages 可以保存用户可见内容。
