// lib/providers/history_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/firebase_service.dart';

// FirebaseServiceのインスタンスを提供するProvider（シングルトン）
final firebaseServiceProvider = Provider<FirebaseService>(
  (ref) => FirebaseService(),
);

// 💡 ユーザーIDごとの履歴一覧をリアルタイム監視するStreamProvider
// 本番は認証（Auth）からユーザーIDを取るけど、今は dummy_user_id にしておくね！
final adventureHistoryProvider = StreamProvider.autoDispose((ref) {
  final firebaseService = ref.read(firebaseServiceProvider);
  const dummyUserId = 'mi_kun_hero_001';

  return firebaseService.getAdventureHistories(dummyUserId).map((snapshot) {
    // Firestoreのドキュメントを扱いやすいMapのリストに変換してUIに渡すよ
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'themeName': data['themeName'] ?? '名もなき散歩道',
        'themeDescription': data['themeDescription'] ?? '',
        'totalDistance': (data['totalDistance'] ?? 0.0).toDouble(),
        'estimatedTime': data['estimatedTime'] ?? 0,
        'aiReport': data['aiReport'] ?? '',
        'imageUrls': List<String>.from(data['imageUrls'] ?? []),
        'createdAt': data['createdAt'] != null
            ? (data['createdAt'] as dynamic).toDate() as DateTime
            : DateTime.now(),
      };
    }).toList();
  });
});
