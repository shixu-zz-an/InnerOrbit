// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'PillarWise AI';

  @override
  String get loadingPreparing => '正在准备你的个人向导...';

  @override
  String get genericErrorTitle => '这里需要重试一下。';

  @override
  String get genericRetry => '重试';

  @override
  String get continueButton => '继续';

  @override
  String get done => '完成';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get notNow => '暂时不用';

  @override
  String get free => '免费版';

  @override
  String get premiumActive => '高级版已开通';

  @override
  String get welcomeEyebrow => '私密自我探索';

  @override
  String get welcomeTitle => '更清楚地看见你的内在模式。';

  @override
  String get welcomeSubtitle => '一个安静的个人向导，帮助你理解时机、关系、选择和反复出现的内在主题。';

  @override
  String get welcomePrimary => '开始我的蓝图';

  @override
  String get disclaimerTitle => '开始之前';

  @override
  String get disclaimerSubtitle =>
      'PillarWise 用于自我反思和个人洞察，不提供医疗、法律、财务或心理健康建议。所有解读都不是确定性的预测。';

  @override
  String get disclaimerAccept => '我理解，并希望继续。';

  @override
  String get birthDateTitle => '你的出生日期是？';

  @override
  String get birthDateSubtitle => '出生日期会锚定你蓝图中的核心模式。';

  @override
  String get birthTimeTitle => '你的出生时间是？';

  @override
  String get birthTimeSubtitle => '准确时间可以提升时机和关系洞察的精度。如果你不知道，我们也可以生成部分蓝图。';

  @override
  String get timeExact => '准确';

  @override
  String get timeApprox => '大约';

  @override
  String get timeUnknown => '未知';

  @override
  String get birthPlaceTitle => '你的出生地点是？';

  @override
  String get birthPlaceSubtitle => '出生地点会帮助我们更准确地计算时区和地点相关信息。';

  @override
  String get selectedBirthplace => '已选择出生地';

  @override
  String timezoneLabel(Object timezone) {
    return '时区：$timezone';
  }

  @override
  String get traditionalTitle => '一个传统计算细节';

  @override
  String get traditionalSubtitle =>
      '部分传统运势周期计算会使用出生时登记的生理性别。它只用于时间算法，不定义你的性别身份。';

  @override
  String get female => '女性';

  @override
  String get male => '男性';

  @override
  String get preferNot => '不透露';

  @override
  String get goalTitle => '你最想先理解什么？';

  @override
  String get goalSubtitle => '最多选择三项，之后可以随时调整。';

  @override
  String get goalMyself => '我自己';

  @override
  String get goalLove => '亲密关系';

  @override
  String get goalCareer => '职业方向';

  @override
  String get goalMoney => '金钱模式';

  @override
  String get goalTiming => '人生时机';

  @override
  String get goalGrowth => '情绪成长';

  @override
  String get generateBlueprint => '生成我的蓝图';

  @override
  String get generationFailedTitle => '你的蓝图没有加载成功。';

  @override
  String get generatingText => '正在映射你的四柱...';

  @override
  String get previewTitle => '你的首次解读';

  @override
  String get previewDefaultTitle => '你的人生蓝图';

  @override
  String get previewDefaultSubtitle => '你的首次解读已经准备好了。';

  @override
  String get unlockBlueprint => '解锁完整蓝图';

  @override
  String get continueFree => '继续使用免费预览';

  @override
  String get tabToday => '今日';

  @override
  String get tabBlueprint => '蓝图';

  @override
  String get tabAsk => '提问';

  @override
  String get tabLove => '关系';

  @override
  String get tabMe => '我的';

  @override
  String get todayFocus => '今日重点';

  @override
  String get challenge => '挑战';

  @override
  String get opportunity => '机会';

  @override
  String get askAboutThis => '围绕这个提问';

  @override
  String get createBlueprintFirstTitle => '请先创建你的蓝图。';

  @override
  String get createBlueprintFirstBody => '每日洞察会基于你的出生信息生成。';

  @override
  String get refresh => '刷新';

  @override
  String get reflectionPlaceholder => '写下一段简短反思...';

  @override
  String get saveReflection => '保存反思';

  @override
  String get weeklyTheme => '本周主题';

  @override
  String get journalSavedTitle => '已保存';

  @override
  String get journalSavedBody => '已加入你的日记。';

  @override
  String get coreArchetype => '核心原型';

  @override
  String get saveToJournal => '保存到日记';

  @override
  String get lockedReadingSuffix => '解锁完整解读，继续深入查看。';

  @override
  String get askIntro => '你可以向个人向导询问关系、职业、模式或时机主题。';

  @override
  String get askPlaceholder => '向你的向导提问...';

  @override
  String get promptStuck => '为什么我最近感觉卡住了？';

  @override
  String get promptCareer => '什么职业路径更适合我的自然优势？';

  @override
  String get promptRelationship => '为什么我总在关系里重复同一种模式？';

  @override
  String get promptMonth => '这个月我应该专注什么？';

  @override
  String get notice => '提示';

  @override
  String get guideUnavailable => '向导暂时不可用';

  @override
  String get unlockUnlimited => '解锁无限提问';

  @override
  String get guideLabel => 'PillarWise 向导';

  @override
  String tryThis(Object step) {
    return '可以尝试：$step';
  }

  @override
  String get loveEmptyLabel => '关系洞察';

  @override
  String get loveEmptyTitle => '理解一段关系的动态。';

  @override
  String get loveEmptyBody => '添加对方的出生信息，探索沟通、吸引力和冲突模式。';

  @override
  String get addSomeone => '添加一个人';

  @override
  String get relationshipFallbackTitle => '关系';

  @override
  String get relationshipPreviewFallback => '生成预览，理解这段关系的动态。';

  @override
  String get viewRelationshipReport => '查看完整关系报告';

  @override
  String get unlockRelationshipReport => '解锁完整关系报告';

  @override
  String get relationshipReportTitle => '关系报告';

  @override
  String get relationshipReportUnlocked => '完整关系报告已准备好。';

  @override
  String get generatePreview => '生成预览';

  @override
  String get namePlaceholder => '姓名或昵称';

  @override
  String get datePlaceholder => 'YYYY-MM-DD';

  @override
  String get account => '账户';

  @override
  String get profile => '资料';

  @override
  String get you => '你';

  @override
  String get birthDetails => '出生信息';

  @override
  String get subscription => '订阅';

  @override
  String get currentPlan => '当前方案';

  @override
  String get restorePurchases => '恢复购买';

  @override
  String get manageSubscription => '管理订阅';

  @override
  String get managedInAppStore => '请在 App Store 账户设置中管理';

  @override
  String get saved => '已保存';

  @override
  String get savedJournal => '已保存日记';

  @override
  String get noJournalTitle => '还没有保存内容。';

  @override
  String get noJournalBody => '你的反思和已保存的向导回答会出现在这里。';

  @override
  String get dataPrivacy => '数据与隐私';

  @override
  String get exportData => '导出我的数据';

  @override
  String get deleteAccount => '删除账号';

  @override
  String get legal => '法律';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get termsOfUse => '使用条款';

  @override
  String get disclaimer => '免责声明';

  @override
  String get language => '语言';

  @override
  String get systemLanguage => '跟随系统';

  @override
  String get english => 'English';

  @override
  String get chineseSimplified => '简体中文';

  @override
  String get versionLabel => 'PillarWise AI v1.0.0';

  @override
  String get privacyBody => '我们会收集出生信息、对话、日记条目和权益状态，用于个性化解读。我们不会出售个人数据。';

  @override
  String get termsBody => 'PillarWise 是自我反思产品，不提供医疗、法律、财务或心理健康建议。';

  @override
  String get disclaimerBody => '所有解读都是反思性的模式提示，不是确定性的预测。';

  @override
  String get deleteTitle => '删除账号？';

  @override
  String get deleteBody => '这会移除你的出生资料、命盘、报告、对话、日记条目和本地订阅状态。此操作无法撤销。';

  @override
  String get paywallTitle => '解锁完整人生蓝图';

  @override
  String get paywallBody =>
      '完整人格解读、每日个性化洞察、无限 AI 追问，以及关系报告。\n\n年度 - 最划算 - \$79.99/年\n月度 - \$14.99/月\n订阅会自动续订，除非你在当前周期结束前至少 24 小时取消。';

  @override
  String get startAnnual => '开始年度方案';

  @override
  String get appLanguageTitle => 'App 语言';

  @override
  String get exportTitle => '导出我的数据';
}
