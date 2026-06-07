# Main Tabs Redesign Guide

## Product Direction

The main tabs should feel private, quiet, clear, restrained, trustworthy, slightly premium, and practical. The product should support self-reflection without sounding mystical, diagnostic, fatalistic, or like an admin dashboard.

## Visual Principles

- Background: soft light gray, never stark white across the whole page.
- Surfaces: white cards with very light borders and almost no shadow.
- Accent: blue only for selected navigation, primary actions, and key links.
- Support color: green/teal only for opportunity, confirmation, or gentle auxiliary states.
- Density: fewer large cards; use one dominant module per page and lighter rows for secondary information.
- Typography: clear hierarchy, no oversized titles inside dense content.
- Icons: linear, light, 22-24px in TabBar, 16-20px in rows.
- Layout: consistent 20px horizontal page padding, 16-20px section gaps, safe bottom spacing.
- Copy: direct, concrete, and non-deterministic. Avoid "fortune" language and avoid promising outcomes.

## Typography Scale

- Page large title: 32-36, used sparingly.
- Page title: 28-32.
- Card title: 22-26.
- Section title: 15-17.
- Body: 16-18.
- Supporting text: 14-16.
- Tag text: 13-15.
- Tab label: 11-12.

Rules:

- Do not use bold weight to compensate for unclear structure.
- Do not truncate core titles; rewrite or reflow the content.
- Keep Chinese long titles out of two-column cards.
- Use `maxLines` only for truly secondary text.

## Color Semantics

- `background`: soft light gray.
- `surface`: white content surface.
- `surfaceSubtle`: very light gray for gentle panels.
- `primary`: blue for current selection and main action.
- `primarySoft`: pale blue for restrained emphasis.
- `secondary`: teal/green for supportive opportunity states.
- `textPrimary`: deep neutral.
- `textSecondary`: medium neutral.
- `textTertiary`: muted neutral.
- `border`: extremely light.
- `divider`: extremely light.
- `disabled`: low contrast but readable.

Rules:

- Avoid scattered `Colors.xxx`.
- Avoid more than one strong accent per screen.
- Disabled primary buttons should not look like active CTAs.
- Green should not compete with the primary action.

## Card System

- Radius: 18-24.
- Border: ultra-light.
- Shadow: very light or none.
- Padding: 20-24 for primary cards, 16-20 for compact cards.
- Gap: 16-20 between cards.
- Primary screen card: at most one per tab root.
- Secondary content: prefer rows, list groups, or small summaries.

Do not:

- Put long titles in two-column cards.
- Let titles ellipsize.
- Give every card the same weight.
- Put cards inside cards.
- Use thick borders or obvious shadows.

## Button System

- Primary button height: 52-56.
- Radius: 16-18.
- Text size: 17-18.
- One strongest CTA per page.
- Card actions should often be text/ghost buttons.
- Disabled primary state should be pale, calm, and non-dominant.

## TabBar System

- Icons: 22-24.
- Labels: 11-12.
- Selected: primary blue.
- Unselected: tertiary text.
- Border: ultra-light top divider.
- Height: native iOS feeling with Home Indicator safe area preserved.
- No icon scaling or heavy selected pill.

## Page Direction

### 今日

Purpose: daily entry, not an information panel.

Structure:

1. Nav title `今日`; right refresh icon remains small and secondary.
2. Quiet intro: one short recommendation and one next step.
3. One primary focus card:
   - Label: `今日重点`
   - Title: `让一个真实信号就足够`
   - Body: `今天先完成一个踏实选择，不急着同时打开所有可能。`
   - CTA: `帮我拆解下一步`
4. Secondary daily summary as light rows:
   - `本周主题：准备不是等到完美`
   - `今日行动：先完成一个直接行动`
   - `今日提醒：把注意力从结果拉回下一步`
5. Signals as one light card with two rows:
   - `挑战：过度承担结果`
   - `机会：更清晰的下一步`
6. Reflection save: show only when text exists, otherwise show a light hint.

### 蓝图

Purpose: personal blueprint overview.

Structure:

1. Header:
   - Title: `蓝图`
   - Tag: `蓝图预览` or `完整蓝图`
   - Archetype title, e.g. `稳健的策略者`
   - One-sentence subtitle.
2. One summary card:
   - `核心原型`
   - Archetype
   - One-line value statement
   - Text/secondary action: `围绕这个提问`
3. Section list:
   - `核心模式`
   - `隐藏优势`
   - `成长提醒`
   - `关系线索`
   - `行动建议`
4. Locked content keeps clear lock state but lower visual weight.
5. Detail expansion can happen on later screens; root should stay scannable.

### 提问

Purpose: private AI guide entry.

Structure:

1. Header:
   - Title: `提问`
   - Tag: `AI 引导`
   - Main title: `从一个真实问题开始`
   - Subtitle: practical, reflective, not decision-making.
2. Suggestion chips:
   - Short, compact, tappable.
   - Examples:
     - `我最近为什么总是卡住？`
     - `哪个选择更值得先做？`
     - `我在关系里重复什么模式？`
     - `这个月该关注什么？`
3. Input:
   - Placeholder: `说出你正在纠结的事`
   - Rounded 18-22, light border.
   - Send button compact and disabled when empty.
4. Empty state:
   - Light text, no oversized card.
   - Copy: `你的问题会结合蓝图线索，但不会替你做决定。`

### 我的

Purpose: account and blueprint management center.

Structure:

1. Profile header card:
   - Nickname or `You`
   - Current blueprint archetype
   - Birth place
   - `编辑出生信息` action if available.
2. Plan card:
   - Current plan: free or premium.
   - `了解高级版`
   - `管理订阅`
3. Saved, privacy, language, legal as compact grouped rows.
4. Local premium test: hide from release; in local builds move under a developer section at the bottom.
5. Relationship beta: move under `探索更多` or hide if it feels unfinished.

## Global Implementation Rules

- No core text ellipsis.
- No long titles in two-column cards.
- One highest-weight module per page.
- One primary CTA per tab root.
- No heavy disabled bottom button.
- Keep TabBar clear of scroll content.
- Keep input visible above keyboard and Home Indicator.
- Preserve existing provider calls, routes, API payloads, and entitlement logic.

