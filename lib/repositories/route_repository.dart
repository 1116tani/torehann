// lib/repositories/route_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/route_model.dart';

class RouteRepository {
  final FirebaseFirestore _firestore;

  RouteRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// ── 新規作成された冒険ルートをFirestoreに保存する ──
  Future<void> saveRoute(RouteModel route) async {
    try {
      await _firestore
          .collection('routes')
          .doc(route.id)
          .set(route.toMap());
    } catch (e) {
      throw Exception('ルートの保存に失敗しました: $e');
    }
  }

  /// ── 指定されたIDの冒険ルートを取得する ──
  Future<RouteModel?> getRoute(String routeId) async {
    try {
      final doc = await _firestore.collection('routes').doc(routeId).get();
      if (doc.exists && doc.data() != null) {
        return RouteModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('ルートの取得に失敗しました: $e');
    }
  }

  /// ── ユーザーが作成した全ルート、または最新のルート一覧を取得する ──
  Future<List<RouteModel>> getLatestRoutes({int limit = 10}) async {
    try {
      final snapshot = await _firestore
          .collection('routes')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => RouteModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('最新ルート一覧の取得に失敗しました: $e');
    }
  }

  /// ── 特定のタグ（例: 公園, カフェ）を持つルートを取得する ──
  Future<List<RouteModel>> getRoutesByTag(String tag) async {
    try {
      final snapshot = await _firestore
          .collection('routes')
          .where('tags', arrayContains: tag)
          .get();

      return snapshot.docs
          .map((doc) => RouteModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('タグによるルート検索に失敗しました: $e');
    }
  }
}

// 💡 アプリ全体から依存性注入できるよう、RiverpodのProviderを定義しておくよ！
final routeRepositoryProvider = Provider<RouteRepository>((ref) {
  return RouteRepository();
});
