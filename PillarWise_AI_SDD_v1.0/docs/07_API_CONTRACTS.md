# 07. API Contracts

## 1. Base

```text
Base URL local: http://127.0.0.1:8080
Content-Type: application/json
Authorization: Bearer <token>
```

所有返回统一 envelope。

## 2. Auth

### GET /api/v1/auth/dev-session

本地开发创建/获取 dev session。

Response：

```json
{
  "success": true,
  "data": {
    "userId": "usr_...",
    "accessToken": "dev_...",
    "expiresAt": "2099-01-01T00:00:00Z",
    "isNewUser": true
  }
}
```

### POST /api/v1/auth/apple

生产登录预留。

Request：

```json
{
  "identityToken": "string",
  "authorizationCode": "string",
  "email": "optional",
  "fullName": "optional"
}
```

## 3. User / Settings

### GET /api/v1/me

Response：

```json
{
  "id": "usr_...",
  "email": null,
  "displayName": "You",
  "locale": "en-US",
  "hasPrimaryBirthProfile": true,
  "entitlement": {
    "plan": "free",
    "premiumActive": false,
    "expiresAt": null
  }
}
```

### DELETE /api/v1/me

删除账号。

Request：

```json
{
  "confirmation": "DELETE"
}
```

Response：

```json
{
  "deleted": true
}
```

## 4. Birth Profiles

### POST /api/v1/birth-profiles

Request：

```json
{
  "name": "Me",
  "birthDate": "1994-08-21",
  "birthTime": "14:30",
  "birthTimePrecision": "exact",
  "birthPlaceText": "Los Angeles, CA, US",
  "latitude": 34.0522,
  "longitude": -118.2437,
  "timezone": "America/Los_Angeles",
  "sexForTraditionalCycle": "female",
  "trueSolarTimeEnabled": true,
  "isPrimary": true
}
```

Validation：

- `birthDate` required，YYYY-MM-DD。
- `birthTimePrecision=unknown` 时 `birthTime` 可为空。
- `birthTimePrecision=exact/approximate` 时 `birthTime` required，HH:mm。
- `timezone` required。
- `latitude` 范围 -90..90；`longitude` -180..180。

Response：

```json
{
  "birthProfile": {
    "id": "bp_...",
    "name": "Me",
    "birthDate": "1994-08-21",
    "birthTimePrecision": "exact",
    "birthPlaceText": "Los Angeles, CA, US",
    "timezone": "America/Los_Angeles",
    "isPrimary": true
  },
  "chartSummary": {
    "chartId": "chart_...",
    "dayMaster": "Ji Earth",
    "coreArchetype": "The Grounded Strategist",
    "confidenceLevel": "high"
  }
}
```

### GET /api/v1/birth-profiles/primary

返回主 profile。

## 5. Chart

### GET /api/v1/bazi/charts/{birthProfileId}

Response：

```json
{
  "chartId": "chart_...",
  "calcVersion": "bazi-v1-lunarjava-1.7.7",
  "fourPillars": {
    "year": {"stem": "Jia", "branch": "Xu", "element": "Wood"},
    "month": {"stem": "Ren", "branch": "Shen", "element": "Water"},
    "day": {"stem": "Ji", "branch": "Mao", "element": "Earth"},
    "hour": {"stem": "Xin", "branch": "Wei", "element": "Metal"}
  },
  "dayMaster": "Ji Earth",
  "elementDistribution": {
    "wood": 0.22,
    "fire": 0.14,
    "earth": 0.31,
    "metal": 0.18,
    "water": 0.15
  },
  "confidence": {
    "birthTime": "exact",
    "location": "exact",
    "timeline": "high"
  }
}
```

## 6. Reports

### POST /api/v1/reports/life-blueprint

Request：

```json
{
  "birthProfileId": "bp_...",
  "mode": "preview"
}
```

`mode`：preview/full。

Response：

```json
{
  "reportId": "rpt_...",
  "reportType": "life_blueprint",
  "unlocked": false,
  "preview": {
    "coreArchetype": "The Grounded Strategist",
    "headline": "You create steadiness where others feel scattered.",
    "cards": [
      {
        "section": "personality",
        "label": "Core Pattern",
        "title": "Built for steadiness",
        "body": "You naturally notice what needs structure...",
        "locked": false
      }
    ]
  },
  "lockedSections": ["career", "love", "timeline"]
}
```

### GET /api/v1/reports/{reportId}

返回报告。

### POST /api/v1/reports/{reportId}/unlock-local

本地 unlock。

## 7. Today

### GET /api/v1/today

Query：

```text
birthProfileId=bp_...
date=2026-06-01
```

Response：

```json
{
  "date": "2026-06-01",
  "focus": {
    "title": "Choose clarity over guessing.",
    "body": "Your chart suggests today is better for direct emotional signals..."
  },
  "challenge": {...},
  "opportunity": {...},
  "reflectionQuestion": "Where are you reading silence as rejection?",
  "action": "Ask one direct question today.",
  "weeklyTheme": "Stability before expansion"
}
```

## 8. AI Guide

### POST /api/v1/ai/conversations

Request：

```json
{
  "birthProfileId": "bp_...",
  "topic": "career"
}
```

### POST /api/v1/ai/messages

Request：

```json
{
  "conversationId": "conv_...",
  "birthProfileId": "bp_...",
  "message": "Why do I feel stuck in my career?",
  "context": {
    "includeBlueprint": true,
    "includeLifePhase": true
  }
}
```

Response：

```json
{
  "messageId": "msg_...",
  "answer": {
    "headline": "You may be craving momentum before your foundation feels ready.",
    "sections": [
      {
        "title": "The pattern",
        "body": "Your profile leans toward building stable systems..."
      }
    ],
    "practicalStep": "Pick one unfinished commitment and close it before starting a new one.",
    "reflectionQuestion": "What would feel lighter if it were finished this week?"
  },
  "quota": {
    "remainingToday": 0,
    "premiumRequired": false
  }
}
```

## 9. Relationship

### POST /api/v1/relationships

Request：

```json
{
  "targetName": "Alex",
  "relationshipType": "romantic_partner",
  "birthDate": "1993-02-18",
  "birthTime": null,
  "birthTimePrecision": "unknown",
  "birthPlaceText": "New York, NY, US",
  "latitude": 40.7128,
  "longitude": -74.006,
  "timezone": "America/New_York"
}
```

### POST /api/v1/relationships/{relationshipId}/report

Request：

```json
{
  "mode": "preview"
}
```

Response：

```json
{
  "relationshipId": "rel_...",
  "reportId": "rpt_...",
  "preview": {
    "patternName": "The Magnetic Mirror",
    "chemistryScore": 82,
    "communicationSnapshot": "You seek clarity quickly; Alex may process emotions privately first.",
    "mainTension": "Different recovery speeds after conflict."
  },
  "unlocked": false
}
```

## 10. Subscription

### GET /api/v1/subscriptions/entitlement

Response：

```json
{
  "premiumActive": false,
  "plan": "free",
  "expiresAt": null,
  "features": {
    "aiUnlimited": false,
    "fullBlueprint": false,
    "relationshipReportsIncluded": false
  }
}
```

### POST /api/v1/subscriptions/local/activate

本地开发模拟订阅。

Request：

```json
{
  "productId": "premium_annual"
}
```

## 11. Journal

### POST /api/v1/journal

Request：

```json
{
  "sourceType": "daily_insight",
  "sourceId": "day_...",
  "prompt": "Where are you reading silence as rejection?",
  "content": "I noticed I do this with Alex..."
}
```

### GET /api/v1/journal

Query：`limit=50&cursor=`

## 12. Error examples

### Entitlement required

```json
{
  "success": false,
  "error": {
    "code": "ENTITLEMENT_REQUIRED",
    "message": "Unlock Premium to continue this reading.",
    "details": {
      "paywall": "life_blueprint_full"
    }
  }
}
```

### Safety blocked

```json
{
  "success": false,
  "error": {
    "code": "SAFETY_BLOCKED",
    "message": "I can’t help with that kind of prediction, but I can help you reflect on the pattern behind it."
  }
}
```
