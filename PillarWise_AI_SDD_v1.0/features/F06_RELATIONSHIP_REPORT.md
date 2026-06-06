# F06. Relationship Report

## 1. 目标

Relationship 是最高付费与传播潜力模块。用户可以添加伴侣/暧昧对象/前任/朋友，生成关系模式洞察。

## 2. Tab 命名

底部 Tab 显示：`Love`

页面 title：`Relationship Insights`

## 3. 关系类型

```text
romantic_partner
crush
ex_partner
friend
family
coworker
```

UI 展示：

- Partner
- Crush
- Ex
- Friend
- Family
- Coworker

## 4. Love Tab Empty State

```text
Understand a relationship dynamic.
Add someone’s birth details to explore communication, chemistry, and conflict patterns.
```

CTA：`Add Someone`

## 5. Add Relationship Flow

页面：

1. Relationship type
2. Name / nickname
3. Birth date
4. Birth time
5. Birth place
6. Generate preview

与 onboarding 共用 birth input components。

## 6. Preview

免费展示：

```json
{
  "patternName": "The Magnetic Mirror",
  "chemistryScore": 82,
  "communicationSnapshot": "You seek clarity quickly; they may need private processing first.",
  "mainTension": "Different recovery speeds after conflict."
}
```

UI：

- Pattern hero card。
- Score 用 ring 但不要像游戏。
- 3 个 preview cards。
- CTA：`Unlock Full Relationship Report`

## 7. Full Report

章节：

1. Relationship Overview
2. Emotional Chemistry
3. Communication Style
4. Conflict Pattern
5. Trust & Security
6. Intimacy Rhythm
7. Long-Term Potential
8. What This Relationship Teaches You
9. Practical Advice
10. Conversation Prompts

## 8. Compatibility Engine

输入：

- user chart
- target chart
- confidence for both
- relationship type

输出 structured compatibility：

```java
public record CompatibilityInsight(
  String patternName,
  int chemistryScore,
  int communicationScore,
  int stabilityScore,
  String mainStrength,
  String mainTension,
  List<String> advicePrompts
) {}
```

### Score 规则

不要宣称科学精确。用于 UI 参考。

分数基准：70。

调整：

- complementary elements +5
- same day master +3 or -3 depending balance
- strong clash signal -8
- supportive cycle +6
- both unknown hour -5 confidence

最终 clamp 45–95。

低分也不能写 doom。写 growth dynamic。

## 9. Share Card

用户可以生成 share image/card：

```text
Our Pattern
The Magnetic Mirror

Strength: Deep emotional recognition
Challenge: Different conflict recovery speed
```

本地首版可实现 Flutter widget 截图或只复制文字。不能强制分享。

## 10. Paywall

触发：

- Unlock full report。
- 查看 locked sections。

价格：

- Deep Relationship Report $19.99 one-time
- Included in Premium Annual

本地：Fake entitlement/unlock。

## 11. Safety copy

禁止：

```text
This person is your soulmate.
You must break up.
This relationship will fail.
You will marry them.
```

使用：

```text
This dynamic may feel intense because...
A useful practice is...
Long-term potential depends on...
```

## 12. API

- `POST /api/v1/relationships`
- `GET /api/v1/relationships`
- `POST /api/v1/relationships/{id}/report`
- `DELETE /api/v1/relationships/{id}`

## 13. Acceptance Criteria

- 用户可添加关系对象。
- birth time unknown 可继续。
- Preview 免费可看。
- Full report gated。
- Premium 可解锁 full。
- 报告语气不恐吓、不控制用户选择。
- 可删除关系对象。
- 可从 report 跳 AI follow-up。
