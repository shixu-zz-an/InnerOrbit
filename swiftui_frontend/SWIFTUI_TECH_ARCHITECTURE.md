# SwiftUI Technical Architecture

## App Entry

The SwiftUI app should use a native app target named `BluePrintApp`.

```swift
@main
struct BluePrintApp: App {
    @StateObject private var environment = AppEnvironment.live()

    var body: some Scene {
        WindowGroup {
            AppRouterView()
                .environmentObject(environment)
        }
    }
}
```

Minimum recommended deployment target: iOS 17 if the product can choose modern Observation APIs; otherwise iOS 16 with `ObservableObject`. First skeleton should use `ObservableObject` for compatibility and easy previews.

## Directory Structure

```text
swiftui_frontend/
  README.md
  MIGRATION_AUDIT.md
  SWIFTUI_PRODUCT_ARCHITECTURE.md
  SWIFTUI_TECH_ARCHITECTURE.md
  BluePrintApp/
    BluePrintApp/
      App/
      Core/
        DesignSystem/
        Networking/
        Storage/
        Analytics/
        Extensions/
        Utilities/
      Models/
      Services/
      Features/
        Onboarding/
        Today/
        Blueprint/
        Ask/
        Profile/
        Subscription/
        Settings/
      Shared/
        Components/
        States/
        Sheets/
      Resources/
      PreviewContent/
```

## Routing Design

Use `NavigationStack` inside each Tab and lightweight route enums.

- `AppRoute`: boot, onboarding, main.
- `OnboardingRoute`: value screens, birth setup, generating, preview.
- `TodayRoute`: reflection detail if needed.
- `BlueprintRoute`: section detail, ask handoff, premium info.
- `AskRoute`: conversation if split from main Ask.
- `ProfileRoute`: birth details, saved reflections, settings, privacy, terms, delete account.

Avoid a global string router. Routes should be typed and feature-owned where possible.

## ViewModel Design

Use MVVM with focused ViewModels:

- `AppSessionViewModel`: initialization, auth token/session, `me`, high-level app state.
- `OnboardingViewModel`: onboarding progress, birth draft, create profile, generate preview.
- `TodayViewModel`: fetch daily insight, save reflection, retry.
- `BlueprintViewModel`: load latest report, derive sections, open detail.
- `AskViewModel`: conversation lifecycle, send message, retry, save answer.
- `ProfileViewModel`: user summary, entitlement, settings actions, export/delete.
- `SubscriptionViewModel`: entitlement and StoreKit state when implemented.

Each ViewModel should expose a `LoadableState<T>` or explicit states:

```swift
enum ViewState<Value> {
    case idle
    case loading
    case empty(EmptyStateContent)
    case loaded(Value)
    case failed(AppError)
}
```

For submitting actions, use separate `isSubmitting` flags or `ActionState`, so loading a page does not block every button.

## Service Design

Services map to backend ownership:

- `AuthService`
- `UserService`
- `BirthProfileService`
- `BlueprintService`
- `TodayInsightService`
- `AskGuideService`
- `JournalService`
- `RelationshipService`
- `SubscriptionService`
- `AnalyticsService`

Views do not call services directly. ViewModels call protocols injected through `AppEnvironment`.

## API Client Design

`APIClient` should use `URLSession` and async/await.

Responsibilities:

- Build URL from `APIConfiguration.baseURL` + endpoint path.
- Encode JSON request bodies with unchanged backend keys.
- Add `Content-Type: application/json`.
- Add `Authorization: Bearer <token>` when present.
- Add `X-Request-Id`.
- Decode `APIEnvelope<T>`.
- Throw `APIError` from backend error envelope.
- Map transport errors to user-safe `AppError`.

Endpoints should be centralized:

```swift
enum APIEndpoint {
    case devSession
    case me
    case primaryBirthProfile
    case createBirthProfile
    case lifeBlueprint
    case today
    case aiConversations
    case aiMessages
    case reports
    case report(id: String)
    case journal
    case entitlement
}
```

Do not write `URLSession` calls inside SwiftUI Views.

## Error Handling

Create two layers:

- `APIError`: exact backend/transport information.
- `AppError`: user-facing title, message, recovery action.

Known backend codes:

- `UNAUTHORIZED`: clear token and recreate local session in debug/local.
- `ENTITLEMENT_REQUIRED`: show locked state or premium info; do not auto-open a fake purchase sheet.
- Validation errors: point to the relevant field.
- Not found: show create/retry guidance.

Never show stack traces, raw Java/Dio errors, or JSON dumps in product UI.

## Loading / Empty / Error / Success States

Shared states should cover:

- Loading: page-level and inline.
- Empty: first-time state with one clear action.
- Error: user-safe message + retry.
- Offline/network error: retry and keep last loaded data if available.
- Permission denied: explanation + next step.
- Locked/pro required: honest capability boundary.
- Submitting: disable duplicate taps.
- Success: lightweight confirmation, not blocking modals.

## Local Storage

Use:

- Keychain for `access_token`.
- `UserDefaults` / `AppStorage` for onboarding completion, birth draft, locale, API mode.
- Optional file cache only after real need appears.

Local keys should be namespaced, e.g. `blueprint.onboardingDraft`.

## Token / User Storage

`AuthTokenStore` protocol:

```swift
protocol AuthTokenStore {
    func readToken() async -> String?
    func writeToken(_ token: String) async throws
    func clearToken() async throws
}
```

Production must not rely on dev-session as the only auth strategy. Until Apple Sign In is implemented, SwiftUI release notes must state authentication is local/dev.

## Subscription Design

Current backend supports local/fake activation endpoints. SwiftUI should reserve:

- `StoreKitSubscriptionService` using StoreKit 2.
- `MockSubscriptionService` for previews/tests.
- `LocalDebugSubscriptionService` only in Debug.

Release UI rules:

- No fake "Start plan" button.
- No local unlock button.
- No price unless products are fetched from StoreKit.
- Restore Purchases appears only after StoreKit integration.

## Analytics Design

`AnalyticsService.track(_ event:properties:)` should:

- Use `/api/v1/analytics/events`.
- Never block product actions.
- Fail silently after optional debug logging.
- Keep events small and non-sensitive.

## Preview And Mock Data

Create `PreviewContent` with static mock values:

- `MockBirthProfile`
- `MockTodayInsight`
- `MockBlueprintReport`
- `MockAIAnswer`
- `MockJournalEntry`

Mock services should conform to the same protocols as live services. Previews should not require backend.

## Reusing Existing Backend Interfaces

Strictly preserve:

- URL paths.
- HTTP methods.
- Request field names.
- Response envelope shape.
- Bearer auth.
- Business semantics for preview/full/entitlement.

Swift models may include display helpers but must not change API payloads.

## Avoiding Backend Pollution

- Keep all SwiftUI-only display grouping in ViewModels.
- Do not request backend changes for UI-only layout needs.
- Do not add fake fields to API requests.
- Use tolerant decoding for flexible AI/report content.
- Capture unclear API issues in `API_MIGRATION_NOTES.md` before proposing backend changes.

