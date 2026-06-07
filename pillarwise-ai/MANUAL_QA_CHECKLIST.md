# Manual QA Checklist

## 1. 首次安装启动
操作：卸载 App，重新安装并启动。
预期：进入 Welcome，无白屏。
失败表现：停留 loading 或错误页。
页面：Welcome。

## 2. Onboarding
操作：Welcome -> Disclaimer -> Profile Setup。
预期：默认路径不超过三屏，能生成蓝图。
失败表现：按钮不可点、picker 溢出。
页面：Welcome、Disclaimer、Profile Setup。

## 3. 首页
操作：完成蓝图后进入 Today。
预期：看到今日重点、主按钮、今日信号和反思输入。
失败表现：首页像菜单、无主行动。
页面：Today。

## 4. 核心闭环
操作：点击“让向导帮我拆解”，等待 AI 返回，保存回答或反思。
预期：loading 明确，成功保存到 Journal。
失败表现：按钮重复提交、英文混入中文、保存无反馈。
页面：Today、Ask、Saved Journal。

## 5. 蓝图
操作：进入 Blueprint，查看预览和锁定章节。
预期：免费内容可读，锁定内容不误导。
失败表现：空白、锁定内容无说明。
页面：Blueprint。

## 6. 会员页
操作：点击 Preview/Blueprint/Me 的升级入口。
预期：未接 IAP 时只显示说明，不展示虚假价格。
失败表现：出现假购买按钮或订阅价格。
页面：Paywall sheet。

## 7. 关系 Beta
操作：Me -> Labs -> Relationship。
预期：作为 Beta 二级入口可用，不占主 Tab。
失败表现：主 Tab 仍有关系入口。
页面：Me、Love。

## 8. 空状态
操作：新账号未添加关系、未保存 Journal。
预期：有解释和下一步按钮。
失败表现：只有“暂无数据”。
页面：Love、Saved Journal。

## 9. 错误状态
操作：断开后端或模拟弱网。
预期：错误文案可理解，有重试。
失败表现：技术错误码或白屏。
页面：启动、Today、Ask。

## 10. 权限
操作：检查是否请求系统权限。
预期：当前不强制请求权限。
失败表现：无解释地弹权限。
页面：全局。

## 11. 小屏 iPhone
操作：iPhone SE 或小屏模拟器跑完整流程。
预期：Profile Setup 可滚动，无 overflow。
失败表现：按钮被遮挡、picker 溢出。
页面：Profile Setup、Ask。

## 12. 大屏 iPhone
操作：iPhone Pro Max 跑完整流程。
预期：布局不显得稀疏，底部 SafeArea 正常。
失败表现：内容贴边或过空。
页面：主 Tab。

## 13. 键盘遮挡
操作：Ask 输入、反思输入、关系添加输入。
预期：输入框和按钮不被键盘挡住。
失败表现：无法提交或看不到输入。
页面：Ask、Today、Love sheet。

## 14. 设置页
操作：切换语言、导出数据、查看法律说明。
预期：中文/英文切换稳定，导出有反馈。
失败表现：文案混乱或弹窗溢出。
页面：Me。

## 15. 删除账号
操作：打开删除确认但不提交。
预期：危险操作有明确确认。
失败表现：误触直接删除。
页面：Me。

## 16. App Store 审核风险
操作：全局检查假数据、价格、未完成入口、医疗/财务承诺。
预期：无假购买、无占位承诺。
失败表现：出现价格、demo、mock、TODO。
页面：全局。
