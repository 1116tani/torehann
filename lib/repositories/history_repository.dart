// lib/repositories/history_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/adventure_history_model.dart';

class HistoryRepository {
  final FirebaseFirestore _firestore;

  HistoryRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _historiesRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('histories');
  }

  Stream<List<AdventureHistoryModel>> watchHistories(String userId) {
    return _historiesRef(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return AdventureHistoryModel.fromMap({...doc.data(), 'id': doc.id});
      }).toList();
    });
  }

  Future<List<AdventureHistoryModel>> fetchHistories(String userId) async {
    final snapshot =
        await _historiesRef(userId).orderBy('createdAt', descending: true).get();
    return snapshot.docs.map((doc) {
      return AdventureHistoryModel.fromMap({...doc.data(), 'id': doc.id});
    }).toList();
  }

  Future<void> saveHistory({
    required String userId,
    required AdventureHistoryModel history,
  }) {
    final doc = history.id.isEmpty ? _historiesRef(userId).doc() : _historiesRef(userId).doc(history.id);
    return doc.set({
      ...history.toMap(),
      'id': doc.id,
      'createdAt': history.createdAt,
    }, SetOptions(merge: true));
  }
}
