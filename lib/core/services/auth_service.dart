import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Keys used in secure storage.
class _StorageKeys {
  static const String firebaseUid = 'yogya_uid';
  static const String userEmail = 'yogya_email';
  static const String displayName = 'yogya_display_name';
  static const String photoUrl = 'yogya_photo_url';
  static const String isLoggedIn = 'yogya_logged_in';
}

/// Result wrapper so callers can handle auth outcomes safely.
class AuthResult {
  final bool success;
  final String? errorMessage;
  final User? user;

  const AuthResult.success(this.user)
      : success = true,
        errorMessage = null;

  const AuthResult.failure(this.errorMessage)
      : success = false,
        user = null;
}

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<bool> get isLoggedIn async {
    final value = await _storage.read(key: _StorageKeys.isLoggedIn);
    return value == 'true' && _auth.currentUser != null;
  }

  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        return const AuthResult.failure(
          'Authentication failed. Please try again.',
        );
      }

      await _persistSession(user);
      return AuthResult.success(user);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_mapFirebaseError(e.code));
    } catch (_) {
      return const AuthResult.failure('Something went wrong. Please try again.');
    }
  }

  Future<AuthResult> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        return const AuthResult.failure(
          'Authentication failed. Please try again.',
        );
      }

      await user.updateDisplayName(displayName.trim());
      await user.reload();
      final refreshedUser = _auth.currentUser;
      if (refreshedUser == null) {
        return const AuthResult.failure(
          'Authentication failed. Please try again.',
        );
      }

      await _persistSession(refreshedUser);
      return AuthResult.success(refreshedUser);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_mapFirebaseError(e.code));
    } catch (_) {
      return const AuthResult.failure('Something went wrong. Please try again.');
    }
  }

  Future<AuthResult> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return const AuthResult.success(null);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_mapFirebaseError(e.code));
    } catch (_) {
      return const AuthResult.failure(
        'Unable to send reset email right now.',
      );
    }
  }

  Future<AuthResult> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return const AuthResult.failure('Google sign-in was cancelled.');
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final authCredential = await _auth.signInWithCredential(credential);
      final user = authCredential.user;
      if (user == null) {
        return const AuthResult.failure('Google sign-in failed. Please try again.');
      }

      await _persistSession(user);
      return AuthResult.success(user);
    } on FirebaseAuthException catch (e) {
      var errorMessage = _mapFirebaseError(e.code);
      if (e.code.contains('invalid-api-key') ||
          e.code.contains('permission-denied')) {
        errorMessage =
            'Firebase configuration issue. Please check project settings.';
      }
      return AuthResult.failure(errorMessage);
    } catch (e) {
      final rawError = e.toString();
      if (rawError.contains('PlatformException')) {
        return const AuthResult.failure(
          'Google Play Services issue. Please update Google Play Services.',
        );
      }
      return const AuthResult.failure('Google sign-in failed. Please try again.');
    }
  }

  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
      _clearSession(),
    ]);
  }

  Future<void> _persistSession(User user) async {
    await Future.wait([
      _storage.write(key: _StorageKeys.firebaseUid, value: user.uid),
      _storage.write(key: _StorageKeys.userEmail, value: user.email ?? ''),
      _storage.write(
        key: _StorageKeys.displayName,
        value: user.displayName ?? '',
      ),
      _storage.write(key: _StorageKeys.photoUrl, value: user.photoURL ?? ''),
      _storage.write(key: _StorageKeys.isLoggedIn, value: 'true'),
    ]);
  }

  Future<void> _clearSession() async {
    await Future.wait([
      _storage.delete(key: _StorageKeys.firebaseUid),
      _storage.delete(key: _StorageKeys.userEmail),
      _storage.delete(key: _StorageKeys.displayName),
      _storage.delete(key: _StorageKeys.photoUrl),
      _storage.delete(key: _StorageKeys.isLoggedIn),
    ]);
  }

  Future<Map<String, String?>> getCachedSession() async {
    return {
      'uid': await _storage.read(key: _StorageKeys.firebaseUid),
      'email': await _storage.read(key: _StorageKeys.userEmail),
      'displayName': await _storage.read(key: _StorageKeys.displayName),
      'photoUrl': await _storage.read(key: _StorageKeys.photoUrl),
    };
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'No internet connection. Please check your network.';
      case 'invalid-credential':
        return 'Invalid credentials. Please check and try again.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
