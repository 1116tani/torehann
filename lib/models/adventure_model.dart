// lib/models/adventure_model.dart

class AdventureModel {
  final String id;
  final String userId;
  final String routeId;
  final String status; // 状態管理（'walking'：冒険中、'completed'：クリア、'cancelled'：中断）
  final DateTime? startTime; // 冒険を始めた時間
  final DateTime? endTime; // 冒険が終わった時間
  final int steps; // 歩数
  final double distance; // 実際に歩いた距離（km）
  final List<String> fragmentIds; // この冒険中に拾った「街の断片（Fragment）」のIDリスト
  final String aiReport; // リザルト画面で絵巻物風に表示する、AIからの総評メッセージ

  const AdventureModel({
    required this.id,
    required this.userId,
    required this.routeId,
    this.status = 'walking',
    this.startTime,
    this.endTime,
    this.steps = 0,
    this.distance = 0.0,
    this.fragmentIds = const [],
    this.aiReport = '',
  });

  // FirestoreのMapからAdventureModelを作る
  factory AdventureModel.fromMap(Map<String, dynamic> map) {
    DateTime? parsedStartTime;
    if (map['startTime'] != null) {
      parsedStartTime = (map['startTime'] as dynamic).toDate();
    }

    DateTime? parsedEndTime;
    if (map['endTime'] != null) {
      parsedEndTime = (map['endTime'] as dynamic).toDate();
    }

    return AdventureModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      routeId: map['routeId'] ?? '',
      status: map['status'] ?? 'walking',
      startTime: parsedStartTime,
      endTime: parsedEndTime,
      fragmentIds: List<String>.from(map['fragmentIds'] ?? []),
      aiReport: map['aiReport'] ?? '',
    );
  }

  // FirestoreにMapとして保存する
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'routeId': routeId,
      'status': status,
      'startTime': startTime,
      'endTime': endTime,
      'fragmentIds': fragmentIds,
      'aiReport': aiReport,
    };
  }
}
