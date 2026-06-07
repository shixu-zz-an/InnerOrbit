# PillarWise AI

Local-first implementation of the PillarWise AI SDD.

## Structure

```text
app/       Flutter iOS-first app
backend/   Java 21 Spring Boot API with SQLite
scripts/   local verification helpers
```

## Backend

```bash
cd backend
./mvnw test
./mvnw spring-boot:run
```

Run the backend with Qwen through DashScope OpenAI-compatible Chat Completions:

```bash
AI_PROVIDER=qwen AI_API_KEY=<dashscope-key> ./mvnw spring-boot:run
```

Optional overrides:

```bash
AI_MODEL=qwen-plus
AI_BASE_URL=https://dashscope.aliyuncs.com/compatible-mode/v1
```

Health:

```bash
curl http://127.0.0.1:8080/health
```

## Flutter

```bash
cd app
flutter pub get
flutter analyze
flutter test
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8080 --dart-define=APP_FLAVOR=local
```

## Local Flow

```text
Onboarding -> Birth Profile -> BaZi Chart -> Life Blueprint -> Today -> AI Guide -> Relationship -> Paywall -> Journal -> Settings -> Delete Account
```
