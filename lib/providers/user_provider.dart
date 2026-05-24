// lib/providers/user_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserState {
  final String name;
  final String age;
  final String occupation; // 職業（学生／社会人など）
  final String homeLocation; // 自宅エリア
  final List<String> hobbyTags; // 趣味タグ（AIプロンプトに使う）
  final int dailyStepGoal; // 1日の歩数目標
  final double dailyDistanceGoal; // 1日の距離目標（km）
  final bool notificationEnabled; // 通知オン／オフ
  final bool reminderEnabled; // 毎日のリマインド
  final String reminderTime; // リマインド時刻
  final bool bgNotification; // バックグラウンド通知
  final bool removeGpsOnShare; // 写真シェア時のGPS除去
  final String locationPermission; // 位置情報許可設定
  final String fontSize; // 文字サイズ
  final String mapStyle; // マップスタイル（'game'/'white'/'black'）
  final bool isSaving; // 保存中フラグ

  const UserState({
    this.name = '',
    this.age = '',
    this.occupation = '学生',
    this.homeLocation = '',
    this.hobbyTags = const [],
    this.dailyStepGoal = 6000,
    this.dailyDistanceGoal = 3.0,
    this.notificationEnabled = true,
    this.reminderEnabled = true,
    this.reminderTime = '18:00',
    this.bgNotification = true,
    this.removeGpsOnShare = true,
    this.locationPermission = 'always',
    this.fontSize = 'medium',
    this.mapStyle = 'game',
    this.isSaving = false,
  });

  UserState copyWith({
    String? name,
    String? age,
    String? occupation,
    String? homeLocation,
    List<String>? hobbyTags,
    int? dailyStepGoal,
    double? dailyDistanceGoal,
    bool? notificationEnabled,
    bool? reminderEnabled,
    String? reminderTime,
    bool? bgNotification,
    bool? removeGpsOnShare,
    String? locationPermission,
    String? fontSize,
    String? mapStyle,
    bool? isSaving,
  }) {
    return UserState(
      name: name ?? this.name,
      age: age ?? this.age,
      occupation: occupation ?? this.occupation,
      homeLocation: homeLocation ?? this.homeLocation,
      hobbyTags: hobbyTags ?? this.hobbyTags,
      dailyStepGoal: dailyStepGoal ?? this.dailyStepGoal,
      dailyDistanceGoal: dailyDistanceGoal ?? this.dailyDistanceGoal,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      bgNotification: bgNotification ?? this.bgNotification,
      removeGpsOnShare: removeGpsOnShare ?? this.removeGpsOnShare,
      locationPermission: locationPermission ?? this.locationPermission,
      fontSize: fontSize ?? this.fontSize,
      mapStyle: mapStyle ?? this.mapStyle,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class UserNotifier extends Notifier<UserState> {
  @override
  UserState build() => const UserState();

  void setName(String value) => state = state.copyWith(name: value);
  void setAge(String value) => state = state.copyWith(age: value);
  void setOccupation(String value) => state = state.copyWith(occupation: value);
  void setHomeLocation(String value) =>
      state = state.copyWith(homeLocation: value);
  void setNotification(bool value) =>
      state = state.copyWith(notificationEnabled: value);
  void setReminderEnabled(bool value) =>
      state = state.copyWith(reminderEnabled: value);
  void setReminderTime(String value) =>
      state = state.copyWith(reminderTime: value);
  void setBgNotification(bool value) =>
      state = state.copyWith(bgNotification: value);
  void setRemoveGpsOnShare(bool value) =>
      state = state.copyWith(removeGpsOnShare: value);
  void setLocationPermission(String value) =>
      state = state.copyWith(locationPermission: value);
  void setFontSize(String value) => state = state.copyWith(fontSize: value);
  void setMapStyle(String value) => state = state.copyWith(mapStyle: value);
  void setDailyStepGoal(int value) =>
      state = state.copyWith(dailyStepGoal: value);
  void setDailyDistanceGoal(double value) =>
      state = state.copyWith(dailyDistanceGoal: value);

  // 趣味タグはトグル（押したら追加・もう一度押したら削除）
  void toggleHobbyTag(String tag) {
    final current = List<String>.from(state.hobbyTags);
    if (current.contains(tag)) {
      current.remove(tag);
    } else {
      current.add(tag);
    }
    state = state.copyWith(hobbyTags: current);
  }

  // 保存処理（Firestore連携まではダミー）
  Future<void> saveSettings() async {
    state = state.copyWith(isSaving: true);
    await Future.delayed(const Duration(seconds: 1)); // TODO: Firestore保存
    state = state.copyWith(isSaving: false);
  }

  Future<void> deleteAccount() async {
    state = state.copyWith(isSaving: true);
    await Future.delayed(const Duration(seconds: 1)); // TODO: Firebase Auth / Firestoreで削除処理
    state = const UserState();
  }
}

final userProvider = NotifierProvider<UserNotifier, UserState>(
  UserNotifier.new,
);
