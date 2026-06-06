# A07. Release Checklist

## App Store readiness

- App name, subtitle, keywords prepared.
- Screenshots show app in use.
- No placeholder content.
- Backend live for review.
- Demo account or review instructions included.
- IAP products configured.
- Restore purchases works.
- Manage subscription link works.
- Privacy Policy URL live.
- Terms URL live.
- Account deletion works in app.
- Disclaimer visible in onboarding/settings.
- App does not promise deterministic future outcomes.
- No medical/legal/financial advice.

## iOS technical

- App icon all sizes.
- Launch screen.
- No debug banner.
- No debug logs with PII.
- ATS uses HTTPS in release.
- Dark mode checked.
- Dynamic Type checked.
- VoiceOver basic flow checked.
- iPhone SE layout checked.
- iPhone 15 Pro Max layout checked.
- App can restore after force quit.

## Flutter

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
flutter build ios --release
```

## Backend

```bash
./mvnw clean test
./mvnw spring-boot:run
```

## Product QA

- Onboarding exact birth time.
- Onboarding unknown birth time.
- Manual city fallback.
- Blueprint preview.
- Premium unlock.
- Today insight.
- AI safety reframe.
- Relationship preview.
- Journal save/edit/delete.
- Delete account.
