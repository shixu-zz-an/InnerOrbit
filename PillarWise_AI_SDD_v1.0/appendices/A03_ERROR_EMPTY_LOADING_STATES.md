# A03. Error / Empty / Loading States

## 1. Global Loading

- Use skeleton cards for content pages.
- Use progress phrases for report generation.
- Never show a blank spinner for more than 1 second.

## 2. Global Error

Component：`PillarErrorView`

Props：

```dart
String title;
String message;
String primaryActionText;
VoidCallback onPrimaryAction;
String? secondaryActionText;
VoidCallback? onSecondaryAction;
```

Default copy：

```text
Something didn’t load right.
Your data is safe. Please try again.
```

## 3. Offline

```text
You’re offline.
Your saved readings are still available. Reconnect to generate new insights.
```

## 4. Empty states

### No birth profile

```text
Create your blueprint first.
Your daily insights and AI guide are personalized from your birth details.
```

CTA：Start My Blueprint

### No relationships

```text
Understand a relationship dynamic.
Add someone’s birth details to explore communication, chemistry, and conflict patterns.
```

CTA：Add Someone

### No journal

```text
No saved reflections yet.
When an insight resonates, save it here and come back to it later.
```

CTA：Go to Today

## 5. Validation errors

- Birth date missing：`Please choose your birth date.`
- Birth date future：`Birth date can’t be in the future.`
- Birth time missing：`Please choose a birth time or select “I don’t know.”`
- Birth place missing：`Please enter your birthplace.`
- Timezone missing：`Please choose a timezone.`
- Delete confirmation：`Type DELETE to confirm.`

## 6. API error mapping

| API code | UI title | UI action |
|---|---|---|
| VALIDATION_ERROR | Check your details | Fix field |
| UNAUTHORIZED | Session expired | Restart |
| ENTITLEMENT_REQUIRED | Unlock to continue | Show paywall |
| RATE_LIMITED | Daily limit reached | Upgrade |
| AI_UNAVAILABLE | Guide unavailable | Retry |
| INTERNAL_ERROR | Something went wrong | Retry |
