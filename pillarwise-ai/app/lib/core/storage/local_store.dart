import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStore {
  LocalStore(this._secure, this._prefs);

  static Future<LocalStore> create() async {
    return LocalStore(
      const FlutterSecureStorage(),
      await SharedPreferences.getInstance(),
    );
  }

  final FlutterSecureStorage _secure;
  final SharedPreferences _prefs;

  Future<String?> readToken() => _secure.read(key: 'access_token');

  Future<void> writeToken(String token) =>
      _secure.write(key: 'access_token', value: token);

  Future<void> clearAuth() => _secure.delete(key: 'access_token');

  Map<String, Object?> readDraft() {
    final value = _prefs.getString('onboarding_draft');
    if (value == null) return {};
    final decoded = jsonDecode(value);
    return decoded is Map ? Map<String, Object?>.from(decoded) : {};
  }

  Future<void> writeDraft(Map<String, Object?> draft) {
    return _prefs.setString('onboarding_draft', jsonEncode(draft));
  }

  Future<void> clearDraft() => _prefs.remove('onboarding_draft');

  String? readLocaleCode() => _prefs.getString('locale_code');

  Future<void> writeLocaleCode(String? code) async {
    if (code == null || code.isEmpty) {
      await _prefs.remove('locale_code');
      return;
    }
    await _prefs.setString('locale_code', code);
  }

  Future<void> clearAll() async {
    await clearAuth();
    await _prefs.clear();
  }
}
