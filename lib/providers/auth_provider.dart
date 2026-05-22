// lib/providers/auth_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// ── 💡 Firebase Authのインスタンスを提供するProvider ──
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// ── 💡 現在のログイン状態（Userかnullか）をリアルタイムに監視するProvider ──
final authStateProvider = StreamProvider<User?>((ref) {
  // 💡 ダミーのユーザーオブジェクトを作って、強制的に「ログイン済み」にしちゃうよ！
  // これで AuthGate は絶対に HomeScreen を開いてくれます！
  return Stream.value(FirebaseAuth.instance.currentUser ?? _DummyUser());
});

/// ── 💡 匿名ログインの処理を担当するコントローラー ──
final authControllerProvider = Provider((ref) {
  return AuthController(ref.watch(firebaseAuthProvider));
});

class AuthController {
  final FirebaseAuth _auth;
  AuthController(this._auth);

  /// 🪄 匿名ログインを呼び出す
  Future<UserCredential?> signInAnonymously() async {
    try {
      // 💡 Firebaseのエラーで止まらないように、ここもお休みさせるよ
      print('デバッグ中だからFirebase通信はスキップするよ！');
      return null;
    } catch (e) {
      print('サインインに失敗しました…: $e');
      return null;
    }
  }

  /// 🚪 ログアウト
  Future<void> signOut() async {
    // お休み中
  }
}

// 💡 強制ホーム用のダミーユーザー定義（一応用意しておくね）
class _DummyUser implements User {
  @override
  String get uid => 'dummy_master_mii_kun';
  @override
  bool get isAnonymous => true;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
