# IA_REDESIGN

## 1. 当前信息架构

当前 App 的真实页面和入口：

- Root：初始化、错误、OnboardingFlow、MainTabs。
- Onboarding：Welcome、Disclaimer、ProfileSetup、Generating、Preview；代码中仍保留 BirthDate/BirthTime/BirthPlace/Traditional/Goal 旧页面。
- MainTabs：Today、Blueprint、Ask、Me。
- 二级页面/弹窗：SavedJournal、Relationship Beta、Blueprint section detail、Paywall sheet、Add relationship sheet、Language sheet、Legal dialogs、Delete confirmation。

## 2. 当前 Tab / 菜单 / 功能入口

- Today：刷新、今日主行动、今日信号、最近 Journal、保存反思。
- Blueprint：Ask about this、锁定章节、Unlock full blueprint。
- Ask：推荐问题、输入栏、保存 AI 回答、额度触发 paywall。
- Me：Premium plan、Saved Journal、Relationship Beta、数据导出、删除账号、语言、隐私/条款/免责声明、本地 Premium 测试。

## 3. 核心入口

Today、Ask、Blueprint、Saved Journal、Premium explanation。

## 4. 干扰入口

Relationship Beta、local Premium test、旧 onboarding step 页面、模板 README。

## 5. 应合并的入口

出生日期、时间、地点、传统计算细节、目标选择合并为 ProfileSetup，一次完成首份 blueprint 所需信息。

## 6. 应后置的入口

Relationship 放在 Me / Explore more 下。Saved Journal 保持 Me 二级入口，同时在 Today 显示最近一条作为留存回流。

## 7. 应隐藏的入口

生产构建应隐藏 local Premium test；当前代码已用 `APP_FLAVOR=local` 控制。旧 onboarding step 不应出现在主流程。

## 8. 应改成二级页面的页面

Relationship、Saved Journal、Legal、Language、Data Export。

## 9. 太长的流程

旧 onboarding 多页资料录入太长；已收敛为 Welcome -> Disclaimer -> ProfileSetup -> Generating -> Preview。

## 10. 可减少一步的流程

Today 主行动直接切到 Ask 并带入 prompt，减少用户复制/重新输入。

## 11. 新信息架构

主导航：

1. Today：每日价值和留存。
2. Blueprint：长期个人资产和自然升级点。
3. Ask：AI guide 核心互动。
4. Me：账户、权益、Journal、Beta、隐私。

## 12. 首页任务

首页不是功能菜单，而是每天推动用户完成一个核心动作：理解一个今日信号，并用 AI 或 Journal 形成下一步。

## 13. Tab 保留

保留 Today、Blueprint、Ask、Me。Love/Relationship 不做主 Tab。

## 14. 页面合并、删除或隐藏

- 合并：资料录入旧步骤 -> ProfileSetup。
- 隐藏：生产环境 local unlock。
- 后置：Relationship Beta。
- 保留：Journal、Legal、Language、Delete account。

## 15. 核心用户路径

Welcome -> Disclaimer -> ProfileSetup -> Preview -> Today -> Ask -> Save Reflection。

## 16. 付费转化路径

Preview/Blueprint locked content -> Paywall explanation；Ask quota -> Paywall explanation；Me plan card -> Paywall explanation。未接入 IAP 前不展示真实购买。
