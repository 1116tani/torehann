// lib/models/settings_model.dart

class SettingsState {
  final String userName;
  final int age;
  final double dailyGoalKm;
  final int dailyStepGoal; // 既存の health_page などの互換性のために保持
  final List<String> favoriteTags;
  final bool reminderEnabled;
  final bool backgroundNotificationEnabled;
  final String mapStyle;
  final String textSize;
  final String themeMode;
  final String locationPermission;
  final bool photoPermission;
  
  // 場所ピン
  final String homeLocation;
  final String workLocation;
  final String favoriteLocation;

  final bool isSaving;

  const SettingsState({
    this.userName = '',
    this.age = 20,
    this.dailyGoalKm = 3.0,
    this.dailyStepGoal = 6000,
    this.favoriteTags = const [],
    this.reminderEnabled = true,
    this.backgroundNotificationEnabled = true,
    this.mapStyle = 'game',
    this.textSize = 'medium',
    this.themeMode = 'default',
    this.locationPermission = 'always',
    this.photoPermission = true,
    this.homeLocation = '',
    this.workLocation = '',
    this.favoriteLocation = '',
    this.isSaving = false,
  });

  factory SettingsState.fromMap(Map<String, dynamic> map) {
    return SettingsState(
      userName: map['userName'] as String? ?? '',
      age: (map['age'] as num?)?.toInt() ?? 20,
      dailyGoalKm: (map['dailyGoalKm'] as num?)?.toDouble() ?? 3.0,
      dailyStepGoal: (map['dailyStepGoal'] as num?)?.toInt() ?? 6000,
      favoriteTags: List<String>.from(map['favoriteTags'] as List? ?? const []),
      reminderEnabled: map['reminderEnabled'] as bool? ?? true,
      backgroundNotificationEnabled: map['backgroundNotificationEnabled'] as bool? ?? true,
      mapStyle: map['mapStyle'] as String? ?? 'game',
      textSize: map['textSize'] as String? ?? 'medium',
      themeMode: map['themeMode'] as String? ?? 'default',
      locationPermission: map['locationPermission'] as String? ?? 'always',
      photoPermission: map['photoPermission'] as bool? ?? true,
      homeLocation: map['homeLocation'] as String? ?? '',
      workLocation: map['workLocation'] as String? ?? '',
      favoriteLocation: map['favoriteLocation'] as String? ?? '',
      isSaving: map['isSaving'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'age': age,
      'dailyGoalKm': dailyGoalKm,
      'dailyStepGoal': dailyStepGoal,
      'favoriteTags': favoriteTags,
      'reminderEnabled': reminderEnabled,
      'backgroundNotificationEnabled': backgroundNotificationEnabled,
      'mapStyle': mapStyle,
      'textSize': textSize,
      'themeMode': themeMode,
      'locationPermission': locationPermission,
      'photoPermission': photoPermission,
      'homeLocation': homeLocation,
      'workLocation': workLocation,
      'favoriteLocation': favoriteLocation,
    };
  }

  SettingsState copyWith({
    String? userName,
    int? age,
    double? dailyGoalKm,
    int? dailyStepGoal,
    List<String>? favoriteTags,
    bool? reminderEnabled,
    bool? backgroundNotificationEnabled,
    String? mapStyle,
    String? textSize,
    String? themeMode,
    String? locationPermission,
    bool? photoPermission,
    String? homeLocation,
    String? workLocation,
    String? favoriteLocation,
    bool? isSaving,
  }) {
    return SettingsState(
      userName: userName ?? this.userName,
      age: age ?? this.age,
      dailyGoalKm: dailyGoalKm ?? this.dailyGoalKm,
      dailyStepGoal: dailyStepGoal ?? this.dailyStepGoal,
      favoriteTags: favoriteTags ?? this.favoriteTags,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      backgroundNotificationEnabled: backgroundNotificationEnabled ?? this.backgroundNotificationEnabled,
      mapStyle: mapStyle ?? this.mapStyle,
      textSize: textSize ?? this.textSize,
      themeMode: themeMode ?? this.themeMode,
      locationPermission: locationPermission ?? this.locationPermission,
      photoPermission: photoPermission ?? this.photoPermission,
      homeLocation: homeLocation ?? this.homeLocation,
      workLocation: workLocation ?? this.workLocation,
      favoriteLocation: favoriteLocation ?? this.favoriteLocation,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
