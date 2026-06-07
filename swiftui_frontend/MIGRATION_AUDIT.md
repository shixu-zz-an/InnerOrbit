# SwiftUI Migration Audit

## Scope

This audit is based on the current Flutter app under `pillarwise-ai/app`, backend API contracts under `pillarwise-ai/backend`, and the SDD/OpenAPI files under `PillarWise_AI_SDD_v1.0`. The SwiftUI app must treat Flutter as a functional reference only. Visual structure, form layouts, card density, and paywall behavior should be redesigned for native iOS.

## Current Flutter Architecture

| Area | Current implementation | Notes for SwiftUI |
|---|---|---|
| App entry | `lib/main.dart`, `lib/app.dart` | `PillarWiseApp` boots a `CupertinoApp` and switches between loading, onboarding, and tabs. |
| State management | `lib/app_state.dart` | Riverpod `StateNotifier` holds all feature state in one `AppState`. SwiftUI should split this into feature ViewModels and lightweight app session state. |
| Networking | `lib/core/network/api_client.dart` | Dio client with bearer auth, `X-Request-Id`, and unified `success/data/error/meta` envelope. Must be preserved. |
| Config | `lib/core/config/app_config.dart` | `API_BASE_URL` default is `http://127.0.0.1:8080`; `APP_FLAVOR` default is `local`. |
| Local storage | `lib/core/storage/local_store.dart` | Secure token storage plus `SharedPreferences` for onboarding draft and locale. SwiftUI should use Keychain + `UserDefaults` / `AppStorage`. |
| Theme/components | `lib/core/theme/*`, `lib/core/widgets/app_components.dart` | Useful as feature inventory, not as visual design source. Existing component file is too large and Flutter-specific. |
| Localization | `lib/l10n/*.arb`, generated localizations | English and Simplified Chinese strings exist. SwiftUI can reuse product meaning but should rewrite final copy. |
| iOS config | `ios/Runner/Info.plist`, Runner Xcode project | Flutter Runner only. Do not modify in this phase. |

## Existing Functional Modules

| Module | Flutter files | APIs | Data models / fields | User goal | Migrate? | Can hide in first SwiftUI version? | SwiftUI redo recommendation |
|---|---|---|---|---|---|---|---|
| App boot/session | `app.dart`, `app_state.dart`, `api_client.dart`, `local_store.dart` | `GET /api/v1/auth/dev-session`, `GET /api/v1/me` | `accessToken`, `me.id`, `displayName`, `locale`, `hasPrimaryBirthProfile`, `entitlement` | Start app and know whether user has a primary profile | Yes | No | Build `AppEnvironment`, `SessionStore`, `AuthService`; use dev session only for local/debug until real Apple auth is configured. |
| Onboarding | `WelcomeScreen`, `DisclaimerScreen`, `ProfileSetupScreen`, `StepScaffold` in `app.dart` | Eventually posts birth profile and blueprint | `OnboardingDraft` | Understand product value and begin first blueprint | Yes | No | Reduce to max 3 value screens, then a native birth info setup. Keep safety disclaimer but do not make it feel like a legal wall. |
| Birth information setup | `ProfileSetupScreen`, `BirthDateScreen`, `BirthTimeScreen`, `BirthPlaceScreen`, `TraditionalScreen`, `GoalScreen` | `POST /api/v1/birth-profiles` | `birthDate`, `birthTime`, `birthTimePrecision`, `birthPlaceText`, `latitude`, `longitude`, `timezone`, `sexForTraditionalCycle`, `trueSolarTimeEnabled`, `isPrimary`, goals local-only | Generate required profile/chart inputs | Yes | No | Replace persistent pickers with confirmation rows and sheets. Location should be searchable/manual without fake coordinates. `sexForTraditionalCycle` copy must be careful and secondary. |
| Blueprint generation/preview | `generateProfileAndPreview`, `GeneratingScreen`, `PreviewScreen` | `POST /api/v1/reports/life-blueprint` | request: `birthProfileId`, `mode`; response: `reportId`, `reportType`, `unlocked`, `preview`, `fullReport`, `lockedSections` | See first personal blueprint | Yes | No | Make preview a finished free experience, not a paywall trap. Treat locked sections honestly. |
| Today | `TodayScreen` | `GET /api/v1/today`, `POST /api/v1/journal`, analytics | `date`, `greeting`, `focus{title,body}`, `challenge`, `opportunity`, `action`, `reflectionQuestion`, `weeklyTheme`, `confidence`, `id` | Get one daily focus and save reflection | Yes | No | One primary insight and one primary action. Less card stacking. Clear loading/empty/error states. |
| Blueprint overview | `BlueprintScreen` | `GET /api/v1/reports`, `GET /api/v1/reports/{id}`, `POST /api/v1/ai/messages`, `POST /api/v1/journal` | `preview/fullReport.coreArchetype`, `headline`, `summary`, `cards[]`, `locked` | Understand personal blueprint as a coherent map | Yes | No | Reframe as overview + structured sections + detail pages. Avoid article-feed look. |
| Blueprint detail | `showBlueprintSectionDetail` | `POST /api/v1/journal`, possible Ask handoff | section card fields: `label`, `title`, `body`, `locked` | Read a specific section and act on it | Yes | No | Native `NavigationStack` detail view; save and ask actions in toolbar/bottom area. No deterministic language. |
| Ask / AI guide | `AskScreen`, `_AiAnswerCard`, `askGuide` | `POST /api/v1/ai/conversations`, `POST /api/v1/ai/messages`, `GET /api/v1/ai/conversations/{id}` | request: `conversationId`, `birthProfileId`, `message`, `context.includeBlueprint`, `context.locale`; answer: `headline`, `summary`, `sections[]`, `practicalStep`, `reflectionQuestion` | Ask a private reflective question and receive practical guidance | Yes | No | Input-first experience. Suggested chips should be light. Conversation view can be integrated first, split later if needed. |
| Journal / saved reflections | `SavedJournalScreen`, `saveReflection` | `GET /api/v1/journal`, `POST /api/v1/journal`, `PUT /api/v1/journal/{id}`, `DELETE /api/v1/journal/{id}` | `id`, `sourceType`, `sourceId`, `prompt`, `content`, `createdAt`, `updatedAt` | Save useful reflections and revisit them | Yes | Could be secondary | Keep entry list under Profile or Today; avoid making it a main Tab. |
| Profile / Me | `MeScreen` | `GET /api/v1/me`, `GET /api/v1/me/export`, `DELETE /api/v1/me`, entitlement, journal | user, birth profile, entitlement, counts | Manage account, data, plan, settings | Yes | No | Make it a formal account/settings hub. Hide debug/local premium in release. |
| Subscription / Premium | `showPaywall`, `activatePremium`, `AppPlanCard` | `GET /api/v1/subscriptions/entitlement`, `POST /api/v1/subscriptions/local/activate`, `POST /api/v1/purchases/local/unlock` | `premiumActive`, `plan`, `expiresAt`, `features` | Understand paid capability | Partial | Yes unless StoreKit is real | Do not show purchasable buttons without StoreKit 2. Use "Learn about Premium" or "Coming soon" for release until IAP is connected. Local unlock Debug only. |
| Relationship / Love | `LoveScreen`, `RelationshipCard`, `showAddRelationship`, `showRelationshipReport` | `GET/POST /api/v1/relationships`, `POST /api/v1/relationships/{id}/report`, `DELETE /api/v1/relationships/{id}` | `targetName`, `relationshipType`, target birth fields, preview/full relationship report | Explore communication patterns with another person | Defer | Yes | Do not put in main Tab. Consider secondary feature from Blueprint/Ask after core loop is stable. Avoid "compatibility verdict" framing. |
| Settings / privacy / legal | `MeScreen`, `showLegal`, `confirmDeleteAccount`, `showLanguageSheet` | `GET /api/v1/me/export`, `DELETE /api/v1/me` | privacy text, export payload, locale | Understand data use and manage account | Yes | No | Dedicated Settings stack with Privacy, Terms, Disclaimer, Language, Export, Delete. |
| Analytics | `trackEvent` in `AppController` | `POST /api/v1/analytics/events` | `eventName`, `properties` | Measure core loop and failures | Yes as non-blocking | Can stub | Create `AnalyticsClient` that never blocks UI. |
| App Store/iOS config | `Info.plist`, `pubspec.yaml`, SDD release docs | N/A | version, bundle display name, orientations | Ship iOS app | Later | No | New SwiftUI project needs its own bundle/settings. Avoid touching Flutter Runner in first phase. |

## API Inventory

All business APIs use:

- Base URL: `http://127.0.0.1:8080` by default.
- Header: `Content-Type: application/json`.
- Header: `Authorization: Bearer <token>` after session creation.
- Header: `X-Request-Id`.
- Response envelope: `{ "success": true, "data": ..., "error": null, "meta": ... }` or `{ "success": false, "data": null, "error": { "code", "message", "details" }, "meta": ... }`.

| API | Current Flutter usage | SwiftUI service |
|---|---|---|
| `GET /api/v1/auth/dev-session` | Auto-created if no token | `AuthService.createDevSession()` for local/debug only. |
| `POST /api/v1/auth/apple` | Not used; backend returns not configured | Reserve `SignInWithAppleService`; do not claim production login is ready. |
| `GET /api/v1/me` | App initialization | `UserService.fetchMe()`. |
| `GET /api/v1/me/export` | Profile export action | `UserService.exportData()`. |
| `DELETE /api/v1/me` | Delete account with `confirmation: DELETE` | `UserService.deleteAccount()`. |
| `POST /api/v1/birth-profiles` | Onboarding profile creation | `BirthProfileService.createPrimaryProfile()`. |
| `GET /api/v1/birth-profiles/primary` | Main data load | `BirthProfileService.primary()`. |
| `DELETE /api/v1/birth-profiles/{id}` | Backend supports; Flutter does not expose broadly | Keep for later edit/delete profile flow. |
| `GET /api/v1/bazi/charts/{birthProfileId}` | Available but not central in Flutter UI | `ChartService.chart()` for detail/diagnostics only. |
| `POST /api/v1/reports/life-blueprint` | Preview/full generation | `BlueprintService.generate(mode:)`. |
| `GET /api/v1/reports` | Find latest life blueprint | `BlueprintService.listReports()`. |
| `GET /api/v1/reports/{id}` | Load latest report details | `BlueprintService.report(id:)`. |
| `POST /api/v1/reports/{id}/unlock-local` | Backend local unlock | Debug only; no release UI. |
| `GET /api/v1/today` | Today page | `TodayService.fetchToday(profileId:date:)`. |
| `POST /api/v1/ai/conversations` | First Ask message | `AskService.createConversation()`. |
| `POST /api/v1/ai/messages` | Ask and Today/Blueprint handoff | `AskService.sendMessage()`. |
| `GET /api/v1/ai/conversations/{id}` | Backend supports conversation history | `AskService.fetchConversation()` when history UI is added. |
| `GET/POST/DELETE /api/v1/relationships` | Secondary relationship flow | `RelationshipService`, hidden first version. |
| `POST /api/v1/relationships/{id}/report` | Preview/full relationship report | Hidden first version unless secondary beta is deliberately enabled. |
| `GET /api/v1/subscriptions/entitlement` | Plan state | `SubscriptionService.currentEntitlement()`. |
| `POST /api/v1/subscriptions/local/activate` | Local test premium | Debug only; never as production purchase. |
| `POST /api/v1/purchases/local/unlock` | Local one-time unlock | Debug only. |
| `GET/POST/PUT/DELETE /api/v1/journal` | List and save reflections | `JournalService`. |
| `POST /api/v1/analytics/events` | Non-blocking tracking | `AnalyticsClient.track()`. |

## Data Models To Reuse

SwiftUI should create typed `Codable` models mirroring backend field names:

- `APIEnvelope<T>`, `APIMeta`, `APIErrorPayload`.
- `Me`, `Entitlement`, `EntitlementFeatures`.
- `BirthProfile`, `BirthProfileRequest`, `BirthProfileCreateResponse`.
- `ChartSummary`, `BaziChart`, `FourPillars`, `Pillar`.
- `BlueprintReport`, `BlueprintContent`, `BlueprintSection`.
- `TodayInsight`, `TitledBody`, `Confidence`.
- `AIConversationCreateRequest`, `AIConversationCreateResponse`, `AIMessageRequest`, `AIMessageResponse`, `AIAnswer`, `AIAnswerSection`.
- `JournalEntry`, `JournalEntryRequest`.
- `RelationshipProfile`, `RelationshipRequest`, `RelationshipReport` for later.

Keep JSON keys unchanged. Add Swift computed properties only for display formatting.

## What Can Be Reused

- API paths, auth header strategy, request/response field names.
- Core business sequence: create session, fetch `me`, create birth profile, generate blueprint preview, load today/report/journal.
- Safety constraints from backend prompts and copy: reflective, non-deterministic, no medical/legal/financial/emergency advice.
- Current localization meaning and compliance copy as source material.
- Local API base URL and environment concept.

## What Cannot Be Reused

- Flutter widget hierarchy and component implementation.
- Persistent wheel pickers on birth setup screens.
- Dense card stacks as the default page structure.
- Beta relationship feature as a main Tab.
- Local premium activation as a release feature.
- Any copy that implies deterministic fate, guaranteed predictions, diagnosis, or real subscription purchase without StoreKit.
- Giant single-file app/state/component structure.

## Flutter UI Patterns To Abandon

- Multiple onboarding substeps that feel like a form wizard.
- Always-visible Cupertino pickers in the main content.
- Repeated `AppCard` stacks for every page section.
- Paywall-first unlock CTA on the first blueprint preview.
- "Beta" relationship item inside primary profile page for release builds.
- Developer menu and local premium test in visible product UI.
- Large central `AppState` driving every page.

## SwiftUI First-Version Scope

Must have:

- App boot with local/dev auth support and clear unauthenticated/error states.
- Three-screen onboarding plus birth information setup.
- Birth info confirmation screen with date/time/location sheets.
- Main Tab: Today, Blueprint, Ask, Mine.
- Today full UI with loading/empty/error/success/reflection-save states.
- Blueprint overview and detail pages.
- Ask input, suggestions, answer rendering, retry/error, save reflection.
- Mine page with birth info, plan status, saved reflections, settings, privacy.
- Subscription page as informational unless StoreKit 2 is implemented.

Can hide/defer:

- Relationship/Love main flow.
- Full StoreKit purchase.
- Apple Sign In, because backend currently reports it is not configured.
- Detailed Bazi chart visualization.
- Journal editing/deleting beyond saving and list viewing.
- Location geocoding with real coordinates.

## Migration Risks

| Risk | Impact | Mitigation |
|---|---|---|
| Backend schema is documented partly in Java maps, not full OpenAPI schemas | Swift models can drift | Start with tolerant decoding for dynamic report sections; keep typed request models strict. |
| Current auth is dev-session first | App Store login story incomplete | Do not present account login as finished. Plan Sign in with Apple separately. |
| Subscription endpoints are local/fake | App Store rejection risk | Hide purchase CTAs until StoreKit 2 is wired and server validation exists. |
| AI response is structured but may fallback | UI must handle missing fields | Render optional sections defensively with empty/error states. |
| Location search is not implemented | Birth setup could feel unfinished | Use manual city/timezone sheet first; do not fake coordinates. |

