# App Store Readiness

## 高风险问题
- 真实收费前必须接入 Apple IAP。当前已移除生产路径上的虚假购买动作。
- AI 内容必须持续避免医疗、金融、法律和确定性预测。

## 中风险问题
- 出生地点支持城市仍然有限，公开推广前应扩展城市库或接入地点搜索。
- Relationship 功能仍偏 Beta，不应作为首版核心卖点。

## 低风险问题
- `app.dart` 仍较长，后续可按页面拆分。
- 后端本地激活接口应仅用于开发环境。

## 已修复问题
- 移除主 Tab 的 Relationship 入口。
- 付费文案去除价格和假订阅承诺。
- 首页加入明确主行动和最近记录。
- Onboarding 默认路径减少为三屏。

## 仍需人工处理问题
- Apple IAP 产品配置。
- 完整隐私政策网页。
- App Store 截图和审核备注。
- 弱网和真机长期体验。

## 上架前必须检查的页面
Welcome、Disclaimer、Profile Setup、Preview、Today、Ask、Blueprint、Me、Paywall、Data Export、Delete Account。

## 需要补充到 App Store 描述里的内容
PillarWise 是自我反思工具，不提供医疗、法律、财务或心理健康建议；AI 输出用于思考和行动建议，不是确定性预测。

## 需要补充到隐私政策里的内容
出生信息、对话、Journal、权益状态、analytics events 的用途、保存期限、删除方式。

## 需要真机验证的权限流程
当前无强制系统权限。未来如果加通知提醒，需要验证权限弹窗和拒绝后的路径。

## 是否存在 4.3 Spam 风险
当前风险为低到中。关键在于避免模板化页面、假付费和空壳功能；Relationship 已后置可降低风险。
