# SwiftUI Product Architecture

## One-Sentence Positioning

BluePrint is a private self-reflection app that turns birth context, daily signals, and guided AI questions into a calm personal blueprint and one practical next step.

## Target Users

- People who want structured self-understanding without deterministic fortune-telling.
- Users reflecting on relationships, career direction, recurring choices, and timing.
- Users who value privacy, gentle language, and practical prompts over entertainment-style prediction.
- Users who may be curious about BaZi/Four Pillars but do not want jargon-heavy metaphysics.

## First Launch Experience

1. Introduce the product in no more than three calm screens:
   - Notice recurring inner patterns.
   - Reflect on relationships, choices, and timing without fatalism.
   - Create the first personal blueprint.
2. Let users skip value screens, but not the required birth information if they want a personalized blueprint.
3. Move into a birth information setup screen with summary rows and native sheets.
4. Generate a first blueprint preview.
5. Enter Today as the default daily home.

## Core User Path

1. User opens app.
2. User completes onboarding and birth information setup.
3. App creates the primary birth profile and generates a blueprint preview.
4. User lands on Today.
5. User reads one daily focus.
6. User asks AI to break down a next step or writes a reflection.
7. User saves useful reflection.
8. User returns to Blueprint or Ask when a deeper question appears.

## Core Functional Loop

`Personal context -> Daily focus -> Guided question -> Practical next step -> Saved reflection -> Better future context`

This loop should be visible in the product, but not explained with in-app instructional blocks.

## Main Tab Information Architecture

Recommended first version:

| Tab | Purpose | Primary action | Notes |
|---|---|---|---|
| Today | Daily entry point | Break down the next step / save reflection | Default landing after onboarding. |
| Blueprint | Personal blueprint overview | Ask about this / open detail | Not an article feed. |
| Ask | Private AI guide | Send a real question | Input-first. |
| Mine | Account, data, plan, settings | Manage blueprint/settings | Formal product hub, no debug entries. |

Relationship exploration should not be a primary Tab in the first SwiftUI release. It can be a secondary entry from Ask or Blueprint after the core loop is strong.

## Page Hierarchy

```text
App
  Loading / Unavailable
  Onboarding
    Value screens
    Birth Info Setup
      Date Picker Sheet
      Time Picker Sheet
      Location / Timezone Sheet
      Traditional Cycle Info Sheet
    Generating Blueprint
    Blueprint Preview
  Main Tabs
    Today
      Today Detail / Reflection Save Sheet
      Ask handoff
    Blueprint
      Blueprint Section Detail
      Ask handoff
      Informational Premium Page
    Ask
      Conversation / Answer
      Save Reflection Sheet
    Mine
      Birth Details
      Saved Reflections
      Plan / Premium Info
      Settings
        Language
        Privacy
        Terms
        Disclaimer
        Export Data
        Delete Account
```

## Free Version

The free version should feel complete:

- Create one primary blueprint preview.
- View Today daily focus.
- Ask limited AI questions according to backend entitlement rules.
- Save reflections.
- View saved reflections.
- View privacy/settings/account data.

## Premium Version Reserved

Only expose as real purchase after StoreKit 2 and backend receipt validation are implemented:

- Full blueprint sections.
- More AI follow-up capacity.
- Relationship reports.
- Deeper timeline/career/relationship interpretations.

Until then, use only "Learn about Premium" or "Coming soon" copy. Do not show real purchase buttons, pricing, or fake entitlement activation in release builds.

## Must-Have First-Version Features

- Onboarding.
- Birth information setup.
- Blueprint preview generation.
- Today page.
- Blueprint overview and section detail.
- Ask page and answer rendering.
- Save reflection.
- Mine/settings/privacy.
- Unified loading/empty/error/offline/locked states.

## Can Hide In First Version

- Relationship/Love flow.
- StoreKit purchase.
- Apple Sign In.
- Deep Bazi chart details.
- Export UI polish beyond a readable export screen/sheet.
- Journal editing/deleting.
- Location autocomplete/geocoding.

## Should Not Appear In Main Tab

- Relationship/Love beta.
- Subscription/paywall.
- Journal as a standalone Tab.
- Debug/developer tools.
- Raw chart or database-style data pages.

## Should Live In Secondary Pages

- Birth details editing.
- Saved reflections.
- Privacy/legal.
- Entitlement details.
- Relationship exploration.
- Chart details.
- Data export/delete account.

## App Store Compliance Prompts Needed

- Onboarding / first generated insight: self-reflection only; not medical, legal, financial, mental health, emergency, or deterministic advice.
- Ask: AI answers are reflective prompts and practical next steps, not decisions made for the user.
- Premium: only after IAP is real; must include price, duration, auto-renewal disclosure, Restore Purchases, Terms, Privacy, and cancellation management.
- Delete/export data: clear confirmation and consequences.
- Birth information: explain why date/time/place are used and that sex-for-cycle is for traditional calculation math only, not identity.

## Product Tone

Use language that is:

- Specific.
- Calm.
- Non-diagnostic.
- Non-fatalistic.
- Practical.
- Respectful of uncertainty.

Avoid:

- "Destiny says..."
- "You are guaranteed to..."
- "Your perfect partner/career..."
- Medical/therapy-like diagnosis.
- Fear, scarcity, or exaggerated monetization language.

