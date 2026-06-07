# Premium UI Audit

Strict verdict: the app has a coherent direction, but several screens still read as engineered feature surfaces. The largest quality gap is not color. It is composition, hierarchy, rhythm, and product copy.

## 1. Onboarding

- Page name: Onboarding welcome, disclaimer, profile setup, old split birth steps, generating, preview.
- File path: `app/lib/app.dart`.
- Current goal: collect required birth data, explain safety boundary, generate first blueprint.
- Why not premium yet: the active profile setup is functional but form-heavy; older split-step screens remain in code and carry implementation copy; preview stacks report cards too early.
- Most obvious low-craft source: too many form sections and report cards competing before the user has felt value.
- Typography: page titles are acceptable; repeated card titles are too heavy.
- Spacing: form spacing is regular but mechanical.
- Cards: preview uses repeated `AppInsightCard`, producing a report-stack feeling.
- Copy: timezone and local implementation notes are too technical.
- Interaction: date/time picker works but feels like a raw control inside a panel.
- State: generation error is recoverable but generic.
- Template feel: medium.
- Engineering feel: high in profile setup helper text.
- H5 feel: low.
- Android/Flutter trace: low because Cupertino is used.
- Must redo: preview composition, technical helper copy, form focus/disabled states.
- Keep: disclaimer gate, single profile setup direction, deterministic data requirements.
- Priority: P0.
- Risk: medium.

## 2. Today

- Page name: Today home.
- File path: `app/lib/app.dart`.
- Current goal: daily focus, one next step, reflection loop.
- Why not premium yet: the intent is right, but the page still has several card-like blocks and section labels that make it feel assembled.
- Most obvious low-craft source: primary card plus secondary card plus signals card creates a card stack.
- Typography: primary card title is clear; section labels and row labels can overuse accent colors.
- Spacing: rhythm is consistent but too modular.
- Cards: needs one true primary card; secondary info should become lighter rows.
- Copy: good direction, can be shorter and more decisive.
- Interaction: refresh is present but should be visually quieter.
- State: reflection save only appears with input, which is good.
- Template feel: medium.
- Engineering feel: medium.
- H5 feel: low.
- Android/Flutter trace: low.
- Must redo: reduce card count, create a lighter daily summary group, weaken refresh, tighten copy.
- Keep: one main action, latest journal callback, reflection-gated save.
- Priority: P0.
- Risk: low.

## 3. Blueprint

- Page name: Blueprint overview.
- File path: `app/lib/app.dart`.
- Current goal: show identity overview, preview/full status, sections, upgrade path.
- Why not premium yet: summary card and section card are both heavy; sections look like a list of report chunks.
- Most obvious low-craft source: root screen gives too much report weight instead of premium overview.
- Typography: archetype appears twice with similar importance.
- Spacing: section transition is predictable but not crafted.
- Cards: primary card should become a compact summary; section list should be lighter.
- Copy: mostly acceptable, should reduce repeated labels.
- Interaction: tap-to-detail exists and is worth keeping.
- State: locked sections are clear but visually too explicit.
- Template feel: medium.
- Engineering feel: medium.
- H5 feel: low.
- Android/Flutter trace: low.
- Must redo: remove duplicate hero/card hierarchy, make section entrance calmer.
- Keep: section details, locked state, ask-about-this action.
- Priority: P0.
- Risk: low.

## 4. Ask / AI Conversation

- Page name: Ask.
- File path: `app/lib/app.dart`.
- Current goal: private AI guide entry and conversation.
- Why not premium yet: empty state and suggestions are reasonable, but input does not yet feel like the visual anchor; answer cards can become dense.
- Most obvious low-craft source: header, chips, empty hint, answers, and bottom bar all have similar modular weight.
- Typography: AI answer titles can be too large for repeated responses.
- Spacing: conversation area needs more careful rhythm.
- Cards: AI answer card is a strong card for every answer; okay for detail but needs lighter internals.
- Copy: boundary copy is good but should stay quiet.
- Interaction: disabled send is calm; focus state should be refined.
- State: loading copy exists; retry path from error could be clearer.
- Template feel: medium.
- Engineering feel: medium.
- H5 feel: low.
- Android/Flutter trace: low.
- Must redo: make composer feel premium, lighten suggestions, reduce answer-card weight.
- Keep: bottom input, suggested questions, structured answer.
- Priority: P0.
- Risk: medium.

## 5. Me / Personal Center

- Page name: Me.
- File path: `app/lib/app.dart`.
- Current goal: profile summary, plan, saved content, privacy, language, legal.
- Why not premium yet: it still contains developer/local premium test UI and a Relationship Beta promo; this makes it feel unfinished.
- Most obvious low-craft source: development/test controls and too many grouped cards.
- Typography: list titles are readable; plan card copy is long.
- Spacing: many section headers create settings-menu fatigue.
- Cards: each group is a card; acceptable for settings but needs tighter grouping.
- Copy: "local Premium test" is not production-quality.
- Interaction: settings actions work; export shows raw data string in a legal-style sheet.
- State: delete/export loading states exist.
- Template feel: medium.
- Engineering feel: high due to dev controls.
- H5 feel: low.
- Android/Flutter trace: low.
- Must redo: hide developer control, weaken/hide beta, shorten plan copy, unify neutral icons.
- Keep: data export, delete account, language, legal.
- Priority: P0.
- Risk: low.

## 6. Login / Registration

- Page name: no explicit login/registration UI in current Flutter app.
- File path: `app/lib/app_state.dart`, backend `auth`.
- Current goal: local/dev session.
- Why not premium yet: not applicable visually, but production auth path is not represented.
- Must redo: before public release, add a formal auth/account entry if required by product.
- Priority: P2.
- Risk: high if production auth is added late.

## 7. Settings

- Page name: settings sections inside Me.
- File path: `app/lib/app.dart`.
- Current goal: language, privacy, terms, disclaimer, account data controls.
- Why not premium yet: settings are serviceable but resemble grouped engineering rows.
- Must redo: tighter grouping, formal row copy, no debug wording.
- Keep: standard iOS list behavior.
- Priority: P1.
- Risk: low.

## 8. Premium / Paywall

- Page name: Paywall action sheet.
- File path: `app/lib/app.dart`.
- Current goal: explain premium and local entitlement behavior.
- Why not premium yet: `CupertinoActionSheet` feels generic; production value proposition needs a custom premium sheet.
- Most obvious low-craft source: system action sheet used for a commercial moment.
- Must redo: custom bottom sheet with premium summary, compliance copy, and one action.
- Keep: local-only activation guard.
- Priority: P1.
- Risk: medium.

## 9. Forms

- Page name: profile setup, birth place, add relationship.
- File path: `app/lib/app.dart`.
- Current goal: gather user data.
- Why not premium yet: helper text can be technical; inputs lack focus craft.
- Must redo: focus state, helper copy, keyboard-safe layout.
- Keep: validation gates.
- Priority: P1.
- Risk: medium.

## 10. Detail Pages

- Page name: blueprint section detail, relationship report, journal detail via sheets/routes.
- File path: `app/lib/app.dart`.
- Current goal: show deeper content.
- Why not premium yet: action sheets for details can feel like temporary UI.
- Must redo: use detail screens or custom sheets for content-heavy report sections.
- Keep: structured section model.
- Priority: P1.
- Risk: medium.

## 11. Lists

- Page name: saved journal, blueprint sections, Me rows.
- File path: `app/lib/app.dart`, `app/lib/core/widgets/app_components.dart`.
- Current goal: scan stored/secondary items.
- Why not premium yet: list rows are fine but icons can be too colored; card wrapping makes every list a block.
- Must redo: neutral icon default, less visual boxing.
- Priority: P1.
- Risk: low.

## 12. Empty States

- Page name: `AppEmptyState`.
- File path: `app/lib/core/widgets/app_components.dart`.
- Current goal: explain missing data.
- Why not premium yet: too card-like and visually large for all empty contexts.
- Must redo: lighter compact empty state; action optional and quiet.
- Priority: P1.
- Risk: low.

## 13. Error States

- Page name: `AppErrorState`.
- File path: `app/lib/core/widgets/app_components.dart`.
- Current goal: recover from loading/API failures.
- Why not premium yet: centered error is generic; raw error mapping may leak implementation tone.
- Must redo: map error copy, keep retry clear, avoid alarming visual treatment.
- Priority: P1.
- Risk: low.

## 14. Bottom Sheet / Picker

- Page name: paywall, language, add relationship, legal/detail sheets, date/time pickers.
- File path: `app/lib/app.dart`, `app/lib/core/widgets/app_components.dart`.
- Current goal: modal choices and data entry.
- Why not premium yet: system action sheets are fast but generic; pickers need better framing.
- Must redo: custom premium/info sheets for content; keep system picker only where native is expected.
- Priority: P1.
- Risk: medium.

## 15. TabBar

- Page name: main navigation.
- File path: `app/lib/core/widgets/app_components.dart`.
- Current goal: Today, Blueprint, Ask, Me.
- Why not premium yet: close to native, but final quality depends on content clearing it and not overloading tab roots.
- Must redo: keep icon/label quiet; audit bottom padding on small screens.
- Priority: P0.
- Risk: low.

