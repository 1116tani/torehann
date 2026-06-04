// lib/models/achievement_model.dart

/// ── 実績の達成ランク ──
enum AchievementRank { none, copper, silver, gold }

/// ── 実績のデータ構造モデル ──
class AchievementModel {
  final String id;
  final String title;
  final String description;
  final double currentCount; // 進捗数値
  final double copperValue; // 銅の基準
  final double silverValue; // 銀の基準
  final double goldValue; // 金の基準
  final String unit; // 単位（km, 回, 個など）
  final DateTime? unlockedAt; // 解放日時

  AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.currentCount,
    required this.copperValue,
    required this.silverValue,
    required this.goldValue,
    required this.unit,
    this.unlockedAt,
  });

  // 現在どのランクにいるかを判定するよ
  AchievementRank get currentRank {
    if (currentCount >= goldValue) return AchievementRank.gold;
    if (currentCount >= silverValue) return AchievementRank.silver;
    if (currentCount >= copperValue) return AchievementRank.copper;
    return AchievementRank.none;
  }

  bool get isUnlocked => currentRank != AchievementRank.none;

  // 次の目標値を設定するよ
  double get nextThreshold {
    switch (currentRank) {
      case AchievementRank.none:
        return copperValue;
      case AchievementRank.copper:
        return silverValue;
      case AchievementRank.silver:
        return goldValue;
      case AchievementRank.gold:
        return goldValue; // 金到達後は最大値のまま
    }
  }

  // 進捗バー用の割合（0.0 〜 1.0）を計算するよ
  double get progressRatio {
    if (currentCount >= goldValue) return 1.0;
    return (currentCount / nextThreshold).clamp(0.0, 1.0);
  }

  AchievementModel copyWith({
    String? id,
    String? title,
    String? description,
    double? currentCount,
    double? copperValue,
    double? silverValue,
    double? goldValue,
    String? unit,
    DateTime? unlockedAt,
  }) {
    return AchievementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      currentCount: currentCount ?? this.currentCount,
      copperValue: copperValue ?? this.copperValue,
      silverValue: silverValue ?? this.silverValue,
      goldValue: goldValue ?? this.goldValue,
      unit: unit ?? this.unit,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}