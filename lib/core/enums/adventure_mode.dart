// lib/core/enums/adventure_mode.dart

// ─────────────────────────────
// 🗺️ 難易度モード
// ─────────────────────────────

enum AdventureMode {
  // 短距離・のんびり散歩
  walk('お散歩', '1〜3km'),

  // 中距離・街探索
  explore('探索', '3〜6km'),

  // 長距離・本格冒険
  adventure('冒険', '6km以上');

  const AdventureMode(this.label, this.distanceRange);

  // Geminiプロンプト・UI表示用ラベル
  final String label;

  // 距離目安テキスト
  final String distanceRange;
}
