// lib/services/storage_service.dart

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage;

  StorageService() : _storage = FirebaseStorage.instance;

  /// ── 冒険の思い出写真をFirebase Storageにアップロードする ──
  /// [imageFile]: スマホのカメラやギャラリーから取得した画像ファイル
  /// [userId]: ユーザーのID
  Future<String> uploadAdventureImage({
    required String userId,
    required File imageFile,
  }) async {
    try {
      // ファイル名が被らないように、タイムスタンプを使って一意のパスを作るよ
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = _storage.ref().child(
        'users/$userId/adventure_images/$fileName',
      );

      // 画像をアップロード！
      final uploadTask = await storageRef.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/jpeg'), // JPEG形式を指定して安全に
      );

      // アップロード完了後、アプリに表示するためのURL（ダウンロードURL）を取得して返すよ
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('画像のアップロードに失敗しました：$e');
    }
  }
}
