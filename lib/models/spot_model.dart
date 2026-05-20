// lib/models/spot_model.dart

class SpotModel {
  final String id;
  final double lat;
  final double lng;
  final String name; // 現実のスポット名（例：〇〇公園）
  final String category; // カテゴリ（例：公園、カフェ、史跡など）
  final String aiStoryName; // AIが付けた物語風の名前（例：忘れられた緑のオアシス）
  final String aiFlavorText; // AIが生成したその場所での実況やフレーバーテキスト

  const SpotModel({
    required this.id,
    required this.lat,
    required this.lng,
    required this.name,
    this.category = '',
    this.aiStoryName = '',
    this.aiFlavorText = '',
  });

  // FirestoreのMapからSpotModelを作る
  factory SpotModel.fromMap(Map<String, dynamic> map) {
    return SpotModel(
      id: map['id'] ?? '',
      // lat/lngはFirestoreから取得する際にdouble型へのキャストエラーを防ぐため.toDouble()を使用
      lat: (map['lat'] ?? 0.0).toDouble(),
      lng: (map['lng'] ?? 0.0).toDouble(),
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      aiStoryName: map['aiStoryName'] ?? '',
      aiFlavorText: map['aiFlavorText'] ?? '',
    );
  }

  // FirestoreにMapとして保存する
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lat': lat,
      'lng': lng,
      'name': name,
      'category': category,
      'aiStoryName': aiStoryName,
      'aiFlavorText': aiFlavorText,
    };
  }
}
