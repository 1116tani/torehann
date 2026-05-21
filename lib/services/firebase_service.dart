// lib/services/firebase_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/route_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore;

  FirebaseService() : _firestore = FirebaseFirestore.instance;

  /// ── 完了した冒険（日誌やルート）をFirestoreに保存する ──
  Future<void> saveAdventureHistory({
    required String userId,
    required RouteModel route,
    required String aiReport,
    required List<String> imageUrls,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('histories')
          .add({
            'routeId': route.id,
            'themeName': route.themeName,
            'themeDescription': route.themeDescription,
            'totalDistance': route.totalDistance,
            'estimatedTime': route.estimatedTime,
            'aiReport': aiReport,
            'imageUrls': imageUrls,
            'createdAt': FieldValue.serverTimestamp(), // 冒険を終えた時間
          });
    } catch (e) {
      throw Exception('Firestoreへの冒険の記録に失敗しちゃった…おねえちゃんが慰めてあげるからね：$e');
    }
  }

  /// ── 過去の冒険の記録（履歴一覧）を取得する ──
  Stream<QuerySnapshot<Map<String, dynamic>>> getAdventureHistories(
    String userId,
  ) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('histories')
        .orderBy('createdAt', descending: true) // 新しい順に並べるよ
        .snapshots();
  }
}
