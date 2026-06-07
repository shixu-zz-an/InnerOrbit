import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'app_state.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_radius.dart';
import 'core/theme/app_spacing.dart';
import 'core/theme/app_text_styles.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/app_components.dart';
import 'l10n/app_localizations.dart';

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

const double _tabBottomInset = AppSpacing.tabBottomInset;

class PillarWiseApp extends ConsumerWidget {
  const PillarWiseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appControllerProvider);
    return CupertinoApp(
      title: 'PillarWise AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: state.localeCode == null ? null : Locale(state.localeCode!),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: Builder(
        builder: (context) {
          if (!state.initialized) {
            return LoadingScaffold(text: context.l10n.loadingPreparing);
          }
          if (state.error != null && state.me == null) {
            return AppPage(
              child: AppErrorState(
                title: _uiText(
                  context,
                  en: 'PillarWise is unavailable.',
                  zh: 'PillarWise 暂时不可用。',
                ),
                message: _errorCopy(context, state.error!),
                actionText: context.l10n.genericRetry,
                onAction: () =>
                    ref.read(appControllerProvider.notifier).initialize(),
              ),
            );
          }
          if (state.needsOnboarding) {
            return const OnboardingFlow();
          }
          return const MainTabs();
        },
      ),
    );
  }
}

class LoadingScaffold extends StatelessWidget {
  const LoadingScaffold({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return AppPage(child: AppLoading(text: text));
  }
}

class OnboardingFlow extends ConsumerWidget {
  const OnboardingFlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appControllerProvider);
    return switch (state.step) {
      OnboardingStep.welcome => const WelcomeScreen(),
      OnboardingStep.disclaimer => const DisclaimerScreen(),
      OnboardingStep.birthDate => const BirthDateScreen(),
      OnboardingStep.birthTime => const BirthTimeScreen(),
      OnboardingStep.birthPlace => const BirthPlaceScreen(),
      OnboardingStep.traditional => const TraditionalScreen(),
      OnboardingStep.goal => const GoalScreen(),
      OnboardingStep.generating => const GeneratingScreen(),
      OnboardingStep.preview => const PreviewScreen(),
    };
  }
}

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return AppPage(
      bottomActionBar: AppBottomActionBar(
        child: AppButton(
          text: l.welcomePrimary,
          icon: CupertinoIcons.arrow_right,
          onPressed: () => ref
              .read(appControllerProvider.notifier)
              .goTo(OnboardingStep.disclaimer),
        ),
      ),
      child: ListView(
        children: [
          const SizedBox(height: AppSpacing.xxl),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppBrandMark(),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: AppPageHeader(
                  eyebrow: l.welcomeEyebrow,
                  title: l.welcomeTitle,
                  subtitle: l.welcomeSubtitle,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          AppCard(
            child: Column(
              children: [
                AppInfoRow(
                  icon: CupertinoIcons.square_grid_2x2,
                  label: _uiText(context, en: 'Reading style', zh: '解读方式'),
                  value: _uiText(
                    context,
                    en: 'Reflective, not fatalistic',
                    zh: '用于反思，而非宿命判断',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppInfoRow(
                  icon: CupertinoIcons.lock_shield,
                  label: _uiText(context, en: 'Your data', zh: '你的数据'),
                  value: _uiText(context, en: 'Private by design', zh: '以隐私为先'),
                ),
                const SizedBox(height: AppSpacing.md),
                AppInfoRow(
                  icon: CupertinoIcons.sparkles,
                  label: _uiText(context, en: 'AI guidance', zh: 'AI 引导'),
                  value: _uiText(
                    context,
                    en: 'Grounded next steps',
                    zh: '给出可执行下一步',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
        ],
      ),
    );
  }
}

class DisclaimerScreen extends ConsumerStatefulWidget {
  const DisclaimerScreen({super.key});

  @override
  ConsumerState<DisclaimerScreen> createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends ConsumerState<DisclaimerScreen> {
  bool accepted = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return StepScaffold(
      step: OnboardingStep.disclaimer,
      title: l.disclaimerTitle,
      subtitle: l.disclaimerSubtitle,
      child: Column(
        children: [
          AppCard(
            selected: accepted,
            onTap: () => setState(() => accepted = !accepted),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Icon(
                  accepted
                      ? CupertinoIcons.checkmark_circle_fill
                      : CupertinoIcons.circle,
                  color: accepted ? AppColors.primary : AppColors.inkFaint,
                  size: 24,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(l.disclaimerAccept, style: AppTextStyles.body),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            text: l.continueButton,
            onPressed: accepted
                ? () => ref
                      .read(appControllerProvider.notifier)
                      .goTo(OnboardingStep.birthDate)
                : null,
          ),
        ],
      ),
    );
  }
}

class BirthDateScreen extends ConsumerWidget {
  const BirthDateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final draft = ref.watch(appControllerProvider).draft;
    return StepScaffold(
      step: OnboardingStep.birthDate,
      title: l.birthDateTitle,
      subtitle: l.birthDateSubtitle,
      child: Column(
        children: [
          AppPickerPanel(
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: draft.birthDate,
              minimumDate: DateTime(1900),
              maximumDate: DateTime.now(),
              onDateTimeChanged: (value) {
                ref
                    .read(appControllerProvider.notifier)
                    .updateDraft(draft.copyWith(birthDate: value));
              },
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            text: l.continueButton,
            onPressed: () => ref
                .read(appControllerProvider.notifier)
                .goTo(OnboardingStep.birthTime),
          ),
        ],
      ),
    );
  }
}

class BirthTimeScreen extends ConsumerWidget {
  const BirthTimeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final draft = ref.watch(appControllerProvider).draft;
    return StepScaffold(
      step: OnboardingStep.birthTime,
      title: l.birthTimeTitle,
      subtitle: l.birthTimeSubtitle,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: CupertinoSlidingSegmentedControl<String>(
              groupValue: draft.birthTimePrecision,
              children: {
                'exact': Padding(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  child: Text(l.timeExact),
                ),
                'approximate': Padding(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  child: Text(l.timeApprox),
                ),
                'unknown': Padding(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  child: Text(l.timeUnknown),
                ),
              },
              onValueChanged: (value) {
                if (value != null) {
                  ref
                      .read(appControllerProvider.notifier)
                      .updateDraft(draft.copyWith(birthTimePrecision: value));
                }
              },
            ),
          ),
          if (draft.birthTimePrecision != 'unknown') ...[
            const SizedBox(height: AppSpacing.lg),
            AppPickerPanel(
              height: 190,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: draft.birthTime,
                onDateTimeChanged: (value) {
                  ref
                      .read(appControllerProvider.notifier)
                      .updateDraft(draft.copyWith(birthTime: value));
                },
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            text: l.continueButton,
            onPressed: () => ref
                .read(appControllerProvider.notifier)
                .goTo(OnboardingStep.birthPlace),
          ),
        ],
      ),
    );
  }
}

class BirthPlaceScreen extends ConsumerWidget {
  const BirthPlaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final draft = ref.watch(appControllerProvider).draft;
    final selected = draft.birthPlaceText;
    return StepScaffold(
      step: OnboardingStep.birthPlace,
      title: l.birthPlaceTitle,
      subtitle: l.birthPlaceSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCard(
            tone: AppTone.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.selectedBirthplace, style: AppTextStyles.caption),
                const SizedBox(height: AppSpacing.xs),
                Text(selected, style: AppTextStyles.title3),
                const SizedBox(height: AppSpacing.sm),
                AppInfoRow(
                  icon: CupertinoIcons.time,
                  label: _uiText(context, en: 'Timezone', zh: '时区'),
                  value: draft.timezone,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            _uiText(context, en: 'Choose a supported city', zh: '选择一个支持的城市'),
            style: AppTextStyles.subhead,
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              AppTag(
                text: 'Los Angeles, CA, US',
                selected: draft.birthPlaceText.contains('Los Angeles'),
                onTap: () => ref
                    .read(appControllerProvider.notifier)
                    .updateDraft(
                      draft.copyWith(
                        birthPlaceText: 'Los Angeles, CA, US',
                        latitude: 34.0522,
                        longitude: -118.2437,
                        timezone: 'America/Los_Angeles',
                      ),
                    ),
              ),
              AppTag(
                text: 'New York, NY, US',
                selected: draft.birthPlaceText.contains('New York'),
                onTap: () => ref
                    .read(appControllerProvider.notifier)
                    .updateDraft(
                      draft.copyWith(
                        birthPlaceText: 'New York, NY, US',
                        latitude: 40.7128,
                        longitude: -74.006,
                        timezone: 'America/New_York',
                      ),
                    ),
              ),
              AppTag(
                text: 'London, UK',
                selected: draft.birthPlaceText.contains('London'),
                onTap: () => ref
                    .read(appControllerProvider.notifier)
                    .updateDraft(
                      draft.copyWith(
                        birthPlaceText: 'London, UK',
                        latitude: 51.5072,
                        longitude: -0.1276,
                        timezone: 'Europe/London',
                      ),
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            _uiText(
              context,
              en: 'Location support is intentionally limited in this build so timezone math stays reliable.',
              zh: '当前版本先提供有限地点，以保证时区计算可靠。',
            ),
            style: AppTextStyles.footnote.copyWith(color: AppColors.inkMuted),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            text: l.continueButton,
            onPressed: () => ref
                .read(appControllerProvider.notifier)
                .goTo(OnboardingStep.traditional),
          ),
        ],
      ),
    );
  }
}

class TraditionalScreen extends ConsumerWidget {
  const TraditionalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final draft = ref.watch(appControllerProvider).draft;
    return StepScaffold(
      step: OnboardingStep.traditional,
      title: l.traditionalTitle,
      subtitle: l.traditionalSubtitle,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: CupertinoSlidingSegmentedControl<String>(
              groupValue: draft.sexForTraditionalCycle,
              children: {
                'female': Padding(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  child: Text(l.female),
                ),
                'male': Padding(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  child: Text(l.male),
                ),
                'prefer_not_to_say': Padding(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  child: Text(l.preferNot),
                ),
              },
              onValueChanged: (value) {
                if (value != null) {
                  ref
                      .read(appControllerProvider.notifier)
                      .updateDraft(
                        draft.copyWith(sexForTraditionalCycle: value),
                      );
                }
              },
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            text: l.continueButton,
            onPressed: () => ref
                .read(appControllerProvider.notifier)
                .goTo(OnboardingStep.goal),
          ),
        ],
      ),
    );
  }
}

class GoalScreen extends ConsumerWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final draft = ref.watch(appControllerProvider).draft;
    final goals = [
      _GoalOption('Myself', l.goalMyself, CupertinoIcons.person),
      _GoalOption('Love & relationships', l.goalLove, CupertinoIcons.heart),
      _GoalOption('Career direction', l.goalCareer, CupertinoIcons.briefcase),
      _GoalOption(
        'Money patterns',
        l.goalMoney,
        CupertinoIcons.money_dollar_circle,
      ),
      _GoalOption('Life timing', l.goalTiming, CupertinoIcons.clock),
      _GoalOption(
        'Emotional growth',
        l.goalGrowth,
        CupertinoIcons.leaf_arrow_circlepath,
      ),
    ];
    return StepScaffold(
      step: OnboardingStep.goal,
      title: l.goalTitle,
      subtitle: l.goalSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final goal in goals)
                AppTag(
                  text: goal.label,
                  icon: goal.icon,
                  selected: draft.goals.contains(goal.value),
                  onTap: () {
                    final next = [...draft.goals];
                    if (next.contains(goal.value)) {
                      next.remove(goal.value);
                    } else if (next.length < 3) {
                      next.add(goal.value);
                    }
                    ref
                        .read(appControllerProvider.notifier)
                        .updateDraft(draft.copyWith(goals: next));
                  },
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            text: l.generateBlueprint,
            icon: CupertinoIcons.sparkles,
            onPressed: draft.goals.isEmpty
                ? null
                : () => ref
                      .read(appControllerProvider.notifier)
                      .generateProfileAndPreview(),
          ),
        ],
      ),
    );
  }
}

class GeneratingScreen extends ConsumerWidget {
  const GeneratingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final state = ref.watch(appControllerProvider);
    if (state.error != null) {
      return AppPage(
        child: AppErrorState(
          title: l.generationFailedTitle,
          message: _errorCopy(context, state.error!),
          actionText: l.genericRetry,
          onAction: () => ref
              .read(appControllerProvider.notifier)
              .generateProfileAndPreview(),
        ),
      );
    }
    return LoadingScaffold(text: l.generatingText);
  }
}

class PreviewScreen extends ConsumerWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final state = ref.watch(appControllerProvider);
    final preview = _asMap(state.blueprint?['preview']);
    final cards = _asList(preview['cards']);
    return AppPage(
      title: l.previewTitle,
      bottomActionBar: AppBottomActionBar(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              text: l.unlockBlueprint,
              icon: CupertinoIcons.lock_open,
              onPressed: () => showPaywall(context, ref),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton(
              text: l.continueFree,
              variant: AppButtonVariant.secondary,
              onPressed: () =>
                  ref.read(appControllerProvider.notifier).enterMain(),
            ),
          ],
        ),
      ),
      child: ListView(
        children: [
          const SizedBox(height: AppSpacing.xl),
          Text(
            _copy(context, preview['coreArchetype']) ?? l.previewDefaultTitle,
            style: AppTextStyles.title1,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _copy(context, preview['headline']) ?? l.previewDefaultSubtitle,
            style: AppTextStyles.callout.copyWith(color: AppColors.inkMuted),
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final card in cards) ...[
            AppInsightCard(
              label: _copy(context, card['label']),
              title: _copy(context, card['title']) ?? '',
              body: _lockedBody(
                context,
                _copy(context, card['body']) ?? '',
                card['locked'] == true,
              ),
              locked: card['locked'] == true,
              tone: _toneForLabel(card['label']?.toString()),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          const SizedBox(height: AppSpacing.xxxl),
        ],
      ),
    );
  }
}

class MainTabs extends ConsumerStatefulWidget {
  const MainTabs({super.key});

  @override
  ConsumerState<MainTabs> createState() => _MainTabsState();
}

class _MainTabsState extends ConsumerState<MainTabs> {
  late final CupertinoTabController controller;

  @override
  void initState() {
    super.initState();
    controller = CupertinoTabController(
      initialIndex: ref.read(appControllerProvider).selectedTab,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    ref.listen<int>(
      appControllerProvider.select((state) => state.selectedTab),
      (_, next) {
        if (controller.index != next) {
          controller.index = next;
        }
      },
    );
    return CupertinoTabScaffold(
      controller: controller,
      tabBar: AppTabBar(
        onTap: (index) =>
            ref.read(appControllerProvider.notifier).selectTab(index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.sparkles),
            label: l.tabToday,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.square_grid_2x2),
            label: l.tabBlueprint,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.chat_bubble_2),
            label: l.tabAsk,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.heart),
            label: l.tabLove,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.person_crop_circle),
            label: l.tabMe,
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) => switch (index) {
            0 => const TodayScreen(),
            1 => const BlueprintScreen(),
            2 => const AskScreen(),
            3 => const LoveScreen(),
            _ => const MeScreen(),
          },
        );
      },
    );
  }
}

class TodayScreen extends ConsumerStatefulWidget {
  const TodayScreen({super.key});

  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen> {
  final reflection = TextEditingController();
  bool hasReflection = false;

  @override
  void dispose() {
    reflection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final state = ref.watch(appControllerProvider);
    final today = state.today;
    Future<void> saveReflection() async {
      final todayData = today;
      if (todayData == null) return;
      final saved = await ref
          .read(appControllerProvider.notifier)
          .saveReflection(
            'daily_insight',
            todayData['id']?.toString(),
            todayData['reflectionQuestion']?.toString() ?? '',
            reflection.text,
          );
      if (!saved) return;
      reflection.clear();
      setState(() => hasReflection = false);
      if (context.mounted) {
        showNotice(context, l.journalSavedTitle, l.journalSavedBody);
      }
    }

    return AppPage(
      title: l.tabToday,
      trailing: AppIconButton(
        icon: CupertinoIcons.arrow_clockwise,
        label: l.refresh,
        onPressed: state.loading
            ? null
            : () => ref.read(appControllerProvider.notifier).loadMainData(),
      ),
      bottomActionBar: today == null
          ? null
          : AppBottomActionBar(
              child: AppButton(
                text: l.saveReflection,
                icon: CupertinoIcons.bookmark,
                loading: state.savingReflection,
                onPressed: hasReflection ? saveReflection : null,
              ),
            ),
      child: ListView(
        children: [
          if (today == null)
            AppErrorState(
              title: l.createBlueprintFirstTitle,
              message: state.error == null
                  ? l.createBlueprintFirstBody
                  : _errorCopy(context, state.error!),
              actionText: l.refresh,
              onAction: () =>
                  ref.read(appControllerProvider.notifier).loadMainData(),
            )
          else ...[
            AppPageHeader(
              eyebrow: DateFormat.EEEE(
                Localizations.localeOf(context).toLanguageTag(),
              ).format(DateTime.now()),
              title: _copy(context, today['greeting']) ?? l.tabToday,
              subtitle: _uiText(
                context,
                en: 'A focused reading for what deserves your attention now.',
                zh: '为此刻最值得关注的事，保留一个清晰入口。',
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final themeMetric = AppMetricCard(
                  label: l.weeklyTheme,
                  value: _copy(context, today['weeklyTheme']) ?? '',
                  icon: CupertinoIcons.calendar,
                  tone: AppTone.primary,
                );
                final actionMetric = AppMetricCard(
                  label: _uiText(context, en: 'Today action', zh: '今日行动'),
                  value: _copy(context, today['action']) ?? '',
                  icon: CupertinoIcons.checkmark_circle,
                  tone: AppTone.secondary,
                );
                if (constraints.maxWidth < 360) {
                  return Column(
                    children: [
                      themeMetric,
                      const SizedBox(height: AppSpacing.sm),
                      actionMetric,
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(child: themeMetric),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: actionMetric),
                  ],
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            AppInsightCard(
              label: l.todayFocus,
              title: _copy(context, _asMap(today['focus'])['title']) ?? '',
              body: _copy(context, _asMap(today['focus'])['body']) ?? '',
              actionText: l.askAboutThis,
              tone: AppTone.primary,
              onAction: () {
                final focus = _asMap(today['focus']);
                final prompt = '${focus['title'] ?? ''}\n${focus['body'] ?? ''}'
                    .trim();
                ref
                    .read(appControllerProvider.notifier)
                    .askFromToday(
                      prompt,
                      localeCode: Localizations.localeOf(context).languageCode,
                    );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            AppSectionHeader(
              text: _uiText(context, en: 'Signals', zh: '今日信号'),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 360) {
                  return Column(
                    children: [
                      _TodayMiniCard(
                        label: l.challenge,
                        data: _asMap(today['challenge']),
                        tone: AppTone.secondary,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _TodayMiniCard(
                        label: l.opportunity,
                        data: _asMap(today['opportunity']),
                        tone: AppTone.secondary,
                      ),
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _TodayMiniCard(
                        label: l.challenge,
                        data: _asMap(today['challenge']),
                        tone: AppTone.secondary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _TodayMiniCard(
                        label: l.opportunity,
                        data: _asMap(today['opportunity']),
                        tone: AppTone.secondary,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            AppInput(
              label: _copy(context, today['reflectionQuestion']) ?? '',
              controller: reflection,
              placeholder: l.reflectionPlaceholder,
              maxLines: 3,
              onChanged: (value) =>
                  setState(() => hasReflection = value.trim().isNotEmpty),
            ),
            const SizedBox(height: AppSpacing.md),
            AppInsightCard(
              label: l.weeklyTheme,
              title: _copy(context, today['weeklyTheme']) ?? '',
              body: _copy(context, today['action']) ?? '',
              tone: AppTone.warning,
            ),
          ],
          const SizedBox(height: _tabBottomInset),
        ],
      ),
    );
  }
}

class BlueprintScreen extends ConsumerWidget {
  const BlueprintScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final state = ref.watch(appControllerProvider);
    final preview = _asMap(state.blueprint?['preview']);
    final full = _asMap(state.blueprint?['fullReport']);
    final source = full.isNotEmpty ? full : preview;
    final cards = _asList(source['cards']);
    final dayMaster = state.birthProfile?['chartSummary'] is Map
        ? _asMap(state.birthProfile?['chartSummary'])['dayMaster']?.toString()
        : null;
    return AppPage(
      title: l.tabBlueprint,
      child: ListView(
        children: [
          AppPageHeader(
            eyebrow: full.isNotEmpty
                ? _uiText(context, en: 'Full blueprint', zh: '完整蓝图')
                : _uiText(context, en: 'Preview blueprint', zh: '蓝图预览'),
            title:
                _copy(context, source['coreArchetype']) ??
                l.previewDefaultTitle,
            subtitle:
                _copy(context, source['summary']) ??
                _copy(context, source['headline']) ??
                l.previewDefaultSubtitle,
            trailing: dayMaster == null
                ? null
                : AppStatusTag(text: dayMaster, tone: AppTone.primary),
          ),
          AppInsightCard(
            label: l.coreArchetype,
            title:
                _copy(context, source['coreArchetype']) ??
                l.previewDefaultTitle,
            body:
                _copy(context, source['headline']) ??
                l.createBlueprintFirstTitle,
            actionText: l.askAboutThis,
            tone: AppTone.primary,
            onAction: () {
              final prompt =
                  '${source['coreArchetype'] ?? ''}. ${source['headline'] ?? ''}'
                      .trim();
              ref
                  .read(appControllerProvider.notifier)
                  .askFromToday(
                    prompt,
                    localeCode: Localizations.localeOf(context).languageCode,
                  );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          if (cards.isEmpty)
            AppEmptyState(
              title: l.createBlueprintFirstTitle,
              message: state.error == null
                  ? l.createBlueprintFirstBody
                  : _errorCopy(context, state.error!),
              icon: CupertinoIcons.square_grid_2x2,
              action: AppButton(
                text: l.refresh,
                icon: CupertinoIcons.arrow_clockwise,
                onPressed: () =>
                    ref.read(appControllerProvider.notifier).loadMainData(),
              ),
            )
          else
            AppSectionHeader(
              text: _uiText(context, en: 'Reading sections', zh: '解读章节'),
            ),
          if (cards.isNotEmpty)
            for (final card in cards) ...[
              AppInsightCard(
                label: _copy(context, card['label']),
                title: _copy(context, card['title']) ?? '',
                body: _lockedBody(
                  context,
                  _copy(context, card['body']) ?? '',
                  card['locked'] == true,
                ),
                locked: card['locked'] == true,
                tone: _toneForLabel(card['label']?.toString()),
                actionText: card['locked'] == true
                    ? l.unlockBlueprint
                    : l.saveToJournal,
                actionLoading: state.savingReflection,
                onAction: () async {
                  if (card['locked'] == true) {
                    showPaywall(context, ref);
                  } else {
                    final saved = await ref
                        .read(appControllerProvider.notifier)
                        .saveReflection(
                          'blueprint_card',
                          state.blueprint?['reportId']?.toString(),
                          card['reflectionQuestion']?.toString() ?? '',
                          card['body']?.toString() ?? '',
                        );
                    if (saved && context.mounted) {
                      showNotice(
                        context,
                        l.journalSavedTitle,
                        l.journalSavedBody,
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          if (full.isEmpty)
            AppButton(
              text: l.unlockBlueprint,
              icon: CupertinoIcons.lock_open,
              onPressed: () => showPaywall(context, ref),
            ),
          const SizedBox(height: _tabBottomInset),
        ],
      ),
    );
  }
}

class AskScreen extends ConsumerStatefulWidget {
  const AskScreen({super.key});

  @override
  ConsumerState<AskScreen> createState() => _AskScreenState();
}

class _AskScreenState extends ConsumerState<AskScreen> {
  final input = TextEditingController();
  bool hasInput = false;

  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final state = ref.watch(appControllerProvider);
    final prompts = [
      l.promptStuck,
      l.promptCareer,
      l.promptRelationship,
      l.promptMonth,
    ];
    return AppPage(
      title: l.tabAsk,
      bottomActionBar: AppBottomActionBar(
        child: AppComposer(
          controller: input,
          placeholder: l.askPlaceholder,
          canSend: hasInput,
          sending: state.askingGuide,
          onChanged: (value) =>
              setState(() => hasInput = value.trim().isNotEmpty),
          onSend: () {
            final text = input.text;
            input.clear();
            setState(() => hasInput = false);
            ref
                .read(appControllerProvider.notifier)
                .askGuide(
                  text,
                  localeCode: Localizations.localeOf(context).languageCode,
                );
          },
        ),
      ),
      child: ListView(
        children: [
          AppPageHeader(
            eyebrow: _uiText(context, en: 'AI Guide', zh: 'AI 引导'),
            title: l.tabAsk,
            subtitle: l.askIntro,
          ),
          const SizedBox(height: AppSpacing.md),
          AppSection(
            title: _uiText(context, en: 'Useful starts', zh: '推荐问题'),
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final prompt in prompts)
                  AppTag(
                    text: prompt,
                    selected: false,
                    onTap: state.askingGuide
                        ? null
                        : () => ref
                              .read(appControllerProvider.notifier)
                              .askGuide(
                                prompt,
                                localeCode: Localizations.localeOf(
                                  context,
                                ).languageCode,
                              ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (state.messages.isEmpty && !state.askingGuide)
            AppEmptyState(
              title: _uiText(
                context,
                en: 'Ask from your chart',
                zh: '从你的命盘开始提问',
              ),
              message: _uiText(
                context,
                en: 'Choose a prompt or ask what feels unresolved. Answers stay reflective and practical.',
                zh: '选择一个问题，或直接说出让你卡住的事。回答会保持反思性和可执行。',
              ),
              icon: CupertinoIcons.chat_bubble_2,
            ),
          for (final message in state.messages) ...[
            if (message['role'] == 'user')
              AppMessageBubble(text: message['content']?.toString() ?? '')
            else
              _AiAnswerCard(
                answer: _asMap(message['answer']),
                messageId: message['messageId']?.toString(),
              ),
            const SizedBox(height: AppSpacing.sm),
          ],
          if (state.askingGuide) ...[
            const SizedBox(height: AppSpacing.md),
            AppLoading(
              text: _uiText(
                context,
                en: 'Thinking through your pattern...',
                zh: '正在梳理你的模式...',
              ),
            ),
          ],
          if (state.error != null) ...[
            const SizedBox(height: AppSpacing.md),
            AppInsightCard(
              label: l.notice,
              title: l.guideUnavailable,
              body: _errorCopy(context, state.error!),
              actionText: l.unlockUnlimited,
              tone: AppTone.warning,
              onAction: () => showPaywall(context, ref),
            ),
          ],
          const SizedBox(height: _tabBottomInset),
        ],
      ),
    );
  }
}

class LoveScreen extends ConsumerWidget {
  const LoveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final state = ref.watch(appControllerProvider);
    final relationships = state.relationships;
    final premium = _asMap(state.entitlement)['premiumActive'] == true;
    return AppPage(
      title: l.tabLove,
      trailing: AppIconButton(
        icon: CupertinoIcons.add,
        label: l.addSomeone,
        onPressed: () => showAddRelationship(context, ref),
      ),
      child: ListView(
        children: [
          AppPageHeader(
            eyebrow: _uiText(context, en: 'Relationship map', zh: '关系地图'),
            title: l.tabLove,
            subtitle: _uiText(
              context,
              en: 'Compare communication patterns without turning them into verdicts.',
              zh: '比较沟通模式，但不把关系变成定论。',
            ),
            trailing: AppStatusTag(
              text: relationships.length.toString(),
              tone: relationships.isEmpty ? AppTone.neutral : AppTone.secondary,
            ),
          ),
          if (relationships.isEmpty)
            AppEmptyState(
              title: l.loveEmptyTitle,
              message: l.loveEmptyBody,
              icon: CupertinoIcons.heart,
              action: AppButton(
                text: l.addSomeone,
                icon: CupertinoIcons.add,
                onPressed: () => showAddRelationship(context, ref),
              ),
            )
          else
            for (final relationship in relationships) ...[
              RelationshipCard(relationship: relationship, premium: premium),
              const SizedBox(height: AppSpacing.md),
            ],
          const SizedBox(height: _tabBottomInset),
        ],
      ),
    );
  }
}

class RelationshipCard extends ConsumerWidget {
  const RelationshipCard({
    super.key,
    required this.relationship,
    required this.premium,
  });

  final JsonMap relationship;
  final bool premium;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final preview = _asMap(relationship['preview']);
    final fullReport = _asMap(relationship['fullReport']).isNotEmpty
        ? _asMap(relationship['fullReport'])
        : _asMap(_asMap(relationship['report'])['fullReport']);
    final unlocked =
        relationship['unlocked'] == true || fullReport.isNotEmpty || premium;
    final relationshipId = relationship['id']?.toString();
    final loadingReport =
        relationshipId != null &&
        ref.watch(appControllerProvider).activeRelationshipReportId ==
            relationshipId;
    return AppInsightCard(
      label: _relationshipTypeLabel(
        relationship['relationshipType']?.toString(),
      ),
      title:
          relationship['targetName']?.toString() ?? l.relationshipFallbackTitle,
      body:
          _copy(context, preview['communicationSnapshot']) ??
          l.relationshipPreviewFallback,
      tone: AppTone.secondary,
      actionText: unlocked
          ? l.viewRelationshipReport
          : l.unlockRelationshipReport,
      actionLoading: loadingReport,
      onAction: () async {
        if (!premium && !unlocked) {
          showPaywall(context, ref);
          return;
        }
        var report = _asMap(relationship['report']);
        if (fullReport.isEmpty) {
          final id = relationshipId;
          if (id != null) {
            report =
                await ref
                    .read(appControllerProvider.notifier)
                    .generateRelationshipReport(id, full: true) ??
                report;
          }
        }
        if (context.mounted) {
          showRelationshipReport(
            context,
            relationship,
            report.isEmpty ? relationship : report,
          );
        }
      },
    );
  }
}

class MeScreen extends ConsumerWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final state = ref.watch(appControllerProvider);
    final premium = _asMap(state.entitlement)['premiumActive'] == true;
    return AppPage(
      title: l.tabMe,
      child: ListView(
        children: [
          const SizedBox(height: AppSpacing.sm),
          AppSectionHeader(text: l.account),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                AppListTile(
                  title: l.profile,
                  subtitle: state.me?['displayName']?.toString() ?? l.you,
                  leading: const AppAvatar(
                    icon: CupertinoIcons.person_crop_circle,
                    tone: AppTone.primary,
                    size: 34,
                  ),
                ),
                AppListTile(
                  title: l.birthDetails,
                  subtitle:
                      state.birthProfile?['birthPlaceText']?.toString() ??
                      l.createBlueprintFirstTitle,
                  leading: const AppAvatar(
                    icon: CupertinoIcons.calendar,
                    tone: AppTone.secondary,
                    size: 34,
                  ),
                  showDivider: false,
                ),
              ],
            ),
          ),
          AppSectionHeader(text: l.subscription),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                AppListTile(
                  title: l.currentPlan,
                  subtitle: premium ? l.premiumActive : l.free,
                  leading: AppAvatar(
                    icon: premium
                        ? CupertinoIcons.checkmark_seal_fill
                        : CupertinoIcons.sparkles,
                    tone: premium ? AppTone.success : AppTone.warning,
                    size: 34,
                  ),
                ),
                AppListTile(
                  title: l.restorePurchases,
                  leading: const AppAvatar(
                    icon: CupertinoIcons.arrow_clockwise,
                    tone: AppTone.primary,
                    size: 34,
                  ),
                  trailing: state.activatingPremium
                      ? const CupertinoActivityIndicator()
                      : const Icon(
                          CupertinoIcons.arrow_clockwise,
                          color: AppColors.primary,
                          size: 20,
                        ),
                  onTap: state.activatingPremium
                      ? null
                      : () async {
                          final ok = await ref
                              .read(appControllerProvider.notifier)
                              .activatePremium();
                          if (!context.mounted) return;
                          showNotice(
                            context,
                            ok
                                ? _uiText(
                                    context,
                                    en: 'Premium active',
                                    zh: '高级版已开通',
                                  )
                                : _uiText(
                                    context,
                                    en: 'Restore failed',
                                    zh: '恢复失败',
                                  ),
                            ok
                                ? _uiText(
                                    context,
                                    en: 'Your subscription is ready.',
                                    zh: '你的订阅状态已更新。',
                                  )
                                : _nullableErrorCopy(
                                        context,
                                        ref.read(appControllerProvider).error,
                                      ) ??
                                      _uiText(
                                        context,
                                        en: 'Please try again later.',
                                        zh: '请稍后再试。',
                                      ),
                          );
                        },
                ),
                AppListTile(
                  title: l.manageSubscription,
                  subtitle: l.managedInAppStore,
                  leading: const AppAvatar(
                    icon: CupertinoIcons.creditcard,
                    tone: AppTone.neutral,
                    size: 34,
                  ),
                  showDivider: false,
                ),
              ],
            ),
          ),
          AppSectionHeader(text: l.saved),
          AppCard(
            padding: EdgeInsets.zero,
            child: AppListTile(
              title: l.savedJournal,
              leading: const AppAvatar(
                icon: CupertinoIcons.bookmark,
                tone: AppTone.secondary,
                size: 34,
              ),
              trailing: Text(
                state.journal.length.toString(),
                style: AppTextStyles.subhead.copyWith(
                  color: AppColors.inkMuted,
                ),
              ),
              showChevron: true,
              showDivider: false,
              onTap: () => Navigator.of(context).push(
                CupertinoPageRoute<void>(
                  builder: (_) => const SavedJournalScreen(),
                ),
              ),
            ),
          ),
          AppSectionHeader(text: l.dataPrivacy),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                AppListTile(
                  title: l.exportData,
                  leading: const AppAvatar(
                    icon: CupertinoIcons.square_arrow_up,
                    tone: AppTone.primary,
                    size: 34,
                  ),
                  trailing: state.exportingData
                      ? const CupertinoActivityIndicator()
                      : null,
                  showChevron: true,
                  onTap: state.exportingData
                      ? null
                      : () async {
                          try {
                            final data = await ref
                                .read(appControllerProvider.notifier)
                                .exportData();
                            if (context.mounted) {
                              showLegal(
                                context,
                                l.exportTitle,
                                data.toString(),
                              );
                            }
                          } catch (_) {
                            if (context.mounted) {
                              showNotice(
                                context,
                                _uiText(
                                  context,
                                  en: 'Export failed',
                                  zh: '导出失败',
                                ),
                                _nullableErrorCopy(
                                      context,
                                      ref.read(appControllerProvider).error,
                                    ) ??
                                    _uiText(
                                      context,
                                      en: 'Please try again later.',
                                      zh: '请稍后再试。',
                                    ),
                              );
                            }
                          }
                        },
                ),
                AppListTile(
                  title: l.deleteAccount,
                  leading: const AppAvatar(
                    icon: CupertinoIcons.delete,
                    tone: AppTone.destructive,
                    size: 34,
                  ),
                  trailing: state.deletingAccount
                      ? const CupertinoActivityIndicator()
                      : const Icon(
                          CupertinoIcons.delete,
                          color: AppColors.destructive,
                          size: 20,
                        ),
                  destructive: true,
                  showDivider: false,
                  onTap: state.deletingAccount
                      ? null
                      : () => confirmDeleteAccount(context, ref),
                ),
              ],
            ),
          ),
          AppSectionHeader(text: l.language),
          AppCard(
            padding: EdgeInsets.zero,
            child: AppListTile(
              title: l.language,
              subtitle: _languageSubtitle(context, state.localeCode),
              leading: const AppAvatar(
                icon: CupertinoIcons.globe,
                tone: AppTone.secondary,
                size: 34,
              ),
              showChevron: true,
              showDivider: false,
              onTap: () => showLanguageSheet(context, ref),
            ),
          ),
          AppSectionHeader(text: l.legal),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                AppListTile(
                  title: l.privacyPolicy,
                  leading: const AppAvatar(
                    icon: CupertinoIcons.lock_shield,
                    tone: AppTone.neutral,
                    size: 34,
                  ),
                  showChevron: true,
                  onTap: () =>
                      showLegal(context, l.privacyPolicy, l.privacyBody),
                ),
                AppListTile(
                  title: l.termsOfUse,
                  leading: const AppAvatar(
                    icon: CupertinoIcons.doc_text,
                    tone: AppTone.neutral,
                    size: 34,
                  ),
                  showChevron: true,
                  onTap: () => showLegal(context, l.termsOfUse, l.termsBody),
                ),
                AppListTile(
                  title: l.disclaimer,
                  leading: const AppAvatar(
                    icon: CupertinoIcons.exclamationmark_circle,
                    tone: AppTone.warning,
                    size: 34,
                  ),
                  showChevron: true,
                  showDivider: false,
                  onTap: () =>
                      showLegal(context, l.disclaimer, l.disclaimerBody),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              l.versionLabel,
              textAlign: TextAlign.center,
              style: AppTextStyles.footnote.copyWith(color: AppColors.inkFaint),
            ),
          ),
          const SizedBox(height: _tabBottomInset),
        ],
      ),
    );
  }
}

class SavedJournalScreen extends ConsumerWidget {
  const SavedJournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final entries = ref.watch(appControllerProvider).journal;
    return AppPage(
      title: l.savedJournal,
      child: ListView(
        children: [
          const SizedBox(height: AppSpacing.lg),
          if (entries.isEmpty)
            AppEmptyState(
              title: l.noJournalTitle,
              message: l.noJournalBody,
              icon: CupertinoIcons.bookmark,
            )
          else
            for (final entry in entries) ...[
              AppInsightCard(
                label: _journalLabel(context, entry),
                title: entry['prompt']?.toString().isNotEmpty == true
                    ? _copy(context, entry['prompt']) ??
                          entry['prompt'].toString()
                    : l.savedJournal,
                body: entry['content']?.toString() ?? '',
                tone: AppTone.secondary,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class StepScaffold extends StatelessWidget {
  const StepScaffold({
    super.key,
    required this.step,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final OnboardingStep step;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppPage(
      child: ListView(
        children: [
          const SizedBox(height: AppSpacing.md),
          AppProgressBar(value: _progressForStep(step)),
          AppPageHeader(
            eyebrow: _uiText(
              context,
              en: 'Step ${(_progressForStep(step) * 6).ceil().clamp(1, 6)} of 6',
              zh: '第 ${(_progressForStep(step) * 6).ceil().clamp(1, 6)} / 6 步',
            ),
            title: title,
            subtitle: subtitle,
          ),
          child,
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _AiAnswerCard extends ConsumerWidget {
  const _AiAnswerCard({required this.answer, this.messageId});

  final JsonMap answer;
  final String? messageId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final sections = _asList(answer['sections']);
    return AppCard(
      tone: AppTone.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppAvatar(
                icon: CupertinoIcons.sparkles,
                tone: AppTone.primary,
                size: 34,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppStatusTag(text: l.guideLabel, tone: AppTone.primary),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      _copy(context, answer['headline']) ?? '',
                      style: AppTextStyles.title3,
                    ),
                    if ((answer['summary']?.toString() ?? '').isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        _copy(context, answer['summary']) ?? '',
                        style: AppTextStyles.callout.copyWith(
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          for (final section in sections) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              _copy(context, section['title']) ?? section['title'].toString(),
              style: AppTextStyles.headline,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              _copy(context, section['body']) ?? section['body'].toString(),
              style: AppTextStyles.callout.copyWith(color: AppColors.inkMuted),
            ),
          ],
          if ((answer['practicalStep']?.toString() ?? '')
              .trim()
              .isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.secondarySoft,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Text(
                l.tryThis(
                  _copy(context, answer['practicalStep']) ??
                      answer['practicalStep'].toString(),
                ),
                style: AppTextStyles.subhead.copyWith(
                  color: AppColors.secondary,
                ),
              ),
            ),
          ],
          if ((answer['reflectionQuestion']?.toString() ?? '')
              .trim()
              .isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              _copy(context, answer['reflectionQuestion']) ?? '',
              style: AppTextStyles.bodyEmphasized,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          AppButton(
            text: l.save,
            variant: AppButtonVariant.secondary,
            loading: ref.watch(appControllerProvider).savingReflection,
            icon: CupertinoIcons.bookmark,
            onPressed: () async {
              final saved = await ref
                  .read(appControllerProvider.notifier)
                  .saveReflection(
                    'ai_message',
                    messageId,
                    answer['reflectionQuestion']?.toString() ?? '',
                    answer['summary']?.toString() ?? '',
                  );
              if (saved && context.mounted) {
                showNotice(context, l.journalSavedTitle, l.journalSavedBody);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _TodayMiniCard extends StatelessWidget {
  const _TodayMiniCard({
    required this.label,
    required this.data,
    required this.tone,
  });

  final String label;
  final JsonMap data;
  final AppTone tone;

  @override
  Widget build(BuildContext context) {
    return AppInsightCard(
      label: label,
      title: _copy(context, data['title']) ?? '',
      body: _copy(context, data['body']) ?? '',
      tone: tone,
      compact: true,
    );
  }
}

class _GoalOption {
  const _GoalOption(this.value, this.label, this.icon);

  final String value;
  final String label;
  final IconData icon;
}

void showPaywall(BuildContext context, WidgetRef ref) {
  final l = context.l10n;
  showCupertinoModalPopup<void>(
    context: context,
    builder: (sheetContext) {
      bool submitting = false;
      String? actionError;
      Future<void> activate(StateSetter setSheetState) async {
        setSheetState(() {
          submitting = true;
          actionError = null;
        });
        final ok = await ref
            .read(appControllerProvider.notifier)
            .activatePremium();
        if (!sheetContext.mounted) return;
        if (ok) {
          Navigator.of(sheetContext).pop();
          if (context.mounted) {
            showNotice(
              context,
              _uiText(context, en: 'Premium active', zh: '高级版已开通'),
              _uiText(
                context,
                en: 'Your full blueprint is now available.',
                zh: '完整蓝图已解锁。',
              ),
            );
          }
          return;
        }
        setSheetState(() {
          submitting = false;
          actionError =
              _nullableErrorCopy(
                context,
                ref.read(appControllerProvider).error,
              ) ??
              _uiText(
                context,
                en: 'Could not activate Premium.',
                zh: '暂时无法开通高级版。',
              );
        });
      }

      return StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          return CupertinoActionSheet(
            title: Text(l.paywallTitle),
            message: Column(
              children: [
                Text(l.paywallBody),
                if (actionError != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    actionError!,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.footnote.copyWith(
                      color: AppColors.destructive,
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  if (submitting) return;
                  activate(setSheetState);
                },
                child: submitting
                    ? const CupertinoActivityIndicator()
                    : Text(l.startAnnual),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  if (submitting) return;
                  activate(setSheetState);
                },
                child: Text(l.restorePurchases),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                if (submitting) return;
                Navigator.of(sheetContext).pop();
              },
              child: Text(l.notNow),
            ),
          );
        },
      );
    },
  );
}

void showAddRelationship(BuildContext context, WidgetRef ref) {
  final l = context.l10n;
  final name = TextEditingController();
  final date = TextEditingController();
  showCupertinoModalPopup<void>(
    context: context,
    builder: (sheetContext) {
      String? formError;
      bool submitting = false;
      return StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          return CupertinoActionSheet(
            title: Text(l.addSomeone),
            message: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: Column(
                children: [
                  AppInput(controller: name, placeholder: l.namePlaceholder),
                  const SizedBox(height: AppSpacing.sm),
                  AppInput(controller: date, placeholder: l.datePlaceholder),
                  if (formError != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      formError!,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.footnote.copyWith(
                        color: AppColors.destructive,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () async {
                  if (submitting) return;
                  final trimmedName = name.text.trim();
                  final trimmedDate = date.text.trim();
                  if (trimmedName.isEmpty || trimmedDate.isEmpty) {
                    setSheetState(() {
                      formError = _uiText(
                        context,
                        en: 'Name and birth date are required.',
                        zh: '请填写姓名和出生日期。',
                      );
                    });
                    return;
                  }
                  setSheetState(() {
                    submitting = true;
                    formError = null;
                  });
                  final ok = await ref
                      .read(appControllerProvider.notifier)
                      .addRelationship(
                        name: trimmedName,
                        type: 'romantic_partner',
                        birthDate: trimmedDate,
                        precision: 'unknown',
                        place: 'New York, NY, US',
                        timezone: 'America/New_York',
                      );
                  if (!sheetContext.mounted) return;
                  if (ok) {
                    Navigator.of(sheetContext).pop();
                    if (context.mounted) {
                      showNotice(
                        context,
                        _uiText(context, en: 'Relationship added', zh: '关系已添加'),
                        _uiText(
                          context,
                          en: 'A preview is ready in Love.',
                          zh: '关系预览已生成。',
                        ),
                      );
                    }
                    return;
                  }
                  setSheetState(() {
                    submitting = false;
                    formError =
                        _nullableErrorCopy(
                          context,
                          ref.read(appControllerProvider).error,
                        ) ??
                        _uiText(
                          context,
                          en: 'Could not add this relationship.',
                          zh: '暂时无法添加这段关系。',
                        );
                  });
                },
                child: submitting
                    ? const CupertinoActivityIndicator()
                    : Text(l.generatePreview),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                if (submitting) return;
                Navigator.of(sheetContext).pop();
              },
              child: Text(l.cancel),
            ),
          );
        },
      );
    },
  );
}

void showLanguageSheet(BuildContext context, WidgetRef ref) {
  final l = context.l10n;
  showCupertinoModalPopup<void>(
    context: context,
    builder: (context) => CupertinoActionSheet(
      title: Text(l.appLanguageTitle),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
            ref.read(appControllerProvider.notifier).setLocaleCode(null);
          },
          child: Text(l.systemLanguage),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
            ref.read(appControllerProvider.notifier).setLocaleCode('en');
          },
          child: Text(l.english),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
            ref.read(appControllerProvider.notifier).setLocaleCode('zh');
          },
          child: Text(l.chineseSimplified),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(l.cancel),
      ),
    ),
  );
}

void showRelationshipReport(
  BuildContext context,
  JsonMap relationship,
  JsonMap report,
) {
  final l = context.l10n;
  final preview = _asMap(report['preview']).isNotEmpty
      ? _asMap(report['preview'])
      : _asMap(relationship['preview']);
  final full = _asMap(report['fullReport']).isNotEmpty
      ? _asMap(report['fullReport'])
      : _asMap(relationship['fullReport']);
  final body = [
    _copy(context, preview['patternName']),
    if (preview['chemistryScore'] != null)
      Localizations.localeOf(context).languageCode == 'zh'
          ? '吸引力 ${preview['chemistryScore']}'
          : 'Chemistry ${preview['chemistryScore']}',
    _copy(context, full['overview']),
    _copy(context, full['emotionalChemistry']),
    _copy(context, full['communicationStyle']),
    _copy(context, full['conflictPattern']),
    _copy(context, full['trustAndSecurity']),
    _copy(context, full['practicalAdvice']),
  ].whereType<String>().where((line) => line.trim().isNotEmpty).join('\n\n');
  showLegal(
    context,
    l.relationshipReportTitle,
    body.isEmpty ? l.relationshipReportUnlocked : body,
  );
}

void showLegal(BuildContext context, String title, String body) {
  final l = context.l10n;
  showCupertinoDialog<void>(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.done),
        ),
      ],
    ),
  );
}

void showNotice(BuildContext context, String title, String body) {
  final l = context.l10n;
  showCupertinoDialog<void>(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.done),
        ),
      ],
    ),
  );
}

void confirmDeleteAccount(BuildContext context, WidgetRef ref) {
  final l = context.l10n;
  showCupertinoDialog<void>(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(l.deleteTitle),
      content: Text(l.deleteBody),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.cancel),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () async {
            Navigator.of(context).pop();
            final deleted = await ref
                .read(appControllerProvider.notifier)
                .deleteAccount();
            if (!deleted && context.mounted) {
              showNotice(
                context,
                _uiText(context, en: 'Delete failed', zh: '删除失败'),
                _nullableErrorCopy(
                      context,
                      ref.read(appControllerProvider).error,
                    ) ??
                    _uiText(
                      context,
                      en: 'Please try again later.',
                      zh: '请稍后再试。',
                    ),
              );
            }
          },
          child: Text(l.deleteAccount),
        ),
      ],
    ),
  );
}

String? _copy(BuildContext context, Object? value) {
  final text = value?.toString();
  if (text == null || text.isEmpty) return text;
  if (Localizations.localeOf(context).languageCode != 'zh') return text;
  final dynamic = _dynamicZhCopy(text);
  if (dynamic != null) return dynamic;
  return _zhCopy[text] ?? text;
}

String _uiText(BuildContext context, {required String en, required String zh}) {
  return Localizations.localeOf(context).languageCode == 'zh' ? zh : en;
}

String? _nullableErrorCopy(BuildContext context, String? error) {
  if (error == null || error.trim().isEmpty) return null;
  return _errorCopy(context, error);
}

String _errorCopy(BuildContext context, String error) {
  if (Localizations.localeOf(context).languageCode != 'zh') return error;
  return switch (error) {
    'Something didn’t load right. Your data is safe. Please try again.' =>
      '有些内容暂时没有加载成功，你的数据是安全的，请重试。',
    'You’ve used today’s free question. Unlock unlimited guidance.' =>
      '今天的免费提问次数已用完，解锁后可以继续提问。',
    _ => error,
  };
}

String? _dynamicZhCopy(String text) {
  const prefix = 'You seek clarity quickly; ';
  const suffix = ' may need more private processing before responding.';
  if (text.startsWith(prefix) && text.endsWith(suffix)) {
    final name = text.substring(prefix.length, text.length - suffix.length);
    return '你会很快寻求清晰；$name 可能需要更多独处处理的时间，之后再回应。';
  }
  if (text.startsWith('Your ') &&
      text.contains(
        ' pattern suggests that the answer becomes clearer when you turn pressure into one grounded next step.',
      )) {
    return '你的命盘模式提示：当你把压力转化成一个踏实的下一步时，答案会变得更清楚。';
  }
  return null;
}

const Map<String, String> _zhCopy = {
  'Good morning': '早上好',
  'The Grounded Strategist': '稳健的策略者',
  'The Vision Builder': '愿景建造者',
  'The Adaptive Creator': '适应型创造者',
  'The Radiant Catalyst': '明亮的催化者',
  'The Quiet Illuminator': '安静的照亮者',
  'The Steady Mountain': '稳定的山',
  'The Principled Architect': '有原则的架构师',
  'The Refined Editor': '精细的校准者',
  'The Deep Explorer': '深度探索者',
  'The Intuitive Synthesizer': '直觉整合者',
  'Your blueprint points to a person who turns uncertainty into structure and makes life feel more workable.':
      '你的蓝图指向一种能力：把不确定变成结构，让生活变得更可处理。',
  'Core Pattern': '核心模式',
  'Built for steadiness': '为稳定而生',
  'You create steadiness where others feel scattered.': '当别人分散时，你能创造稳定。',
  'You notice the pattern beneath the surface and turn it into direction.':
      '你能看见表象之下的模式，并把它转化成方向。',
  'Hidden Strength': '隐藏优势',
  'Your quiet advantage': '你安静的优势',
  'Turns vague ideas into structure': '把模糊想法变成结构',
  'Reliable when others feel scattered': '当别人分散时依然可靠',
  'Blind Spot': '盲点',
  'Where growth gets heavy': '成长变沉重的地方',
  'May confuse control with safety': '可能把控制误认为安全感',
  'Can carry too much responsibility alone': '可能独自承担过多责任',
  'Relationship': '关系',
  'How connection tends to work': '连接通常如何发生',
  'You need consistency, trust, and clear emotional signals.':
      '你需要稳定、信任，以及清晰的情感信号。',
  'Reflection': '反思',
  'A useful question': '一个有用的问题',
  'Where are you managing something that needs trust?': '哪里需要的是信任，而你却在管理它？',
  'Career': '职业',
  'Natural work style': '自然工作风格',
  'You build value by turning uncertainty into practical systems.':
      '你通过把不确定转化为实用系统来创造价值。',
  'Money': '金钱',
  'Stability and growth': '稳定与成长',
  'Money feels safest when plans are visible and grounded.':
      '当计划可见且踏实时，金钱会让你更有安全感。',
  'Growth': '成长',
  'Your next practice': '你的下一步练习',
  'This phase asks you to let support in before you feel fully ready.':
      '这个阶段邀请你在还没完全准备好之前，先允许支持进来。',
  'Timeline': '时间线',
  '12-month focus': '未来 12 个月重点',
  'The next year favors clearer boundaries, cleaner commitments, and fewer half-started plans.':
      '接下来一年更适合建立清晰边界、简洁承诺，并减少半途开启的计划。',
  'Emotional Pattern': '情绪模式',
  'What steadies you': '什么能让你稳定下来',
  'You return to yourself when expectations are concrete and care is consistent.':
      '当期待具体、关怀稳定时，你更容易回到自己。',
  'Choose clarity over guessing.': '选择清晰，而不是猜测。',
  'Build the container before the leap.': '先搭好容器，再迈出下一步。',
  'Let one honest signal be enough.': '让一个真实信号就足够。',
  'Finish what is quietly draining you.': '完成那个正在悄悄消耗你的事。',
  'Protect your attention from scattered urgency.': '保护你的注意力，不被分散的紧急感牵走。',
  'Your pattern suggests today is better for one grounded choice than several half-open possibilities.':
      '你的模式提示：今天更适合做一个踏实选择，而不是同时打开几个悬而未决的可能。',
  'Over-carrying the outcome': '过度承担结果',
  'A cleaner next step': '更清晰的下一步',
  'Creates stability under pressure': '在压力下创造稳定',
  'Choose one direct action and complete it before widening the plan.':
      '先选择一个直接行动并完成它，再扩大计划。',
  'Where are you turning uncertainty into a story?': '你在哪里把不确定变成了一个故事？',
  'You may be craving clarity before your foundation feels settled.':
      '你可能在基础真正稳定之前，就已经很渴望清晰。',
  'The pattern': '模式',
  'What to watch': '需要留意',
  'Your useful strength': '你可用的优势',
  'Pick one unfinished commitment and close it before starting a new one.':
      '选择一个未完成的承诺，先把它收尾，再开始新的事。',
  'What would feel lighter if it were finished this week?':
      '如果这周能完成一件事，什么会让你感觉更轻？',
  'Let’s keep this grounded.': '我们把这件事放回现实。',
  'I can help you reflect on patterns and choices without making fixed predictions.':
      '我可以帮助你反思模式和选择，但不会做确定性预测。',
  'A useful frame': '一个有用的框架',
  'Focus on the next choice you can make with clarity.': '专注于下一个你可以清楚做出的选择。',
  'Choose one concrete action you control today.': '今天选择一个你能掌控的具体行动。',
  'What changes when you stop needing a guaranteed answer?':
      '当你不再需要一个保证的答案时，什么会改变？',
  'The Growth Dynamic': '成长型动态',
  'The Magnetic Mirror': '磁性镜像',
  'This dynamic can create deep recognition when both people name what they need directly.':
      '当双方都能直接说出自己的需要时，这段动态会带来很深的看见。',
  'Different recovery speeds after conflict.': '冲突后的恢复速度不同。',
  'The connection may feel strongest when honesty is paired with enough room to process.':
      '当诚实搭配足够的消化空间时，这段连接会最有力量。',
  'Trust grows through consistent repair, not mind-reading.':
      '信任来自持续修复，而不是彼此猜心。',
  'Choose one repair ritual before the next difficult conversation.':
      '在下一次困难对话前，先约定一个修复仪式。',
};

String _lockedBody(BuildContext context, String body, bool locked) {
  if (!locked) return body;
  return [
    body,
    context.l10n.lockedReadingSuffix,
  ].whereType<String>().where((line) => line.trim().isNotEmpty).join('\n\n');
}

String _relationshipTypeLabel(String? value) {
  if (value == null || value.isEmpty) return '';
  return value.replaceAll('_', ' ');
}

String _languageSubtitle(BuildContext context, String? code) {
  final l = context.l10n;
  return switch (code) {
    'en' => l.english,
    'zh' => l.chineseSimplified,
    _ => l.systemLanguage,
  };
}

String _journalLabel(BuildContext context, JsonMap entry) {
  final type =
      entry['source_type']?.toString() ??
      entry['sourceType']?.toString() ??
      context.l10n.savedJournal;
  final created = DateTime.tryParse(
    entry['created_at']?.toString() ?? entry['createdAt']?.toString() ?? '',
  );
  if (created == null) return type.replaceAll('_', ' ');
  final locale = Localizations.localeOf(context).toLanguageTag();
  return '${type.replaceAll('_', ' ')} - ${DateFormat.yMMMd(locale).format(created.toLocal())}';
}

AppTone _toneForLabel(String? label) {
  final value = label?.toLowerCase() ?? '';
  if (value.contains('relationship') || value.contains('love')) {
    return AppTone.secondary;
  }
  if (value.contains('career') || value.contains('pattern')) {
    return AppTone.secondary;
  }
  if (value.contains('strength') || value.contains('opportunity')) {
    return AppTone.primary;
  }
  if (value.contains('blind') || value.contains('challenge')) {
    return AppTone.warning;
  }
  return AppTone.neutral;
}

double _progressForStep(OnboardingStep step) {
  return switch (step) {
    OnboardingStep.disclaimer => 1 / 6,
    OnboardingStep.birthDate => 2 / 6,
    OnboardingStep.birthTime => 3 / 6,
    OnboardingStep.birthPlace => 4 / 6,
    OnboardingStep.traditional => 5 / 6,
    OnboardingStep.goal => 1,
    _ => 0,
  };
}

JsonMap _asMap(Object? value) =>
    value is Map ? Map<String, Object?>.from(value) : <String, Object?>{};

List<JsonMap> _asList(Object? value) => value is List
    ? value.whereType<Map>().map((e) => Map<String, Object?>.from(e)).toList()
    : [];
