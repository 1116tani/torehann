// lib/models/adventure_history_model.dart

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'fragment_model.dart';
import 'result_model.dart';

class AdventureHistoryModel {
  final String id;
  final DateTime createdAt;
  final String title;
  final String themeName;
  final String themeDescription;
  final String themeIcon;
  final String weather;
  final String aiReport;
  final double distanceKm;
  final int steps; // 👈 追加
  final int expGained; // 👈 追加
  final int durationMinutes;
  final bool isCompleted;
  final List<String> imageUrls;
  final List<LatLng> routePoints; // 👈 追加
  final List<FragmentModel> obtainedFragments; // 👈 追加（型変更）
  final List<String> unlockedAchievements; // 👈 追加
  final List<String> friendIds;
  final List<String> tags;

  const AdventureHistoryModel({
    required this.id,
    required this.createdAt,
    this.title = '名前のない冒険',
    this.themeName = 'ノーマル',
    this.themeDescription = '',
    this.themeIcon = 'map',
    this.weather = '晴れ',
    this.aiReport = '',
    this.distanceKm = 0.0,
    this.steps = 0,
    this.expGained = 0,
    this.durationMinutes = 0,
    this.isCompleted = true,
    this.imageUrls = const [],
    this.routePoints = const [],
    this.obtainedFragments = const [],
    this.unlockedAchievements = const [],
    this.friendIds = const [],
    this.tags = const [],
  });

  factory AdventureHistoryModel.fromMap(Map<String, dynamic> map) {
    return AdventureHistoryModel(
      id: map['id'] as String? ?? '',
      createdAt: _dateTimeFromMap(map['createdAt']) ?? DateTime.now(),
      title: map['title'] as String? ?? '名前のない冒険',
      themeName: map['themeName'] as String? ?? 'ノーマル',
      themeDescription: map['themeDescription'] as String? ?? '',
      themeIcon: map['themeIcon'] as String? ?? 'map',
      weather: map['weather'] as String? ?? '晴れ',
      aiReport: map['aiReport'] as String? ?? '',
      distanceKm: (map['distanceKm'] as num?)?.toDouble() ?? 0.0,
      steps: (map['steps'] as num?)?.toInt() ?? 0,
      expGained: (map['expGained'] as num?)?.toInt() ?? 0,
      durationMinutes: (map['durationMinutes'] as num?)?.toInt() ?? 0,
      isCompleted: map['isCompleted'] as bool? ?? true,
      imageUrls: List<String>.from(map['imageUrls'] as List? ?? const []),
      routePoints: (map['routePoints'] as List? ?? const [])
          .map((p) => LatLng(
                (p['lat'] as num).toDouble(),
                (p['lng'] as num).toDouble(),
              ))
          .toList(),
      obtainedFragments: (map['obtainedFragments'] as List? ?? const [])
          .map((f) => FragmentModel.fromMap(Map<String, dynamic>.from(f)))
          .toList(),
      unlockedAchievements: List<String>.from(map['unlockedAchievements'] as List? ?? const []),
      friendIds: List<String>.from(map['friendIds'] as List? ?? const []),
      tags: List<String>.from(map['tags'] as List? ?? const []),
    );
  }

  AdventureResult toResult() {
    return AdventureResult(
      id: id,
      title: title,
      subTitle: themeDescription,
      completedAt: createdAt,
      aiStory: aiReport,
      closingMessage: '', // 履歴からは空でOK
      distanceKm: distanceKm,
      steps: steps,
      calories: (steps * 0.04).round(),
      durationMinutes: durationMinutes,
      fragmentCount: obtainedFragments.length,
      expGained: expGained,
      weather: weather,
      themeIcon: themeIcon,
      routeMapImageUrl: '', // 必要なら別のURL
      routePoints: routePoints,
      photos: imageUrls.map((url) => ResultPhoto(imageUrl: url, caption: '冒険の思い出')).toList(),
      friends: friendIds.map((fid) => ResultFriend(id: fid, name: 'フレンド')).toList(),
      obtainedFragments: obtainedFragments,
      unlockedAchievements: unlockedAchievements,
      isCompleted: isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'title': title,
      'themeName': themeName,
      'themeDescription': themeDescription,
      'themeIcon': themeIcon,
      'weather': weather,
      'aiReport': aiReport,
      'distanceKm': distanceKm,
      'steps': steps,
      'expGained': expGained,
      'durationMinutes': durationMinutes,
      'isCompleted': isCompleted,
      'imageUrls': imageUrls,
      'routePoints': routePoints.map((p) => {'lat': p.latitude, 'lng': p.longitude}).toList(),
      'obtainedFragments': obtainedFragments.map((f) => f.toMap()).toList(),
      'unlockedAchievements': unlockedAchievements,
      'friendIds': friendIds,
      'tags': tags,
    };
  }

  static DateTime? _dateTimeFromMap(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    try {
      return (value as dynamic).toDate() as DateTime;
    } catch (_) {
      return null;
    }
  }
}
