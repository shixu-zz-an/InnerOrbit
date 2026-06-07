# PRODUCT_DIAGNOSIS

## 0. 北极星判断

1. 这个 App 是什么产品：PillarWise AI 是一个以四柱/八字命盘为输入、以 AI 引导和 Journal 为输出的个人反思与每日洞察 App。
2. 解决什么问题：帮助用户把“我为什么总是卡住、关系里重复什么、今天该先做什么”这类模糊问题转成可执行的下一步和可保存的反思。
3. 目标用户：对自我探索、关系模式、职业方向、人生阶段和东方命理框架感兴趣，但更需要现代、私密、非宿命化解释的 iOS 用户。
4. 为什么下载：用户想快速得到一份个人蓝图、每日重点和可追问的私人 AI guide，而不是读复杂命理术语。
5. 首次 30 秒是否明白价值：现在基本能明白“自我反思 + AI guidance”，但首次资料设置仍偏重，地点选择有限会削弱信任。
6. 第一次是否能完成核心动作：能完成创建出生资料、生成 Life Blueprint preview、进入 Today；当前通过提交前校验避免请求体缺少出生资料，并修复了 `birthTime` 草稿恢复。
7. 为什么第二天回来：Today 每日洞察、继续上次 Journal、Ask Guide 追问，构成低风险留存理由。
8. 为什么愿意付费：完整 Life Blueprint、更多 AI 追问和关系深度报告是自然付费点，但必须先让用户体验免费价值。
9. 离可收费产品差在哪里：Apple IAP 未接入、城市/地点输入能力不足、权益限制策略还需要服务端和 StoreKit 校验闭环。
10. 最大商业化阻碍：目前付费不是支付技术问题，而是信任闭环问题。用户必须先看到准确、克制、有帮助的洞察，再接受高级版。

## 1. 当前产品定位

PillarWise AI 应定位为“用四柱象征帮助用户每日反思和行动的私人 AI guide”，而不是算命、预测、心理治疗、投资建议或泛聊天 App。

## 2. 当前核心功能

- Onboarding：欢迎、免责声明、出生资料与关注目标设置、生成首份 Life Blueprint preview。
- Today：首页每日重点、挑战、机会、本周主题、今日行动、反思保存。
- Blueprint：展示 preview/full report、锁定章节、引导 Ask 或升级说明。
- Ask：AI guide 问答、推荐问题、保存回答。
- Relationship：关系预览和深度报告入口，当前已降级为 Me 内 Beta。
- Me：会员权益说明、Saved Journal、语言、数据导出、删除账号、隐私/条款/免责声明。
- 后端：Spring Boot + SQLite，包含 birth profile、BaZi chart、daily insights、reports、conversations、journal、subscriptions、analytics。

## 3. 当前用户路径

首次路径：Welcome -> Disclaimer -> Profile Setup -> Generate Blueprint -> Preview -> Continue Free / Learn Premium -> Today。

日常路径：Today -> Break down next step -> Ask -> Save Reflection -> Journal -> Next day Today。

升级路径：Preview locked full blueprint / Blueprint locked section / Ask quota / Me plan card -> Paywall sheet。

## 4. 当前主要问题

- Onboarding 代码仍保留旧的拆分步骤类，虽然主路径已经合并，后续维护容易混乱。
- `app.dart` 过长，页面、弹窗、文案辅助函数和组件混在一起，不利于快速迭代。
- Relationship 能力地点固定、表单字段少，暂不应作为主商业功能。
- 生产构建没有真实 IAP，只能展示高级版说明，不能收费。
- 城市库、AI 输出一致性、会员权益校验仍需增强。
- `app/README.md` 原本仍是 Flutter 模板文案，削弱工程交付感。

## 5. 当前最影响转化的问题

首页如果只是展示信息，用户不知道下一步该做什么。已通过 Today 主行动“Break down the next step / 帮我拆解下一步”把首页转化目标收敛为一次 AI 追问。

## 6. 当前最影响留存的问题

用户完成一次 reading 后，如果 Journal 不回流到首页，就没有“继续上次”的理由。当前 Today 已展示最近 Journal，是首版最重要的留存入口。

## 7. 当前最影响付费的问题

完整蓝图和 AI 限额是合理付费点，但 IAP 未接入前不能显示价格、购买按钮或成功支付。当前 paywall 只能作为高级版说明和 StoreKit 预留。

## 8. 当前最影响 App Store 上架的问题

- AI 和命理内容必须持续声明非医疗、非法律、非财务、非心理健康建议。
- 外部或本地解锁不能在生产中伪装成真实购买。
- Relationship Beta 不应在首版描述中承诺完整匹配/预测能力。
- 出生资料、AI 对话、Journal、analytics 的收集用途必须写进隐私政策。

## 9. 当前最应该保留的功能

Life Blueprint preview、Today、Ask Guide、Journal、数据导出、删除账号、语言切换、免责声明、非侵入式高级版说明。

## 10. 当前最应该隐藏或弱化的功能

Relationship 深度报告应弱化为 Beta 二级入口。未接入 IAP 前，所有“购买、订阅、价格、恢复购买”表达都应保持说明性质，不进入真实交易承诺。

## 11. 当前最应该重做的 3 个流程

1. 首次体验：从多步命理表单收敛为 3 段价值理解和一次资料设置。
2. 首页闭环：Today -> Ask Guide -> Save Reflection -> Journal -> Continue。
3. 付费路径：从“买高级版”改成“高级版能力说明 + IAP 待接入 + 本地测试仅限 local flavor”。

## 12. 当前最应该重做的 5 个页面

1. Today 首页：承载价值说明、主行动、今日重点、最近记录。
2. Profile Setup：减少步骤，要求用户显式提供必要资料，错误可恢复。
3. Preview：先给价值，再自然展示完整蓝图升级点。
4. Me：把权益、Journal、Beta、隐私、语言聚合。
5. Paywall sheet：合规说明，不假装支付。
