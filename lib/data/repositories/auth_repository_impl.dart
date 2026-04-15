
// import 'package:firebase_auth/firebase_auth.dart' as fb;
// import '../../domain/entities/user_profile.dart';
// import '../../domain/repositories/auth_repository.dart';
// import '../../core/services/auth_service.dart';

// class AuthRepositoryImpl implements AuthRepository {
//   final AuthService _authService;

//   AuthRepositoryImpl(this._authService);

//   @override
//   Future<UserProfile> login(String email, String password) async {
//     final result = await _authService.signInWithEmail(
//       email:    email,
//       password: password,
//     );
//     if (!result.success || result.user == null) {
//       throw Exception(result.errorMessage);
//     }
//     return _mapFirebaseUser(result.user!);
//   }

//   @override
//   Future<void> logout() async {
//     await _authService.signOut();
//   }

//   @override
//   Future<UserProfile?> getCurrentUser() async {
//     final fbUser = _authService.currentUser;
//     if (fbUser == null) return null;
//     return _mapFirebaseUser(fbUser);
//   }

//   // Maps Firebase User → domain UserProfile entity
//   UserProfile _mapFirebaseUser(fb.User user) {
//     return UserProfile(
//       id:       user.uid,
//       name:     user.displayName ?? 'Aspirant',
//       email:    user.email ?? '',
//       category: 'General', // default; user updates in Profile screen
//     );
//   }
// }


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

  // 👇 YAHAN SE NAYA CODE ADD KIYA HAI FORGET PASSWORD KE LIYE 👇
  @override
  Future<void> resetPassword(String email) async {
    // Ye line AuthService ke andar reset function ko call karegi
    final result = await _authService.sendPasswordReset(email);
    
    // Agar koi error aayi (jaise email exist nahi karta), toh Exception throw karenge
    if (!result.success) {
      throw Exception(result.errorMessage ?? 'Failed to send reset link');
    }
  }
  // 👆 NAYA CODE YAHAN KHATAM HUA 👆

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