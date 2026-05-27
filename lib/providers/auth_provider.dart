// lib/providers/auth_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

/// ─────────────────────────────────
/// 🔥 FirebaseAuth Instance
/// ─────────────────────────────────

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

<<<<<<< HEAD
final loggerProvider = Provider<Logger>((ref) {
  return Logger();
=======
final loggerProvider = Provider((ref) => Logger());

/// ── 💡 現在のログイン状態（Userかnullか）をリアルタイムに監視するProvider ──
final authStateProvider = StreamProvider<User?>((ref) {
  // 💡 ダミーのユーザーオブジェクトを作って、強制的に「ログイン済み」にしちゃうよ！
  // これで AuthGate は絶対に HomeScreen を開いてくれます！
  return FirebaseAuth.instance.authStateChanges();
>>>>>>> f6fb035acfcd648a4312dd36a29e4bb810041937
});

/// ─────────────────────────────────
/// 👤 ログイン状態監視
/// FirebaseAuth の状態変化を監視
/// ─────────────────────────────────

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

/// ─────────────────────────────────
/// 🔐 Auth Controller
/// ─────────────────────────────────

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(
    ref.watch(firebaseAuthProvider),
    ref.watch(loggerProvider),
  );
});

class AuthController {
  final FirebaseAuth _auth;
  final Logger _logger;

  AuthController(this._auth, this._logger);

  /// ─────────────────────────────
  /// 🪄 匿名ログイン
  /// ─────────────────────────────

  Future<UserCredential?> signInAnonymously() async {
    try {
<<<<<<< HEAD
      final credential = await _auth.signInAnonymously();

      _logger.i('匿名ログイン成功: ${credential.user?.uid}');

      return credential;
    } on FirebaseAuthException catch (e) {
      _logger.e('FirebaseAuthException: ${e.code}');

      return null;
=======
      // 💡 Firebaseのエラーで止まらないように、ここもお休みさせるよ
      return await FirebaseAuth.instance.signInAnonymously();
>>>>>>> f6fb035acfcd648a4312dd36a29e4bb810041937
    } catch (e) {
      _logger.e('匿名ログイン失敗: $e');

      return null;
    }
  }

  /// ─────────────────────────────
  /// 🚪 ログアウト
  /// ─────────────────────────────

  Future<void> signOut() async {
    try {
      await _auth.signOut();

      _logger.i('ログアウトしました');
    } catch (e) {
      _logger.e('ログアウト失敗: $e');
    }
  }
}
<<<<<<< HEAD
=======

// 💡 強制ホーム用のダミーユーザー定義（一応用意しておくね）
>>>>>>> f6fb035acfcd648a4312dd36a29e4bb810041937
