# Stability Report

## 已检查风险
- 主流程按钮重复提交：已有 loading/disabled。
- AI 慢响应：Ask 输入按钮会进入 loading。
- 后端 401：启动会清理旧 token 并恢复 dev session。
- 网络错误：统一进入可恢复错误文案。
- 键盘遮挡：AppPage 支持 resize，底部输入栏放在 SafeArea。

## 本轮修复
- 生产付费路径不再触发本地激活。
- Relationship 不再作为主 Tab 暴露。
- Onboarding 步骤减少，降低中途流失。
- 首页加入最近记录，降低“用完即走”。

## 高风险未自动修改
- 城市库不足。
- Apple IAP 未接入。
- `app.dart` 仍较长，拆文件需要更完整回归。

## 后续性能建议
按 feature 拆分页面文件，引入页面级 provider，Journal 长列表改分页，AI 会话历史做服务端分页。
