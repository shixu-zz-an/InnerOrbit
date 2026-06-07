# Final Launch Report

## 新产品定位
PillarWise AI 从“能展示八字/AI 功能的 App”升级为“每日个人洞察和反思留存产品”。

## 核心用户路径
Welcome -> Disclaimer -> Profile Setup -> Generate Blueprint -> Today -> Ask Guide -> Save Reflection。

## 核心付费路径
完整蓝图、更多 AI 追问和关系深度报告是自然升级点。当前只保留合规说明，真实收费必须接入 Apple IAP。

## 留存机制
Today 首页展示最近 Journal；保存反思和 AI 回答成为核心留存动作。

## 已完成重构
- Onboarding 收敛为三屏默认路径。
- 主 Tab 从 5 个收敛为 4 个。
- Relationship 降级为 Me / Labs 二级 Beta。
- Today 首页新增主行动和最近记录。
- Paywall 改为合规升级说明。
- 增加轻量 analytics。
- 增加通用状态和 Pro/FeatureLock 组件。

## 已修复体验问题
首页目标不清、关系入口过重、假付费路径、旧价格文案、缺少继续使用入口。

## 已修复上架风险
不再展示虚假订阅价格，不再把本地激活伪装成真实支付，AI 边界说明保留。

## 仍然存在的风险
Apple IAP 未接入，城市库不足，Relationship Beta 成熟度不足，`app.dart` 仍需后续拆分。

## 被隐藏或弱化的功能
Relationship 从主 Tab 移至 Me / Labs。

## 被重做的流程
首次体验、首页每日闭环、升级说明路径、关系入口层级。

## 被重做的页面
Profile Setup、Today、Me、Paywall sheet。

## 被重构的组件
状态组件、ProBadge、FeatureLock、RetryButton。

## 加入的埋点
初始化、核心闭环、AI 提问、反思保存、Paywall、升级点击、关系预览、Tab 曝光。

## 文案优化
移除虚假价格，强化反思价值，弱化未成熟功能承诺。

## 真机重点验收
Profile Setup 小屏滚动、Ask 慢响应、Today 保存反思、Paywall 合规文案、Me 数据导出和删除账号。

## 需要后端支持
更完整城市库、IAP receipt 校验、会员权益同步、AI 会话分页、Journal 搜索。

## 需要 Apple IAP
订阅或一次性购买必须接入 StoreKit 和服务端校验后才能上线收费。

## 需要补充隐私政策
出生数据、AI 对话、Journal、analytics events 的用途、保存期限和删除方式。

## 需要补充 App Store 文案
自我反思定位、非医疗/法律/财务建议、AI 内容边界、隐私承诺。

## 上线前最后 10 个必须检查项
1. IAP 是否接入或完全隐藏真实收费。
2. Profile Setup 小屏无 overflow。
3. 中文 AI 输出不夹英文。
4. 数据导出可用。
5. 删除账号需二次确认。
6. 无 mock/demo/TODO 用户可见文案。
7. 断网有可恢复错误。
8. Journal 保存成功可见。
9. 隐私政策和免责声明完整。
10. App Store 审核截图与真实功能一致。

## 一句话结论
当前版本已经从“能跑的 App”明显升级为“具备上线产品结构的版本”，但真实商业化上线前必须完成 Apple IAP、城市库扩展和真机 QA。
