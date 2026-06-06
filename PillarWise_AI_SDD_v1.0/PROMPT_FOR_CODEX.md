# Prompt for Codex

You are implementing PillarWise AI from the SDD package in this repository.

## Required reading order

1. README.md
2. 00_SDD_MASTER.md
3. docs/01_ARCHITECTURE.md
4. docs/02_LOCAL_DEV_SETUP.md
5. docs/03_IOS_UIUX_DESIGN_SYSTEM.md
6. docs/04_FLUTTER_APP_STRUCTURE.md
7. docs/05_BACKEND_JAVA21_STRUCTURE.md
8. docs/06_SQLITE_DATA_MODEL.md
9. docs/07_API_CONTRACTS.md
10. docs/08_AI_ORCHESTRATION.md
11. features/*.md
12. appendices/*.md
13. db/V001__init.sql
14. contracts/openapi.yaml

## Implementation rules

- Build a local-runnable full app, not a throwaway MVP.
- Flutter must be iOS-first and use Cupertino patterns.
- Backend must use Java JDK 21 and local SQLite.
- Do not introduce Docker or a remote database.
- Do not let AI calculate BaZi. Backend deterministic engine only.
- Do not create placeholder pages. If local mock is needed, make it user-ready and production-adapter compatible.
- Implement account deletion, restore purchases UI, privacy/terms/disclaimer, and error states.
- Keep all user-facing product copy in English.
- Use local mock AI and local fake entitlement by default.
- Leave no TODO in user-visible flows.

## First implementation milestone

Create this repo shape:

```text
pillarwise-ai/
  app/
  backend/
  scripts/
  docs/
```

Then implement:

1. backend health + SQLite migration + dev auth;
2. Flutter Welcome screen + dev auth call;
3. shared API envelope models;
4. design tokens and Cupertino app shell.

After each milestone, run:

```bash
(cd backend && ./mvnw test)
(cd app && flutter analyze && flutter test)
```

## Done means

The app can run locally end-to-end:

```text
Onboarding → Birth Profile → BaZi Chart → Life Blueprint → Today → AI Guide → Relationship Report → Paywall Mock → Journal → Settings → Delete Account
```
