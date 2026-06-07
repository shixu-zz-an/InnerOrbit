# FINAL_LAUNCH_REPORT

## 1. 当前 App 的新产品定位

PillarWise AI 是“每日个人洞察 + AI 反思 guide + Journal 数据沉淀”的 iOS 产品，而不是命理 Demo 或泛 AI 聊天。

## 2. 当前 App 的核心用户路径

Welcome -> Disclaimer -> ProfileSetup -> Generate Blueprint -> Preview -> Today -> Ask Guide -> Save Reflection -> Journal。

## 3. 当前 App 的核心付费路径

完整 Life Blueprint、更多 AI follow-up、relationship deep report。当前仅保留高级版说明；真实收费必须接 Apple IAP。

## 4. 当前 App 的留存机制

Today 每日重点、最近 Journal、AI 回答保存、Saved Journal 数量和继续上次记录。

## 5. 已完成的重构

- 主导航收敛为 Today、Blueprint、Ask、Me。
- Relationship 降级为 Me 下 Beta。
- Onboarding 主路径收敛。
- Paywall 改成合规说明。
- 状态组件和 Pro/FeatureLock 组件保留为公共能力。
- 确认 onboarding draft 不默认提交样例出生资料，并修复 birthTime 草稿恢复。

## 6. 已修复的体验问题

- 首次生成请求可能缺出生日期/时间/地点。
- 首页下一步不明确。
- 保存后缺少留存回流。
- 生产环境假付费风险。
- 关系功能过早占主入口。

## 7. 已修复的上架风险

- 不展示虚假价格。
- 不伪造 IAP。
- 强化非专业建议边界。
- 数据导出/删除账号保留。

## 8. 仍然存在的风险

Apple IAP 未接入、城市库有限、Relationship Beta 成熟度不足、正式法律文本缺失、AI 输出质量需真机/真实数据验证。

## 9. 被隐藏或弱化的功能

Relationship 从主 Tab 弱化为 Me 的 Beta 二级入口；local Premium test 仅 local flavor 出现。

## 10. 被重做的功能

Today 主行动、onboarding 主路径、paywall 说明、Journal 留存回流、出生资料提交校验。

## 11. 被重做的页面

Today、ProfileSetup、Preview paywall path、Me、Paywall sheet。

## 12. 被重构的组件

App state components、ProBadge、FeatureLock、PlanCard、RetryButton 作为统一 UI 基础继续使用。

## 13. 加入或确认的埋点

app initialized、main data loaded、core loop started/completed/failed、onboarding completed、ask guide started/completed/failed、reflection saved、paywall viewed、upgrade tapped、relationship preview。

## 14. 文案优化

文案从“功能展示”转向“今日行动、反思边界、隐私和合规”；付费文案去掉虚假购买承诺。

## 15. 真机重点验收

小屏 onboarding、Ask 键盘、Today 保存、Paywall 文案、删除账号、导出数据、断网错误、中文 UI。

## 16. 需要后端支持

城市/时区库、IAP 校验、AI 会话分页、Journal 搜索、分块加载、真实用户账户体系。

## 17. 需要 Apple IAP

订阅、一次性报告购买、恢复购买、交易监听、服务端校验、退款/过期权益同步。

## 18. 需要补充隐私政策

出生资料、AI 对话、Journal、analytics、订阅权益、第三方 AI provider、数据删除和导出。

## 19. 需要补充 App Store 文案

自我反思定位、每日洞察、AI guide、Journal、非专业建议免责声明、隐私承诺。

## 20. 上线前最后 10 个必须检查项

1. 生产构建无 local Premium test。
2. 若收费，IAP 已完整接入并通过沙盒测试。
3. ProfileSetup 小屏无 overflow。
4. Today 主行动可完成 Ask。
5. Journal 保存后可回看。
6. 断网错误可恢复。
7. 无 demo/mock/TODO/null/undefined 用户可见文案。
8. 隐私政策和条款链接/文本完整。
9. 删除账号真实删除用户数据。
10. App Store 截图不展示未完成或未上线收费能力。

## 一句话总结

当前版本已经从“能跑的 App”升级为“可以让真实用户理解和试用的上线候选产品”，但要上线收费仍必须补齐 Apple IAP、正式隐私合规和真机 QA。
