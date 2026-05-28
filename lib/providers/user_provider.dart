// lib/providers/user_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';

class UserState {
  final String name;
  final String age;
  final String occupation;
  final String homeLocation;
  final List<String> hobbyTags;
  final int dailyStepGoal;
  final double dailyDistanceGoal;
  final bool notificationEnabled;
  final bool reminderEnabled;
  final String reminderTime;
  final bool bgNotification;
  final bool removeGpsOnShare;
  final String locationPermission;
  final String fontSize;
  final String mapStyle;
  final bool isSaving;

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

  factory UserState.fromFirestore(Map<String, dynamic> data) {
    final settings = Map<String, dynamic>.from(
      data['settings'] as Map? ?? const {},
    );

    return UserState(
      name: data['name'] as String? ?? '',
      age: settings['age'] as String? ?? '',
      occupation: settings['occupation'] as String? ?? '学生',
      homeLocation: settings['homeLocation'] as String? ?? '',
      hobbyTags: List<String>.from(data['hobbyTags'] as List? ?? const []),
      dailyStepGoal: (settings['dailyStepGoal'] as num?)?.toInt() ?? 6000,
      dailyDistanceGoal:
          (settings['dailyDistanceGoal'] as num?)?.toDouble() ?? 3.0,
      notificationEnabled: data['notificationEnabled'] as bool? ?? true,
      reminderEnabled: data['reminderEnabled'] as bool? ?? true,
      reminderTime: data['reminderTime'] as String? ?? '18:00',
      bgNotification: settings['bgNotification'] as bool? ?? true,
      removeGpsOnShare: settings['removeGpsOnShare'] as bool? ?? true,
      locationPermission:
          settings['locationPermission'] as String? ?? 'always',
      fontSize: settings['fontSize'] as String? ?? 'medium',
      mapStyle: settings['mapStyle'] as String? ?? 'game',
    );
  }

  Map<String, dynamic> toSettingsMap() {
    return {
      'age': age,
      'occupation': occupation,
      'homeLocation': homeLocation,
      'dailyStepGoal': dailyStepGoal,
      'dailyDistanceGoal': dailyDistanceGoal,
      'bgNotification': bgNotification,
      'removeGpsOnShare': removeGpsOnShare,
      'locationPermission': locationPermission,
      'fontSize': fontSize,
      'mapStyle': mapStyle,
    };
  }

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
  UserState build() {
    Future.microtask(loadSettings);
    return const UserState();
  }

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

  void toggleHobbyTag(String tag) {
    final current = List<String>.from(state.hobbyTags);
    if (current.contains(tag)) {
      current.remove(tag);
    } else {
      current.add(tag);
    }
    state = state.copyWith(hobbyTags: current);
  }

  Future<void> loadSettings() async {
    final user = ref.read(firebaseAuthProvider).currentUser;
    if (user == null) return;

    final data = await ref.read(userRepositoryProvider).fetchUserData(user.uid);
    if (data == null) return;

    state = UserState.fromFirestore(data);
  }

  Future<void> saveSettings() async {
    final user = ref.read(firebaseAuthProvider).currentUser;
    if (user == null) return;

    state = state.copyWith(isSaving: true);
    await ref.read(userRepositoryProvider).saveSettings(
          userId: user.uid,
          name: state.name,
          hobbyTags: state.hobbyTags,
          notificationEnabled: state.notificationEnabled,
          reminderEnabled: state.reminderEnabled,
          reminderTime: state.reminderTime,
          settings: state.toSettingsMap(),
        );
    state = state.copyWith(isSaving: false);
  }

  Future<void> deleteAccount() async {
    final user = ref.read(firebaseAuthProvider).currentUser;
    if (user == null) return;

    state = state.copyWith(isSaving: true);
    await ref.read(userRepositoryProvider).deleteUserData(user.uid);
    await user.delete();
    state = const UserState();
  }
}

final userProvider = NotifierProvider<UserNotifier, UserState>(
  UserNotifier.new,
);
