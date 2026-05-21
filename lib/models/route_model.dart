// lib/models/route_model.dart

import 'spot_model.dart';

class RouteModel {
  final String id;
  final String themeName; // AIが生成した物語のテーマ（例：「探偵の怪しい調査」「深夜の逃避行」）
  final List<String> spotIds; // 巡るスポット（SpotModel）のIDを順番通りに格納するリスト
  final double totalDistance; // 総移動距離（kmまたはm）
  final int estimatedTime; // 予測所要時間（分）
  final String themeDescription;
  final List<String> tags;
  final List<SpotModel> generatedSpots; // Geminiが生成したスポット情報
  final DateTime? createdAt; // ルートが生成された日時

  const RouteModel({
    required this.id,
    required this.themeName,
    required this.themeDescription,
    required this.tags,
    required this.generatedSpots,
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
      generatedSpots: (map['generatedSpots'] as List<dynamic>?)
              ?.map((item) => SpotModel.fromMap(item as Map<String, dynamic>))
              .toList() ?? [],
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
      'generatedSpots': generatedSpots.map((spot) => spot.toMap()).toList(),
      'createdAt': createdAt, // Firebaseに保存する時は自動でTimestampに変換されるよ
    };
  }
}
