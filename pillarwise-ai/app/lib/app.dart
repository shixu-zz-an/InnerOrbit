import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'app_state.dart';
import 'core/design/components/pillar_components.dart';
import 'core/design/pillar_theme.dart';
import 'l10n/app_localizations.dart';

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

const double _tabBottomInset = 96;

class PillarWiseApp extends ConsumerWidget {
  const PillarWiseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appControllerProvider);
    return CupertinoApp(
      title: 'PillarWise AI',
      debugShowCheckedModeBanner: false,
      theme: pillarTheme,
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
    return CupertinoPageScaffold(
      child: PagePad(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CupertinoActivityIndicator(radius: 14),
              const SizedBox(height: S.md),
              Text(
                text,
                textAlign: TextAlign.center,
                style: PillarType.callout.copyWith(color: PillarColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
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
    return CupertinoPageScaffold(
      child: PagePad(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(flex: 2),
            const _BrandMark(),
            const SizedBox(height: S.xxl),
            Text(
              l.welcomeEyebrow,
              style: PillarType.caption.copyWith(color: PillarColors.accent),
            ),
            const SizedBox(height: S.sm),
            Text(l.welcomeTitle, style: PillarType.largeTitle),
            const SizedBox(height: S.md),
            Text(
              l.welcomeSubtitle,
              style: PillarType.callout.copyWith(color: PillarColors.muted),
            ),
            const Spacer(flex: 3),
            PillarButton(
              text: l.welcomePrimary,
              icon: CupertinoIcons.arrow_right,
              onPressed: () => ref
                  .read(appControllerProvider.notifier)
                  .goTo(OnboardingStep.disclaimer),
            ),
            const SizedBox(height: S.sm),
          ],
        ),
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
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => setState(() => accepted = !accepted),
            child: Container(
              constraints: const BoxConstraints(minHeight: 58),
              padding: const EdgeInsets.all(S.md),
              decoration: BoxDecoration(
                color: PillarColors.surface,
                borderRadius: BorderRadius.circular(R.card),
                border: Border.all(
                  color: accepted ? PillarColors.accent : PillarColors.hairline,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    accepted
                        ? CupertinoIcons.checkmark_circle_fill
                        : CupertinoIcons.circle,
                    color: accepted ? PillarColors.accent : PillarColors.faint,
                    size: 24,
                  ),
                  const SizedBox(width: S.sm),
                  Expanded(
                    child: Text(l.disclaimerAccept, style: PillarType.body),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: S.xl),
          PillarButton(
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
          _PickerPanel(
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
          const SizedBox(height: S.xl),
          PillarButton(
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
                  padding: const EdgeInsets.all(S.xs),
                  child: Text(l.timeExact),
                ),
                'approximate': Padding(
                  padding: const EdgeInsets.all(S.xs),
                  child: Text(l.timeApprox),
                ),
                'unknown': Padding(
                  padding: const EdgeInsets.all(S.xs),
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
            const SizedBox(height: S.lg),
            _PickerPanel(
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
          const SizedBox(height: S.xl),
          PillarButton(
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
    return StepScaffold(
      step: OnboardingStep.birthPlace,
      title: l.birthPlaceTitle,
      subtitle: l.birthPlaceSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: S.sm,
            runSpacing: S.sm,
            children: [
              PillarChip(
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
              PillarChip(
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
              PillarChip(
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
          const SizedBox(height: S.xl),
          InsightCard(
            label: l.selectedBirthplace,
            title: draft.birthPlaceText,
            body: l.timezoneLabel(draft.timezone),
            tone: PillarTone.teal,
          ),
          const SizedBox(height: S.xl),
          PillarButton(
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
                  padding: const EdgeInsets.all(S.xs),
                  child: Text(l.female),
                ),
                'male': Padding(
                  padding: const EdgeInsets.all(S.xs),
                  child: Text(l.male),
                ),
                'prefer_not_to_say': Padding(
                  padding: const EdgeInsets.all(S.xs),
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
          const SizedBox(height: S.xl),
          PillarButton(
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
            spacing: S.sm,
            runSpacing: S.sm,
            children: [
              for (final goal in goals)
                PillarChip(
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
          const SizedBox(height: S.xl),
          PillarButton(
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
      return CupertinoPageScaffold(
        child: PillarErrorView(
          title: l.generationFailedTitle,
          message: state.error!,
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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(l.previewTitle)),
      child: PagePad(
        child: ListView(
          children: [
            const SizedBox(height: S.xl),
            Text(
              _copy(context, preview['coreArchetype']) ?? l.previewDefaultTitle,
              style: PillarType.title1,
            ),
            const SizedBox(height: S.sm),
            Text(
              _copy(context, preview['headline']) ?? l.previewDefaultSubtitle,
              style: PillarType.callout.copyWith(color: PillarColors.muted),
            ),
            const SizedBox(height: S.lg),
            for (final card in cards) ...[
              InsightCard(
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
              const SizedBox(height: S.md),
            ],
            PillarButton(
              text: l.unlockBlueprint,
              icon: CupertinoIcons.lock_open,
              onPressed: () => showPaywall(context, ref),
            ),
            const SizedBox(height: S.sm),
            PillarButton(
              text: l.continueFree,
              secondary: true,
              onPressed: () =>
                  ref.read(appControllerProvider.notifier).enterMain(),
            ),
            const SizedBox(height: S.xl),
          ],
        ),
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
      tabBar: CupertinoTabBar(
        activeColor: PillarColors.accent,
        inactiveColor: PillarColors.faint,
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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(l.tabToday)),
      child: PagePad(
        child: ListView(
          children: [
            const SizedBox(height: S.lg),
            if (today == null)
              PillarErrorView(
                title: l.createBlueprintFirstTitle,
                message: l.createBlueprintFirstBody,
                actionText: l.refresh,
                onAction: () =>
                    ref.read(appControllerProvider.notifier).loadMainData(),
              )
            else ...[
              InsightCard(
                label: l.todayFocus,
                title: _copy(context, _asMap(today['focus'])['title']) ?? '',
                body: _copy(context, _asMap(today['focus'])['body']) ?? '',
                actionText: l.askAboutThis,
                tone: PillarTone.blue,
                onAction: () {
                  final focus = _asMap(today['focus']);
                  final prompt =
                      '${focus['title'] ?? ''}\n${focus['body'] ?? ''}'.trim();
                  ref.read(appControllerProvider.notifier).askFromToday(prompt);
                },
              ),
              const SizedBox(height: S.md),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 360) {
                    return Column(
                      children: [
                        _TodayMiniCard(
                          label: l.challenge,
                          data: _asMap(today['challenge']),
                          tone: PillarTone.rose,
                        ),
                        const SizedBox(height: S.md),
                        _TodayMiniCard(
                          label: l.opportunity,
                          data: _asMap(today['opportunity']),
                          tone: PillarTone.teal,
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
                          tone: PillarTone.rose,
                        ),
                      ),
                      const SizedBox(width: S.sm),
                      Expanded(
                        child: _TodayMiniCard(
                          label: l.opportunity,
                          data: _asMap(today['opportunity']),
                          tone: PillarTone.teal,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: S.lg),
              PillarTextField(
                label: _copy(context, today['reflectionQuestion']) ?? '',
                controller: reflection,
                placeholder: l.reflectionPlaceholder,
                maxLines: 3,
                onChanged: (value) =>
                    setState(() => hasReflection = value.trim().isNotEmpty),
              ),
              const SizedBox(height: S.md),
              PillarButton(
                text: l.saveReflection,
                icon: CupertinoIcons.bookmark,
                onPressed: hasReflection
                    ? () async {
                        await ref
                            .read(appControllerProvider.notifier)
                            .saveReflection(
                              'daily_insight',
                              today['id']?.toString(),
                              today['reflectionQuestion']?.toString() ?? '',
                              reflection.text,
                            );
                        reflection.clear();
                        setState(() => hasReflection = false);
                        if (context.mounted) {
                          showNotice(
                            context,
                            l.journalSavedTitle,
                            l.journalSavedBody,
                          );
                        }
                      }
                    : null,
              ),
              const SizedBox(height: S.md),
              InsightCard(
                label: l.weeklyTheme,
                title: _copy(context, today['weeklyTheme']) ?? '',
                body: _copy(context, today['action']) ?? '',
                tone: PillarTone.amber,
              ),
            ],
            const SizedBox(height: _tabBottomInset),
          ],
        ),
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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(l.tabBlueprint)),
      child: PagePad(
        child: ListView(
          children: [
            const SizedBox(height: S.lg),
            InsightCard(
              label: l.coreArchetype,
              title:
                  _copy(context, source['coreArchetype']) ??
                  l.previewDefaultTitle,
              body:
                  _copy(context, source['headline']) ??
                  l.createBlueprintFirstTitle,
              actionText: l.askAboutThis,
              tone: PillarTone.blue,
              onAction: () {
                final prompt =
                    '${source['coreArchetype'] ?? ''}. ${source['headline'] ?? ''}'
                        .trim();
                ref.read(appControllerProvider.notifier).askFromToday(prompt);
              },
            ),
            const SizedBox(height: S.md),
            for (final card in cards) ...[
              InsightCard(
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
                onAction: () async {
                  if (card['locked'] == true) {
                    showPaywall(context, ref);
                  } else {
                    await ref
                        .read(appControllerProvider.notifier)
                        .saveReflection(
                          'blueprint_card',
                          state.blueprint?['reportId']?.toString(),
                          card['reflectionQuestion']?.toString() ?? '',
                          card['body']?.toString() ?? '',
                        );
                    if (context.mounted) {
                      showNotice(
                        context,
                        l.journalSavedTitle,
                        l.journalSavedBody,
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: S.md),
            ],
            if (full.isEmpty)
              PillarButton(
                text: l.unlockBlueprint,
                icon: CupertinoIcons.lock_open,
                onPressed: () => showPaywall(context, ref),
              ),
            const SizedBox(height: _tabBottomInset),
          ],
        ),
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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(l.tabAsk)),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(S.lg, S.lg, S.lg, S.md),
                children: [
                  Text(
                    l.askIntro,
                    style: PillarType.callout.copyWith(
                      color: PillarColors.muted,
                    ),
                  ),
                  const SizedBox(height: S.md),
                  Wrap(
                    spacing: S.sm,
                    runSpacing: S.sm,
                    children: [
                      for (final prompt in prompts)
                        PillarChip(
                          text: prompt,
                          selected: false,
                          onTap: () => ref
                              .read(appControllerProvider.notifier)
                              .askGuide(prompt),
                        ),
                    ],
                  ),
                  const SizedBox(height: S.lg),
                  for (final message in state.messages) ...[
                    if (message['role'] == 'user')
                      _UserBubble(text: message['content']?.toString() ?? '')
                    else
                      _AiAnswerCard(
                        answer: _asMap(message['answer']),
                        messageId: message['messageId']?.toString(),
                      ),
                    const SizedBox(height: S.sm),
                  ],
                  if (state.error != null) ...[
                    const SizedBox(height: S.md),
                    InsightCard(
                      label: l.notice,
                      title: l.guideUnavailable,
                      body: state.error!,
                      actionText: l.unlockUnlimited,
                      tone: PillarTone.amber,
                      onAction: () => showPaywall(context, ref),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(S.lg, S.sm, S.lg, S.md),
              decoration: const BoxDecoration(
                color: PillarColors.bg,
                border: Border(top: BorderSide(color: PillarColors.hairline)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoTextField(
                      controller: input,
                      placeholder: l.askPlaceholder,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (value) =>
                          setState(() => hasInput = value.trim().isNotEmpty),
                      padding: const EdgeInsets.symmetric(
                        horizontal: S.md,
                        vertical: 13,
                      ),
                      style: PillarType.body,
                      placeholderStyle: PillarType.body.copyWith(
                        color: PillarColors.faint,
                      ),
                      decoration: BoxDecoration(
                        color: PillarColors.surface,
                        borderRadius: BorderRadius.circular(R.control),
                        border: Border.all(color: PillarColors.hairline),
                      ),
                    ),
                  ),
                  const SizedBox(width: S.sm),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(46, 46),
                    onPressed: hasInput
                        ? () {
                            final text = input.text;
                            input.clear();
                            setState(() => hasInput = false);
                            ref
                                .read(appControllerProvider.notifier)
                                .askGuide(text);
                          }
                        : null,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 160),
                      opacity: hasInput ? 1 : 0.42,
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: const BoxDecoration(
                          color: PillarColors.accent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          CupertinoIcons.arrow_up,
                          color: CupertinoColors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l.tabLove),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => showAddRelationship(context, ref),
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: PagePad(
        child: ListView(
          children: [
            const SizedBox(height: S.lg),
            if (relationships.isEmpty)
              InsightCard(
                label: l.loveEmptyLabel,
                title: l.loveEmptyTitle,
                body: l.loveEmptyBody,
                actionText: l.addSomeone,
                tone: PillarTone.rose,
                onAction: () => showAddRelationship(context, ref),
              )
            else
              for (final relationship in relationships) ...[
                RelationshipCard(relationship: relationship, premium: premium),
                const SizedBox(height: S.md),
              ],
            const SizedBox(height: _tabBottomInset),
          ],
        ),
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
    return InsightCard(
      label: _relationshipTypeLabel(
        relationship['relationshipType']?.toString(),
      ),
      title:
          relationship['targetName']?.toString() ?? l.relationshipFallbackTitle,
      body:
          _copy(context, preview['communicationSnapshot']) ??
          l.relationshipPreviewFallback,
      tone: PillarTone.rose,
      actionText: unlocked
          ? l.viewRelationshipReport
          : l.unlockRelationshipReport,
      onAction: () async {
        if (!premium && !unlocked) {
          showPaywall(context, ref);
          return;
        }
        var report = _asMap(relationship['report']);
        if (fullReport.isEmpty) {
          final id = relationship['id']?.toString();
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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(l.tabMe)),
      child: ListView(
        children: [
          const SizedBox(height: S.lg),
          CupertinoListSection.insetGrouped(
            backgroundColor: PillarColors.bg,
            header: Text(l.account),
            children: [
              CupertinoListTile(
                title: Text(l.profile),
                subtitle: Text(state.me?['displayName']?.toString() ?? l.you),
              ),
              CupertinoListTile(
                title: Text(l.birthDetails),
                subtitle: Text(
                  state.birthProfile?['birthPlaceText']?.toString() ??
                      l.createBlueprintFirstTitle,
                ),
              ),
            ],
          ),
          CupertinoListSection.insetGrouped(
            backgroundColor: PillarColors.bg,
            header: Text(l.subscription),
            children: [
              CupertinoListTile(
                title: Text(l.currentPlan),
                subtitle: Text(premium ? l.premiumActive : l.free),
              ),
              CupertinoListTile(
                title: Text(l.restorePurchases),
                trailing: const Icon(
                  CupertinoIcons.arrow_clockwise,
                  color: PillarColors.accent,
                ),
                onTap: () =>
                    ref.read(appControllerProvider.notifier).activatePremium(),
              ),
              CupertinoListTile(
                title: Text(l.manageSubscription),
                subtitle: Text(l.managedInAppStore),
              ),
            ],
          ),
          CupertinoListSection.insetGrouped(
            backgroundColor: PillarColors.bg,
            header: Text(l.saved),
            children: [
              CupertinoListTile(
                title: Text(l.savedJournal),
                additionalInfo: Text(state.journal.length.toString()),
                trailing: const CupertinoListTileChevron(),
                onTap: () => Navigator.of(context).push(
                  CupertinoPageRoute<void>(
                    builder: (_) => const SavedJournalScreen(),
                  ),
                ),
              ),
            ],
          ),
          CupertinoListSection.insetGrouped(
            backgroundColor: PillarColors.bg,
            header: Text(l.dataPrivacy),
            children: [
              CupertinoListTile(
                title: Text(l.exportData),
                trailing: const CupertinoListTileChevron(),
                onTap: () async {
                  final data = await ref
                      .read(appControllerProvider.notifier)
                      .exportData();
                  if (context.mounted) {
                    showLegal(context, l.exportTitle, data.toString());
                  }
                },
              ),
              CupertinoListTile(
                title: Text(l.deleteAccount),
                trailing: const Icon(
                  CupertinoIcons.delete,
                  color: PillarColors.destructive,
                ),
                onTap: () => confirmDeleteAccount(context, ref),
              ),
            ],
          ),
          CupertinoListSection.insetGrouped(
            backgroundColor: PillarColors.bg,
            header: Text(l.language),
            children: [
              CupertinoListTile(
                title: Text(l.language),
                subtitle: Text(_languageSubtitle(context, state.localeCode)),
                trailing: const CupertinoListTileChevron(),
                onTap: () => showLanguageSheet(context, ref),
              ),
            ],
          ),
          CupertinoListSection.insetGrouped(
            backgroundColor: PillarColors.bg,
            header: Text(l.legal),
            children: [
              CupertinoListTile(
                title: Text(l.privacyPolicy),
                trailing: const CupertinoListTileChevron(),
                onTap: () => showLegal(context, l.privacyPolicy, l.privacyBody),
              ),
              CupertinoListTile(
                title: Text(l.termsOfUse),
                trailing: const CupertinoListTileChevron(),
                onTap: () => showLegal(context, l.termsOfUse, l.termsBody),
              ),
              CupertinoListTile(
                title: Text(l.disclaimer),
                trailing: const CupertinoListTileChevron(),
                onTap: () => showLegal(context, l.disclaimer, l.disclaimerBody),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(S.lg),
            child: Text(
              l.versionLabel,
              textAlign: TextAlign.center,
              style: PillarType.footnote.copyWith(color: PillarColors.faint),
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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(l.savedJournal)),
      child: PagePad(
        child: ListView(
          children: [
            const SizedBox(height: S.lg),
            if (entries.isEmpty)
              InsightCard(
                label: l.savedJournal,
                title: l.noJournalTitle,
                body: l.noJournalBody,
                tone: PillarTone.teal,
              )
            else
              for (final entry in entries) ...[
                InsightCard(
                  label: _journalLabel(context, entry),
                  title: entry['prompt']?.toString().isNotEmpty == true
                      ? _copy(context, entry['prompt']) ??
                            entry['prompt'].toString()
                      : l.savedJournal,
                  body: entry['content']?.toString() ?? '',
                  tone: PillarTone.teal,
                ),
                const SizedBox(height: S.md),
              ],
            const SizedBox(height: S.xl),
          ],
        ),
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
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: PagePad(
        child: ListView(
          children: [
            const SizedBox(height: S.md),
            _StepProgress(value: _progressForStep(step)),
            const SizedBox(height: S.xl),
            Text(title, style: PillarType.title1),
            const SizedBox(height: S.sm),
            Text(
              subtitle,
              style: PillarType.callout.copyWith(color: PillarColors.muted),
            ),
            const SizedBox(height: S.xl),
            child,
            const SizedBox(height: S.xl),
          ],
        ),
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
    final lines = [
      _copy(context, answer['summary']) ?? '',
      for (final section in sections)
        '${_copy(context, section['title']) ?? section['title']}: ${_copy(context, section['body']) ?? section['body']}',
      if ((answer['practicalStep']?.toString() ?? '').trim().isNotEmpty)
        l.tryThis(
          _copy(context, answer['practicalStep']) ??
              answer['practicalStep'].toString(),
        ),
      _copy(context, answer['reflectionQuestion']) ?? '',
    ].whereType<String>().where((line) => line.trim().isNotEmpty).join('\n\n');
    return InsightCard(
      label: l.guideLabel,
      title: _copy(context, answer['headline']) ?? '',
      body: lines,
      tone: PillarTone.blue,
      actionText: l.save,
      onAction: () async {
        await ref
            .read(appControllerProvider.notifier)
            .saveReflection(
              'ai_message',
              messageId,
              answer['reflectionQuestion']?.toString() ?? '',
              answer['summary']?.toString() ?? '',
            );
        if (context.mounted) {
          showNotice(context, l.journalSavedTitle, l.journalSavedBody);
        }
      },
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
  final PillarTone tone;

  @override
  Widget build(BuildContext context) {
    return InsightCard(
      label: label,
      title: _copy(context, data['title']) ?? '',
      body: _copy(context, data['body']) ?? '',
      tone: tone,
      compact: true,
    );
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: S.xs),
          padding: const EdgeInsets.symmetric(horizontal: S.md, vertical: S.sm),
          decoration: BoxDecoration(
            color: PillarColors.accent,
            borderRadius: BorderRadius.circular(R.control),
          ),
          child: Text(
            text,
            style: PillarType.callout.copyWith(color: CupertinoColors.white),
          ),
        ),
      ),
    );
  }
}

class _PickerPanel extends StatelessWidget {
  const _PickerPanel({required this.child, this.height = 220});

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: PillarColors.surface,
        borderRadius: BorderRadius.circular(R.card),
        border: Border.all(color: PillarColors.hairline),
      ),
      child: child,
    );
  }
}

class _StepProgress extends StatelessWidget {
  const _StepProgress({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 4,
          decoration: BoxDecoration(
            color: PillarColors.pressed,
            borderRadius: BorderRadius.circular(2),
          ),
          alignment: Alignment.centerLeft,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: constraints.maxWidth * value.clamp(0, 1),
            decoration: BoxDecoration(
              color: PillarColors.accent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      },
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 86,
      height: 86,
      decoration: BoxDecoration(
        color: PillarColors.ink,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: const [
          Positioned(
            top: 18,
            left: 18,
            child: _MarkTile(color: PillarColors.accent),
          ),
          Positioned(
            top: 18,
            right: 18,
            child: _MarkTile(color: PillarColors.teal),
          ),
          Positioned(
            bottom: 18,
            left: 18,
            child: _MarkTile(color: PillarColors.amber),
          ),
          Positioned(
            bottom: 18,
            right: 18,
            child: _MarkTile(color: PillarColors.rose),
          ),
        ],
      ),
    );
  }
}

class _MarkTile extends StatelessWidget {
  const _MarkTile({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
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

void showPaywall(BuildContext context, WidgetRef ref) {
  final l = context.l10n;
  showCupertinoModalPopup<void>(
    context: context,
    builder: (context) => CupertinoActionSheet(
      title: Text(l.paywallTitle),
      message: Text(l.paywallBody),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () async {
            Navigator.of(context).pop();
            await ref.read(appControllerProvider.notifier).activatePremium();
          },
          child: Text(l.startAnnual),
        ),
        CupertinoActionSheetAction(
          onPressed: () async {
            Navigator.of(context).pop();
            await ref.read(appControllerProvider.notifier).activatePremium();
          },
          child: Text(l.restorePurchases),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(l.notNow),
      ),
    ),
  );
}

void showAddRelationship(BuildContext context, WidgetRef ref) {
  final l = context.l10n;
  final name = TextEditingController(text: 'Alex');
  final date = TextEditingController(text: '1993-02-18');
  showCupertinoModalPopup<void>(
    context: context,
    builder: (context) => CupertinoActionSheet(
      title: Text(l.addSomeone),
      message: Padding(
        padding: const EdgeInsets.only(top: S.md),
        child: Column(
          children: [
            CupertinoTextField(
              controller: name,
              placeholder: l.namePlaceholder,
              padding: const EdgeInsets.all(S.sm),
            ),
            const SizedBox(height: S.sm),
            CupertinoTextField(
              controller: date,
              placeholder: l.datePlaceholder,
              padding: const EdgeInsets.all(S.sm),
            ),
          ],
        ),
      ),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () async {
            Navigator.of(context).pop();
            await ref
                .read(appControllerProvider.notifier)
                .addRelationship(
                  name: name.text,
                  type: 'romantic_partner',
                  birthDate: date.text,
                  precision: 'unknown',
                  place: 'New York, NY, US',
                  timezone: 'America/New_York',
                );
          },
          child: Text(l.generatePreview),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(l.cancel),
      ),
    ),
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
            await ref.read(appControllerProvider.notifier).deleteAccount();
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

PillarTone _toneForLabel(String? label) {
  final value = label?.toLowerCase() ?? '';
  if (value.contains('relationship') || value.contains('love')) {
    return PillarTone.rose;
  }
  if (value.contains('career') || value.contains('pattern')) {
    return PillarTone.teal;
  }
  if (value.contains('strength') || value.contains('opportunity')) {
    return PillarTone.blue;
  }
  if (value.contains('blind') || value.contains('challenge')) {
    return PillarTone.amber;
  }
  return PillarTone.neutral;
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
