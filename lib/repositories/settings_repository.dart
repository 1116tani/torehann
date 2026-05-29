// lib/repositories/settings_repository.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/settings_model.dart';
import '../services/local_storage_service.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final storageService = ref.watch(localStorageServiceProvider);
  return LocalSettingsRepository(storageService);
});

abstract class SettingsRepository {
  Future<SettingsState> loadSettings();
  Future<void> saveSettings(SettingsState settings);
}

class LocalSettingsRepository implements SettingsRepository {
  final LocalStorageService _storageService;
  static const _storageKey = 'torehann_settings';

  LocalSettingsRepository(this._storageService);

  @override
  Future<SettingsState> loadSettings() async {
    final map = _storageService.getMap(_storageKey);
    if (map == null) {
      return const SettingsState();
    }
    return SettingsState.fromMap(map);
  }

  @override
  Future<void> saveSettings(SettingsState settings) async {
    await _storageService.setMap(_storageKey, settings.toMap());
  }
}
