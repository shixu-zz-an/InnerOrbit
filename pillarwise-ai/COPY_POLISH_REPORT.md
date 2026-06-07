# Copy Polish Report

## Scope

Reviewed the current Flutter app copy across onboarding, Today, Blueprint, Ask, Me, paywall, empty/error states, and form helpers.

## Copy Direction

The app voice should be private, direct, practical, and non-fatalistic.

Rules applied:

- Do not sound mystical.
- Do not sound clinical.
- Do not sound like a marketing page.
- Do not expose implementation details.
- Do not promise outcomes.
- Make every primary button an action.
- Keep helper text short.

## Changes Made

### Today

Changed the main focus copy from a broad reflective phrase to a more action-oriented sentence.

Before:

- "Let one honest signal be enough"
- "Finish one grounded choice today before opening every possibility at once."

After:

- "One honest signal is enough"
- "Choose the next step you can actually finish today."

Impact: shorter, less poetic, more useful.

### Preview

Changed the first-run preview bottom actions.

Before:

- Primary action pushed unlocking Premium first.
- Continue Free was secondary.

After:

- Primary action continues into the app.
- Premium becomes a quieter secondary action.

Impact: builds trust before monetization.

### Me

Shortened plan copy and removed development language from the visible personal center.

Before:

- "Your full blueprint and expanded guide access are available on this account."
- "Premium adds the full blueprint and more guide questions."
- Local Premium test was exposed.

After:

- "Full blueprint access is active on this account."
- "Keep using Today, Ask, and your preview. Premium adds the full blueprint when purchases are available."
- Local test controls no longer appear in Me.

Impact: more formal, less like a development build.

### Premium Sheet

Replaced system action-sheet copy with a custom bottom sheet.

Before:

- Mentioned "local build", "testing", and "Apple In-App Purchase" in one long paragraph.
- Button said "Enable Local Premium Test".

After:

- Local build says "Preview the complete experience in this build."
- Production build says no payment will be taken.
- Button says "Preview Premium" or "Got it".

Impact: keeps compliance information without making the UI feel unfinished.

### Ask

Removed repeated icons from suggested questions and lowered answer-card emphasis.

Impact: questions read more like private prompts and less like feature chips.

## Remaining Copy Issues

### P0

- Some l10n strings still carry generic wording from the earlier implementation.
- Backend error messages may still need more user-friendly mapping.

### P1

- Timezone helper text should be rewritten further once real location search exists.
- Relationship copy should remain hidden or Beta-only until the workflow is mature.
- Export data flow should not show raw object strings in a production-quality UX.

### P2

- Legal/privacy copy should be reviewed before App Store submission.
- Premium value copy should be rewritten again when StoreKit and actual products exist.

## Forbidden Copy Going Forward

- "test", "mock", "demo", "local unlock", "TODO", "debug" in user-facing UI.
- "Destiny", "guaranteed", "will happen", "perfect match", or "doomed".
- Raw technical terms unless the page is explicitly developer-facing.
- Full backend exception messages.

