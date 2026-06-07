# RETENTION_PLAN

## 1. 当前留存问题

用户完成首次 reading 后，如果后续只剩静态 blueprint，会很快流失。留存必须来自每日变化、继续上次记录和用户自己的 Journal 数据沉淀。

## 2. 新增或优化的留存机制

- Today 展示 daily insight、weekly theme、today action。
- Today 显示最近 Journal，形成“继续上次”。
- AI 回答和 Today 反思都可以保存到 Journal。
- Me 显示 Saved Journal 入口和数量。
- 空状态引导用户创建第一条记录。

## 3. 修改文件

- `app/lib/app.dart`：Today、Ask、Me、Saved Journal。
- `app/lib/app_state.dart`：`saveReflection` 后更新本地 journal list，并埋点。
- `app/lib/core/widgets/app_components.dart`：统一 empty/loading/error/success/locked 状态。

## 4. 是否需要权限

当前不需要通知、定位、通讯录、相册等敏感权限。出生地点通过用户选择/输入，不请求系统定位。

## 5. 是否影响隐私合规

会保存出生资料、AI 对话、Journal、entitlement 和 analytics events。隐私政策必须说明用途、保存、删除和导出方式。

## 6. 后续可增强点

Journal 搜索、最近 7 天洞察、连续反思趋势、用户可选择的提醒、离线缓存、AI 总结用户长期模式。提醒必须由用户主动开启并解释价值。
