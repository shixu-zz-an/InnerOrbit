# Implementation Notes

## Current local implementation

- The local backend uses deterministic BaZi-style calculations implemented in Java instead of delegating to an LLM.
- The local AI and entitlement providers are production-adapter compatible mocks. They do not show mock wording to users.
- Production Apple Sign-In, RevenueCat/StoreKit, hosted Terms/Privacy URLs, and real AI provider credentials are adapter points.
- `backend/mvnw` is a lightweight local shim that delegates to the installed Maven because the Maven wrapper plugin was not available in the local cache and Maven Central access was blocked by a SOCKS proxy error during this run.
- Spring Boot is pinned to `3.3.12` and SQLite JDBC to `3.50.3.0` because those compatible versions were already available in the local Maven cache.
- The first implementation pass prioritized a working end-to-end local loop over fine-grained package splitting. API contracts and storage tables are stable enough for later internal refactors.

## Verified rhythm

1. Backend foundation: health, request envelope, SQLite migration, dev auth.
2. Core personalization: birth profile, deterministic chart, mapped insight, blueprint preview/full.
3. Retention: Today insight and Journal save/list/edit/delete.
4. Guidance: AI conversation/message, quota, and SafetyGuard.
5. Monetization: fake premium entitlement, restore/purchase-style local unlock.
6. Relationship: add relationship profile, compatibility preview, full report gating.
7. Compliance: Me, export data, delete account, privacy/terms/disclaimer UI.
8. Flutter: Cupertino onboarding, 5-tab app shell, paywall, settings, iOS simulator debug build.

## Verification run

- `./scripts/check_all.sh`
- `flutter build ios --simulator --debug`
- Manual curl smoke against local backend for health, dev auth, profile, chart, blueprint, today, AI, premium, relationship, journal, export.
