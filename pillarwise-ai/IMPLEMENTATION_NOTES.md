# IMPLEMENTATION_NOTES

## 首页重做输出

修改文件：

- `app/lib/app.dart`
- `app/lib/app_state.dart`
- `app/lib/core/widgets/app_components.dart`

新首页结构：

- 顶部：Today 标题、刷新、日期 eyebrow、价值说明。
- 中部：主行动卡片，推动用户把今日重点拆成下一步。
- 数据区：weekly theme、today action、challenge、opportunity。
- 留存区：最近 Journal。
- 底部：反思输入和保存按钮。

解决的转化问题：用户进入后不再面对功能菜单，而是知道今天要先完成一个行动或一次反思。

是否影响业务逻辑：保留原 Today API 和 Journal API；确认不会默认提交样例出生资料，并通过生成前校验提升请求可靠性。

人工验收：小屏 overflow、长文本、断网刷新、保存成功反馈、Ask 跳转。

## Onboarding 输出

是否新增 onboarding：没有从零新增，已将已有 onboarding 主路径收敛为轻量流程。

涉及文件：

- `app/lib/app.dart`
- `app/lib/app_state.dart`
- `app/lib/core/storage/local_store.dart`

首次体验流程：

1. Welcome：说明私人反思价值。
2. Disclaimer：确认非专业建议边界。
3. ProfileSetup：一次性填写首份 blueprint 所需资料。
4. Preview：先给免费预览，再允许继续免费或了解高级版。

本地存储记录：`LocalStore` 保存 onboarding draft 和 locale；完成后清除 draft。是否已完成 onboarding 由后端 `hasPrimaryBirthProfile` 决定。

是否影响登录流程：不强制登录，local/dev session 自动创建；生产应替换为正式账号体系。

上架风险：低。风险主要来自命理/AI 边界，当前已有免责声明。

## 关键状态输出

已覆盖组件：

- `AppLoadingState`
- `AppEmptyState`
- `AppErrorState`
- `AppSuccessState`
- `AppOfflineState`
- `AppPermissionState`
- `AppLockedState`
- `AppRetryButton`

修复或确认的状态：

- loading：初始化、生成、Ask、保存、导出、删除、关系报告。
- empty：Journal、Relationship、Blueprint 无数据。
- error：初始化失败、生成失败、Ask 失败、导出/删除失败。
- success：保存 Journal、Premium local test、关系添加。
- locked/pro：Blueprint section、Relationship report、Premium explanation。
- submitting：Paywall local activation、Relationship submit、Delete/export guards。

仍需后端支持：

- 局部失败恢复。
- AI 额度剩余。
- IAP entitlement 真实同步。
- Journal 分页和搜索。

需要人工验收：

- 弱网 loading。
- 断网 retry。
- 长文本溢出。
- 中文/英文切换。
- 生产 flavor 无 local unlock。
