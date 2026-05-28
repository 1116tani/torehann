// lib/providers/auth_provider.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../repositories/auth_repository.dart';
import '../repositories/user_repository.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final loggerProvider = Provider<Logger>((ref) {
  return Logger();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(auth: ref.watch(firebaseAuthProvider));
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(
    ref.watch(authRepositoryProvider),
    ref.watch(userRepositoryProvider),
    ref.watch(loggerProvider),
  );
});

class AuthController {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final Logger _logger;

  AuthController(
    this._authRepository,
    this._userRepository,
    this._logger,
  );

  Future<UserCredential?> signInAnonymously() async {
    try {
      final credential = await _authRepository.signInAnonymously();
      final user = credential.user;

      if (user != null) {
        await _userRepository.ensureUser(userId: user.uid);
      }

      _logger.i('Anonymous sign-in succeeded: ${user?.uid}');
      return credential;
    } on FirebaseAuthException catch (e, st) {
      _logger.e(
        'Firebase anonymous sign-in failed: ${e.code} ${e.message}',
        error: e,
        stackTrace: st,
      );
      return null;
    } catch (e, st) {
      _logger.e(
        'Anonymous sign-in failed',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }
}
