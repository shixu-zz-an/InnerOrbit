# 09. Security, Privacy, Compliance

## 1. Product Safety

PillarWise is a self-reflection product. It must not claim deterministic predictions.

Forbidden claims:

- exact future prediction
- death/illness prediction
- investment/wealth guarantee
- legal advice
- mental health diagnosis
- relationship command such as “you must break up”

## 2. Privacy

Collected data:

- birth date
- birth time
- birth place / timezone
- user goals
- relationship target birth details
- chat messages
- journal entries
- purchase entitlement state

Use:

- generate chart
- personalize reports
- answer AI questions
- provide saved history

Do not:

- sell data
- train models by default
- log full PII
- upload contacts

## 3. Account Deletion

If app supports account creation, it must allow users to initiate deletion in app.

Path:

```text
Me → Data & Privacy → Delete Account
```

Backend endpoint:

```http
DELETE /api/v1/me
```

Flutter after success:

- clear secure storage
- clear local cache
- invalidate Riverpod providers
- return to Welcome

## 4. IAP compliance

- Digital content sold inside iOS app uses IAP.
- Paywall must show price, period, renewal terms.
- Restore purchases must be present.
- No blocking app usage behind rating/share.

## 5. AI safety

SafetyGuard layers:

1. Pre-check user input.
2. Prompt constraints.
3. Post-check model output.
4. Fallback safe response.

## 6. Data export

Endpoint:

```http
GET /api/v1/me/export
```

Return JSON:

```json
{
  "user": {},
  "birthProfiles": [],
  "reports": [],
  "journalEntries": [],
  "conversations": []
}
```

## 7. Production readiness notes

Before App Store release:

- Host privacy policy and terms.
- Use HTTPS only.
- Disable dev auth endpoint in production.
- Configure Apple Sign-In.
- Configure real IAP.
- Configure support email.
- Prepare App Review notes explaining self-reflection use case.
