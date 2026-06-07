# LAUNCH_STRATEGY

## 1. 一句话定位

PillarWise AI 是一个把四柱命盘转化为每日反思、AI 追问和个人记录的私人洞察 App。

## 2. 目标用户画像

- 25-45 岁，愿意为自我探索、关系模式和人生阶段反思付费的 iOS 用户。
- 对东方命理或 birth chart 有兴趣，但不想要恐吓式预测。
- 愿意保存私密 Journal，希望第二天继续看到与自己相关的行动建议。

## 3. 用户核心痛点

用户感觉自己在关系、职业、情绪或选择上重复卡住，但缺少一个每天能把问题讲清楚、拆成下一步、并长期沉淀的工具。

## 4. 核心价值主张

不用用户理解复杂命理术语，App 每天给出一个重点、一个可执行动作、一条可追问路径和一个可保存的反思。

## 5. 第一次打开 App 应该看到什么

看到 PillarWise 是“Private self-reflection”，明确知道它不是确定性预测，也不会提供医疗、法律、财务或心理健康建议。

## 6. 第一次使用 App 应该完成什么

填写出生日期、出生时间精度、出生地点、传统计算参数和最多 3 个关注目标，生成第一份 Life Blueprint preview。

## 7. 用户激活事件

`core_loop_completed`，属性 `action=generate_blueprint`。

## 8. 用户留存事件

`retention_action_completed`，属性 `action=save_reflection`。这是用户把一次洞察沉淀成自己资产的关键动作。

## 9. 用户付费触发点

- 用户想看 locked full blueprint section。
- 用户用完免费 AI follow-up。
- 用户想查看 relationship deep report。
- 用户在 Me 里主动查看 Premium 权益。

## 10. 免费版应该给什么

创建首份 blueprint、Life Blueprint preview、Today 每日重点、基础 Ask Guide、保存 Journal、数据导出/删除。

## 11. 付费版应该给什么

完整 Life Blueprint、更多 AI follow-up、深度 relationship report、未来 Journal 历史分析、多 profile/多城市支持。

## 12. 适合做高级版的功能

Full blueprint、AI unlimited 或更高额度、relationship full report、历史洞察分析、个性化长期趋势。

## 13. 不能一开始收费的功能

首份资料创建、基础 Today、首次 preview、隐私/法律/数据导出/删除账号、免责声明。

## 14. 适合订阅的功能

持续 AI guide、每日个性化 insight、长期 Journal 分析、关系持续洞察。

## 15. 适合一次性购买的功能

单份完整 Life Blueprint、单份 relationship deep report。

## 16. 不应该强行付费的位置

Onboarding 中途、表单提交前、错误恢复、删除账号、导出数据、语言设置、免责声明页面。

## 17. 上线首版应该砍掉哪些干扰功能

Relationship 不做主 Tab，不在首版主卖点里承诺完整关系匹配。保留为 Me 下 Beta 入口，避免低完成度影响审核和转化。

## 18. 首版最重要用户闭环

Generate Blueprint -> Today focus -> Ask Guide breaks it down -> Save Reflection -> Return to Today and continue from last Journal。

## 商业化边界

当前后端有 `subscriptions/local/activate` 和 `purchases/local/unlock`，只能用于 local flavor 测试。生产 iOS 收费必须接入 Apple IAP、StoreKit 交易、服务端 receipt/transaction 校验和恢复购买。
