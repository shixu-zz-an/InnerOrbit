# Main Tabs Visual Audit

Scope: Flutter iOS main tabs in `lib/app.dart`, shared visual components in `lib/core/widgets/app_components.dart`, and design tokens in `lib/core/theme`.

## 1. 今日页

- Page name: 今日 / Today
- File path: `lib/app.dart`, `TodayScreen`, `_TodayScreenState`, `_TodayMiniCard`
- Current page purpose: Daily entry point for one personalized focus, practical action, reflection saving, and a shortcut into AI guide.
- Current largest visual problem: The page reads like a dashboard because focus, metrics, signals, journal, reflection input, and a repeated weekly card all compete for attention. The disabled bottom save button remains visually heavy.
- Current largest layout problem: Two metric cards and two signal cards use side-by-side layouts with long Chinese text, which encourages truncation and makes the page feel cramped on small iPhones.
- Current largest copy problem: Several backend-driven phrases are long and conceptual. The header subtitle and repeated weekly section make the page sound explanatory instead of directive.
- Current largest interaction problem: The primary CTA is split between the focus card and the disabled bottom save action. Users cannot clearly tell the single best thing to do today.
- Keep: Refresh action, today focus, challenge/opportunity signals, reflection save logic, journal continuation, `askFromToday` shortcut.
- De-emphasize: Weekly theme, latest journal, raw reflection input, secondary signal details.
- Delete or move later: Repeated final weekly `AppInsightCard`; large disabled save button when no reflection exists.
- Components to refactor: `AppCard`, `AppButton`, `AppMetricCard`, `AppSectionHeader`, `AppInfoRow`, `AppBottomActionBar`, add lighter daily summary rows.
- Priority: P0

## 2. 蓝图页

- Page name: 蓝图 / Blueprint
- File path: `lib/app.dart`, `BlueprintScreen`
- Current page purpose: Show a life blueprint preview/full report, allow asking about the core archetype, saving unlocked cards, and opening paywall for locked content.
- Current largest visual problem: It feels like an article feed of large cards rather than a personal blueprint overview.
- Current largest layout problem: Every blueprint section becomes a full `AppInsightCard`, so vertical rhythm is heavy and the last content risks feeling too close to the TabBar.
- Current largest copy problem: `蓝图预览 / 核心原型 / 解读章节` repeat similar concepts without making the most important conclusion obvious.
- Current largest interaction problem: The save/unlock action appears on every card with similar visual weight, diluting the core action of asking around the archetype.
- Keep: Preview/full source selection, core archetype, summary/headline, report cards, locked-card state, save-to-journal logic, paywall entry.
- De-emphasize: Long body copy in the tab root; repeated save buttons on every section.
- Delete or move later: Article-like expanded section cards on root; unlock CTA as an oversized end block if better represented by section locks.
- Components to refactor: `AppInsightCard`, `AppListTile`, add blueprint summary card and section row component.
- Priority: P0

## 3. 提问页

- Page name: 提问 / Ask
- File path: `lib/app.dart`, `AskScreen`, `_AskScreenState`, `_AiAnswerCard`
- Current page purpose: AI guide entry for suggested prompts, free-form question input, chat messages, answer save action, and quota/paywall state.
- Current largest visual problem: The page looks like a static prompt page, not a mature private AI guide surface.
- Current largest layout problem: The title repeats in navigation and page header; top content consumes space while the input is visually separated in a generic bottom bar.
- Current largest copy problem: The empty-state card title "从你的命盘开始提问" is too metaphysical and too large for an AI chat entry.
- Current largest interaction problem: Users may not know whether to tap a chip or type. Suggestion chips are tall and loose; the input does not feel like the main object.
- Keep: Prompt suggestions, `askGuide` logic, message rendering, loading state, quota/paywall error handling, save answer action.
- De-emphasize: Large empty-state explanation card.
- Delete or move later: Duplicate page title and bulky "chart" framing in the empty state.
- Components to refactor: `AppComposer` into `AppBottomInputBar`, `AppTag` into `AppSuggestionChip`, `_AiAnswerCard`, `AppEmptyState`.
- Priority: P0

## 4. 我的页

- Page name: 我的 / Me
- File path: `lib/app.dart`, `MeScreen`
- Current page purpose: Account profile, birth details, plan/subscription, labs, saved journal, privacy/data, language, legal, and version.
- Current largest visual problem: It reads as a settings/debug menu and lacks a polished account-and-blueprint center.
- Current largest layout problem: Multiple `AppCard` wrappers each contain large list rows, causing stacked panels and coarse vertical density.
- Current largest copy problem: "开启本地高级版测试" and "实验功能" expose development language directly in the main product surface.
- Current largest interaction problem: Subscription, local testing, labs, and account settings all have similar prominence, which lowers trust.
- Keep: Profile display, birth details, plan state, paywall entry, manage subscription text, journal, export/delete, language, legal, version.
- De-emphasize: Relationship beta workflow, legal/data sections, destructive account action.
- Delete or move later: Local premium test from main list; direct "实验功能" section title.
- Components to refactor: Add `AppProfileHeader`, `AppPlanCard`, more compact `AppListTile`, developer tools section guarded by local flavor.
- Priority: P0

## 5. 底部 TabBar

- Page name: Main TabBar
- File path: `lib/app.dart`, `MainTabs`; `lib/core/widgets/app_components.dart`, `AppTabBar`
- Current purpose: Navigate between 今日、蓝图、提问、我的.
- Current largest visual problem: Icons inherit Cupertino defaults without enough control over size and selected/unselected weight.
- Current largest layout problem: Bottom area feels heavier than native iOS because item sizing and page bottom padding are not coordinated.
- Current largest copy problem: Tab labels are fine and should remain short.
- Current largest interaction problem: No issue with tap logic; visual feedback should be subtler.
- Keep: Four-tab information architecture and `selectedTab` state.
- De-emphasize: Sparkle-heavy first icon and oversized selected visual.
- Delete or move later: None.
- Components to refactor: `AppTabBar`, add helper for 22-24px icons, tune `AppSpacing.tabBottomInset`.
- Priority: P0

## 6. 通用卡片组件

- Component: `AppCard`, `AppInsightCard`, `AppMetricCard`
- File path: `lib/core/widgets/app_components.dart`
- Current purpose: Shared surfaces for insights, metrics, empty states, feature locks, answers.
- Current largest visual problem: `AppRadius.card` is 8, which feels more like a web/admin panel than a mature iOS surface; cards are too uniformly weighted.
- Current largest layout problem: Metric cards put long titles in compact fixed structures and use ellipsis.
- Current largest copy problem: Components encourage passing long title/body directly into root screens.
- Current largest interaction problem: Tappable cards do not visually distinguish light list navigation from primary content.
- Keep: Single reusable surface abstraction and tone system.
- De-emphasize: Shadows, visible borders, dense cards.
- Delete or move later: Long-text metric cards in two-column layouts.
- Components to refactor: `AppCard`, `AppInsightCard`, `AppMetricCard`.
- Priority: P0

## 7. 通用按钮组件

- Component: `AppButton`, `AppIconButton`
- File path: `lib/core/widgets/app_components.dart`
- Current purpose: Primary/secondary/destructive/ghost buttons and small circular icon actions.
- Current largest visual problem: Disabled primary buttons keep a large filled silhouette and only fade opacity.
- Current largest layout problem: Full-width buttons are used inside cards and bottom bars too often, which adds pressure.
- Current largest copy problem: Long button text can ellipsize.
- Current largest interaction problem: Secondary card actions can look as heavy as main actions.
- Keep: Loading state, icon support, variants, haptics.
- De-emphasize: Filled secondary surfaces and disabled primary fills.
- Delete or move later: None.
- Components to refactor: `AppButton`, maybe add compact/text behavior through variants.
- Priority: P0

## 8. 通用列表项组件

- Component: `AppListTile`, `AppSettingItem`
- File path: `lib/core/widgets/app_components.dart`
- Current purpose: Settings and grouped rows.
- Current largest visual problem: Rows are large and icon avatars introduce too many colored pills.
- Current largest layout problem: Subtitles are capped with ellipsis, so important Chinese text can look unfinished.
- Current largest copy problem: Development and beta labels are passed directly into product rows.
- Current largest interaction problem: Chevron and trailing elements have similar visual priority.
- Keep: Leading/trailing/onTap API.
- De-emphasize: Colored avatars, heavy dividers.
- Delete or move later: None.
- Components to refactor: `AppListTile`, add lighter icon treatment.
- Priority: P1

## 9. 通用页面容器

- Component: `AppPage`, `AppNavigationBar`, `AppPageHeader`, `AppBottomActionBar`
- File path: `lib/core/widgets/app_components.dart`
- Current purpose: Cupertino page scaffold, navigation bar, page title blocks, bottom action area.
- Current largest visual problem: Header and navigation title can duplicate hierarchy, especially in Ask.
- Current largest layout problem: Bottom action bar is generic and can create a visual wall above Home Indicator.
- Current largest copy problem: Header subtitle supports long explanatory text, encouraging pages to over-explain.
- Current largest interaction problem: Keyboard and bottom input need a more specialized component than generic bottom action.
- Keep: SafeArea handling, tap-to-dismiss keyboard, reusable nav bar.
- De-emphasize: Large page headers on every tab.
- Delete or move later: None.
- Components to refactor: `AppPageHeader`, `AppBottomInputBar`.
- Priority: P0

## 10. Theme, Color, Type, Spacing, Radius, Shadows

- Files: `lib/core/theme/app_colors.dart`, `app_text_styles.dart`, `app_spacing.dart`, `app_radius.dart`, `app_shadows.dart`, `app_theme.dart`
- Current purpose: App-wide Cupertino tokens.
- Current largest visual problem: The palette is mostly appropriate, but component defaults do not use it with enough subtlety.
- Current largest layout problem: `tabBottomInset` and generic page spacing need coordination with TabBar and bottom input.
- Current largest copy problem: Not token-related, but large type styles invite overuse.
- Current largest interaction problem: Disabled/pressed states lack a refined token.
- Keep: SF Pro usage, shallow color semantics, Cupertino app theme.
- De-emphasize: Heavy primary/secondary backgrounds.
- Delete or move later: Scattered direct `AppColors.lightSurface` references when semantic aliases exist.
- Components to refactor: `AppRadius`, `AppTextStyles`, `AppShadows`, `AppTheme`.
- Priority: P0

