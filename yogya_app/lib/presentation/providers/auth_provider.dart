import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // Use MockAuthRepository to prevent Firebase crashing before `flutterfire configure` is run.
  // Switch to FirebaseAuthRepository() once you have configured Firebase.
  return MockAuthRepository();
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(() {
  return AuthController();
});

class AuthController extends AsyncNotifier<void> {
  late final AuthRepository _authRepository;

  @override
  FutureOr<void> build() {
    _authRepository = ref.watch(authRepositoryProvider);
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _authRepository.signInWithEmailAndPassword(email, password));
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _authRepository.createUserWithEmailAndPassword(email, password));
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _authRepository.signInWithGoogle());
  }

  Future<void> sendPasswordResetEmail(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _authRepository.sendPasswordResetEmail(email));
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _authRepository.signOut());
  }
}
