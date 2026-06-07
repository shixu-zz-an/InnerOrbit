# Implementation Notes

## Current implementation

- The backend uses deterministic BaZi calculations implemented in Java instead of delegating chart math to an LLM.
- AI Guide calls Qwen through the DashScope OpenAI-compatible Chat Completions API when `AI_PROVIDER=qwen` and `AI_API_KEY` or `DASHSCOPE_API_KEY` is configured.
- Production Apple Sign-In, RevenueCat/StoreKit, and hosted Terms/Privacy URLs remain adapter points.
- `backend/mvnw` is a lightweight local shim that delegates to the installed Maven because the Maven wrapper plugin was not available in the local cache and Maven Central access was blocked by a SOCKS proxy error during this run.
- Spring Boot is pinned to `3.3.12` and SQLite JDBC to `3.50.3.0` because those compatible versions were already available in the local Maven cache.
- The first implementation pass prioritized a working end-to-end local loop over fine-grained package splitting. API contracts and storage tables are stable enough for later internal refactors.

## Verified rhythm

1. Backend foundation: health, request envelope, SQLite migration, dev auth.
2. Core personalization: birth profile, deterministic chart, mapped insight, blueprint preview/full.
3. Retention: Today insight and Journal save/list/edit/delete.
4. Guidance: AI conversation/message, quota, and SafetyGuard.
5. Monetization: premium entitlement, restore/purchase-style unlock.
6. Relationship: add relationship profile, compatibility preview, full report gating.
7. Compliance: Me, export data, delete account, privacy/terms/disclaimer UI.
8. Flutter: Cupertino onboarding, 5-tab app shell, paywall, settings, iOS simulator debug build.

## Verification run

- `./scripts/check_all.sh`
- `flutter build ios --simulator --debug`
- Manual curl smoke against local backend for health, dev auth, profile, chart, blueprint, today, AI, premium, relationship, journal, export.
