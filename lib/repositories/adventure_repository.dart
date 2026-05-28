// lib/repositories/adventure_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/adventure_model.dart';

class AdventureRepository {
  final FirebaseFirestore _firestore;

  AdventureRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _adventuresRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('adventures');
  }

  Stream<List<AdventureModel>> watchAdventures(String userId) {
    return _adventuresRef(userId)
        .orderBy('startTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return AdventureModel.fromMap({...doc.data(), 'id': doc.id});
      }).toList();
    });
  }

  Future<void> saveAdventure(AdventureModel adventure) {
    return _adventuresRef(adventure.userId).doc(adventure.id).set(
      adventure.toMap(),
      SetOptions(merge: true),
    );
  }
}
