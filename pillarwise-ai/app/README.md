# PillarWise AI Flutter App

PillarWise AI is an iOS-first Flutter app for reflective Four Pillars-based personal insight. The app supports onboarding, Life Blueprint preview, Today insights, AI guide questions, Journal retention, Premium explanation, privacy controls, and local development entitlement testing.

## Run

```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8080 --dart-define=APP_FLAVOR=local
```

## Verify

```bash
flutter analyze
flutter test
```

## Commercialization Note

`APP_FLAVOR=local` enables local Premium testing only. Production iOS monetization must use Apple In-App Purchase and server-side transaction validation before any digital service is sold.
