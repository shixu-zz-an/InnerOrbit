import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'app_state.dart';
import 'core/config/app_config.dart';
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
const double _bottomInputListInset = AppSpacing.tabBottomInset + 88;

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
      OnboardingStep.profileSetup => const ProfileSetupScreen(),
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
                      .goTo(OnboardingStep.profileSetup)
                : null,
          ),
        ],
      ),
    );
  }
}

class ProfileSetupScreen extends ConsumerWidget {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final draft = ref.watch(appControllerProvider).draft;
    final placeController = TextEditingController(text: draft.birthPlaceText);
    final timezoneController = TextEditingController(text: draft.timezone);
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
      step: OnboardingStep.profileSetup,
      title: _uiText(
        context,
        en: 'Set up your first blueprint',
        zh: '设置你的第一份蓝图',
      ),
      subtitle: _uiText(
        context,
        en: 'A few details let PillarWise calculate the chart and turn it into a practical reading.',
        zh: '用几项必要信息完成命盘计算，并生成可执行的个人解读。',
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSection(
            title: l.birthDateTitle,
            child: AppPickerPanel(
              height: 150,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: draft.birthDate ?? DateTime(1990),
                minimumDate: DateTime(1900),
                maximumDate: DateTime.now(),
                onDateTimeChanged: (value) => ref
                    .read(appControllerProvider.notifier)
                    .updateDraft(draft.copyWith(birthDate: value)),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppSection(
            title: l.birthTimeTitle,
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
                            .updateDraft(
                              draft.copyWith(birthTimePrecision: value),
                            );
                      }
                    },
                  ),
                ),
                if (draft.birthTimePrecision != 'unknown') ...[
                  const SizedBox(height: AppSpacing.md),
                  AppPickerPanel(
                    height: 150,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      initialDateTime:
                          draft.birthTime ?? DateTime(1990, 1, 1, 12),
                      onDateTimeChanged: (value) => ref
                          .read(appControllerProvider.notifier)
                          .updateDraft(draft.copyWith(birthTime: value)),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppSection(
            title: l.birthPlaceTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppInput(
                  controller: placeController,
                  label: l.selectedBirthplace,
                  placeholder: _uiText(
                    context,
                    en: 'City, region, country',
                    zh: '城市、省州、国家',
                  ),
                  onChanged: (value) => ref
                      .read(appControllerProvider.notifier)
                      .updateDraft(draft.copyWith(birthPlaceText: value)),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppInput(
                  controller: timezoneController,
                  label: _uiText(context, en: 'Timezone', zh: '时区'),
                  placeholder: _uiText(
                    context,
                    en: 'America/Los_Angeles',
                    zh: 'Asia/Shanghai',
                  ),
                  onChanged: (value) => ref
                      .read(appControllerProvider.notifier)
                      .updateDraft(
                        draft.copyWith(
                          timezone: value,
                          clearLocationCoordinates: true,
                        ),
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _uiText(
                    context,
                    en: 'Use an IANA timezone such as America/New_York, Europe/London, or Asia/Shanghai.',
                    zh: '请输入 IANA 时区，例如 America/New_York、Europe/London 或 Asia/Shanghai。',
                  ),
                  style: AppTextStyles.footnote.copyWith(
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppSection(
            title: l.traditionalTitle,
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
          const SizedBox(height: AppSpacing.lg),
          AppSection(
            title: l.goalTitle,
            child: Wrap(
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
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            text: l.generateBlueprint,
            icon: CupertinoIcons.sparkles,
            onPressed:
                draft.goals.isEmpty ||
                    draft.birthDate == null ||
                    (draft.birthTimePrecision != 'unknown' &&
                        draft.birthTime == null) ||
                    draft.birthPlaceText.trim().isEmpty ||
                    draft.timezone.trim().isEmpty
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
              initialDateTime: draft.birthDate ?? DateTime(1990),
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
                initialDateTime: draft.birthTime ?? DateTime(1990, 1, 1, 12),
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
    final selected = draft.birthPlaceText.trim().isEmpty
        ? _uiText(context, en: 'Not set yet', zh: '尚未填写')
        : draft.birthPlaceText;
    final placeController = TextEditingController(text: draft.birthPlaceText);
    final timezoneController = TextEditingController(text: draft.timezone);
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
            _uiText(context, en: 'Birth location', zh: '出生地点'),
            style: AppTextStyles.subhead,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppInput(
            controller: placeController,
            placeholder: _uiText(
              context,
              en: 'City, region, country',
              zh: '城市、省州、国家',
            ),
            onChanged: (value) => ref
                .read(appControllerProvider.notifier)
                .updateDraft(draft.copyWith(birthPlaceText: value)),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppInput(
            controller: timezoneController,
            placeholder: _uiText(
              context,
              en: 'IANA timezone, e.g. America/New_York',
              zh: 'IANA 时区，例如 Asia/Shanghai',
            ),
            onChanged: (value) => ref
                .read(appControllerProvider.notifier)
                .updateDraft(
                  draft.copyWith(
                    timezone: value,
                    clearLocationCoordinates: true,
                  ),
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            _uiText(
              context,
              en: 'Timezone is validated by the backend. Coordinates are omitted unless a real location service is connected.',
              zh: '后端会校验时区是否合法。未接入真实地点服务前，不会提交假经纬度。',
            ),
            style: AppTextStyles.footnote.copyWith(color: AppColors.inkMuted),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            text: l.continueButton,
            onPressed:
                draft.birthPlaceText.trim().isEmpty ||
                    draft.timezone.trim().isEmpty
                ? null
                : () => ref
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
      initialIndex: _visibleTabIndex(
        ref.read(appControllerProvider).selectedTab,
      ),
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
        final visibleIndex = _visibleTabIndex(next);
        if (controller.index != visibleIndex) {
          controller.index = visibleIndex;
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
            icon: const Icon(CupertinoIcons.calendar, size: 23),
            label: l.tabToday,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.square_grid_2x2, size: 23),
            label: l.tabBlueprint,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.chat_bubble, size: 23),
            label: l.tabAsk,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.person_crop_circle, size: 23),
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
    final latestJournal = state.journal.isEmpty ? null : state.journal.first;
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

    final focus = _asMap(today?['focus']);
    final challenge = _asMap(today?['challenge']);
    final opportunity = _asMap(today?['opportunity']);
    final focusPrompt = [
      _copy(context, focus['title']),
      _copy(context, focus['body']),
    ].whereType<String>().where((line) => line.trim().isNotEmpty).join('\n');

    return AppPage(
      title: l.tabToday,
      trailing: AppIconButton(
        icon: CupertinoIcons.arrow_clockwise,
        label: l.refresh,
        onPressed: state.loading
            ? null
            : () => ref.read(appControllerProvider.notifier).loadMainData(),
      ),
      bottomActionBar: today == null || !hasReflection
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
            _QuietIntro(
              eyebrow: DateFormat.EEEE(
                Localizations.localeOf(context).toLanguageTag(),
              ).format(DateTime.now()),
              title: _uiText(
                context,
                en: 'One focus, one next step.',
                zh: '一个今日重点，一个可执行下一步。',
              ),
              subtitle: _uiText(
                context,
                en: 'Keep today practical: notice one real signal, then choose the next move you can complete.',
                zh: '今天先看见一个真实信号，再完成一个你能掌控的下一步。',
              ),
            ),
            AppCard(
              tone: AppTone.primary,
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppStatusTag(text: l.todayFocus, tone: AppTone.primary),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    _uiText(
                      context,
                      en: 'Let one honest signal be enough',
                      zh: '让一个真实信号就足够',
                    ),
                    style: AppTextStyles.title2,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _uiText(
                      context,
                      en: 'Finish one grounded choice today before opening every possibility at once.',
                      zh: '今天先完成一个踏实选择，不急着同时打开所有可能。',
                    ),
                    style: AppTextStyles.callout.copyWith(
                      color: AppColors.inkMuted,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    text: _uiText(
                      context,
                      en: 'Break down the next step',
                      zh: '帮我拆解下一步',
                    ),
                    icon: CupertinoIcons.chat_bubble,
                    onPressed: () {
                      ref
                          .read(appControllerProvider.notifier)
                          .askFromToday(
                            focusPrompt.isEmpty
                                ? _uiText(
                                    context,
                                    en: 'Help me break today into one grounded next step.',
                                    zh: '帮我把今天拆成一个踏实的下一步。',
                                  )
                                : focusPrompt,
                            localeCode: Localizations.localeOf(
                              context,
                            ).languageCode,
                          );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.xs,
              ),
              child: Column(
                children: [
                  _StackedInfoRow(
                    label: l.weeklyTheme,
                    title:
                        _copy(context, today['weeklyTheme']) ??
                        _uiText(
                          context,
                          en: 'Preparation is not waiting for perfect',
                          zh: '准备不是等到完美',
                        ),
                    icon: CupertinoIcons.calendar,
                    tone: AppTone.primary,
                  ),
                  _StackedInfoRow(
                    label: _uiText(context, en: 'Today action', zh: '今日行动'),
                    title:
                        _copy(context, today['action']) ??
                        _uiText(
                          context,
                          en: 'Complete one direct action first',
                          zh: '先完成一个直接行动',
                        ),
                    icon: CupertinoIcons.checkmark_circle,
                    tone: AppTone.secondary,
                  ),
                  _StackedInfoRow(
                    label: _uiText(context, en: 'Reminder', zh: '今日提醒'),
                    title: _uiText(
                      context,
                      en: 'Bring attention back from the result to the next step',
                      zh: '把注意力从结果拉回下一步',
                    ),
                    icon: CupertinoIcons.arrow_turn_down_right,
                    tone: AppTone.neutral,
                    showDivider: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppSectionHeader(
              text: _uiText(context, en: 'Today signals', zh: '今日信号'),
            ),
            AppCard(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.xs,
              ),
              child: Column(
                children: [
                  _StackedInfoRow(
                    label: l.challenge,
                    title:
                        _copy(context, challenge['title']) ??
                        _uiText(
                          context,
                          en: 'Over-carrying the outcome',
                          zh: '过度承担结果',
                        ),
                    body: _copy(context, challenge['body']),
                    icon: CupertinoIcons.exclamationmark_circle,
                    tone: AppTone.warning,
                  ),
                  _StackedInfoRow(
                    label: l.opportunity,
                    title:
                        _copy(context, opportunity['title']) ??
                        _uiText(
                          context,
                          en: 'A cleaner next step',
                          zh: '更清晰的下一步',
                        ),
                    body: _copy(context, opportunity['body']),
                    icon: CupertinoIcons.leaf_arrow_circlepath,
                    tone: AppTone.secondary,
                    showDivider: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (latestJournal != null) ...[
              AppSectionHeader(
                text: _uiText(
                  context,
                  en: 'Continue from last time',
                  zh: '继续上次沉淀',
                ),
              ),
              AppCard(
                padding: EdgeInsets.zero,
                child: AppListTile(
                  title:
                      _copy(context, latestJournal['prompt']) ??
                      _uiText(context, en: 'Recent reflection', zh: '最近反思'),
                  subtitle: _journalLabel(context, latestJournal),
                  leading: const AppAvatar(
                    icon: CupertinoIcons.bookmark,
                    tone: AppTone.secondary,
                    size: 32,
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
              const SizedBox(height: AppSpacing.md),
            ],
            AppInput(
              label:
                  _copy(context, today['reflectionQuestion']) ??
                  _uiText(context, en: 'Reflection', zh: '今日反思'),
              controller: reflection,
              placeholder: l.reflectionPlaceholder,
              maxLines: 3,
              onChanged: (value) =>
                  setState(() => hasReflection = value.trim().isNotEmpty),
            ),
            if (!hasReflection) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                _uiText(
                  context,
                  en: 'After one reflection, you can save it to your journal.',
                  zh: '完成一次反思后，可保存到日记。',
                ),
                style: AppTextStyles.footnote.copyWith(
                  color: AppColors.inkMuted,
                ),
              ),
            ],
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
    final archetype =
        _copy(context, source['coreArchetype']) ?? l.previewDefaultTitle;
    final headline =
        _copy(context, source['headline']) ??
        _uiText(
          context,
          en: 'When others feel scattered, you can create steadiness.',
          zh: '当别人分散时，你能创造稳定。',
        );
    final summary =
        _copy(context, source['summary']) ??
        _uiText(
          context,
          en: 'You tend to turn uncertainty into structure, making life feel more workable.',
          zh: '你倾向于把不确定变成结构，让生活更可处理。',
        );
    final blueprintStatus = full.isNotEmpty
        ? _uiText(context, en: 'Full blueprint', zh: '完整蓝图')
        : _uiText(context, en: 'Preview blueprint', zh: '蓝图预览');
    return AppPage(
      title: l.tabBlueprint,
      child: ListView(
        children: [
          _QuietIntro(
            eyebrow: blueprintStatus,
            title: archetype,
            subtitle: summary,
            trailing: dayMaster == null
                ? null
                : AppStatusTag(text: dayMaster, tone: AppTone.primary),
          ),
          AppCard(
            tone: AppTone.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppStatusTag(text: l.coreArchetype, tone: AppTone.primary),
                const SizedBox(height: AppSpacing.md),
                Text(archetype, style: AppTextStyles.title2),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  headline,
                  style: AppTextStyles.callout.copyWith(
                    color: AppColors.inkMuted,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  text: l.askAboutThis,
                  variant: AppButtonVariant.secondary,
                  icon: CupertinoIcons.chat_bubble,
                  onPressed: () {
                    final prompt =
                        '${source['coreArchetype'] ?? ''}. ${source['headline'] ?? ''}'
                            .trim();
                    ref
                        .read(appControllerProvider.notifier)
                        .askFromToday(
                          prompt.isEmpty ? '$archetype. $headline' : prompt,
                          localeCode: Localizations.localeOf(
                            context,
                          ).languageCode,
                        );
                  },
                ),
              ],
            ),
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
              text: _uiText(context, en: 'Blueprint sections', zh: '蓝图章节'),
            ),
          if (cards.isNotEmpty)
            AppCard(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.xs,
              ),
              child: Column(
                children: [
                  for (var index = 0; index < cards.length; index++)
                    _StackedInfoRow(
                      label:
                          _copy(context, cards[index]['label']) ??
                          _uiText(context, en: 'Section', zh: '章节'),
                      title:
                          _copy(context, cards[index]['title']) ??
                          _uiText(context, en: 'Blueprint note', zh: '蓝图线索'),
                      body: _lockedBody(
                        context,
                        _copy(context, cards[index]['body']) ?? '',
                        cards[index]['locked'] == true,
                      ),
                      icon: cards[index]['locked'] == true
                          ? CupertinoIcons.lock_fill
                          : CupertinoIcons.chevron_right,
                      tone: _toneForLabel(cards[index]['label']?.toString()),
                      trailing: cards[index]['locked'] == true
                          ? const Icon(
                              CupertinoIcons.lock_fill,
                              color: AppColors.inkFaint,
                              size: 16,
                            )
                          : null,
                      showDivider: index != cards.length - 1,
                      onTap: () => showBlueprintSectionDetail(
                        context,
                        ref,
                        cards[index],
                        state.blueprint?['reportId']?.toString(),
                      ),
                    ),
                ],
              ),
            ),
          if (full.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: AppButton(
                text: l.unlockBlueprint,
                icon: CupertinoIcons.lock_open,
                variant: AppButtonVariant.ghost,
                onPressed: () => showPaywall(context, ref),
              ),
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
      _uiText(
        context,
        en: 'Why do I keep getting stuck lately?',
        zh: '我最近为什么总是卡住？',
      ),
      _uiText(
        context,
        en: 'Which choice is worth doing first?',
        zh: '哪个选择更值得先做？',
      ),
      _uiText(
        context,
        en: 'What pattern repeats in relationships?',
        zh: '我在关系里重复什么模式？',
      ),
      _uiText(
        context,
        en: 'What should I focus on this month?',
        zh: '这个月该关注什么？',
      ),
    ];
    void ask(String text) {
      final trimmed = text.trim();
      if (trimmed.isEmpty) return;
      ref
          .read(appControllerProvider.notifier)
          .askGuide(
            trimmed,
            localeCode: Localizations.localeOf(context).languageCode,
          );
    }

    return AppPage(
      title: l.tabAsk,
      bottomActionBar: AppBottomInputBar(
        controller: input,
        placeholder: _uiText(
          context,
          en: 'Say what you are working through',
          zh: '说出你正在纠结的事',
        ),
        canSend: hasInput,
        sending: state.askingGuide,
        onChanged: (value) =>
            setState(() => hasInput = value.trim().isNotEmpty),
        onSend: () {
          final text = input.text;
          input.clear();
          setState(() => hasInput = false);
          ask(text);
        },
      ),
      child: ListView(
        children: [
          _QuietIntro(
            eyebrow: _uiText(context, en: 'AI Guide', zh: 'AI 引导'),
            title: _uiText(
              context,
              en: 'Start with one real question',
              zh: '从一个真实问题开始',
            ),
            subtitle: _uiText(
              context,
              en: 'Ask about relationships, work, choices, or repeated patterns. Answers stay reflective and practical.',
              zh: '可以问关系、职业、选择或反复出现的模式。回答会保持反思性和可执行。',
            ),
          ),
          AppSectionHeader(
            text: _uiText(context, en: 'Suggested questions', zh: '推荐问题'),
          ),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final prompt in prompts)
                AppSuggestionChip(
                  text: prompt,
                  icon: CupertinoIcons.chat_bubble,
                  onTap: state.askingGuide ? null : () => ask(prompt),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (state.messages.isEmpty && !state.askingGuide)
            _AskEmptyHint(
              text: _uiText(
                context,
                en: 'Your question can use blueprint clues, but it will not make the decision for you.',
                zh: '你的问题会结合蓝图线索，但不会替你做决定。',
              ),
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
          const SizedBox(height: _bottomInputListInset),
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
    final localBuild = ref.watch(appConfigProvider).flavor == 'local';
    final premium = _asMap(state.entitlement)['premiumActive'] == true;
    final preview = _asMap(state.blueprint?['preview']);
    final full = _asMap(state.blueprint?['fullReport']);
    final source = full.isNotEmpty ? full : preview;
    final displayName = state.me?['displayName']?.toString().trim();
    final name = displayName == null || displayName.isEmpty
        ? l.you
        : displayName;
    final archetype =
        _copy(context, source['coreArchetype']) ?? l.previewDefaultTitle;
    final birthPlace =
        state.birthProfile?['birthPlaceText']?.toString() ??
        l.createBlueprintFirstTitle;
    return AppPage(
      title: l.tabMe,
      child: ListView(
        children: [
          const SizedBox(height: AppSpacing.sm),
          AppProfileHeader(
            name: name,
            blueprint: _uiText(
              context,
              en: 'Current blueprint: $archetype',
              zh: '当前蓝图：$archetype',
            ),
            birthPlaceLabel: l.birthDetails,
            birthPlace: birthPlace,
            actionText: _uiText(
              context,
              en: 'View birth details',
              zh: '查看出生信息',
            ),
            onAction: () => showLegal(context, l.birthDetails, birthPlace),
          ),
          AppSectionHeader(text: l.subscription),
          AppPlanCard(
            planName: premium
                ? l.premiumActive
                : _uiText(context, en: 'Free plan', zh: '免费版'),
            statusText: premium
                ? _uiText(context, en: 'Premium', zh: '高级版')
                : l.free,
            description: premium
                ? _uiText(
                    context,
                    en: 'Your full blueprint and expanded guide access are available on this account.',
                    zh: '此账户已可查看完整蓝图，并使用更多 AI 引导能力。',
                  )
                : _uiText(
                    context,
                    en: 'You can keep using the preview and core reflection flow. Premium adds the full blueprint and more guide questions.',
                    zh: '你可以继续使用蓝图预览和核心反思流程。高级版包含完整蓝图和更多 AI 追问。',
                  ),
            primaryActionText: premium
                ? l.tabBlueprint
                : _uiText(context, en: 'Learn about Premium', zh: '了解高级版'),
            premium: premium,
            onPrimaryAction: premium
                ? () => ref.read(appControllerProvider.notifier).selectTab(1)
                : () => showPaywall(context, ref, source: 'me_plan'),
            secondaryLabel: l.manageSubscription,
            secondaryValue: _uiText(
              context,
              en: 'App Store settings',
              zh: 'App Store 账户设置',
            ),
          ),
          AppSectionHeader(
            text: _uiText(context, en: 'Saved', zh: '保存'),
          ),
          AppCard(
            padding: EdgeInsets.zero,
            child: AppListTile(
              title: l.savedJournal,
              leading: const AppAvatar(
                icon: CupertinoIcons.bookmark,
                tone: AppTone.neutral,
                size: 32,
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
          AppSectionHeader(
            text: _uiText(context, en: 'Explore more', zh: '探索更多'),
          ),
          AppCard(
            padding: EdgeInsets.zero,
            child: AppListTile(
              title: l.tabLove,
              subtitle: _uiText(
                context,
                en: 'Relationship insights as a secondary beta workflow.',
                zh: '关系洞察作为二级 Beta 功能保留。',
              ),
              leading: const AppAvatar(
                icon: CupertinoIcons.heart,
                tone: AppTone.neutral,
                size: 32,
              ),
              trailing: AppStatusTag(
                text: _uiText(context, en: 'Beta', zh: 'Beta'),
                tone: AppTone.warning,
              ),
              showChevron: true,
              showDivider: false,
              onTap: () => Navigator.of(context).push(
                CupertinoPageRoute<void>(builder: (_) => const LoveScreen()),
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
                    tone: AppTone.neutral,
                    size: 32,
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
                    size: 32,
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
                tone: AppTone.neutral,
                size: 32,
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
                    size: 32,
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
                    size: 32,
                  ),
                  showChevron: true,
                  onTap: () => showLegal(context, l.termsOfUse, l.termsBody),
                ),
                AppListTile(
                  title: l.disclaimer,
                  leading: const AppAvatar(
                    icon: CupertinoIcons.exclamationmark_circle,
                    tone: AppTone.neutral,
                    size: 32,
                  ),
                  showChevron: true,
                  showDivider: false,
                  onTap: () =>
                      showLegal(context, l.disclaimer, l.disclaimerBody),
                ),
              ],
            ),
          ),
          if (localBuild) ...[
            AppSectionHeader(
              text: _uiText(context, en: 'Developer', zh: '开发者设置'),
            ),
            AppCard(
              padding: EdgeInsets.zero,
              child: AppListTile(
                title: _uiText(
                  context,
                  en: 'Enable local Premium test',
                  zh: '开启本地高级版测试',
                ),
                subtitle: _uiText(
                  context,
                  en: 'Development only. Production must use Apple In-App Purchase.',
                  zh: '仅限开发测试。正式版必须接入 Apple IAP。',
                ),
                leading: const AppAvatar(
                  icon: CupertinoIcons.hammer,
                  tone: AppTone.neutral,
                  size: 32,
                ),
                trailing: state.activatingPremium
                    ? const CupertinoActivityIndicator()
                    : null,
                showChevron: true,
                showDivider: false,
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
                                  en: 'Local Premium enabled',
                                  zh: '本地高级版已开启',
                                )
                              : _uiText(
                                  context,
                                  en: 'Local unlock failed',
                                  zh: '本地开通失败',
                                ),
                          ok
                              ? _uiText(
                                  context,
                                  en: 'This is a development-only entitlement.',
                                  zh: '这是仅限开发环境的权益。',
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
            ),
          ],
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
              en: 'Step ${_stepNumber(step)} of 3',
              zh: '第 ${_stepNumber(step)} / 3 步',
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
              final reflectionPrompt =
                  answer['reflectionQuestion']?.toString() ?? '';
              final content =
                  [
                        answer['summary']?.toString(),
                        if ((answer['summary']?.toString() ?? '')
                            .trim()
                            .isEmpty)
                          answer['headline']?.toString(),
                        if ((answer['summary']?.toString() ?? '')
                            .trim()
                            .isEmpty)
                          answer['practicalStep']?.toString(),
                      ]
                      .whereType<String>()
                      .where((line) => line.trim().isNotEmpty)
                      .join('\n\n');
              final saved = await ref
                  .read(appControllerProvider.notifier)
                  .saveReflection(
                    'ai_message',
                    messageId,
                    reflectionPrompt,
                    content,
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

class _QuietIntro extends StatelessWidget {
  const _QuietIntro({
    this.eyebrow,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String? eyebrow;
  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (eyebrow != null && eyebrow!.trim().isNotEmpty) ...[
                  Text(
                    eyebrow!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                ],
                Text(title, style: AppTextStyles.title2),
                if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle!,
                    style: AppTextStyles.subhead.copyWith(
                      color: AppColors.inkMuted,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.md),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class _StackedInfoRow extends StatelessWidget {
  const _StackedInfoRow({
    required this.label,
    required this.title,
    this.body,
    this.icon,
    this.tone = AppTone.neutral,
    this.trailing,
    this.onTap,
    this.showDivider = true,
  });

  final String label;
  final String title;
  final String? body;
  final IconData? icon;
  final AppTone tone;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colors = tone.colors;
    final content = Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.lightDivider))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.soft,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Icon(icon, size: 16, color: colors.accent),
            ),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 2,
                  style: AppTextStyles.caption.copyWith(color: colors.accent),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(title, maxLines: 3, style: AppTextStyles.headline),
                if (body != null && body!.trim().isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    body!,
                    maxLines: 4,
                    style: AppTextStyles.footnote.copyWith(
                      color: AppColors.inkMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          trailing ??
              (onTap == null
                  ? const SizedBox.shrink()
                  : const Icon(
                      CupertinoIcons.chevron_right,
                      color: AppColors.inkFaint,
                      size: 16,
                    )),
        ],
      ),
    );
    if (onTap == null) return content;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: const Size(44, 44),
      onPressed: onTap,
      child: content,
    );
  }
}

class _AskEmptyHint extends StatelessWidget {
  const _AskEmptyHint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: const Icon(
              CupertinoIcons.chat_bubble_2,
              color: AppColors.primary,
              size: 21,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyles.subhead.copyWith(color: AppColors.inkMuted),
          ),
        ],
      ),
    );
  }
}

class _GoalOption {
  const _GoalOption(this.value, this.label, this.icon);

  final String value;
  final String label;
  final IconData icon;
}

void showBlueprintSectionDetail(
  BuildContext context,
  WidgetRef ref,
  JsonMap card,
  String? reportId,
) {
  final l = context.l10n;
  final locked = card['locked'] == true;
  final title = _copy(context, card['title']) ?? l.tabBlueprint;
  final label = _copy(context, card['label']);
  final body = _lockedBody(context, _copy(context, card['body']) ?? '', locked);
  showCupertinoModalPopup<void>(
    context: context,
    builder: (sheetContext) {
      var saving = false;
      return StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          Future<void> saveSection() async {
            if (saving) return;
            setSheetState(() => saving = true);
            final saved = await ref
                .read(appControllerProvider.notifier)
                .saveReflection(
                  'blueprint_card',
                  reportId,
                  card['reflectionQuestion']?.toString() ?? '',
                  card['body']?.toString() ?? '',
                );
            if (!sheetContext.mounted) return;
            Navigator.of(sheetContext).pop();
            if (!context.mounted) return;
            showNotice(
              context,
              saved
                  ? l.journalSavedTitle
                  : _uiText(context, en: 'Save failed', zh: '保存失败'),
              saved
                  ? l.journalSavedBody
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
          }

          return CupertinoActionSheet(
            title: Text(title),
            message: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Column(
                children: [
                  if (label != null && label.trim().isNotEmpty) ...[
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.footnote.copyWith(
                        color: AppColors.inkMuted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  Text(body, textAlign: TextAlign.center),
                ],
              ),
            ),
            actions: [
              if (locked)
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    showPaywall(context, ref, source: 'blueprint_section');
                  },
                  child: Text(l.unlockBlueprint),
                )
              else
                CupertinoActionSheetAction(
                  onPressed: saveSection,
                  child: saving
                      ? const CupertinoActivityIndicator()
                      : Text(l.saveToJournal),
                ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.of(sheetContext).pop(),
              child: Text(l.cancel),
            ),
          );
        },
      );
    },
  );
}

void showPaywall(
  BuildContext context,
  WidgetRef ref, {
  String source = 'inline',
}) {
  final l = context.l10n;
  final localBuild = ref.read(appConfigProvider).flavor == 'local';
  ref.read(appControllerProvider.notifier).trackEvent('paywall_viewed', {
    'source': source,
    'local_build': localBuild,
  });
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
                Text(
                  localBuild
                      ? _uiText(
                          context,
                          en: 'Premium includes the full blueprint, more AI follow-up, and deeper relationship reports. This local build can enable it for testing; production must use Apple In-App Purchase.',
                          zh: '高级版包含完整蓝图、更多 AI 追问和更深入的关系报告。当前本地构建可用于测试开通；正式版必须接入 Apple IAP。',
                        )
                      : _uiText(
                          context,
                          en: 'Premium will include the full blueprint, more AI follow-up, and deeper relationship reports. In-App Purchase is not connected yet, so this build will not take payment.',
                          zh: '高级版将包含完整蓝图、更多 AI 追问和更深入的关系报告。当前版本尚未接入 App 内购买，不会收取费用。',
                        ),
                ),
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
              if (localBuild)
                CupertinoActionSheetAction(
                  onPressed: () {
                    if (submitting) return;
                    ref.read(appControllerProvider.notifier).trackEvent(
                      'upgrade_tapped',
                      {'source': source, 'mode': 'local_test'},
                    );
                    activate(setSheetState);
                  },
                  child: submitting
                      ? const CupertinoActivityIndicator()
                      : Text(
                          _uiText(
                            context,
                            en: 'Enable Local Premium Test',
                            zh: '开启本地高级版测试',
                          ),
                        ),
                )
              else
                CupertinoActionSheetAction(
                  onPressed: () {
                    ref.read(appControllerProvider.notifier).trackEvent(
                      'upgrade_tapped',
                      {'source': source, 'mode': 'iap_not_ready'},
                    );
                    Navigator.of(sheetContext).pop();
                  },
                  child: Text(_uiText(context, en: 'Got it', zh: '我知道了')),
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
  final place = TextEditingController();
  final timezone = TextEditingController();
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
                  const SizedBox(height: AppSpacing.sm),
                  AppInput(
                    controller: place,
                    placeholder: _uiText(context, en: 'Birthplace', zh: '出生地点'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppInput(
                    controller: timezone,
                    placeholder: _uiText(
                      context,
                      en: 'Timezone, e.g. Asia/Shanghai',
                      zh: '时区，例如 Asia/Shanghai',
                    ),
                  ),
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
                  final trimmedPlace = place.text.trim();
                  final trimmedTimezone = timezone.text.trim();
                  final parsedDate = _parseIsoDate(trimmedDate);
                  if (trimmedName.isEmpty ||
                      trimmedDate.isEmpty ||
                      trimmedPlace.isEmpty ||
                      trimmedTimezone.isEmpty) {
                    setSheetState(() {
                      formError = _uiText(
                        context,
                        en: 'Name, birth date, birthplace, and timezone are required.',
                        zh: '请填写姓名、出生日期、出生地点和时区。',
                      );
                    });
                    return;
                  }
                  if (parsedDate == null) {
                    setSheetState(() {
                      formError = _uiText(
                        context,
                        en: 'Birth date must be a real date in YYYY-MM-DD format.',
                        zh: '出生日期需填写真实日期，格式为 YYYY-MM-DD。',
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
                        place: trimmedPlace,
                        timezone: trimmedTimezone,
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

DateTime? _parseIsoDate(String value) {
  final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(value);
  if (match == null) return null;
  final year = int.tryParse(match.group(1)!);
  final month = int.tryParse(match.group(2)!);
  final day = int.tryParse(match.group(3)!);
  if (year == null || month == null || day == null) return null;
  final parsed = DateTime.tryParse(value);
  if (parsed == null) return null;
  if (parsed.year != year || parsed.month != month || parsed.day != day) {
    return null;
  }
  return parsed;
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
    OnboardingStep.disclaimer => 2 / 3,
    OnboardingStep.profileSetup => 1,
    OnboardingStep.birthDate => 2 / 6,
    OnboardingStep.birthTime => 3 / 6,
    OnboardingStep.birthPlace => 4 / 6,
    OnboardingStep.traditional => 5 / 6,
    OnboardingStep.goal => 1,
    _ => 0,
  };
}

int _stepNumber(OnboardingStep step) {
  return switch (step) {
    OnboardingStep.disclaimer => 2,
    OnboardingStep.profileSetup => 3,
    _ => 1,
  };
}

int _visibleTabIndex(int index) => index < 0 || index > 3 ? 0 : index;

JsonMap _asMap(Object? value) =>
    value is Map ? Map<String, Object?>.from(value) : <String, Object?>{};

List<JsonMap> _asList(Object? value) => value is List
    ? value.whereType<Map>().map((e) => Map<String, Object?>.from(e)).toList()
    : [];
