// lib/repositories/user_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';
import '../models/fragment_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _userRef(String userId) {
    return _firestore.collection('users').doc(userId);
  }

  Stream<UserModel?> watchUser(String userId) {
    return _userRef(userId).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null) return null;
      return UserModel.fromMap({...data, 'id': snapshot.id});
    });
  }

  Future<UserModel?> fetchUser(String userId) async {
    final snapshot = await _userRef(userId).get();
    final data = snapshot.data();
    if (data == null) return null;
    return UserModel.fromMap({...data, 'id': snapshot.id});
  }

  Future<Map<String, dynamic>?> fetchUserData(String userId) async {
    final snapshot = await _userRef(userId).get();
    final data = snapshot.data();
    if (data == null) return null;
    return {...data, 'id': snapshot.id};
  }

  Future<void> ensureUser({
    required String userId,
    String name = '',
  }) async {
    final ref = _userRef(userId);
    final snapshot = await ref.get();

    if (snapshot.exists) {
      await ref.set(
        {'updatedAt': FieldValue.serverTimestamp()},
        SetOptions(merge: true),
      );
      return;
    }

    await ref.set({
      'id': userId,
      'name': name,
      'level': 1,
      'exp': 0,
      'rank': 'beginner',
      'hobbyTags': <String>[],
      'notificationEnabled': true,
      'reminderEnabled': true,
      'reminderTime': '18:00',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> saveSettings({
    required String userId,
    required String name,
    required List<String> hobbyTags,
    required bool notificationEnabled,
    required bool reminderEnabled,
    required String reminderTime,
    required Map<String, dynamic> settings,
  }) {
    return _userRef(userId).set({
      'id': userId,
      'name': name,
      'hobbyTags': hobbyTags,
      'notificationEnabled': notificationEnabled,
      'reminderEnabled': reminderEnabled,
      'reminderTime': reminderTime,
      'settings': settings,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> updateStats(String userId, Map<String, dynamic> stats) {
    return _userRef(userId).collection('stats').doc('counters').set(
      stats,
      SetOptions(merge: true),
    );
  }

  Future<void> updateInventory(String userId, List<FragmentModel> fragments) async {
    final batch = _firestore.batch();
    final inventoryRef = _userRef(userId).collection('inventory');

    for (final fragment in fragments) {
      final docRef = inventoryRef.doc(fragment.itemMasterId);
      batch.set(docRef, {
        ...fragment.toMap(),
        'stackCount': FieldValue.increment(1),
        'collectedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    return batch.commit();
  }

  Future<void> unlockAchievement(String userId, String achievementId) {
    return _userRef(userId).collection('achievements').doc(achievementId).set({
      'id': achievementId,
      'unlockedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> deleteUserData(String userId) {
    return _userRef(userId).delete();
  }
}
