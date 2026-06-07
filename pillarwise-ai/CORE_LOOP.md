# CORE_LOOP

## 1. 原核心流程

旧产品重心容易被多个功能分散：创建 blueprint、看 Today、Ask、Love、Journal、Premium 都像同级入口。用户完成 onboarding 后，不一定知道今天应该做什么。

## 2. 新核心流程

1. 创建首份 Life Blueprint preview。
2. 进入 Today，看到一个今日重点、一个行动、一个挑战/机会。
3. 点击主按钮让 Ask Guide 拆解下一步。
4. 保存反思或 AI 回答到 Journal。
5. 第二天回到 Today 继续最近记录。

## 3. 减少了哪些步骤

- 出生日期、时间、地点、传统计算、目标选择合并为 `ProfileSetupScreen`。
- Today 主按钮直接调用 `askFromToday`，自动切到 Ask 并发起问题。
- Relationship 从主 Tab 移除，避免新用户偏离首个价值闭环。

## 4. 优化了哪些页面

- `TodayScreen`：加入价值说明、主行动、今日数据、最近 Journal、保存反思。
- `AskScreen`：推荐问题、loading、错误和 paywall trigger 更清楚。
- `BlueprintScreen`：锁定章节转为自然升级点。
- `MeScreen`：Journal、Premium、Beta、隐私集中。

## 5. 新增或优化的反馈

- 生成失败使用 `AppErrorState` 重试。
- AI 回答中显示 loading。
- 保存成功使用 `showNotice`。
- 表单提交时禁用重复提交。
- Premium 未接入 IAP 时展示说明，不伪造购买。

## 6. 完成核心动作后的下一步

保存 Journal 后，用户可以在 Today 最近记录或 Me/Saved Journal 找到它；Ask 回答可继续追问；Blueprint locked section 可触发高级版说明。

## 7. 付费转化机会

自然转化点是完整 blueprint、更多 AI follow-up、relationship full report。首版不阻断首次核心体验。

## 8. 是否影响业务逻辑

本次确认了 `OnboardingDraft` 不会默认提交样例出生资料，并修复 `birthTime` 草稿恢复；生成前通过校验确保请求体完整。其他核心流程保持现有 API 和状态管理。
