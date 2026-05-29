// lib/providers/settings_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/settings_model.dart';
import '../repositories/settings_repository.dart';

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    Future.microtask(loadSettings);
    return const SettingsState();
  }

  Future<void> loadSettings() async {
    final repository = ref.read(settingsRepositoryProvider);
    final settings = await repository.loadSettings();
    state = settings;
  }

  Future<void> saveSettings() async {
    state = state.copyWith(isSaving: true);
    final repository = ref.read(settingsRepositoryProvider);
    await repository.saveSettings(state);
    state = state.copyWith(isSaving: false);
  }

  // 設定更新用のメソッド
  void updateUserName(String name) => state = state.copyWith(userName: name);
  
  void updateAge(int age) => state = state.copyWith(age: age);
  
  void updateDailyGoalKm(double km) {
    // 距離に連動して歩数目標も自動調整 (目安: 1km = 1500歩)
    final stepGoal = (km * 1500).toInt().clamp(1000, 30000);
    state = state.copyWith(dailyGoalKm: km, dailyStepGoal: stepGoal);
  }
  
  void updateDailyStepGoal(int steps) {
    // 歩数に連動して距離目標も自動調整
    final kmGoal = double.parse((steps / 1500).toStringAsFixed(1));
    state = state.copyWith(dailyStepGoal: steps, dailyGoalKm: kmGoal);
  }
  
  void toggleFavoriteTag(String tag) {
    final current = List<String>.from(state.favoriteTags);
    if (current.contains(tag)) {
      current.remove(tag);
    } else {
      if (current.length < 5) {
        current.add(tag);
      }
    }
    state = state.copyWith(favoriteTags: current);
  }

  void setReminderEnabled(bool enabled) => state = state.copyWith(reminderEnabled: enabled);
  
  void setBackgroundNotificationEnabled(bool enabled) =>
      state = state.copyWith(backgroundNotificationEnabled: enabled);
  
  void setMapStyle(String style) => state = state.copyWith(mapStyle: style);
  
  void setTextSize(String size) => state = state.copyWith(textSize: size);
  
  void setThemeMode(String mode) => state = state.copyWith(themeMode: mode);
  
  void setLocationPermission(String permission) => state = state.copyWith(locationPermission: permission);
  
  void setPhotoPermission(bool allowed) => state = state.copyWith(photoPermission: allowed);

  void updateHomeLocation(String loc) => state = state.copyWith(homeLocation: loc);
  
  void updateWorkLocation(String loc) => state = state.copyWith(workLocation: loc);
  
  void updateFavoriteLocation(String loc) => state = state.copyWith(favoriteLocation: loc);
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);
