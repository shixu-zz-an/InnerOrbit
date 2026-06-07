# Design Craft Standard

This standard defines what "iOS-first Calm Premium Utility" must mean in code. Premium craft is not more decoration. It is less noise, sharper hierarchy, steadier rhythm, more natural interaction, and more trustworthy copy.

## 1. Page Composition

High craft: one clear visual center per screen, content starts with a human-readable decision, secondary information recedes into rows or quiet groups, and scroll depth feels intentional.

Low craft: every module has equal weight, every section is a card, and the first screen reads like a feature checklist.

Current issues: Today, Blueprint, Me, and Preview can feel like stacked engineering modules rather than designed product surfaces.

Code fix: use one primary card or panel per page; convert secondary cards into list rows; keep `AppPageHeader`/`_QuietIntro` concise; avoid multiple `AppInsightCard` blocks in a row on root screens.

Forbidden: dashboard grids, repeated large cards, decorative hero blocks, equal-weight section stacks.

## 2. Typography Hierarchy

High craft: one strong title, moderate card titles, relaxed body line height, light labels, and no core content truncation.

Low craft: all headings are black and bold, labels compete with titles, long Chinese titles are placed in narrow columns, or text relies on ellipsis.

Current issues: several cards use `title2/title3` too often; labels and actions often use primary blue; root pages can show multiple high-weight titles.

Code fix: reserve `title1` for page/first-run moments; prefer `title2` for primary cards only; use `headline/subhead/callout` for most repeated content; do not set `maxLines` on primary titles.

Forbidden: `maxLines: 1` on meaningful titles, negative letter spacing, making text larger to compensate for weak layout.

## 3. Spacing Rhythm

High craft: top spacing feels native, modules breathe, bottom content clears TabBar/Home Indicator, and compact rows remain tappable.

Low craft: sections are separated by identical mechanical gaps, cards touch the visual edges, bottom bars feel pasted on, or small screens feel compressed.

Current issues: `SizedBox` rhythm is repetitive; bottom content relies on fixed large insets; repeated cards create table-like cadence.

Code fix: use `AppSpacing.page` for margins, `lg/xl` for major separation, `sm/md` inside rows, and prefer grouped rows over repeated cards.

Forbidden: arbitrary spacing numbers outside tokens, page content hidden by TabBar, oversized empty vertical gaps on root pages.

## 4. Card Restraint

High craft: cards are fewer, lighter, and purposeful. One primary card carries the main decision; secondary data uses rows.

Low craft: every idea is wrapped in a white card; card shadows and borders become the visual system.

Current issues: many page roots stack multiple cards with similar weight.

Code fix: keep `AppCard` border ultra-light and shadow-free by default; create row groups for secondary details; use `AppInsightCard` mainly for detail or answer content.

Forbidden: cards inside cards, card grids with long text, heavy borders, obvious shadows, multiple primary cards per root screen.

## 5. Icon Consistency

High craft: icons are one visual language, mostly line icons, quiet neutral color unless they encode a meaningful state.

Low craft: every row has a different accent color or oversized icon badge.

Current issues: many row avatars use tone colors even when the information is neutral.

Code fix: default list icons to `AppTone.neutral`; use primary only for selected/active actions; use secondary for positive opportunity; use warning/destructive only for real states.

Forbidden: decorative color-coding, mixed icon weights, icon badges that overpower text.

## 6. Color Usage

High craft: background has system warmth, surfaces are quiet, borders are barely visible, and blue is reserved for key action.

Low craft: pale blue is scattered across tags/buttons/icons, disabled states look like cheap CTA leftovers, or contrast is crude.

Current issues: primary tone appears in too many badges/cards/actions; disabled buttons can still feel like visual blocks.

Code fix: make neutral the default tone; use softer disabled surfaces; keep dividers at low alpha; put primary blue only on one main action per screen.

Forbidden: blue as decoration, green as decoration, heavy dividers, saturated backgrounds behind passive labels.

## 7. Button Weight

High craft: each page has one highest-weight action; inline actions are quiet; disabled states recede.

Low craft: multiple blue buttons, full-width buttons inside every card, or disabled buttons still command attention.

Current issues: Preview and Me can show too many button-like elements; card actions are sometimes too heavy.

Code fix: use primary button only for the page's main conversion; use ghost/text-like actions inside cards; make disabled buttons neutral and low-contrast.

Forbidden: every action as blue, marketing-like CTA text, giant fixed buttons for secondary actions.

## 8. Copy Quality

High craft: copy is specific, calm, short, and action-oriented. It preserves agency.

Low craft: mystical claims, clinical diagnosis, engineering terms, mock/test language, or long explanatory paragraphs.

Current issues: local/test copy appears in Me; some helper copy explains implementation details.

Code fix: hide local-only controls from normal UI; rewrite helper text into user-facing trust copy; map backend errors to plain language.

Forbidden: demo, mock, test, TODO, internal error, destiny claims, guaranteed outcomes.

## 9. Motion and Transitions

High craft: feedback is subtle and immediate: light haptics, 120-180ms pressed transitions, natural sheet appearance, and calm loading.

Low craft: no feedback, jumpy state changes, or decorative animation.

Current issues: basic haptics exist, but input focus and loading states are plain.

Code fix: use `AnimatedContainer` for pressed/focus/disabled surfaces; keep durations under 200ms; prefer `CupertinoActivityIndicator` with quiet copy.

Forbidden: large animated gradients, bouncing cards, motion that distracts from reading.

## 10. Empty and Error States

High craft: empty states are compact, helpful, and specific; errors explain what the user can do next.

Low craft: large generic cards, centered dead-end states, raw backend wording.

Current issues: `AppEmptyState` is card-heavy; error copy can dominate.

Code fix: reduce empty-state visual weight, use clear retry actions, and avoid placing errors in full-height centers when page context matters.

Forbidden: raw exception strings, oversized empty cards, alarming colors for recoverable issues.

## 11. TabBar Refinement

High craft: native, clear, low-noise, and never overlaps scroll content.

Low craft: heavy custom pills, oversized icons, labels too loud, or content hidden behind the bar.

Current issues: TabBar is close but content safety depends on fixed insets.

Code fix: keep icon size 22, neutral unselected color, light top border, and adequate bottom scroll padding.

Forbidden: selected pill, custom heavy background, icon scaling.

## 12. Forms and Input

High craft: fields have clear purpose, comfortable height, visible focus, helpful but short helper text, and keyboard-safe actions.

Low craft: long technical helper text, cramped fields, no focus state, or submit buttons covered by keyboard.

Current issues: timezone helper copy is too technical; inputs are functional but not refined.

Code fix: add subtle focus border, keep helper text human, use bottom bars for primary submit where useful.

Forbidden: implementation notes in form copy, validation only after failed network calls, labels that wrap awkwardly.

## 13. Small Screen Adaptation

High craft: no overflow, no clipped titles, scrollable content clears bottom bars, and long Chinese text wraps naturally.

Low craft: compressed cards, two-column long text, sticky controls covering content.

Current issues: chips and rows needed width constraints; fixed bottom insets may still need device checks.

Code fix: constrain chips, avoid narrow columns for long text, use `Flexible/Expanded`, and test small iPhone simulators.

Forbidden: non-scrollable forms, `maxLines: 1` for user-facing content, fixed widths that assume large screens.

## 14. Large Screen Adaptation

High craft: content stays readable with max-width rhythm, not stretched or empty.

Low craft: enormous line lengths, lonely cards, or center-aligned content that feels like a web page.

Current issues: current pages use full width on large iPhones; acceptable but should keep dense enough rhythm.

Code fix: avoid large empty hero areas; keep list density moderate; consider max content width only if iPad is supported.

Forbidden: oversized decorative whitespace, web-like center panels.

## 15. App Store Completion

High craft: no debug controls, no fake purchase language, no unfinished feature promises, polished legal/privacy surfaces, and resilient states.

Low craft: local premium buttons, beta features promoted as finished, placeholder copy, or hidden compliance gaps.

Current issues: local premium test exists under Me in local flavor; Relationship is visible as Beta.

Code fix: hide development-only controls from normal product review builds; keep Relationship secondary; make subscription language compliant until StoreKit is real.

Forbidden: mock/test/debug text in user UI, fake purchase success, overpromising AI or BaZi outcomes.

