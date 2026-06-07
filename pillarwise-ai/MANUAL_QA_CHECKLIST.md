# MANUAL_QA_CHECKLIST

## 1. 首次安装启动检查

操作：清除 App 数据后启动。预期：先出现 Welcome，不白屏。失败表现：卡 loading、直接进空 Today。页面：Root、Welcome。

## 2. Onboarding 检查

操作：Welcome -> Disclaimer -> Profile Setup -> Generate。预期：不超过核心 3 段，用户必须确认必要出生资料和目标后才能生成。失败表现：按钮不可点、日期为空但无提示、地点为空但无提示。页面：Welcome、Disclaimer、ProfileSetup。

## 3. 登录/注册检查

操作：首次启动 local backend。预期：dev session 自动创建；生产后应替换为 Apple/邮箱登录策略。失败表现：未授权错误无法恢复。页面：Root。

## 4. 首页检查

操作：完成 preview 后进入 Today。预期：看到今日重点、主按钮、今日信号、反思输入、最近 Journal。失败表现：像菜单页、无主行动。页面：Today。

## 5. 核心功能闭环检查

操作：Today 点击主按钮 -> Ask 返回回答 -> 保存。预期：Ask 有 loading，成功后 Journal 数量增加。失败表现：重复提交、无成功反馈。页面：Today、Ask、Saved Journal。

## 6. 列表页检查

操作：保存多条 Journal 后进入 Saved Journal。预期：长列表可滚动，文字不溢出。失败表现：卡顿、内容重叠。页面：SavedJournal。

## 7. 详情页检查

操作：点击 Blueprint section。预期：弹窗显示内容，锁定项引导高级版说明。失败表现：空弹窗、锁定项可绕过。页面：Blueprint、section sheet。

## 8. 表单页检查

操作：ProfileSetup 修改日期、时间精度、城市、目标；Relationship Beta 留空提交。预期：Profile 可提交，Relationship 有表单错误。失败表现：空字段提交、日期格式无提示。页面：ProfileSetup、AddRelationship sheet。

## 9. 空状态检查

操作：清空 Journal 或新用户无关系。预期：显示 AppEmptyState 和下一步动作。失败表现：只有“暂无数据”。页面：SavedJournal、Relationship Beta。

## 10. 错误状态检查

操作：停掉 backend 后启动或刷新。预期：用户友好错误和 Retry。失败表现：技术错误码、白屏。页面：Root、Today、Ask。

## 11. 弱网检查

操作：用 Network Link Conditioner 或代理延迟请求。预期：loading 清楚，按钮防重复。失败表现：多次提交、长时间无反馈。页面：Generating、Ask、Paywall。

## 12. 断网检查

操作：断网后刷新 Today 或 Ask。预期：错误可恢复，数据安全文案。失败表现：崩溃或空白。页面：Today、Ask。

## 13. 权限检查

操作：真机运行。预期：当前不主动请求系统权限。失败表现：无解释请求定位/通知。页面：全局。

## 14. 会员页/升级页检查

操作：Preview/Blueprint/Ask/Me 打开 paywall。预期：生产构建只说明高级版和 IAP 未接入，不收款；local 构建才出现测试开通。失败表现：虚假价格、假支付成功。页面：Paywall、Me。

## 15. 设置页检查

操作：切换语言、查看隐私/条款/免责声明、导出数据。预期：内容可读，语言立即生效。失败表现：中英混乱、导出无反馈。页面：Me。

## 16. 退出/删除账号检查

操作：点击 Delete Account，取消，再确认删除。预期：二次确认，失败有提示，成功清数据回到 onboarding。失败表现：误删、无恢复提示。页面：Me、Delete dialog。

## 17. 小屏 iPhone 检查

操作：iPhone SE 尺寸跑完整流程。预期：按钮不被键盘遮挡，Tab 和底部操作安全区正常。失败表现：overflow、按钮看不到。页面：所有表单和 Ask。

## 18. 大屏 iPhone 检查

操作：iPhone Pro Max 尺寸跑完整流程。预期：内容不显得散乱，卡片宽度合理。失败表现：首屏信息稀疏、层级不清。页面：Today、Blueprint、Me。

## 19. 键盘遮挡检查

操作：Ask 输入长问题，Today 输入长反思。预期：输入栏和发送按钮可见。失败表现：键盘遮挡、滚动异常。页面：Ask、Today。

## 20. App Store 审核风险检查

操作：按审核员视角走全 App。预期：无 demo/mock/TODO 文案，无虚假购买，无专业建议承诺。失败表现：模板页、占位功能、外链购买数字服务。页面：全局。
