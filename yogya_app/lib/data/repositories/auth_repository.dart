import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<User?> createUserWithEmailAndPassword(String email, String password);
  Future<User?> signInWithGoogle();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> signOut();
}

class MockAuthRepository implements AuthRepository {
  @override
  Stream<User?> get authStateChanges => Stream.value(null);

  @override
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    if (email.contains("test") && password.isNotEmpty) return null; 
    return null;
  }

  @override
  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    return null;
  }

  @override
  Future<User?> signInWithGoogle() async {
    await Future.delayed(const Duration(seconds: 2));
    return null;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
