
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/services/auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl(this._authService);

  @override
  Future<UserProfile> login(String email, String password) async {
    final result = await _authService.signInWithEmail(
      email:    email,
      password: password,
    );
    if (!result.success || result.user == null) {
      throw Exception(result.errorMessage);
    }
    return _mapFirebaseUser(result.user!);
  }

  @override
  Future<void> logout() async {
    await _authService.signOut();
  }

  @override
  Future<UserProfile?> getCurrentUser() async {
    final fbUser = _authService.currentUser;
    if (fbUser == null) return null;
    return _mapFirebaseUser(fbUser);
  }

  // Maps Firebase User → domain UserProfile entity
  UserProfile _mapFirebaseUser(fb.User user) {
    return UserProfile(
      id:       user.uid,
      name:     user.displayName ?? 'Aspirant',
      email:    user.email ?? '',
      category: 'General', // default; user updates in Profile screen
    );
  }
}
