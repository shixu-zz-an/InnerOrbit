import 'dart:async';

import 'package:flutter/foundation.dart';
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
  profileSetup,
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
    this.birthDate,
    this.birthTime,
    this.birthTimePrecision = 'exact',
    this.birthPlaceText = '',
    this.latitude,
    this.longitude,
    this.timezone = '',
    this.sexForTraditionalCycle = 'female',
    this.trueSolarTimeEnabled = true,
    List<String>? goals,
  }) : goals = goals ?? ['Myself'];

  factory OnboardingDraft.fromMap(JsonMap map) {
    return OnboardingDraft(
      birthDate: map['birthDate'] is String
          ? DateTime.tryParse(map['birthDate']! as String)
          : null,
      birthTime: map['birthTime'] is String
          ? _parseTime(map['birthTime']! as String)
          : null,
      birthTimePrecision: map['birthTimePrecision']?.toString() ?? 'exact',
      birthPlaceText: map['birthPlaceText']?.toString() ?? '',
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      timezone: map['timezone']?.toString() ?? '',
      sexForTraditionalCycle:
          map['sexForTraditionalCycle']?.toString() ?? 'female',
      trueSolarTimeEnabled: map['trueSolarTimeEnabled'] as bool? ?? true,
      goals: (map['goals'] as List?)?.map((e) => e.toString()).toList(),
    );
  }

  final DateTime? birthDate;
  final DateTime? birthTime;
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
    bool clearLocationCoordinates = false,
  }) {
    return OnboardingDraft(
      birthDate: birthDate ?? this.birthDate,
      birthTime: birthTime ?? this.birthTime,
      birthTimePrecision: birthTimePrecision ?? this.birthTimePrecision,
      birthPlaceText: birthPlaceText ?? this.birthPlaceText,
      latitude: clearLocationCoordinates ? null : latitude ?? this.latitude,
      longitude: clearLocationCoordinates ? null : longitude ?? this.longitude,
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
    this.savingReflection = false,
    this.askingGuide = false,
    this.addingRelationship = false,
    this.activatingPremium = false,
    this.exportingData = false,
    this.deletingAccount = false,
    this.activeRelationshipReportId,
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
  final bool savingReflection;
  final bool askingGuide;
  final bool addingRelationship;
  final bool activatingPremium;
  final bool exportingData;
  final bool deletingAccount;
  final String? activeRelationshipReportId;
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
    bool? savingReflection,
    bool? askingGuide,
    bool? addingRelationship,
    bool? activatingPremium,
    bool? exportingData,
    bool? deletingAccount,
    String? activeRelationshipReportId,
    bool clearActiveRelationshipReport = false,
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
      savingReflection: savingReflection ?? this.savingReflection,
      askingGuide: askingGuide ?? this.askingGuide,
      addingRelationship: addingRelationship ?? this.addingRelationship,
      activatingPremium: activatingPremium ?? this.activatingPremium,
      exportingData: exportingData ?? this.exportingData,
      deletingAccount: deletingAccount ?? this.deletingAccount,
      activeRelationshipReportId: clearActiveRelationshipReport
          ? null
          : activeRelationshipReportId ?? this.activeRelationshipReportId,
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
    state = state.copyWith(initialized: false, loading: true, clearError: true);
    try {
      final config = ref.read(appConfigProvider);
      debugPrint(
        '[Pillarwise][Init] start flavor=${config.flavor} '
        'apiBaseUrl=${config.apiBaseUrl}',
      );
      final store = await _store;
      debugPrint('[Pillarwise][Init] local store ready');
      state = state.copyWith(
        draft: OnboardingDraft.fromMap(store.readDraft()),
        localeCode: store.readLocaleCode(),
      );
      final api = await _api;
      debugPrint('[Pillarwise][Init] api client ready');
      var token = await store.readToken();
      debugPrint(
        '[Pillarwise][Init] token exists=${token != null && token.isNotEmpty}',
      );
      if (token == null || token.isEmpty) {
        debugPrint('[Pillarwise][Init] creating dev session');
        token = await _createDevSession(api, store);
        debugPrint(
          '[Pillarwise][Init] dev session created=${token != null && token.isNotEmpty}',
        );
      }
      JsonMap me;
      try {
        debugPrint('[Pillarwise][Init] loading /me');
        me = await api.get<JsonMap>('/api/v1/me', _map);
      } on ApiException catch (error) {
        debugPrint(
          '[Pillarwise][Init] /me failed code=${error.code} message=${error.message}',
        );
        if (error.code != 'UNAUTHORIZED') rethrow;
        await store.clearAuth();
        debugPrint('[Pillarwise][Init] auth cleared after unauthorized');
        await _createDevSession(api, store);
        debugPrint('[Pillarwise][Init] retrying /me');
        me = await api.get<JsonMap>('/api/v1/me', _map);
      }
      final hasProfile = me['hasPrimaryBirthProfile'] == true;
      debugPrint('[Pillarwise][Init] /me loaded hasProfile=$hasProfile');
      state = state.copyWith(
        initialized: true,
        loading: false,
        needsOnboarding: !hasProfile,
        me: me,
        entitlement: me['entitlement'] is Map
            ? Map<String, Object?>.from(me['entitlement'] as Map)
            : null,
        clearError: true,
      );
      if (hasProfile) {
        debugPrint('[Pillarwise][Init] loading main data');
        await loadMainData();
      }
      debugPrint('[Pillarwise][Init] complete');
      trackEvent('app_initialized', {
        'has_profile': hasProfile,
        'locale': state.localeCode ?? 'system',
      });
    } catch (error) {
      debugPrint('[Pillarwise][Init] failed $error');
      state = state.copyWith(
        initialized: true,
        loading: false,
        error: _friendly(error),
      );
      trackEvent('app_initialize_failed', {'reason': _friendly(error)});
    }
  }

  Future<String?> _createDevSession(ApiClient api, LocalStore store) async {
    final session = await api.get<JsonMap>('/api/v1/auth/dev-session', _map);
    final token = session['accessToken']?.toString();
    if (token != null && token.isNotEmpty) {
      await store.writeToken(token);
    }
    return token;
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
      trackEvent('main_data_loaded', {
        'has_today': today.isNotEmpty,
        'journal_count': state.journal.length,
        'relationship_count': state.relationships.length,
      });
    } catch (error) {
      state = state.copyWith(error: _friendly(error));
      trackEvent('main_data_failed', {'reason': _friendly(error)});
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
    trackEvent('core_loop_started', {'action': 'generate_blueprint'});
    state = state.copyWith(
      step: OnboardingStep.generating,
      loading: true,
      clearError: true,
    );
    final started = DateTime.now();
    try {
      final api = await _api;
      final validationError = _validateDraft(state.draft);
      if (validationError != null) {
        state = state.copyWith(
          loading: false,
          step: OnboardingStep.goal,
          error: validationError,
        );
        return;
      }
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
      trackEvent('core_loop_completed', {'action': 'generate_blueprint'});
    } catch (error) {
      state = state.copyWith(
        loading: false,
        step: OnboardingStep.generating,
        error: _friendly(error),
      );
      trackEvent('core_loop_failed', {
        'action': 'generate_blueprint',
        'reason': _friendly(error),
      });
    }
  }

  Future<void> enterMain() async {
    state = state.copyWith(
      needsOnboarding: false,
      selectedTab: 0,
      clearError: true,
    );
    trackEvent('onboarding_completed', {'entry': 'preview'});
    await loadMainData();
  }

  Future<bool> activatePremium() async {
    trackEvent('upgrade_tapped', {'source': 'local_test_unlock'});
    state = state.copyWith(
      loading: true,
      activatingPremium: true,
      clearError: true,
    );
    try {
      final entitlement = await (await _api).post<JsonMap>(
        '/api/v1/subscriptions/local/activate',
        {'productId': 'premium_annual'},
        _map,
      );
      state = state.copyWith(
        loading: state.birthProfile == null ? false : true,
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
          activatingPremium: false,
          blueprint: full,
          clearError: true,
        );
      } else {
        state = state.copyWith(activatingPremium: false, clearError: true);
      }
      trackEvent('upgrade_completed', {'source': 'local_test_unlock'});
      return true;
    } catch (error) {
      state = state.copyWith(
        loading: false,
        activatingPremium: false,
        error: _friendly(error),
      );
      trackEvent('upgrade_failed', {'reason': _friendly(error)});
      return false;
    }
  }

  Future<bool> saveReflection(
    String sourceType,
    String? sourceId,
    String prompt,
    String content,
  ) async {
    if (content.trim().isEmpty) return false;
    state = state.copyWith(savingReflection: true, clearError: true);
    try {
      final saved = await (await _api).post<JsonMap>('/api/v1/journal', {
        'sourceType': sourceType,
        'sourceId': sourceId,
        'prompt': prompt,
        'content': content,
      }, _map);
      state = state.copyWith(
        savingReflection: false,
        journal: [saved, ...state.journal],
        clearError: true,
      );
      trackEvent('retention_action_completed', {
        'action': 'save_reflection',
        'source_type': sourceType,
      });
      return true;
    } catch (error) {
      state = state.copyWith(savingReflection: false, error: _friendly(error));
      trackEvent('retention_action_failed', {
        'action': 'save_reflection',
        'reason': _friendly(error),
      });
      return false;
    }
  }

  Future<void> askGuide(String text, {String? localeCode}) async {
    if (text.trim().isEmpty) return;
    trackEvent('core_action_started', {'action': 'ask_guide'});
    state = state.copyWith(askingGuide: true, clearError: true);
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
        'context': {
          'includeBlueprint': true,
          if (localeCode != null && localeCode.isNotEmpty) 'locale': localeCode,
        },
      }, _map);
      state = state.copyWith(
        askingGuide: false,
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
      trackEvent('core_action_completed', {'action': 'ask_guide'});
    } catch (error) {
      if (error is ApiException && error.code == 'ENTITLEMENT_REQUIRED') {
        state = state.copyWith(
          askingGuide: false,
          error:
              'You’ve used today’s free question. Unlock unlimited guidance.',
        );
        trackEvent('paywall_triggered', {'source': 'ai_quota'});
      } else {
        state = state.copyWith(askingGuide: false, error: _friendly(error));
        trackEvent('core_action_failed', {
          'action': 'ask_guide',
          'reason': _friendly(error),
        });
      }
    }
  }

  Future<void> askFromToday(String text, {String? localeCode}) async {
    selectTab(2);
    await askGuide(text, localeCode: localeCode);
  }

  Future<bool> addRelationship({
    required String name,
    required String type,
    required String birthDate,
    required String precision,
    String? birthTime,
    required String place,
    required String timezone,
  }) async {
    state = state.copyWith(addingRelationship: true, clearError: true);
    try {
      final created = await (await _api)
          .post<JsonMap>('/api/v1/relationships', {
            'targetName': name,
            'relationshipType': type,
            'birthDate': birthDate,
            'birthTime': precision == 'unknown' ? null : birthTime,
            'birthTimePrecision': precision,
            'birthPlaceText': place,
            'latitude': null,
            'longitude': null,
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
        addingRelationship: false,
        relationships: [created, ...state.relationships],
        clearError: true,
      );
      trackEvent('relationship_preview_created');
      return true;
    } catch (error) {
      state = state.copyWith(
        addingRelationship: false,
        error: _friendly(error),
      );
      trackEvent('relationship_preview_failed', {'reason': _friendly(error)});
      return false;
    }
  }

  Future<JsonMap?> generateRelationshipReport(
    String relationshipId, {
    bool full = false,
  }) async {
    state = state.copyWith(
      activeRelationshipReportId: relationshipId,
      clearError: true,
    );
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
      state = state.copyWith(
        relationships: relationships,
        clearActiveRelationshipReport: true,
        clearError: true,
      );
      return report;
    } catch (error) {
      state = state.copyWith(
        clearActiveRelationshipReport: true,
        error: _friendly(error),
      );
      return null;
    }
  }

  Future<bool> deleteAccount() async {
    state = state.copyWith(deletingAccount: true, clearError: true);
    try {
      await (await _api).delete<JsonMap>('/api/v1/me', {
        'confirmation': 'DELETE',
      }, _map);
      await (await _store).clearAll();
      state = AppState.initial().copyWith(initialized: true);
      await initialize();
      return true;
    } catch (error) {
      state = state.copyWith(deletingAccount: false, error: _friendly(error));
      return false;
    }
  }

  Future<JsonMap> exportData() async {
    state = state.copyWith(exportingData: true, clearError: true);
    try {
      final data = await (await _api).get<JsonMap>('/api/v1/me/export', _map);
      state = state.copyWith(exportingData: false, clearError: true);
      return data;
    } catch (error) {
      state = state.copyWith(exportingData: false, error: _friendly(error));
      rethrow;
    }
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
    trackEvent('screen_viewed', {'tab_index': index});
  }

  void trackEvent(String eventName, [JsonMap properties = const {}]) {
    unawaited(_trackEvent(eventName, properties));
  }

  Future<void> _trackEvent(String eventName, JsonMap properties) async {
    try {
      await (await _api).post<JsonMap>('/api/v1/analytics/events', {
        'eventName': eventName,
        'properties': properties,
      }, _map);
    } catch (_) {
      // Analytics must never block the product path.
    }
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
  if (error is ApiException) {
    return '${error.code}: ${error.message} details=${error.details}';
  }
  return '${error.runtimeType}: $error';
}

String? _validateDraft(OnboardingDraft draft) {
  if (draft.birthDate == null) {
    return 'Please choose your birth date.';
  }
  if (draft.birthTimePrecision != 'unknown' && draft.birthTime == null) {
    return 'Please choose your birth time or select “I don’t know.”';
  }
  if (draft.birthPlaceText.trim().isEmpty) {
    return 'Please enter your birthplace.';
  }
  if (draft.timezone.trim().isEmpty) {
    return 'Please enter your birth timezone.';
  }
  if (draft.goals.isEmpty) {
    return 'Choose at least one focus.';
  }
  return null;
}

String? _date(DateTime? value) {
  if (value == null) return null;
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}

String? _time(DateTime? value) {
  if (value == null) return null;
  return '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
}

DateTime? _parseTime(String value) {
  final parts = value.split(':');
  if (parts.length < 2) return null;
  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) return null;
  return DateTime(1970, 1, 1, hour, minute);
}
