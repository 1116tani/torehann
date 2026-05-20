// lib/models/route_model.dart

class RouteModel {
  final String id;
  final String themeName; // AIが生成した物語のテーマ（例：「探偵の怪しい調査」「深夜の逃避行」）
  final List<String> spotIds; // 巡るスポット（SpotModel）のIDを順番通りに格納するリスト
  final double totalDistance; // 総移動距離（kmまたはm）
  final int estimatedTime; // 予測所要時間（分）
  final String themeDescription;
  final List<String> tags;
  final DateTime? createdAt; // ルートが生成された日時

  const RouteModel({
    required this.id,
    required this.themeName,
    required this.themeDescription,
    required this.tags,
    this.spotIds = const [],
    this.totalDistance = 0.0,
    this.estimatedTime = 0,
    this.createdAt,
  });

  // FirestoreのMapからRouteModelを作る
  factory RouteModel.fromMap(Map<String, dynamic> map) {
    // FirestoreのTimestamp型を安全にDateTimeに変換するよ
    DateTime? parsedDate;
    if (map['createdAt'] != null) {
      parsedDate = (map['createdAt'] as dynamic).toDate();
    }

    return RouteModel(
      id: map['id'] ?? '',
      themeName: map['themeName'] ?? '名もなき散歩道',
      spotIds: List<String>.from(map['spotIds'] ?? []),
      totalDistance: (map['totalDistance'] ?? 0.0).toDouble(),
      estimatedTime: map['estimatedTime'] ?? 0,
      themeDescription: map['themeDescription'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      createdAt: parsedDate,
    );
  }

  // FirestoreにMapとして保存する
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'themeName': themeName,
      'themeDescription': themeDescription,
      'tags': tags,
      'spotIds': spotIds,
      'totalDistance': totalDistance,
      'estimatedTime': estimatedTime,
      'createdAt': createdAt, // Firebaseに保存する時は自動でTimestampに変換されるよ
    };
  }
}
