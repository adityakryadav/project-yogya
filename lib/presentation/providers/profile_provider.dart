import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/hive_service.dart';
import '../../data/models/user_profile_model.dart';
import '../../data/providers/auth_provider.dart';

// ── Profile State ─────────────────────────────────────────
class ProfileState {
  final UserProfileModel? profile;
  final bool isLoading;
  final bool isSaved;
  final String? errorMessage;

  const ProfileState({
    this.profile,
    this.isLoading = false,
    this.isSaved = false,
    this.errorMessage,
  });

  ProfileState copyWith({
    UserProfileModel? profile,
    bool? isLoading,
    bool? isSaved,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      isSaved: isSaved ?? this.isSaved,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

// ── Profile Notifier ──────────────────────────────────────
class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(const ProfileState());

  // Hive se profile load karo
  Future<void> loadProfile(String uid) async {
    state = state.copyWith(isLoading: true);
    final profile = HiveService.getUserProfile(uid);
    state = state.copyWith(
      isLoading: false,
      profile: profile,
    );
  }

  // Profile save karo Hive mein
  Future<void> saveProfile({
    required String uid,
    required String name,
    required String email,
    required String category,
    required String gender,
    required String dateOfBirth,
    required String qualification,
    required String university,
    required String passingYear,
    required String percentage,
    required String phone,
    String stateOfDomicile = '',
    String primaryExamGoal = '',
  }) async {
    state = state.copyWith(isLoading: true, isSaved: false);

    try {
      // Existing profile lo ya naya banao
      final existing = HiveService.getUserProfile(uid);

      final profile = UserProfileModel(
        id: uid,
        name: name,
        email: email,
        category: category,
        gender: gender,
        dateOfBirth: dateOfBirth,
        qualification: qualification,
        university: university,
        passingYear: passingYear,
        percentage: percentage,
        phone: phone,
        profileCompletion: 0,
        stateOfDomicile: stateOfDomicile,
        primaryExamGoal: primaryExamGoal,
      );

      // Completion calculate karo
      profile.profileCompletion = profile.calculateCompletion();

      // Hive mein save karo
      await HiveService.saveUserProfile(profile);

      state = state.copyWith(
        isLoading: false,
        isSaved: true,
        profile: profile,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to save profile. Please try again.',
      );
    }
  }
  Future<void> updateFromOcr({
    required String uid,
    required String docType,
    required String dateOfBirth,
    required String university,
    required String percentage,
    required String passingYear,
    String primaryExamGoal = '',
  }) async {
    final existing = HiveService.getUserProfile(uid) ?? state.profile;

    String mergeQualification(String current, String incoming) {
      int rank(String value) {
        final q = value.toLowerCase();
        if (q.contains('phd')) return 5;
        if (q.contains('post')) return 4;
        if (q.contains('grad')) return 3;
        if (q.contains('12')) return 2;
        if (q.contains('10')) return 1;
        return 0;
      }

      if (incoming.trim().isEmpty) return current;
      if (rank(incoming) >= rank(current)) return incoming;
      return current;
    }

    double? parsePercent(String raw) {
      final value = raw.trim().toLowerCase();
      if (value.isEmpty) return null;

      final number = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(value);
      if (number == null) return null;

      final parsed = double.tryParse(number.group(1)!);
      if (parsed == null) return null;

      if (value.contains('cgpa')) return parsed * 9.5;
      return parsed;
    }

    final currentPercent = parsePercent(existing?.percentage ?? '');
    final incomingPercent = parsePercent(percentage);
    final mergedPercent = incomingPercent != null &&
            (currentPercent == null || incomingPercent > currentPercent)
        ? percentage
        : (existing?.percentage ?? '');

    final currentYear = int.tryParse(existing?.passingYear ?? '');
    final incomingYear = int.tryParse(passingYear);
    final mergedYear = incomingYear != null &&
            (currentYear == null || incomingYear > currentYear)
        ? passingYear
        : (existing?.passingYear ?? '');

    final mergedGoal =
        primaryExamGoal.trim().isNotEmpty ? primaryExamGoal : (existing?.primaryExamGoal ?? '');

    await saveProfile(
      uid: uid,
      name: existing?.name ?? '',
      email: existing?.email ?? '',
      category: existing?.category ?? 'General',
      gender: existing?.gender ?? 'Male',
      dateOfBirth: dateOfBirth.isNotEmpty ? dateOfBirth : (existing?.dateOfBirth ?? ''),
      qualification: mergeQualification(existing?.qualification ?? '', docType),
      university: university.isNotEmpty ? university : (existing?.university ?? ''),
      passingYear: mergedYear,
      percentage: mergedPercent,
      phone: existing?.phone ?? '',
      stateOfDomicile: existing?.stateOfDomicile ?? '',
      primaryExamGoal: mergedGoal,
    );
  }

  void resetSaved() => state = state.copyWith(isSaved: false);
}

// ── Providers ─────────────────────────────────────────────
final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier();
});

// Profile load karo jab user login ho
final profileLoaderProvider = FutureProvider<void>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user != null) {
    await ref.read(profileNotifierProvider.notifier).loadProfile(user.uid);
  }
});
