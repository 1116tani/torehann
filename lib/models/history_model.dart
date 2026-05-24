// lib/models/history_model.dart

class AdventureHistory {
  // ── 基本情報 ──
  final String id;
  final DateTime startedAt;

  // ── AIが彩る世界観データ ──
  final String title;
  final String weather;
  final String themeIcon;

  // ── スタッツ ──
  final double distanceKm;
  final int durationMinutes;

  // ── 冒険の詳細・思い出 ──
  final bool isCompleted;
  final List<String> photoUrls;
  final List<String> fragments;
  final List<String> friendIds;
  final List<String> tags;

  const AdventureHistory({
    required this.id,
    required this.startedAt,
    this.title = '名もなき冒険',
    this.weather = '☀️',
    this.themeIcon = '',
    this.distanceKm = 0.0,
    this.durationMinutes = 0,
    this.isCompleted = true,
    this.photoUrls = const [],
    this.fragments = const [],
    this.friendIds = const [],
    this.tags = const [],
  });

  factory AdventureHistory.fromMap(Map<String, dynamic> map) {
    return AdventureHistory(
      id: map['id'] ?? '',
      startedAt: map['startedAt'] != null
          ? (map['startedAt'] as dynamic).toDate()
          : DateTime.now(),
      title: map['title'] ?? '名もなき冒険',
      weather: map['weather'] ?? '☀️',
      themeIcon: map['themeIcon'] ?? '',
      distanceKm: (map['distanceKm'] ?? 0.0).toDouble(),
      durationMinutes: map['durationMinutes'] ?? 0,
      isCompleted: map['isCompleted'] ?? true,
      photoUrls: List<String>.from(map['photoUrls'] ?? []),
      fragments: List<String>.from(map['fragments'] ?? []),
      friendIds: List<String>.from(map['friendIds'] ?? []),
      tags: List<String>.from(map['tags'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startedAt': startedAt,
      'title': title,
      'weather': weather,
      'themeIcon': themeIcon,
      'distanceKm': distanceKm,
      'durationMinutes': durationMinutes,
      'isCompleted': isCompleted,
      'photoUrls': photoUrls,
      'fragments': fragments,
      'friendIds': friendIds,
      'tags': tags,
    };
  }
}