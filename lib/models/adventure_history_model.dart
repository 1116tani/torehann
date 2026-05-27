// lib/models/adventure_history_model.dart

class AdventureHistoryModel {
  // ── 基本情報 ──
  final String id;
  final DateTime createdAt; // 冒険が作成・完了した日時

  // ── AIが彩る世界観データ ──
  final String title;            // AIが命名した冒険のタイトル
  final String themeName;        // 「ファンタジー」「サイバーパンク」などのテーマ名
  final String themeDescription; // そのテーマのフレーバーテキスト・説明文
  final String themeIcon;        // テーマを表現するアイコン
  final String weather;          // ☀️、☁️、☔ などの天気文字
  final String aiReport;         // 📜 Geminiが紡いだ、今回の冒険のオリジナル物語（巻物用！）

  // ── スタッツ（計測された数値） ──
  final double distanceKm;       // 実際に歩いた距離（km）
  final int durationMinutes;     // 実際にかかった時間（分）

  // ── 冒険の詳細・思い出 ──
  final bool isCompleted;        // 無事にゴールできたかどうかのフラグ
  final List<String> imageUrls;   // 📸 冒険中に撮影した写真のストレージURL（photoUrlsから改名）
  final List<String> fragments;   // 🎒 この冒険でドロップした「街の断片」のIDリスト
  final List<String> friendIds;   // 👥 一緒に歩いたフレンドのUIDリスト
  final List<String> tags;        // 「カフェ寄り道」「坂道多め」などの特徴タグ

  const AdventureHistoryModel({
    required this.id,
    required this.createdAt,
    this.title = '名もなき冒険',
    this.themeName = 'ノーマル',
    this.themeDescription = '',
    this.themeIcon = '🧭',
    this.weather = '☀️',
    this.aiReport = '',
    this.distanceKm = 0.0,
    this.durationMinutes = 0,
    this.isCompleted = true,
    this.imageUrls = const [],
    this.fragments = const [],
    this.friendIds = const [],
    this.tags = const [],
  });

  // 🔌 FirestoreのデータをDartのオブジェクトに変換する職人技
  factory AdventureHistoryModel.fromMap(Map<String, dynamic> map) {
    return AdventureHistoryModel(
      id: map['id'] ?? '',
      // FirestoreのTimestamp型をDateTime型に安全に変換するよ
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
      title: map['title'] ?? '名もなき冒険',
      themeName: map['themeName'] ?? 'ノーマル',
      themeDescription: map['themeDescription'] ?? '',
      themeIcon: map['themeIcon'] ?? '🧭',
      weather: map['weather'] ?? '☀️',
      aiReport: map['aiReport'] ?? '',
      distanceKm: (map['distanceKm'] ?? 0.0).toDouble(),
      durationMinutes: map['durationMinutes'] ?? 0,
      isCompleted: map['isCompleted'] ?? true,
      // 被っていたphotoUrlsとimageUrlsを、2つ目の名前に合わせて美しく統合！
      imageUrls: List<String>.from(map['imageUrls'] ?? map['photoUrls'] ?? []),
      fragments: List<String>.from(map['fragments'] ?? []),
      friendIds: List<String>.from(map['friendIds'] ?? []),
      tags: List<String>.from(map['tags'] ?? []),
    );
  }

  // 💾 データをFirestoreに保存できる形（Map）に変換する関数
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
}