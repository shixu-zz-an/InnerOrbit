# Premium Page Rules

Uniformity is not copying. Premium quality comes from shared rules expressed differently per page type.

## 1. Onboarding

- Goal: earn trust and collect only required data.
- Visual center: one clear explanation or one focused form area.
- Layout: progress, concise title, short subtitle, focused controls.
- Typography: `title1` or `title2` once; labels use `subhead`; helper text uses `footnote`.
- Card count: zero to one.
- Button: one primary bottom or inline submit.
- Copy: calm, direct, privacy-aware.
- Weaken: technical implementation notes.
- Hide: debug/auth/local details.
- Forbidden: long report cards, fake personalization, mystical promises.

## 2. Today

- Goal: tell the user what matters today and move them into one next step.
- Visual center: one primary focus panel.
- Layout: compact intro, one focus card, quiet supporting rows, reflection.
- Typography: one card title; secondary rows use `headline/subhead`.
- Card count: one primary card plus at most one quiet row group.
- Button: one main action.
- Copy: short, practical, non-fatalistic.
- Weaken: refresh, metadata, section labels.
- Hide: secondary feature promotion.
- Forbidden: dashboard cards, multiple CTAs, large disabled buttons.

## 3. Core Overview

- Goal: establish value and offer clear entry to detail.
- Visual center: identity/summary card.
- Layout: status, archetype, one-sentence value, section entrances.
- Typography: avoid repeating the same title weight.
- Card count: one summary card; sections in rows.
- Button: one quiet action tied to the summary.
- Copy: stable, personal, restrained.
- Weaken: locked sections.
- Hide: full report depth on root.
- Forbidden: article-list presentation, repeated insight cards.

## 4. Lists

- Goal: scan and choose.
- Visual center: row content, not card decoration.
- Layout: grouped rows, neutral icons, clear chevrons.
- Typography: row title `body/subhead`, subtitle `footnote`.
- Card count: one group card per list group.
- Button: row tap or trailing text.
- Copy: noun phrase for row title, short action-oriented subtitle.
- Weaken: icon colors.
- Hide: implementation state labels unless user-relevant.
- Forbidden: long row titles in two columns, colored icons for every row.

## 5. Details

- Goal: provide depth without overwhelming the root page.
- Visual center: detail title and readable sections.
- Layout: pushed screen or custom sheet, not generic action sheet for long content.
- Typography: title once, section headings light.
- Card count: minimal; use dividers and text sections.
- Button: save/ask/share only if relevant.
- Copy: explanatory but specific.
- Weaken: labels and badges.
- Hide: locked body text that cannot help.
- Forbidden: dense content in `CupertinoActionSheet`.

## 6. Forms

- Goal: help the user enter data accurately with confidence.
- Visual center: current input group.
- Layout: label, control, short helper/error.
- Typography: label `subhead`, input `body`, helper `footnote`.
- Card count: zero to one per form group.
- Button: one submit; disabled should recede.
- Copy: human, not technical.
- Weaken: explanatory paragraphs.
- Hide: backend details.
- Forbidden: raw IANA/backend wording as primary helper copy, clipped segment labels.

## 7. AI Ask

- Goal: make the input feel like a private guide entry.
- Visual center: composer and current conversation.
- Layout: quiet header, light chips, message list, bottom composer.
- Typography: prompt chips `footnote`, answer headline `headline/title3`.
- Card count: answer cards only; empty state should be light.
- Button: send icon, save as secondary action.
- Copy: private, practical, not diagnostic.
- Weaken: boundary explanation.
- Hide: system/provider details.
- Forbidden: chatbot marketing hero, oversized empty panels.

## 8. Personal Center

- Goal: manage account, plan, saved content, privacy.
- Visual center: profile summary.
- Layout: profile card, compact grouped settings.
- Typography: row titles modest, plan copy concise.
- Card count: one profile card, one plan card, grouped setting cards.
- Button: plan action as secondary unless purchasing is live.
- Copy: formal product language.
- Weaken: beta and experiments.
- Hide: debug/local/mock/test controls.
- Forbidden: developer console feeling, unfinished feature promotion.

## 9. Settings

- Goal: let users control data and preferences.
- Visual center: clear grouped options.
- Layout: standard rows, neutral icons, destructive separated.
- Typography: compact.
- Card count: one card per group.
- Button: row actions.
- Copy: official and precise.
- Weaken: decorative badges.
- Hide: internal implementation names.
- Forbidden: raw export dumps as final UX for production.

## 10. Premium

- Goal: explain premium value without overpromising.
- Visual center: value summary and one action.
- Layout: custom bottom sheet, short benefit list, compliance note.
- Typography: title `title2`, benefits `subhead/body`.
- Card count: no card stack.
- Button: one action; secondary close.
- Copy: honest, StoreKit-ready.
- Weaken: price if not implemented.
- Hide: fake purchase success in production.
- Forbidden: local test controls in user-facing production UI.

## 11. Empty States

- Goal: explain absence and next step.
- Visual center: small icon plus specific message.
- Layout: compact, contextual, not always centered.
- Typography: `headline` title, `subhead/footnote` message.
- Card count: normally none or one subtle panel.
- Button: only when action is obvious.
- Copy: specific.
- Weaken: icon.
- Hide: generic "no data" phrasing.
- Forbidden: huge empty cards for small missing sections.

## 12. Error States

- Goal: recover calmly.
- Visual center: problem and retry.
- Layout: compact, with enough context.
- Typography: short title and plain message.
- Card count: avoid heavy card unless full page.
- Button: retry primary only when it is the only action.
- Copy: no blame, no raw internals.
- Weaken: warning colors.
- Hide: stack traces, request internals.
- Forbidden: dramatic destructive styling for ordinary network errors.

## 13. Bottom Sheet

- Goal: focused temporary decision or detail.
- Visual center: sheet title and one decision.
- Layout: rounded top, safe area, scroll if content-heavy.
- Typography: `title3/headline`, body `callout`.
- Card count: no nested cards.
- Button: one primary/secondary pair.
- Copy: concise.
- Weaken: background noise.
- Hide: irrelevant options.
- Forbidden: generic action sheet for commercial/detail-heavy content.

## 14. Picker

- Goal: native precise selection.
- Visual center: picker.
- Layout: clear label above, native picker in subtle panel.
- Typography: title `subhead`, helper `footnote`.
- Card count: one subtle picker panel.
- Button: next action after selection.
- Copy: direct.
- Weaken: surrounding card decoration.
- Hide: backend validation details.
- Forbidden: cramped picker height, hidden current value.

## 15. TabBar

- Goal: stable root navigation.
- Visual center: selected tab only.
- Layout: native iOS tab bar.
- Typography: system tab label scale.
- Card count: none.
- Button: tab items only.
- Copy: short labels.
- Weaken: unselected icons.
- Hide: beta tabs.
- Forbidden: heavy selected pills, more than four root tabs for this product.

