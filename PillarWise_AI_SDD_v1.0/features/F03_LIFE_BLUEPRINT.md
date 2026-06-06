# F03. Life Blueprint

## 1. 目标

Life Blueprint 是用户首次感受到产品价值的核心报告。它必须像一份高级个人洞察报告，而不是八字排盘表。

## 2. 报告结构

### Free Preview

免费展示：

1. Core Archetype
2. Hidden Strength
3. Blind Spot
4. Relationship Hint
5. Reflection Question

### Full Blueprint

付费完整：

1. Core Archetype
2. Personality Pattern
3. Emotional Pattern
4. Relationship Style
5. Career Style
6. Money Style
7. Blind Spots
8. Growth Practices
9. Current Life Phase
10. 12-Month Focus

## 3. UI

### Blueprint Tab

顶部：

```text
Large title: Blueprint
Hero card:
  Label: Core Archetype
  Title: The Grounded Strategist
  Body: You create steadiness where others feel scattered.
  CTA: Ask about this
```

下方：section cards。

Locked section：

- 下半部分 blur。
- Gold lock。
- CTA：`Unlock Full Blueprint`。

### Detail Screen

点击卡片进入详情：

- 大标题
- explanation
- “How it shows up” bullets
- “Growth edge”
- “Try this”
- “Reflection question”
- Save to Journal
- Ask AI follow-up

## 4. Backend generation

`ReportService.generateLifeBlueprint(userId, birthProfileId, mode)`：

1. Load birth profile。
2. Load chart。
3. Load mapped insight。
4. Check existing report cache。
5. If cache exists and promptVersion same，return。
6. Generate preview/full content。
7. Save report。
8. Return DTO。

## 5. Content schema

```json
{
  "coreArchetype": "The Grounded Strategist",
  "headline": "You create steadiness where others feel scattered.",
  "summary": "Your blueprint points to a person who turns uncertainty into structure.",
  "sections": [
    {
      "id": "personality",
      "label": "Personality",
      "title": "Built for steadiness",
      "body": "You notice what needs structure before others do.",
      "howItShowsUp": ["People rely on you in uncertain moments."],
      "growthEdge": "You may confuse control with safety.",
      "practicalStep": "Let one low-risk situation be unresolved for a day.",
      "reflectionQuestion": "Where are you managing something that needs trust?",
      "locked": false
    }
  ]
}
```

## 6. Copy rules

禁止：

```text
You are destined to...
You will get rich...
Your spouse will...
Your life is doomed if...
```

使用：

```text
Your pattern suggests...
You may notice...
A useful focus is...
This can show up as...
```

## 7. AI prompt

System 使用 `docs/08_AI_ORCHESTRATION.md`。

User prompt template：

```text
Create a Life Blueprint report for a user using the structured chart and insight map below.
Write for a 22-35 year old English-speaking user interested in self-discovery.
Do not use BaZi jargon.
Do not be deterministic.
Return JSON matching the schema.

Chart:
{{chart_json}}

Mapped Insight:
{{mapped_insight_json}}

Mode:
{{preview_or_full}}
```

## 8. Frontend states

### Loading

Skeleton cards + text：

```text
Preparing your blueprint…
```

### Error

```text
Your blueprint didn’t load.
Your birth profile is saved. Try again when you’re ready.
```

CTA：Try Again。

### Empty

如果没有 birth profile：

```text
Create your blueprint first.
```

CTA：Start Onboarding。

## 9. Paywall triggers

- 点击 locked section。
- 点击 Unlock Full Blueprint。
- AI ask about locked section。

Paywall context：`life_blueprint_full`。

## 10. Acceptance Criteria

- Free 用户能看到 preview，不会觉得空。
- Full content 对 premium/local unlocked 用户完整显示。
- 每张卡都有 save 和 ask。
- Locked section 不显示完整内容。
- 重新打开 App 报告仍存在。
- 内容不含中文术语，除非用户在设置打开 advanced mode。
