# 03. iOS UI/UX Design System

## 1. 设计目标

PillarWise AI 的视觉不是“神秘算命盘”，而是：

```text
Premium, calm, intimate, intelligent, reflective.
```

关键词：

- Soft depth
- Warm surfaces
- Refined mystic
- iOS native comfort
- Personal journal feeling
- High trust, low fear

## 2. iOS-first 原则

Flutter 实现必须优先使用 Cupertino：

- `CupertinoApp`
- `CupertinoPageScaffold`
- `CupertinoSliverNavigationBar`
- `CupertinoNavigationBar`
- `CupertinoTabScaffold`
- `CupertinoTabBar`
- `CupertinoButton`
- `CupertinoTextField`
- `CupertinoPicker`
- `CupertinoDatePicker`
- `CupertinoActionSheet`
- `CupertinoAlertDialog`
- `CupertinoContextMenu`（谨慎使用）

可以使用自定义 widget，但交互必须符合 iOS：

- 滑动返回
- bottom sheet / action sheet
- segmented control
- large title
- keyboard safe area
- haptic feedback

## 3. 页面骨架

### 3.1 App Root

```dart
CupertinoApp(
  title: 'PillarWise AI',
  debugShowCheckedModeBanner: false,
  theme: PillarCupertinoTheme.light,
  darkTheme: PillarCupertinoTheme.dark,
  home: AppRoot(),
)
```

### 3.2 Main Tabs

固定 5 个 tab：

```text
Today      icon: sparkles
Blueprint  icon: square.grid.2x2
Ask        icon: bubble.left.and.bubble.right
Love       icon: heart
Me         icon: person.crop.circle
```

命名：

- Tab label 用英文短词。
- Relationship Tab 在 UI 中显示 “Love”，降低认知负担。
- 页面 title 可以是 “Relationship Insights”。

## 4. 颜色系统

### 4.1 Light

```dart
class PillarColorsLight {
  static const bg = Color(0xFFF8F3EC);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceWarm = Color(0xFFFFFBF5);
  static const ink = Color(0xFF17151F);
  static const muted = Color(0xFF7D7489);
  static const hairline = Color(0x1F17151F);
  static const accent = Color(0xFF6B5DD3);
  static const accentSoft = Color(0xFFEDE9FF);
  static const gold = Color(0xFFC7A66A);
  static const rose = Color(0xFFD77A8A);
  static const success = Color(0xFF2E8B57);
  static const warning = Color(0xFFD28A2E);
  static const destructive = Color(0xFFFF3B30);
}
```

### 4.2 Dark

```dart
class PillarColorsDark {
  static const bg = Color(0xFF0F0D14);
  static const surface = Color(0xFF1A1722);
  static const surfaceWarm = Color(0xFF221D2B);
  static const ink = Color(0xFFF8F3EC);
  static const muted = Color(0xFFAAA0B8);
  static const hairline = Color(0x33FFFFFF);
  static const accent = Color(0xFF9B8CFF);
  static const accentSoft = Color(0xFF2A2440);
  static const gold = Color(0xFFD8BE7E);
  static const rose = Color(0xFFE89AAA);
  static const success = Color(0xFF67C98D);
  static const warning = Color(0xFFE5B15C);
  static const destructive = Color(0xFFFF453A);
}
```

## 5. Typography

使用系统字体，不打包字体文件。

| Token | Size | Weight | Usage |
|---|---:|---|---|
| largeTitle | 34 | 700 | Page large title |
| title1 | 28 | 700 | Onboarding title |
| title2 | 22 | 700 | Card title |
| headline | 17 | 600 | Section headline |
| body | 16 | 400 | Main paragraph |
| bodyStrong | 16 | 600 | Highlight |
| callout | 15 | 400 | Supporting content |
| caption | 12 | 500 | Label/meta |

要求：

- 支持 Dynamic Type。
- 长文本不要固定高度。
- 英文段落行高 1.35–1.5。
- 卡片正文最多 3–5 行预览，可展开。

## 6. Spacing & Layout

```dart
class PillarSpace {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 20.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const xxxl = 40.0;
}
```

页面：

- 水平 padding：20pt
- 卡片内 padding：18–20pt
- 卡片间距：14–16pt
- 底部 Tab 上方内容留白：24pt
- 大按钮高度：52pt

## 7. Radius & Depth

```dart
class PillarRadius {
  static const sm = 12.0;
  static const md = 18.0;
  static const lg = 24.0;
  static const xl = 32.0;
}
```

阴影：轻，不要 Android card heavy shadow。

```dart
BoxShadow(
  color: Color(0x14000000),
  blurRadius: 24,
  offset: Offset(0, 10),
)
```

Dark mode 使用边框替代重阴影。

## 8. 组件规范

### 8.1 Primary Button

- Height：52
- Radius：18
- Background：accent
- Text：white / 16 semibold
- Pressed opacity：0.86
- Disabled opacity：0.35
- Haptic：light impact on tap

文案：

- Start My Blueprint
- Continue
- Unlock Full Reading
- Ask My Guide

### 8.2 Secondary Button

- Height：48
- Background：accentSoft
- Text：accent
- Radius：16

### 8.3 Insight Card

结构：

```text
[small label]
Headline
Paragraph
[optional action row]
```

视觉：

- Surface: white / dark surface
- Radius: 24
- Padding: 20
- Optional top-right glyph

### 8.4 Premium Card

用于 paywall 与 locked feature：

- 背景可用渐变，但不要炫彩。
- 加 gold accent。
- 说明权益清晰。

### 8.5 Form Field

使用 CupertinoTextField 自定义容器。

要求：

- Label 在 field 上方，不使用 placeholder 作为唯一 label。
- 错误文本在 field 下方。
- Keyboard type 合理。
- 输入后自动进入下一步。

### 8.6 Loading

避免只有 spinner。使用 skeleton 或进度文案：

```text
Mapping your Four Pillars…
Reading your elemental balance…
Translating patterns into modern insight…
```

### 8.7 Error State

语气温和：

```text
Something didn’t load right.
Your data is safe. Please try again.
```

按钮：

- Try Again
- Contact Support（设置页）

## 9. 重点页面 UI 规格

### 9.1 Welcome

```text
Full screen warm background
Centered small symbol
Title: Decode your inner patterns.
Subtitle: AI self-discovery powered by Eastern wisdom.
Primary CTA: Start My Blueprint
Secondary: I already have a profile
```

### 9.2 Today

顶部 large title：Today

模块顺序：

1. Greeting card
2. Today’s Focus hero card
3. Challenge / Opportunity two cards
4. Reflection question
5. Ask AI CTA
6. Weekly theme

### 9.3 Blueprint

顶部：Core Archetype hero card。

下方分组：

- Personality
- Love
- Career
- Money
- Growth
- Timeline

每个分组是可展开卡片。

### 9.4 Ask AI

聊天不是普通客服 UI，而像 personal guide：

- 顶部显示 “Ask your guide”
- 有 suggested prompts chips
- 用户消息右侧气泡
- AI 回答左侧卡片化，不用长气泡墙
- 回答末尾有：Save / Ask follow-up / Helpful? 

### 9.5 Love

首页：

- Empty：Add someone to understand your dynamic.
- 有关系 profile 后展示 relationship cards。
- Add 按钮在右上角。

### 9.6 Me

使用 `CupertinoListSection.insetGrouped`。

分组：

- Account
- Subscription
- Data & Privacy
- Support
- Legal

## 10. Motion

- 页面 push 使用 iOS 默认。
- Paywall 从底部 modal sheet 上来。
- 卡片出现使用 150–250ms fade/slide。
- 生成报告动画总时长至少 1.2s，即使后端更快也保持仪式感。
- 不使用夸张弹跳。

## 11. Accessibility

必须实现：

- VoiceOver label
- Dynamic Type
- 颜色不作为唯一信息表达
- 触控目标 44pt+
- 表单错误可被 screen reader 读到
- Loading 有语义描述

## 12. iOS 上架视觉检查

禁止：

- 页面像网页 iframe。
- splash 后长时间白屏。
- 大片占位图。
- Android 风格 toolbar。
- 弹窗强迫评分。
- 让用户必须分享才能继续。

必须：

- 截图展示真实使用中的界面。
- 付费页清晰说明价格、周期、权益、取消方式。
- 删除账号路径不超过 3 层：Me → Data & Privacy → Delete Account。
