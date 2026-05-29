// lib/services/local_storage_service.dart

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in main()');
});

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalStorageService(prefs);
});

class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  Future<bool> setString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<bool> setMap(String key, Map<String, dynamic> value) async {
    return _prefs.setString(key, jsonEncode(value));
  }

  Map<String, dynamic>? getMap(String key) {
    final stringValue = _prefs.getString(key);
    if (stringValue == null) return null;
    try {
      return jsonDecode(stringValue) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<bool> remove(String key) async {
    return _prefs.remove(key);
  }

  Future<bool> clear() async {
    return _prefs.clear();
  }
}
