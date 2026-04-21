import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/hive_service.dart';
import '../../data/models/user_profile_model.dart';
import '../../data/providers/auth_provider.dart';

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

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(const ProfileState());

  Future<void> loadProfile(String uid) async {
    state = state.copyWith(isLoading: true);
    final profile = HiveService.getUserProfile(uid);
    state = state.copyWith(isLoading: false, profile: profile);
  }

  Future<void> saveProfile({
    required String uid,
    required String name,
    required String email,
    required String category,
    required String gender,
    required String dateOfBirth,
    required String phone,
    String stateOfDomicile = '',
    String primaryExamGoal = '',
    String tenthBoard = '',
    String tenthYear = '',
    String tenthPercentage = '',
    String twelfthBoard = '',
    String twelfthYear = '',
    String twelfthPercentage = '',
    String gradCourse = '',
    String gradUniversity = '',
    String gradYear = '',
    String gradPercentage = '',
    String graduationStatus = '',
    bool? isVerified,
    double? confidenceLevel,
  }) async {
    state = state.copyWith(isLoading: true, isSaved: false, clearError: true);

    try {
      final existing = HiveService.getUserProfile(uid);
      final computedQualification = _computeQualification(
        tenthBoard: tenthBoard,
        twelfthBoard: twelfthBoard,
        gradCourse: gradCourse,
        graduationStatus: graduationStatus,
      );

      final profile = UserProfileModel(
        id: uid,
        name: name,
        email: email,
        category: category,
        gender: gender,
        dateOfBirth: dateOfBirth,
        phone: phone,
        stateOfDomicile: stateOfDomicile,
        primaryExamGoal: primaryExamGoal,
        tenthBoard: tenthBoard,
        tenthYear: tenthYear,
        tenthPercentage: tenthPercentage,
        twelfthBoard: twelfthBoard,
        twelfthYear: twelfthYear,
        twelfthPercentage: twelfthPercentage,
        gradCourse: gradCourse,
        gradUniversity: gradUniversity,
        gradYear: gradYear,
        gradPercentage: gradPercentage,
        graduationStatus: graduationStatus,
        qualification: computedQualification,
        university: gradUniversity.isNotEmpty
            ? gradUniversity
            : (twelfthBoard.isNotEmpty ? twelfthBoard : tenthBoard),
        passingYear: gradYear.isNotEmpty
            ? gradYear
            : (twelfthYear.isNotEmpty ? twelfthYear : tenthYear),
        percentage: gradPercentage.isNotEmpty
            ? gradPercentage
            : (twelfthPercentage.isNotEmpty
                ? twelfthPercentage
                : tenthPercentage),
        isVerified: isVerified ?? existing?.isVerified ?? false,
        confidenceLevel: confidenceLevel ?? existing?.confidenceLevel ?? 0.0,
      );

      profile.profileCompletion = profile.calculateCompletion();
      await HiveService.saveUserProfile(profile);
      state = state.copyWith(isLoading: false, isSaved: true, profile: profile);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to save profile.',
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
    required String extractedName,
    required String primaryExamGoal,
    String? courseName,
    String? graduationStatus,
    bool isVerified = false,
    double confidenceLevel = 0.0,
  }) async {
    final existing = HiveService.getUserProfile(uid) ?? state.profile;

    var tenthBoard = existing?.tenthBoard ?? '';
    var tenthYear = existing?.tenthYear ?? '';
    var tenthPercentage = existing?.tenthPercentage ?? '';
    var twelfthBoard = existing?.twelfthBoard ?? '';
    var twelfthYear = existing?.twelfthYear ?? '';
    var twelfthPercentage = existing?.twelfthPercentage ?? '';
    var gradCourse = existing?.gradCourse ?? '';
    var gradUniversity = existing?.gradUniversity ?? '';
    var gradYear = existing?.gradYear ?? '';
    var gradPercentage = existing?.gradPercentage ?? '';
    var gradStatus = existing?.graduationStatus ?? '';

    var mergedName = existing?.name ?? '';
    var mergedDob = existing?.dateOfBirth ?? '';

    if (docType.contains('10')) {
      tenthBoard = university;
      tenthYear = passingYear;
      tenthPercentage = percentage;
      if (extractedName.isNotEmpty) {
        mergedName = extractedName;
      }
      if (dateOfBirth.isNotEmpty) {
        mergedDob = dateOfBirth;
      }
    } else if (docType.contains('12')) {
      twelfthBoard = university;
      twelfthYear = passingYear;
      twelfthPercentage = percentage;
    } else if (docType.toLowerCase().contains('grad')) {
      gradCourse = courseName?.trim().isNotEmpty == true
          ? courseName!.trim()
          : university;
      gradUniversity = university;
      gradYear = passingYear;
      gradPercentage = percentage;
      gradStatus = graduationStatus?.trim().isNotEmpty == true
          ? graduationStatus!.trim()
          : ((int.tryParse(passingYear) ?? 9999) > DateTime.now().year
              ? 'Pursuing'
              : 'Completed');
    }

    await saveProfile(
      uid: uid,
      name: mergedName,
      email: existing?.email ?? '',
      category: existing?.category ?? 'General',
      gender: existing?.gender ?? 'Male',
      dateOfBirth: mergedDob,
      phone: existing?.phone ?? '',
      stateOfDomicile: existing?.stateOfDomicile ?? '',
      primaryExamGoal: primaryExamGoal.trim().isNotEmpty
          ? primaryExamGoal
          : (existing?.primaryExamGoal ?? ''),
      tenthBoard: tenthBoard,
      tenthYear: tenthYear,
      tenthPercentage: tenthPercentage,
      twelfthBoard: twelfthBoard,
      twelfthYear: twelfthYear,
      twelfthPercentage: twelfthPercentage,
      gradCourse: gradCourse,
      gradUniversity: gradUniversity,
      gradYear: gradYear,
      gradPercentage: gradPercentage,
      graduationStatus: gradStatus,
      isVerified: isVerified || (existing?.isVerified ?? false),
      confidenceLevel: confidenceLevel > 0
          ? confidenceLevel
          : (existing?.confidenceLevel ?? 0.0),
    );
  }

  void resetSaved() => state = state.copyWith(isSaved: false);

  String _computeQualification({
    required String tenthBoard,
    required String twelfthBoard,
    required String gradCourse,
    required String graduationStatus,
  }) {
    if (gradCourse.isNotEmpty) {
      if (graduationStatus == 'Completed') {
        return 'Graduation ($gradCourse)';
      }
      return 'Under Graduation ($gradCourse)';
    }
    if (twelfthBoard.isNotEmpty) {
      return '12th Pass';
    }
    if (tenthBoard.isNotEmpty) {
      return '10th Pass';
    }
    return 'Not Specified';
  }
}

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>(
  (ref) => ProfileNotifier(),
);

final profileLoaderProvider = FutureProvider<void>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user != null) {
    await ref.read(profileNotifierProvider.notifier).loadProfile(user.uid);
  }
});
