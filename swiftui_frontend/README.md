# SwiftUI Frontend

This directory is the native SwiftUI migration workspace for the existing PillarWise / BluePrint iOS experience. The Flutter app and backend remain untouched.

## Current Phase

Current runnable preview:

- Migration audit completed.
- SwiftUI product architecture defined.
- SwiftUI technical architecture defined.
- Full execution plan recorded in `SWIFTUI_EXECUTION_PLAN.md`.
- Native frontend directory skeleton created.
- Xcode project created at `BluePrintApp/BluePrintApp.xcodeproj`.
- Mock SwiftUI preview app implemented and launched on iOS Simulator.

The app currently uses mock data only. Real backend services are still a later batch.

## How To Open

Open:

```text
swiftui_frontend/BluePrintApp/BluePrintApp.xcodeproj
```

## How To Run

Build and run from Xcode, or use:

```sh
xcodebuild -project swiftui_frontend/BluePrintApp/BluePrintApp.xcodeproj -scheme BluePrintApp -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build
```

The app has been verified on the booted iPhone 17 Pro simulator.

## Directory Structure

```text
swiftui_frontend/
  README.md
  MIGRATION_AUDIT.md
  SWIFTUI_PRODUCT_ARCHITECTURE.md
  SWIFTUI_TECH_ARCHITECTURE.md
  SWIFTUI_EXECUTION_PLAN.md
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
        Assets.xcassets/
      PreviewContent/
```

## Implemented

- Documentation and migration plan.
- Source directory skeleton.
- Batch-by-batch execution plan through final delivery.
- Mock SwiftUI app with onboarding, birth setup, Today, Blueprint, Ask, and Mine.

## Not Implemented Yet

- Services/API client.
- StoreKit.
- Real backend integration.

## Backend Interface

Existing local backend default:

```text
http://127.0.0.1:8080
```

SwiftUI API configuration should be added in:

```text
BluePrintApp/BluePrintApp/Core/Networking/
```

The SwiftUI app must preserve existing backend paths and JSON field names.

## Mock Data

Mock data should be added in:

```text
BluePrintApp/BluePrintApp/PreviewContent/
```

Mocks are for SwiftUI previews and local development only. They must not be presented as backend responses in release behavior.

## Mock / Real API Switching

Planned approach:

- `AppEnvironment.live()` for real backend.
- `AppEnvironment.preview()` for SwiftUI previews.
- Debug-only local services for local premium testing if needed.

Release builds must not expose fake subscriptions or developer unlocks.

## Next Development Batches

The detailed execution baseline is:

```text
SWIFTUI_EXECUTION_PLAN.md
```

1. Build SwiftUI project skeleton: app entry, environment, routing, TabView, design system placeholders, shared components, previews.
2. Implement onboarding and birth information setup.
3. Implement Today, Blueprint, Ask, and Mine tabs.
4. Connect real backend services and typed models.
5. Add settings/privacy/subscription/detail pages.
6. Run App Store readiness review and final polish.
