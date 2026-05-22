// lib/services/firebase_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/route_model.dart';

class FirebaseService {
  // 💡 ここを修正！変数ではなく、getter（使う時に呼び出す）にするよ
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  /// ── 完了した冒険（日誌やルート）をFirestoreに保存する ──
  Future<void> saveAdventureHistory({
    required String userId,
    required RouteModel route,
    required String aiReport,
    required List<String> imageUrls,
  }) async {
    try {
      await _firestore // ← 使う時に初めてinstanceが呼ばれるから安全！
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
            'createdAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw Exception('Firestoreへの冒険の記録に失敗しました：$e');
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
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
