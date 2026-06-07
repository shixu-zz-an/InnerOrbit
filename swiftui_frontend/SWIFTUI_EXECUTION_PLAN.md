# SwiftUI Migration Execution Plan

This document is the operating plan for completing the native SwiftUI frontend from the current first-batch documentation state through final delivery. It is intentionally explicit so later implementation work can continue without re-asking for direction.

## Non-Negotiable Rules

- Do not modify backend code.
- Do not modify backend API paths, methods, request fields, response fields, auth rules, or database schema.
- Do not delete, overwrite, or refactor the existing Flutter app.
- Do not keep repairing Flutter UI.
- Treat Flutter as function/API reference only, not design reference.
- Do not expose fake/local premium unlock in release UI.
- Do not show real purchase buttons until StoreKit 2 is implemented and wired honestly.
- Do not present AI output as deterministic, diagnostic, medical, legal, financial, emergency, or guaranteed advice.
- Keep each batch buildable or clearly isolated and reversible.
- Keep all new work under `swiftui_frontend/` unless explicitly required by a later Xcode project generation step.

## Current Completed State

Completed first batch:

- `MIGRATION_AUDIT.md`
- `SWIFTUI_PRODUCT_ARCHITECTURE.md`
- `SWIFTUI_TECH_ARCHITECTURE.md`
- `README.md` initial version
- `swiftui_frontend/BluePrintApp/BluePrintApp/` source directory skeleton

Current state is not runnable yet. No SwiftUI source code has been implemented.

## Batch 2: SwiftUI Project Skeleton

### Goal

Create a native SwiftUI app foundation that can compile and show a polished shell with navigation, tabs, design system primitives, shared states, and preview mock data.

### Files / Areas

- `BluePrintApp/BluePrintApp.xcodeproj` if project generation is practical.
- `BluePrintApp/BluePrintApp/App/`
- `BluePrintApp/BluePrintApp/Core/DesignSystem/`
- `BluePrintApp/BluePrintApp/Core/Networking/`
- `BluePrintApp/BluePrintApp/Core/Storage/`
- `BluePrintApp/BluePrintApp/Core/Analytics/`
- `BluePrintApp/BluePrintApp/Shared/Components/`
- `BluePrintApp/BluePrintApp/Shared/States/`
- `BluePrintApp/BluePrintApp/PreviewContent/`

### Implementation

- Add `BluePrintApp.swift`.
- Add `AppEnvironment`.
- Add `AppRouter`.
- Add `RootView`.
- Add `MainTabView`.
- Add tab enum: Today, Blueprint, Ask, Mine.
- Add design system:
  - `AppColor.swift`
  - `AppTypography.swift`
  - `AppSpacing.swift`
  - `AppRadius.swift`
  - `AppShadow.swift`
  - `AppTheme.swift`
  - `AppIcon.swift`
  - `AppAnimation.swift`
- Add shared primitives:
  - `AppPage`
  - `AppCard`
  - `AppButton`
  - `AppListRow`
  - `AppSectionHeader`
  - `AppTag`
  - `AppSuggestionChip`
  - `AppInfoRow`
  - `AppBottomInputBar`
  - `AppTextField`
  - `AppTextEditor`
  - `AppEmptyState`
  - `AppLoadingState`
  - `AppErrorState`
  - `AppLockedState`
  - `AppToast`
- Add `ViewState` / `LoadableState`.
- Add Preview mock content.

### Acceptance Criteria

- App target or Swift package can be opened/build attempted.
- Root shell renders onboarding placeholder or tabs placeholder.
- Main tabs exist but use placeholder feature views.
- Shared components have previews.
- Design system uses system colors/fonts and dynamic type-friendly APIs.
- No Flutter files modified.

### Mock / Real State

- Everything is mock at this stage.
- API client may exist as a skeleton but feature screens do not call real backend yet.

### Exit Report

Record:

- Completed files.
- Build command result.
- What is runnable.
- What remains mock.
- Next batch scope.

## Batch 3: Onboarding + Birth Information Setup

### Goal

Implement first-run native onboarding and birth profile setup with sheet-based date/time/location interactions.

### Files / Areas

- `Features/Onboarding/`
- `Shared/Sheets/`
- `Core/Storage/`
- `Models/BirthProfile*`
- `Services/BirthProfileService` mock first

### Implementation

- Three onboarding value screens.
- Skip value screens if allowed, but route to birth setup before personalized core experience.
- Birth setup main screen with confirmation rows:
  - birth date
  - birth time
  - time precision: exact / approximate / unknown
  - birthplace text
  - timezone
  - traditional cycle info
- Native sheets:
  - `AppDatePickerSheet`
  - `AppTimePickerSheet`
  - `AppLocationPickerSheet`
  - optional `AppConfirmSheet`
- Persist onboarding draft locally.
- Add generate-blueprint action as mock first.
- Add loading, validation, failure, and success states.

### UX Rules

- Do not put wheel pickers permanently on the page.
- Do not make the screen look like a backend form.
- Do not fake coordinates.
- Do not force login.
- Do not pressure the user with fatalistic language.

### Acceptance Criteria

- User can complete onboarding.
- User can enter/edit birth date, time precision/time, location/timezone.
- Unknown birth time works.
- Submit button prevents duplicate taps.
- Draft persists across app restart if storage is available.
- Flow enters main tabs or preview placeholder.

### Mock / Real State

- May still use mock generation unless Batch 5 services are pulled forward carefully.

## Batch 4: Main Tab UI

### Goal

Implement complete native UI for Today, Blueprint, Ask, and Mine using mock data and production-grade states.

### Files / Areas

- `Features/Today/`
- `Features/Blueprint/`
- `Features/Ask/`
- `Features/Profile/`
- `Features/Settings/` lightweight links/placeholders
- `PreviewContent/`

### Today

- Header: Today.
- Short subtitle: one focus, one next step.
- Primary focus section.
- One primary action: break down next step.
- Secondary content:
  - weekly theme
  - today action
  - today signals
- Reflection input and save affordance.
- Loading / empty / error states.

### Blueprint

- Overview, not article list.
- Core archetype title.
- Summary.
- Section list:
  - Core pattern
  - Hidden strengths
  - Growth reminders
  - Relationship clues
  - Action suggestions
- Detail page for sections.
- Ask-about-this action.

### Ask

- Input-first layout.
- Suggested chips.
- Empty state.
- AI answer card structure:
  - headline
  - summary
  - sections
  - practical step
  - reflection question
- Continue asking.
- Save reflection.
- Loading/error/retry.

### Mine

- User summary.
- Current blueprint.
- Birth information.
- Plan status.
- Learn about Premium.
- Saved reflections.
- Settings.
- Privacy.
- Delete/export entries as secondary settings actions.

### Acceptance Criteria

- All four tabs render as complete product pages.
- No debug/developer/local premium entries.
- No large blank screens.
- No TabBar content obstruction.
- No keyboard obstruction for Ask input.
- No copied Flutter form/card structure.
- Mock states are clearly internal preview/development behavior only.

## Batch 5: Real Backend Services

### Goal

Connect SwiftUI ViewModels to existing backend endpoints without changing backend contracts.

### Files / Areas

- `Core/Networking/`
- `Core/Storage/`
- `Models/`
- `Services/`
- feature ViewModels

### Implementation

- `APIClient`
- `APIEndpoint`
- `APIError`
- `APIEnvelope`
- `AuthTokenStore`
- `APIConfiguration`
- Service protocols and live implementations:
  - `AuthService`
  - `UserService`
  - `BirthProfileService`
  - `BlueprintService`
  - `TodayInsightService`
  - `AskGuideService`
  - `JournalService`
  - `SubscriptionService`
  - `AnalyticsService`
- Keychain-backed token store.
- Dev-session bootstrap for local/debug.
- Typed Codable request/response models.
- Tolerant decoding for AI/report dynamic JSON.
- ViewModels call services, not `URLSession` directly.

### Required Endpoint Behavior

- Preserve all paths.
- Preserve all request fields.
- Preserve bearer token auth.
- Preserve `success/data/error/meta`.
- Preserve mode values: `preview`, `full`.
- Preserve entitlement semantics.

### Acceptance Criteria

- App initializes against local backend.
- Birth profile can be created.
- Blueprint preview can be generated.
- Main data loads:
  - primary birth profile
  - entitlement
  - today
  - latest report
  - journal
- Ask sends message and renders structured answer.
- Reflection save works.
- Backend errors become user-safe messages.
- Analytics failures never block UI.

### If API Is Unclear

Create `API_MIGRATION_NOTES.md` and continue with the safest existing contract. Do not edit backend.

## Batch 6: Subscription, Settings, Privacy, Details

### Goal

Complete secondary product surfaces without creating App Store risk.

### Files / Areas

- `Features/Subscription/`
- `Features/Settings/`
- `Features/Profile/`
- `Features/Blueprint/Detail`
- `Features/Ask/Conversation`
- `Shared/Sheets/`

### Implementation

- Blueprint section detail page.
- Saved reflections list.
- Settings stack:
  - Language
  - Birth details
  - Privacy
  - Terms
  - Disclaimer
  - Export data
  - Delete account
- Premium information page:
  - honest current state
  - no fake purchase
  - no local activation in release
  - StoreKit 2 placeholder architecture only unless fully implemented
- Optional debug-only local entitlement screen guarded by compiler flags, not visible in release.

### Acceptance Criteria

- No unfinished page looks like a blank shell.
- No fake StoreKit.
- No deceptive paid claims.
- Privacy/data usage is clear.
- Delete/export flows have confirmations and safe states.
- Relationship feature remains hidden or secondary, not a main Tab.

## Batch 7: App Store Readiness + Final Polish

### Goal

Prepare a SwiftUI frontend that feels like a finished native iOS product and document launch readiness.

### Files / Areas

- `APP_STORE_SWIFTUI_READINESS.md`
- `SWIFTUI_MIGRATION_REPORT.md`
- README final update
- all feature files

### Review Checklist

- Complete product, not a shell.
- No test/debug/local unlock visible in release.
- No Flutter traces.
- No template-like UI.
- No fake subscription.
- No external purchase risk.
- No deterministic/fatalistic AI framing.
- No medical/legal/financial/mental-health diagnosis claims.
- No raw technical errors.
- No excessive card stacks.
- No persistent picker forms.
- No text truncation in core screens.
- No bottom Tab/input obstruction.
- Dynamic type and small iPhone layout acceptable.
- Light mode polished.
- Dark mode either supported or explicitly stable with system colors.

### Documents To Generate

- `APP_STORE_SWIFTUI_READINESS.md`
- `SWIFTUI_MIGRATION_REPORT.md`
- Final `README.md`

### Acceptance Criteria

- Build attempted and result recorded.
- Core user path works:
  - launch
  - onboarding
  - birth setup
  - main tabs
  - today
  - blueprint
  - ask
  - mine/settings
- Known gaps documented honestly.
- Next 10 tasks listed.

## Final Delivery Report Requirements

`SWIFTUI_MIGRATION_REPORT.md` must include:

- Migrated Flutter functions.
- Unmigrated Flutter functions.
- New SwiftUI information architecture.
- New SwiftUI page list.
- New SwiftUI component list.
- Backend interface reuse.
- Data model reuse.
- Flutter designs intentionally abandoned.
- Refactored flows.
- Sheet/detail conversions.
- Hidden low-quality entries.
- Backend confirmations still needed.
- StoreKit/IAP support still needed.
- True-device validation needs.
- Current launch readiness status.
- Next 10 tasks.

## Quality Bar For All Batches

- Views remain short and composable.
- Logic lives in ViewModels/services.
- Codable models mirror backend contracts.
- No massive `ContentView`.
- No hardcoded one-off design values in feature views when design tokens exist.
- No unnecessary `GeometryReader`.
- No `AnyView` unless justified.
- No deprecated APIs.
- Async errors handled.
- No blocking work on main thread.
- No permanent TODO/mock/demo copy in release-facing UI.

## Operating Cadence

For every batch completion, record:

- What was completed.
- New files.
- Modified files.
- What is runnable.
- What remains mock.
- What depends on backend.
- Whether Flutter/backend was affected.
- Next batch plan.

