# A04. Analytics Events

## Naming

- snake_case
- past tense for completed action
- no PII

## Events

```text
app_opened
app_cold_start_completed
onboarding_started
onboarding_disclaimer_accepted
birth_date_entered
birth_time_entered
birth_place_entered
user_goal_selected
birth_profile_created
blueprint_generation_started
blueprint_preview_viewed
paywall_viewed
purchase_started
purchase_success
purchase_failed
restore_purchases_tapped
restore_purchases_success
today_viewed
today_focus_ask_tapped
reflection_started
reflection_saved
blueprint_card_viewed
blueprint_card_saved
ai_tab_viewed
ai_prompt_chip_tapped
ai_message_sent
ai_answer_received
ai_answer_saved
ai_safety_blocked
relationship_add_started
relationship_profile_created
relationship_preview_viewed
relationship_report_unlocked
relationship_card_shared
settings_viewed
delete_account_started
delete_account_completed
api_error_seen
```

## Common properties

```json
{
  "flavor": "local",
  "appVersion": "1.0.0",
  "isPremium": false,
  "screen": "today"
}
```

## Sensitive properties forbidden

Do not send：

- birthDate
- birthTime
- exact birthPlace
- full AI message
- email
- full name
- Apple user id
