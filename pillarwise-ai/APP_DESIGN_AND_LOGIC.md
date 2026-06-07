# PillarWise AI App Design and Logic

## 1. Product Positioning

PillarWise AI is a private self-reflection app that uses BaZi/Four Pillars as a symbolic input system and AI guidance as the output layer.

It is not a fortune-telling app, a therapy app, a prediction engine, or a decision maker. Its job is to help users turn vague personal questions into grounded next steps and saved reflections.

Core product promise:

- Build a personal life blueprint from birth information.
- Translate symbolic chart signals into practical, non-fatalistic language.
- Give the user one useful daily focus.
- Let the user ask follow-up questions privately.
- Help the user keep a journal of meaningful reflections.

The app should feel calm, private, trustworthy, premium, and practical. It should not feel mystical, diagnostic, exaggerated, or like a dashboard.

## 2. Target User

The target user is an iOS user interested in self-understanding, relationship patterns, career direction, emotional growth, and Eastern metaphysical frameworks, but who expects a modern product experience.

They are not looking for complex traditional terminology first. They want:

- A clear explanation of themselves.
- A daily point of focus.
- A private place to ask difficult personal questions.
- Suggestions that help them act, not predictions that remove responsibility.

## 3. Design Philosophy

### Quiet Guidance

The product should guide without overwhelming. Each screen should have one main purpose and one primary next action.

Today is not an information board. It is the daily entry point.

Blueprint is not a long report dump. It is a scannable personal overview.

Ask is not a generic chatbot. It is a reflective guide grounded in the user's blueprint.

Me is not a settings junk drawer. It is the control center for account, saved content, privacy, language, and plan state.

### Non-Fatalistic Language

All copy should avoid deterministic claims.

Use:

- "You may notice..."
- "This can point to..."
- "A useful next step is..."
- "Consider..."

Avoid:

- "You will..."
- "Your destiny is..."
- "This proves..."
- "You must..."

The app should preserve user agency. AI can offer patterns and next steps, but it should not make decisions for the user.

### Practical Reflection

Every insight should lead to a small action or a useful question.

A good answer is not just poetic. It should help the user understand:

- What pattern may be active.
- Why it may feel difficult.
- What to try next.
- What to reflect on later.

### Privacy First

The app handles sensitive personal information: birth data, private questions, relationship context, and journal entries.

The UI and product behavior should reinforce trust:

- Clear disclaimer before onboarding.
- Data export available.
- Account deletion available.
- No medical, legal, financial, or psychological diagnosis.
- No fake purchase behavior in production.

## 4. Visual Design Direction

The visual system should be iOS-first and restrained.

Principles:

- Soft light gray background, not full-page stark white.
- White content surfaces with very light borders.
- Minimal or no card shadow.
- Blue only for selected navigation, primary actions, and key links.
- Green/teal only for supportive opportunity or confirmation states.
- One dominant module per tab root.
- Secondary content should use rows or lightweight groups.
- No oversized type inside dense cards.
- No decorative gradients, orbs, heavy shadows, or mystical visual effects.

Tab design:

- Native Cupertino tab behavior.
- Clear selected state.
- Light unselected state.
- 22-24px icons.
- 11-12px labels.
- No heavy selected pill.

Card design:

- Radius around 18-24.
- Ultra-light borders.
- Minimal shadow.
- 20-24px padding for primary cards.
- 16-20px padding for compact content.
- Avoid cards inside cards.

## 5. Core User Journey

### First-Time Flow

```text
Welcome
-> Disclaimer
-> Birth profile setup
-> Generate blueprint
-> Preview
-> Continue to Today or learn about Premium
```

The first-time flow must answer three questions quickly:

- What is this app?
- Why does it need my birth information?
- What do I get after setup?

The onboarding should stay focused on required information:

- Birth date.
- Birth time or time precision.
- Birth place.
- Timezone.
- Traditional cycle option.
- Main goals.

### Daily Flow

```text
Today
-> Break down next step
-> Ask
-> Save reflection
-> Journal
-> Return tomorrow
```

This is the core retention loop.

The Today tab should give the user a reason to open the app again without needing a long reading every time.

### Blueprint Flow

```text
Blueprint preview
-> Core archetype
-> Scannable sections
-> Locked full report when needed
-> Ask about this
```

The blueprint is the user's long-lived identity layer. It should be stable, clear, and easy to revisit.

### Ask Flow

```text
Suggested question or typed question
-> AI guide response
-> Pattern explanation
-> Practical next step
-> Optional saved reflection
```

Ask should feel like a private guide, not a general assistant.

### Upgrade Flow

```text
Locked blueprint section / Ask quota / Me plan card
-> Premium explanation
-> StoreKit or local-only test entitlement
```

Before real IAP is implemented, production builds must not pretend to sell or unlock paid features.

## 6. Main Tabs

### Today

Purpose: daily entry and action loop.

Today should show:

- One quiet intro.
- One primary focus card.
- One main action: break down the next step.
- Lightweight rows for weekly theme, today action, and reminder.
- Challenge and opportunity signals.
- Latest journal continuation when available.
- Reflection input with save action only after text exists.

The screen should not become a dense report page.

### Blueprint

Purpose: personal blueprint overview.

Blueprint should show:

- Preview or full status.
- Core archetype.
- One-sentence summary.
- Primary summary card.
- Section list for core pattern, hidden strength, growth reminder, relationship clue, and action advice.
- Locked state for premium content when appropriate.

The root screen should stay scannable. Details can be shown in pushed screens or modal detail views.

### Ask

Purpose: private AI guide entry.

Ask should show:

- Short positioning header.
- Suggested questions.
- Conversation history.
- AI answer cards.
- Bottom input always reachable above the home indicator and keyboard.

AI answers should remain practical, reflective, and safe.

### Me

Purpose: account and control center.

Me should show:

- Profile and current blueprint summary.
- Plan state.
- Saved journal.
- Relationship Beta as a secondary workflow.
- Data export.
- Delete account.
- Language.
- Privacy, terms, and disclaimer.
- Local premium test only in local flavor.

## 7. Functional Logic

### Birth Profile

Birth information is collected in Flutter, validated client-side, then sent to the backend.

```text
Flutter form
-> API request
-> Backend validation
-> Save birth profile
-> Generate BaZi chart
-> Return profile and chart summary
```

The app should not rely on AI to calculate chart data. Chart generation must be deterministic.

### BaZi Engine

The BaZi engine is a backend domain service.

```text
Birth data
-> deterministic chart calculation
-> chart summary
-> insight mapping
```

This keeps symbolic calculation separate from language generation.

### Life Blueprint

Blueprint generation combines deterministic chart data, mapped insight structure, and optional AI language generation.

```text
Chart
-> insight sections
-> preview or full report
-> save report
-> return cards to Flutter
```

Preview should provide real value. Full report can deepen the same structure.

### Today

Today is generated from the user's profile, chart, and saved context.

```text
Profile and chart
-> daily focus
-> weekly theme
-> challenge
-> opportunity
-> reflection question
```

The Today screen should always create a clear next action.

### AI Guide

The guide uses the user's blueprint context and conversation memory.

```text
User question
-> safety pre-check
-> profile and chart context
-> prompt assembly
-> AI provider
-> safety post-check
-> save conversation message
-> return structured answer
```

The answer should be structured enough for UI cards, not a free-form wall of text.

### Journal

Journal is the memory layer for the user's reflections.

```text
Reflection prompt
-> user text
-> save journal entry
-> show latest entry on Today
```

Journal gives the product a reason to continue from previous sessions.

### Relationship

Relationship is a secondary Beta workflow.

It should not be a main tab in the first product direction. It can live under Me or "Explore more" until the workflow is strong enough.

### Subscription

Subscription controls access to premium report depth and higher guide limits.

Local builds may use fake entitlement for testing. Production builds must use real StoreKit/App Store purchase validation before exposing paid behavior.

## 8. Technical Architecture

The current implementation is:

```text
Flutter iOS-first app
-> Spring Boot Java 21 API
-> SQLite database
-> deterministic BaZi engine
-> AI provider adapter
```

Frontend:

- Flutter.
- Cupertino UI.
- Riverpod state management.
- Local storage for draft and locale.
- API client with JSON envelope handling.

Backend:

- Java 21.
- Spring Boot.
- SQLite.
- Domain modules for auth, profile, bazi, report, ai, relationship, subscription, journal, settings, and analytics.

Important architecture rule:

```text
Deterministic calculation belongs to backend services.
Natural language interpretation belongs to AI orchestration.
UI state and presentation belong to Flutter.
```

## 9. State Logic

App state controls:

- Initialization.
- Loading flags.
- Onboarding step.
- Draft birth profile.
- Current user.
- Birth profile.
- Blueprint.
- Today insight.
- Entitlement.
- Relationships.
- Journal.
- AI messages.
- Locale.
- Selected tab.

The app starts by loading local draft and locale, then attempts to initialize user data. If no profile exists, it enters onboarding. If profile and main data exist, it enters Main Tabs.

```text
Launch
-> initialize store and API
-> load draft and locale
-> load user/profile/main data
-> if no profile: onboarding
-> else: main tabs
```

## 10. Safety and Compliance

The app must consistently avoid high-stakes advice.

It should not provide:

- Medical diagnosis.
- Mental health diagnosis.
- Legal advice.
- Financial advice.
- Guaranteed predictions.
- Compatibility verdicts that label a relationship as doomed or certain.

Every sensitive interpretation should preserve uncertainty and user agency.

The product should keep visible access to:

- Disclaimer.
- Privacy policy.
- Terms of use.
- Data export.
- Delete account.

## 11. Monetization Logic

Free value:

- Onboarding.
- Blueprint preview.
- Today focus.
- Core Ask experience.
- Journal.

Premium value:

- Full blueprint.
- Expanded AI guide access.
- Deeper relationship reports when the Beta workflow is ready.

The paywall should explain value clearly, but trust must come first. Users should see a helpful preview before being asked to upgrade.

## 12. Current Product Direction

The app should continue with Flutter as the production frontend.

The SwiftUI prototype has been removed. Future work should improve the Flutter app instead of splitting effort across two frontends.

Near-term priorities:

- Keep refining Today as the daily habit loop.
- Make Blueprint easier to scan.
- Improve Ask answer quality and structured output.
- Keep Relationship as Beta.
- Add real StoreKit/IAP before production monetization.
- Split the large Flutter `app.dart` into feature modules when iteration slows down.

