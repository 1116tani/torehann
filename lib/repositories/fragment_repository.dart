// lib/repositories/fragment_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/fragment_model.dart';

class FragmentRepository {
  final FirebaseFirestore _firestore;

  FragmentRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _fragmentsRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('fragments');
  }

  /// ユーザーの断片コレクションを監視するストリームを取得する
  Stream<List<FragmentModel>> watchFragments(String userId) {
    return _fragmentsRef(userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return FragmentModel.fromMap({...doc.data(), 'id': doc.id});
      }).toList();
    });
  }

  /// ユーザーの断片コレクションを取得し、itemMasterIdキーのMapに変換して返す
  Future<Map<String, FragmentModel>> fetchFragmentsMap(String userId) async {
    final snapshot = await _fragmentsRef(userId).get();
    final map = <String, FragmentModel>{};
    for (final doc in snapshot.docs) {
      final frag = FragmentModel.fromMap({...doc.data(), 'id': doc.id});
      map[frag.itemMasterId] = frag;
    }
    return map;
  }

  /// 断片データを保存（作成または上書き）する
  Future<void> saveFragment(String userId, FragmentModel fragment) {
    return _fragmentsRef(userId).doc(fragment.itemMasterId).set(
      fragment.toMap(),
      SetOptions(merge: true),
    );
  }
}
