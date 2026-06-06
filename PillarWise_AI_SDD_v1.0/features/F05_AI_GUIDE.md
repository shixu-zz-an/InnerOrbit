# F05. AI Guide

## 1. 目标

AI Guide 是付费核心。它必须表现得像“理解用户 chart 和历史上下文的个人教练”，不是普通 ChatGPT 套壳。

## 2. 入口

- Ask Tab
- Blueprint card 的 `Ask about this`
- Today focus 的 `Ask about this`
- Relationship report 的 `Ask about our dynamic`

## 3. Ask Tab UI

### 初始状态

Large title：`Ask`

Subtitle：

```text
Ask your guide about love, career, patterns, or timing themes.
```

Suggested prompts：

```text
Why do I feel stuck lately?
What career path fits my strengths?
Why do I repeat the same relationship pattern?
What should I focus on this month?
How can I handle conflict better?
```

### Chat UI

- 用户消息：右侧 bubble。
- AI 回答：左侧 card stack，而不是长气泡。
- 输入框固定底部，keyboard safe area。
- Send 按钮为 accent circle。

### AI answer card

结构：

```text
Headline
Summary paragraph
Section cards
Practical step
Reflection question
Actions: Save / Ask follow-up / Helpful?
```

## 4. Free vs Premium

Free：

- 1 question/day。
- 超出显示 paywall。

Premium：

- fair-use 100/month。

本地 Fake premium 可解锁。

## 5. API

- `POST /api/v1/ai/conversations`
- `POST /api/v1/ai/messages`
- `GET /api/v1/ai/conversations/{id}`

## 6. Safety behavior

### 用户问 deterministic future

User：

```text
Will I get rich in 2028?
```

Answer：

```text
I can’t promise a financial outcome. What I can do is read this as a timing theme: this period may be better for visibility, responsibility, and building leverage. A grounded next step is to define what “rich” means in measurable choices you control.
```

### 用户问健康

```text
Will I get sick?
```

Answer：

```text
I can’t predict or assess health. For health concerns, it’s best to speak with a qualified professional. If you want, we can reflect on stress patterns and what helps you feel more supported.
```

### 自伤

必须显示危机支持文案，不做命理解读。

## 7. Memory

每轮保存 message。

每 8–10 轮压缩 memory：

```text
User is navigating uncertainty in their career and responds well to structured, step-by-step advice.
```

Memory 用于后续 prompt。

## 8. Quota UI

输入框上方小提示：

Free：

```text
1 free question today
```

用完：

```text
You’ve used today’s free question.
```

按钮：`Unlock unlimited guidance`

Premium：

不显示 quota，除非接近 fair-use。

## 9. Loading

AI 回复中：

```text
Reading your pattern…
```

使用 typing indicator + subtle shimmer。

如果超过 8s：

```text
Still preparing a thoughtful answer…
```

## 10. Error

AI unavailable：

```text
Your guide is having trouble responding.
Try again in a moment. Your message was saved.
```

本地 mock 不应失败，除非测试 error。

## 11. 埋点

- `ai_tab_viewed`
- `ai_prompt_chip_tapped`
- `ai_message_sent`
- `ai_answer_received`
- `ai_answer_saved`
- `ai_answer_rated_helpful`
- `ai_quota_paywall_viewed`

## 12. Acceptance Criteria

- AI 回答引用用户 chart/mapped insight，而不是泛泛而谈。
- Free quota 生效。
- Paywall 生效。
- 所有聊天重启后仍可查看。
- SafetyGuard 对高风险问题生效。
- 输入框键盘体验符合 iOS。
- 回答可保存到 Journal。
