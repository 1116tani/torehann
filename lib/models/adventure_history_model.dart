// lib/models/adventure_history_model.dart

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
  final int durationMinutes;
  final bool isCompleted;
  final List<String> imageUrls;
  final List<String> fragments;
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
    this.durationMinutes = 0,
    this.isCompleted = true,
    this.imageUrls = const [],
    this.fragments = const [],
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
      distanceKm: (map['distanceKm'] as num?)?.toDouble() ??
          (map['totalDistance'] as num?)?.toDouble() ??
          0.0,
      durationMinutes: (map['durationMinutes'] as num?)?.toInt() ??
          (map['estimatedTime'] as num?)?.toInt() ??
          0,
      isCompleted: map['isCompleted'] as bool? ?? true,
      imageUrls: List<String>.from(
        (map['imageUrls'] ?? map['photoUrls']) as List? ?? const [],
      ),
      fragments: List<String>.from(map['fragments'] as List? ?? const []),
      friendIds: List<String>.from(map['friendIds'] as List? ?? const []),
      tags: List<String>.from(map['tags'] as List? ?? const []),
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
      'durationMinutes': durationMinutes,
      'isCompleted': isCompleted,
      'imageUrls': imageUrls,
      'fragments': fragments,
      'friendIds': friendIds,
      'tags': tags,
    };
  }

  static DateTime? _dateTimeFromMap(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return (value as dynamic).toDate() as DateTime;
  }
}
