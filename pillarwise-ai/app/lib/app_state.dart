import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_config.dart';
import 'core/network/api_client.dart';
import 'core/storage/local_store.dart';

typedef JsonMap = Map<String, Object?>;

final localStoreProvider = FutureProvider<LocalStore>(
  (ref) => LocalStore.create(),
);

final apiClientProvider = FutureProvider<ApiClient>((ref) async {
  final config = ref.watch(appConfigProvider);
  final store = await ref.watch(localStoreProvider.future);
  return ApiClient(config, store);
});

final appControllerProvider = StateNotifierProvider<AppController, AppState>((
  ref,
) {
  return AppController(ref);
});

enum OnboardingStep {
  welcome,
  disclaimer,
  birthDate,
  birthTime,
  birthPlace,
  traditional,
  goal,
  generating,
  preview,
}

class OnboardingDraft {
  OnboardingDraft({
    DateTime? birthDate,
    DateTime? birthTime,
    this.birthTimePrecision = 'exact',
    this.birthPlaceText = 'Los Angeles, CA, US',
    this.latitude = 34.0522,
    this.longitude = -118.2437,
    this.timezone = 'America/Los_Angeles',
    this.sexForTraditionalCycle = 'female',
    this.trueSolarTimeEnabled = true,
    List<String>? goals,
  }) : birthDate = birthDate ?? DateTime(1994, 8, 21),
       birthTime = birthTime ?? DateTime(1994, 1, 1, 14, 30),
       goals = goals ?? ['Myself'];

  factory OnboardingDraft.fromMap(JsonMap map) {
    return OnboardingDraft(
      birthDate: map['birthDate'] is String
          ? DateTime.tryParse(map['birthDate']! as String)
          : null,
      birthTimePrecision: map['birthTimePrecision']?.toString() ?? 'exact',
      birthPlaceText:
          map['birthPlaceText']?.toString() ?? 'Los Angeles, CA, US',
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      timezone: map['timezone']?.toString() ?? 'America/Los_Angeles',
      sexForTraditionalCycle:
          map['sexForTraditionalCycle']?.toString() ?? 'female',
      trueSolarTimeEnabled: map['trueSolarTimeEnabled'] as bool? ?? true,
      goals: (map['goals'] as List?)?.map((e) => e.toString()).toList(),
    );
  }

  final DateTime birthDate;
  final DateTime birthTime;
  final String birthTimePrecision;
  final String birthPlaceText;
  final double? latitude;
  final double? longitude;
  final String timezone;
  final String sexForTraditionalCycle;
  final bool trueSolarTimeEnabled;
  final List<String> goals;

  JsonMap toMap() {
    return {
      'birthDate': _date(birthDate),
      'birthTime': _time(birthTime),
      'birthTimePrecision': birthTimePrecision,
      'birthPlaceText': birthPlaceText,
      'latitude': latitude,
      'longitude': longitude,
      'timezone': timezone,
      'sexForTraditionalCycle': sexForTraditionalCycle,
      'trueSolarTimeEnabled': trueSolarTimeEnabled,
      'goals': goals,
    };
  }

  OnboardingDraft copyWith({
    DateTime? birthDate,
    DateTime? birthTime,
    String? birthTimePrecision,
    String? birthPlaceText,
    double? latitude,
    double? longitude,
    String? timezone,
    String? sexForTraditionalCycle,
    bool? trueSolarTimeEnabled,
    List<String>? goals,
  }) {
    return OnboardingDraft(
      birthDate: birthDate ?? this.birthDate,
      birthTime: birthTime ?? this.birthTime,
      birthTimePrecision: birthTimePrecision ?? this.birthTimePrecision,
      birthPlaceText: birthPlaceText ?? this.birthPlaceText,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timezone: timezone ?? this.timezone,
      sexForTraditionalCycle:
          sexForTraditionalCycle ?? this.sexForTraditionalCycle,
      trueSolarTimeEnabled: trueSolarTimeEnabled ?? this.trueSolarTimeEnabled,
      goals: goals ?? this.goals,
    );
  }
}

class AppState {
  const AppState({
    this.initialized = false,
    this.loading = false,
    this.error,
    this.needsOnboarding = true,
    this.step = OnboardingStep.welcome,
    required this.draft,
    this.me,
    this.birthProfile,
    this.blueprint,
    this.today,
    this.entitlement,
    this.relationships = const [],
    this.journal = const [],
    this.messages = const [],
    this.conversationId,
    this.localeCode,
    this.selectedTab = 0,
  });

  factory AppState.initial() => AppState(draft: OnboardingDraft());

  final bool initialized;
  final bool loading;
  final String? error;
  final bool needsOnboarding;
  final OnboardingStep step;
  final OnboardingDraft draft;
  final JsonMap? me;
  final JsonMap? birthProfile;
  final JsonMap? blueprint;
  final JsonMap? today;
  final JsonMap? entitlement;
  final List<JsonMap> relationships;
  final List<JsonMap> journal;
  final List<JsonMap> messages;
  final String? conversationId;
  final String? localeCode;
  final int selectedTab;

  AppState copyWith({
    bool? initialized,
    bool? loading,
    String? error,
    bool clearError = false,
    bool? needsOnboarding,
    OnboardingStep? step,
    OnboardingDraft? draft,
    JsonMap? me,
    JsonMap? birthProfile,
    JsonMap? blueprint,
    JsonMap? today,
    JsonMap? entitlement,
    List<JsonMap>? relationships,
    List<JsonMap>? journal,
    List<JsonMap>? messages,
    String? conversationId,
    String? localeCode,
    bool clearLocale = false,
    int? selectedTab,
  }) {
    return AppState(
      initialized: initialized ?? this.initialized,
      loading: loading ?? this.loading,
      error: clearError ? null : error ?? this.error,
      needsOnboarding: needsOnboarding ?? this.needsOnboarding,
      step: step ?? this.step,
      draft: draft ?? this.draft,
      me: me ?? this.me,
      birthProfile: birthProfile ?? this.birthProfile,
      blueprint: blueprint ?? this.blueprint,
      today: today ?? this.today,
      entitlement: entitlement ?? this.entitlement,
      relationships: relationships ?? this.relationships,
      journal: journal ?? this.journal,
      messages: messages ?? this.messages,
      conversationId: conversationId ?? this.conversationId,
      localeCode: clearLocale ? null : localeCode ?? this.localeCode,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}

class AppController extends StateNotifier<AppState> {
  AppController(this.ref) : super(AppState.initial()) {
    initialize();
  }

  final Ref ref;

  Future<ApiClient> get _api => ref.read(apiClientProvider.future);
  Future<LocalStore> get _store => ref.read(localStoreProvider.future);

  Future<void> initialize() async {
    try {
      final store = await _store;
      state = state.copyWith(
        draft: OnboardingDraft.fromMap(store.readDraft()),
        localeCode: store.readLocaleCode(),
      );
      final api = await _api;
      var token = await store.readToken();
      if (token == null || token.isEmpty) {
        final session = await api.get<JsonMap>(
          '/api/v1/auth/dev-session',
          _map,
        );
        token = session['accessToken']?.toString();
        if (token != null) await store.writeToken(token);
      }
      final me = await api.get<JsonMap>('/api/v1/me', _map);
      final hasProfile = me['hasPrimaryBirthProfile'] == true;
      state = state.copyWith(
        initialized: true,
        needsOnboarding: !hasProfile,
        me: me,
        entitlement: me['entitlement'] is Map
            ? Map<String, Object?>.from(me['entitlement'] as Map)
            : null,
        clearError: true,
      );
      if (hasProfile) {
        await loadMainData();
      }
    } catch (error) {
      state = state.copyWith(initialized: true, error: _friendly(error));
    }
  }

  Future<void> loadMainData() async {
    final api = await _api;
    try {
      final profile = await api.get<JsonMap>(
        '/api/v1/birth-profiles/primary',
        _map,
      );
      final entitlement = await api.get<JsonMap>(
        '/api/v1/subscriptions/entitlement',
        _map,
      );
      final today = await api.get<JsonMap>(
        '/api/v1/today',
        _map,
        query: {'birthProfileId': profile['id']},
      );
      final reports = await api.get<JsonMap>('/api/v1/reports', _map);
      final relationships = await api.get<JsonMap>(
        '/api/v1/relationships',
        _map,
      );
      final journal = await api.get<JsonMap>('/api/v1/journal', _map);
      final reportList =
          (reports['reports'] as List?)
              ?.whereType<Map>()
              .map((e) => Map<String, Object?>.from(e))
              .toList() ??
          [];
      JsonMap? latestBlueprint;
      if (reportList.isNotEmpty) {
        final id = reportList.firstWhere(
          (r) => r['reportType'] == 'life_blueprint',
          orElse: () => <String, Object?>{},
        )['id'];
        if (id != null) {
          latestBlueprint = await api.get<JsonMap>('/api/v1/reports/$id', _map);
        }
      }
      state = state.copyWith(
        birthProfile: profile,
        entitlement: entitlement,
        today: today,
        blueprint: latestBlueprint ?? state.blueprint,
        relationships: _list(relationships['relationships']),
        journal: _list(journal['entries']),
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(error: _friendly(error));
    }
  }

  Future<void> goTo(OnboardingStep step) async {
    state = state.copyWith(step: step, clearError: true);
    await _saveDraft();
  }

  Future<void> updateDraft(OnboardingDraft draft) async {
    state = state.copyWith(draft: draft, clearError: true);
    await _saveDraft();
  }

  Future<void> generateProfileAndPreview() async {
    state = state.copyWith(
      step: OnboardingStep.generating,
      loading: true,
      clearError: true,
    );
    final started = DateTime.now();
    try {
      final api = await _api;
      final profileResult = await api.post<JsonMap>(
        '/api/v1/birth-profiles',
        state.draft.toMap(),
        _map,
      );
      final profile = Map<String, Object?>.from(
        profileResult['birthProfile'] as Map,
      );
      final preview = await api.post<JsonMap>(
        '/api/v1/reports/life-blueprint',
        {'birthProfileId': profile['id'], 'mode': 'preview'},
        _map,
      );
      final elapsed = DateTime.now().difference(started);
      if (elapsed < const Duration(milliseconds: 1200)) {
        await Future<void>.delayed(
          const Duration(milliseconds: 1200) - elapsed,
        );
      }
      await (await _store).clearDraft();
      state = state.copyWith(
        loading: false,
        step: OnboardingStep.preview,
        birthProfile: profile,
        blueprint: preview,
        needsOnboarding: true,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(
        loading: false,
        step: OnboardingStep.generating,
        error: _friendly(error),
      );
    }
  }

  Future<void> enterMain() async {
    state = state.copyWith(
      needsOnboarding: false,
      selectedTab: 0,
      clearError: true,
    );
    await loadMainData();
  }

  Future<void> activatePremium() async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final entitlement = await (await _api).post<JsonMap>(
        '/api/v1/subscriptions/local/activate',
        {'productId': 'premium_annual'},
        _map,
      );
      state = state.copyWith(
        loading: false,
        entitlement: entitlement,
        clearError: true,
      );
      if (state.birthProfile != null) {
        final full = await (await _api).post<JsonMap>(
          '/api/v1/reports/life-blueprint',
          {'birthProfileId': state.birthProfile!['id'], 'mode': 'full'},
          _map,
        );
        state = state.copyWith(
          loading: false,
          blueprint: full,
          clearError: true,
        );
      }
    } catch (error) {
      state = state.copyWith(loading: false, error: _friendly(error));
    }
  }

  Future<void> saveReflection(
    String sourceType,
    String? sourceId,
    String prompt,
    String content,
  ) async {
    if (content.trim().isEmpty) return;
    try {
      final saved = await (await _api).post<JsonMap>('/api/v1/journal', {
        'sourceType': sourceType,
        'sourceId': sourceId,
        'prompt': prompt,
        'content': content,
      }, _map);
      state = state.copyWith(
        journal: [saved, ...state.journal],
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(error: _friendly(error));
    }
  }

  Future<void> askGuide(String text) async {
    if (text.trim().isEmpty) return;
    try {
      var conversationId = state.conversationId;
      final profileId = state.birthProfile?['id'];
      if (conversationId == null) {
        final created = await (await _api).post<JsonMap>(
          '/api/v1/ai/conversations',
          {'birthProfileId': profileId, 'topic': 'general'},
          _map,
        );
        conversationId = created['conversationId']?.toString();
      }
      final result = await (await _api).post<JsonMap>('/api/v1/ai/messages', {
        'conversationId': conversationId,
        'birthProfileId': profileId,
        'message': text,
        'context': {'includeBlueprint': true},
      }, _map);
      state = state.copyWith(
        conversationId: conversationId,
        messages: [
          ...state.messages,
          {'role': 'user', 'content': text},
          {
            'role': 'assistant',
            'answer': result['answer'],
            'messageId': result['messageId'],
          },
        ],
        clearError: true,
      );
    } catch (error) {
      if (error is ApiException && error.code == 'ENTITLEMENT_REQUIRED') {
        state = state.copyWith(
          error:
              'You’ve used today’s free question. Unlock unlimited guidance.',
        );
      } else {
        state = state.copyWith(error: _friendly(error));
      }
    }
  }

  Future<void> askFromToday(String text) async {
    selectTab(2);
    await askGuide(text);
  }

  Future<void> addRelationship({
    required String name,
    required String type,
    required String birthDate,
    required String precision,
    String? birthTime,
    required String place,
    required String timezone,
  }) async {
    try {
      final created = await (await _api)
          .post<JsonMap>('/api/v1/relationships', {
            'targetName': name,
            'relationshipType': type,
            'birthDate': birthDate,
            'birthTime': precision == 'unknown' ? null : birthTime,
            'birthTimePrecision': precision,
            'birthPlaceText': place,
            'latitude': place.contains('New York') ? 40.7128 : null,
            'longitude': place.contains('New York') ? -74.006 : null,
            'timezone': timezone,
          }, _map);
      final report = await (await _api).post<JsonMap>(
        '/api/v1/relationships/${created['id']}/report',
        {'mode': 'preview'},
        _map,
      );
      created['preview'] = report['preview'];
      created['report'] = report;
      state = state.copyWith(
        relationships: [created, ...state.relationships],
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(error: _friendly(error));
    }
  }

  Future<JsonMap?> generateRelationshipReport(
    String relationshipId, {
    bool full = false,
  }) async {
    try {
      final report = await (await _api).post<JsonMap>(
        '/api/v1/relationships/$relationshipId/report',
        {'mode': full ? 'full' : 'preview'},
        _map,
      );
      final relationships = [
        for (final relationship in state.relationships)
          if (relationship['id']?.toString() == relationshipId)
            {
              ...relationship,
              'preview': report['preview'],
              'fullReport': report['fullReport'],
              'report': report,
              'unlocked': report['unlocked'],
            }
          else
            relationship,
      ];
      state = state.copyWith(relationships: relationships, clearError: true);
      return report;
    } catch (error) {
      state = state.copyWith(error: _friendly(error));
      return null;
    }
  }

  Future<void> deleteAccount() async {
    try {
      await (await _api).delete<JsonMap>('/api/v1/me', {
        'confirmation': 'DELETE',
      }, _map);
      await (await _store).clearAll();
      state = AppState.initial().copyWith(initialized: true);
      await initialize();
    } catch (error) {
      state = state.copyWith(error: _friendly(error));
    }
  }

  Future<JsonMap> exportData() async {
    return (await _api).get<JsonMap>('/api/v1/me/export', _map);
  }

  Future<void> setLocaleCode(String? code) async {
    await (await _store).writeLocaleCode(code);
    state = state.copyWith(
      localeCode: code,
      clearLocale: code == null,
      clearError: true,
    );
  }

  void selectTab(int index) {
    state = state.copyWith(selectedTab: index, clearError: true);
  }

  Future<void> _saveDraft() async {
    await (await _store).writeDraft(state.draft.toMap());
  }
}

JsonMap _map(Object? value) {
  return value is Map ? Map<String, Object?>.from(value) : <String, Object?>{};
}

List<JsonMap> _list(Object? value) {
  return value is List
      ? value.whereType<Map>().map((e) => Map<String, Object?>.from(e)).toList()
      : [];
}

String _friendly(Object error) {
  if (error is ApiException) return error.message;
  return 'Something didn’t load right. Your data is safe. Please try again.';
}

String _date(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}

String _time(DateTime value) {
  return '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
}
