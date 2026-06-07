# APP_STORE_READINESS

## 1. 高风险问题

- 真实 IAP 未接入。上线收费前必须接入 Apple IAP；当前生产构建只能展示高级版说明。
- 出生资料、AI 对话、Journal 属于敏感个人内容，隐私政策必须完整覆盖。
- AI/命理内容必须保持自我反思定位，不能被 App Store 理解为医疗、法律、财务、心理健康建议。

## 2. 中风险问题

- 地点支持有限，公开市场上线前需要更完整的城市/时区输入。
- Relationship Beta 当前表单简单，不能作为首版主卖点。
- `app.dart` 文件过长，后续迭代容易产生回归。
- 生产环境必须确认 `APP_FLAVOR` 不为 `local`，隐藏 local Premium test。

## 3. 低风险问题

- `app/README.md` 原本为 Flutter 模板，已列为交付完成度修复项。
- 旧 onboarding step class 仍存在但不在主路径。
- Legal 文本是产品级说明，还不是正式法律文件。

## 4. 已修复问题

- Relationship 从主 Tab 降为 Me 二级 Beta。
- Paywall 不展示虚假价格，不伪造交易。
- Today 增加清晰主行动和最近记录。
- `OnboardingDraft` 生成前校验和 `birthTime` 草稿恢复，避免生成请求缺字段。
- 通用状态组件已存在并用于关键页面。

## 5. 仍需人工处理问题

- 正式隐私政策和服务条款。
- App Store Connect IAP 商品、订阅组、恢复购买。
- 审核账号/演示数据。
- AI 输出质量和敏感建议边界。

## 6. 上架前必须检查的页面

Welcome、Disclaimer、ProfileSetup、Preview、Today、Blueprint、Ask、Me、Paywall sheet、Saved Journal、Delete account、Privacy/Terms/Disclaimer。

## 7. 需要补充到 App Store 描述里的内容

- PillarWise 是自我反思和个人洞察工具。
- 使用出生资料生成象征性/反思性 reading。
- AI guide 帮用户拆解行动，不替用户做决定。
- 不是医疗、法律、财务或心理健康建议。

## 8. 需要补充到隐私政策里的内容

出生资料、地理/时区信息、AI 对话、Journal、订阅权益、analytics events、数据导出、删除账号、保留期限、第三方 AI provider 使用情况。

## 9. 需要真机验证的权限流程

当前不请求系统权限。仍需真机验证 secure storage、网络失败、键盘遮挡、删除账号、语言切换和 iOS 小屏布局。

## 10. 是否存在 4.3 Spam 风险

如果首版只像“八字报告模板 + AI 聊天”，会有低质量/重复风险。降低风险的关键是：Today 每日闭环、Journal 数据沉淀、明确非宿命化定位、隐藏低成熟度关系功能。
