# A06. Codex Task Breakdown

## How to use

Codex should implement in vertical slices. Do not implement all backend first and UI last.

## Task 1 — Repo bootstrap

- Create `app/` Flutter project.
- Create `backend/` Spring Boot project.
- Add root README.
- Add scripts/check_all.sh.
- Verify both run.

Done when:

- `backend /health` works.
- Flutter shows Welcome screen.

## Task 2 — Backend foundation

- Add SQLite DataSource.
- Add migration runner.
- Add V001 SQL.
- Add API envelope.
- Add error handler.
- Add dev auth.

Done when:

- dev session API works.
- DB file created.
- tests pass.

## Task 3 — Flutter foundation

- Add design tokens.
- Add app routing.
- Add API client.
- Add secure token storage.
- Add common components.
- Add main tab scaffold.

Done when:

- App starts and can call dev session.
- Cupertino tabs render.

## Task 4 — Onboarding vertical slice

- Flutter onboarding screens.
- Backend birth profile endpoint.
- Bazi engine basic integration.
- Preview generation mock.

Done when:

- New user can create profile and see preview.

## Task 5 — Life Blueprint

- Report tables/repositories.
- Report generator.
- Blueprint UI tab/detail.
- Locked sections.

Done when:

- Preview/free and full/unlocked states work.

## Task 6 — Today

- daily insight endpoint.
- Today UI.
- Reflection save.

Done when:

- Today renders and saves journal.

## Task 7 — AI Guide

- Conversation/message tables.
- MockAiProvider.
- SafetyGuard.
- AI chat UI.
- Quota/paywall trigger.

Done when:

- User can ask and save answer.

## Task 8 — Relationship

- Relationship tables/endpoints.
- Add flow.
- Compatibility preview.
- Full report unlock.

Done when:

- User can add someone and see preview/full gated.

## Task 9 — Paywall & Entitlement

- Subscription tables.
- Fake entitlement.
- Paywall UI.
- Restore purchases UI.
- Unlock report.

Done when:

- Local purchase unlocks premium across app restart.

## Task 10 — Settings & compliance

- Me page.
- Privacy/Terms/Disclaimer pages.
- Export data.
- Delete account.

Done when:

- Delete account resets app and deletes DB rows.

## Task 11 — Polish and tests

- Add widget tests.
- Add backend service tests.
- Check iPhone SE layout.
- Dark mode.
- Accessibility labels.
- Error/offline states.

Done when:

- `scripts/check_all.sh` passes.
- Manual QA checklist passes.
