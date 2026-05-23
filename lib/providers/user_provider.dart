// lib/providers/user_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserState {
  // ── 冒険者プロフィール ──
  final String name; // 冒険者名
  final String age; // 年齢
  final List<String> walkAreas; // よく歩くエリア（複数可）
  final String partnerName; // 相棒の名前

  // ── 趣味・好みタグ ──
  final List<String> hobbyTags; // 好きな場所タグ
  final String defaultMood; // デフォルトの気分

  // ── 冒険のデフォルト設定 ──
  final int defaultFreeTimeMinutes; // デフォルトの空き時間（分）
  final int dailyGoal; // 1日の目標（歩数）

  // ── アプリの見た目・マップ ──
  final String mapStyle; // 'game' / 'white' / 'black'
  final String fontSize; // 'small' / 'medium' / 'large'

  // ── 通知 ──
  final bool reminderEnabled; // 毎日のリマインド
  final String reminderTime; // リマインド時刻（例：'18:00'）
  final bool bgNotification; // バックグラウンド通知

  // ── プライバシー ──
  final bool removeGpsOnShare; // シェア時GPS座標を除去
  final String locationPermission; // 'always' / 'whenInUse' / 'denied'

  // ── 内部フラグ ──
  final bool isSaving;

  const UserState({
    this.name = '',
    this.age = '',
    this.walkAreas = const [],
    this.partnerName = '',
    this.hobbyTags = const [],
    this.defaultMood = 'のんびり',
    this.defaultFreeTimeMinutes = 60,
    this.dailyGoal = 8000,
    this.mapStyle = 'game',
    this.fontSize = 'medium',
    this.reminderEnabled = true,
    this.reminderTime = '18:00',
    this.bgNotification = true,
    this.removeGpsOnShare = true,
    this.locationPermission = 'always',
    this.isSaving = false,
  });

  UserState copyWith({
    String? name,
    String? age,
    List<String>? walkAreas,
    String? partnerName,
    List<String>? hobbyTags,
    String? defaultMood,
    int? defaultFreeTimeMinutes,
    int? dailyGoal,
    String? mapStyle,
    String? fontSize,
    bool? reminderEnabled,
    String? reminderTime,
    bool? bgNotification,
    bool? removeGpsOnShare,
    String? locationPermission,
    bool? isSaving,
  }) {
    return UserState(
      name: name ?? this.name,
      age: age ?? this.age,
      walkAreas: walkAreas ?? this.walkAreas,
      partnerName: partnerName ?? this.partnerName,
      hobbyTags: hobbyTags ?? this.hobbyTags,
      defaultMood: defaultMood ?? this.defaultMood,
      defaultFreeTimeMinutes:
          defaultFreeTimeMinutes ?? this.defaultFreeTimeMinutes,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      mapStyle: mapStyle ?? this.mapStyle,
      fontSize: fontSize ?? this.fontSize,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      bgNotification: bgNotification ?? this.bgNotification,
      removeGpsOnShare: removeGpsOnShare ?? this.removeGpsOnShare,
      locationPermission: locationPermission ?? this.locationPermission,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class UserNotifier extends Notifier<UserState> {
  @override
  UserState build() => const UserState();

  // ── プロフィール ──
  void setName(String v) => state = state.copyWith(name: v);
  void setAge(String v) => state = state.copyWith(age: v);
  void setPartnerName(String v) => state = state.copyWith(partnerName: v);

  // よく歩くエリアの追加・削除
  void addWalkArea(String area) {
    if (area.trim().isEmpty) return;
    if (state.walkAreas.contains(area)) return;
    state = state.copyWith(walkAreas: [...state.walkAreas, area.trim()]);
  }

  void removeWalkArea(String area) {
    state = state.copyWith(
      walkAreas: state.walkAreas.where((a) => a != area).toList(),
    );
  }

  void setWalkAreas(List<String> areas) => state = state.copyWith(walkAreas: areas);

  // ── 趣味タグ ──
  void toggleHobbyTag(String tag) {
    final current = List<String>.from(state.hobbyTags);
    current.contains(tag) ? current.remove(tag) : current.add(tag);
    state = state.copyWith(hobbyTags: current);
  }

  void setDefaultMood(String v) => state = state.copyWith(defaultMood: v);

  // ── 冒険デフォルト設定 ──
  void setDefaultFreeTime(int minutes) =>
      state = state.copyWith(defaultFreeTimeMinutes: minutes);
  void setDailyGoal(int v) => state = state.copyWith(dailyGoal: v);

  // ── 見た目・マップ ──
  void setMapStyle(String v) => state = state.copyWith(mapStyle: v);
  void setFontSize(String v) => state = state.copyWith(fontSize: v);

  // ── 通知 ──
  void setReminderEnabled(bool v) => state = state.copyWith(reminderEnabled: v);
  void setReminderTime(String v) => state = state.copyWith(reminderTime: v);
  void setBgNotification(bool v) => state = state.copyWith(bgNotification: v);

  // ── プライバシー ──
  void setRemoveGpsOnShare(bool v) =>
      state = state.copyWith(removeGpsOnShare: v);
  void setLocationPermission(String v) =>
      state = state.copyWith(locationPermission: v);

  // ── 保存処理 ──
  Future<void> saveSettings() async {
    state = state.copyWith(isSaving: true);
    await Future.delayed(const Duration(seconds: 1)); // TODO: Firestore保存
    state = state.copyWith(isSaving: false);
  }

  // ── アカウント削除（データ全消去） ──
  Future<void> deleteAccount() async {
    state = const UserState(); // ローカルをリセット
    // TODO: Firebase AuthのdeleteUser() + Firestoreのデータ削除
  }
}

final userProvider = NotifierProvider<UserNotifier, UserState>(
  UserNotifier.new,
);
