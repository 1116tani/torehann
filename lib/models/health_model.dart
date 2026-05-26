// lib/models/health_model.dart

class HealthModel {
  final DateTime date;        // 日付（サマリーの場合は集計終了日など）
  final int steps;            // 歩数
  final double distanceKm;    // 移動距離 (km)
  final int calories;         // 消費カロリー (kcal)
  final int activeMinutes;    // アクティブ時間（分）

  const HealthModel({
    required this.date,
    this.steps = 0,
    this.distanceKm = 0.0,
    this.calories = 0,
    this.activeMinutes = 0,
  });

  // 🔄 UI側で「歩数だけを100歩増やしたい」という時に安全にコピーできる便利関数
  HealthModel copyWith({
    DateTime? date,
    int? steps,
    double? distanceKm,
    int? calories,
    int? activeMinutes,
  }) {
    return HealthModel(
      date: date ?? this.date,
      steps: steps ?? this.steps,
      distanceKm: distanceKm ?? this.distanceKm,
      calories: calories ?? this.calories,
      activeMinutes: activeMinutes ?? this.activeMinutes,
    );
  }

  // 🔌 バックエンドやHealthKit等からデータを受け取る用の変換
  factory HealthModel.fromMap(Map<String, dynamic> map) {
    return HealthModel(
      date: map['date'] != null ? (map['date'] as dynamic).toDate() : DateTime.now(),
      steps: map['steps'] ?? 0,
      distanceKm: (map['distanceKm'] ?? 0.0).toDouble(),
      calories: map['calories'] ?? 0,
      activeMinutes: map['activeMinutes'] ?? 0,
    );
  }

  // 💾 データを保存したり送信したりする用のMap変換
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'steps': steps,
      'distanceKm': distanceKm,
      'calories': calories,
      'activeMinutes': activeMinutes,
    };
  }
}