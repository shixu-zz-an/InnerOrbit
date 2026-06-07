# Main Tabs Redesign Report

## Summary

This redesign moves the main tabs from a heavy card/dashboard feel toward a quieter iOS product surface: soft gray background, white cards, light borders, clearer type hierarchy, fewer competing modules, compact TabBar icons, and one dominant action per page.

Existing provider calls, API payloads, entitlement checks, route pushes, reflection saving, guide asking, export/delete, language selection, and paywall entry points were preserved.

## Round Log

### 1. Global Design System + TabBar

- Files changed: `pillarwise-ai/app/lib/core/theme/app_colors.dart`, `app_radius.dart`, `app_shadows.dart`, `app_spacing.dart`, `app_components.dart`, `app.dart`
- Visual adjustments: softened background/dividers, raised card radius to 22, reduced card shadow, increased bottom inset, set TabBar icons to 23px.
- Interaction adjustments: disabled buttons now use a true disabled color treatment instead of a faded active button.
- Copy adjustments: none.
- Business logic impact: none.
- Potential risk: global card radius affects onboarding and secondary screens too; this is visually aligned but should be spot-checked.

### 2. 今日页

- Files changed: `pillarwise-ai/app/lib/app.dart`
- Visual adjustments: replaced dashboard metrics and two-column signal cards with one main focus card, one light daily summary card, and one signal card.
- Interaction adjustments: bottom save action is hidden until reflection text exists; refresh and `askFromToday` remain unchanged.
- Copy adjustments: main daily copy rewritten to "让一个真实信号就足够" and "今天先完成一个踏实选择，不急着同时打开所有可能。"
- Business logic impact: none.
- Potential risk: main focus copy is now product-curated instead of directly echoing every backend focus title.

### 3. 蓝图页

- Files changed: `pillarwise-ai/app/lib/app.dart`
- Visual adjustments: rebuilt as a personal blueprint overview with one core summary card and a light section list.
- Interaction adjustments: tapping a section opens a detail sheet; locked sections still open paywall, unlocked sections can still save to journal.
- Copy adjustments: "解读章节" became "蓝图章节"; overview text is shorter and more scannable.
- Business logic impact: none.
- Potential risk: section detail now lives behind a tap, so users should verify the discoverability of row taps.

### 4. 提问页

- Files changed: `pillarwise-ai/app/lib/app.dart`, `app_components.dart`
- Visual adjustments: removed duplicate page title, added compact suggestion chips, replaced bulky empty card with a light empty hint.
- Interaction adjustments: bottom input uses `AppBottomInputBar`, keeps disabled send state, and still calls `askGuide`.
- Copy adjustments: prompt placeholder changed to "说出你正在纠结的事"; suggestions shortened.
- Business logic impact: none.
- Potential risk: chip tap still sends immediately, matching previous behavior; confirm this is desired.

### 5. 我的页

- Files changed: `pillarwise-ai/app/lib/app.dart`, `app_components.dart`
- Visual adjustments: replaced settings-first layout with `AppProfileHeader`, `AppPlanCard`, and compact grouped rows.
- Interaction adjustments: local premium test moved out of subscription area into a `local` flavor developer section.
- Copy adjustments: "实验功能" renamed to "探索更多"; relationship beta copy shortened; plan copy made formal.
- Business logic impact: none.
- Potential risk: "查看出生信息" opens a read-only dialog because no existing edit route/API was available.

### 6. Consistency + Cleanup

- Files changed: `pillarwise-ai/app/lib/app.dart`, `app_components.dart`
- Visual adjustments: removed main-tab ellipsis patterns, normalized icons, and deleted unused `_TodayMiniCard`.
- Interaction adjustments: no additional logic changes.
- Copy adjustments: reduced explanatory copy across root tab surfaces.
- Business logic impact: none.
- Potential risk: none found by analyzer.

## New or Refactored Components

- Refactored: `AppCard`, `AppButton`, `AppTabBar`, `AppListTile`, `AppMetricCard`, `AppInfoRow`, `AppSectionHeader`
- Added: `AppSuggestionChip`, `AppBottomInputBar`, `AppProfileHeader`, `AppPlanCard`
- Added local main-tab helpers: `_QuietIntro`, `_StackedInfoRow`, `_AskEmptyHint`

## Removed, Merged, or Weakened Cards

- 今日: removed two-column metric cards and two large signal cards; removed repeated weekly insight card.
- 蓝图: replaced repeated full insight cards with a single section list.
- 提问: replaced large empty-state card with a light hint.
- 我的: replaced multiple heavy settings cards with profile/plan cards and compact groups.

## Low-Quality Entrances Hidden or Moved

- "开启本地高级版测试" is no longer in the main subscription area; it only appears under `开发者设置` for `local` flavor.
- "实验功能" no longer appears as a product-facing section title; it is now "探索更多".

## Verification

- `dart format lib/app.dart lib/core/theme/app_colors.dart lib/core/theme/app_radius.dart lib/core/theme/app_shadows.dart lib/core/theme/app_spacing.dart lib/core/widgets/app_components.dart`: passed.
- `flutter analyze`: passed with no issues.
- `flutter test`: passed, `All tests passed`.
- `flutter run -d 311DBB21-35CE-40A0-8E8B-87171B2FBBE6`: built and launched on iPhone 17 Pro simulator. Flutter printed `Target native_assets required define SdkRoot but it was not provided`, but the app still launched and exposed VM Service.

## Still Needs Manual Device QA

- Small iPhone viewport: verify no row text feels too tall and TabBar does not cover final content.
- Large iPhone viewport: verify root pages do not feel sparse.
- Ask keyboard flow: verify input bar stays above keyboard and Home Indicator.
- Blueprint section detail sheet: verify users understand row taps.
- Me page developer section: verify release builds hide local premium test.

## Business Logic and Risks

- Backend API contracts were not changed.
- Core functions were not deleted.
- No paid capability was fabricated; local premium remains development-only and is gated by `APP_FLAVOR == local`.
- No heavy third-party UI framework was introduced.
- Main remaining risk is visual QA: the simulator launch confirms build/startup, but real-device scrolling, keyboard, and final iOS polish still need hands-on review.

