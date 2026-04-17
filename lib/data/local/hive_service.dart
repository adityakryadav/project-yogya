import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_profile_model.dart';
import '../models/academic_doc_model.dart';
import '../models/eligibility_result_model.dart';

class HiveService {
  // Box names
  static const String _userBox        = 'userProfile';
  static const String _docsBox        = 'academicDocs';
  static const String _eligibilityBox = 'eligibilityResults';

  // ── Initialize ──────────────────────────────────────────
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters (guard against double-registration)
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserProfileModelAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(AcademicDocModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(EligibilityResultModelAdapter());
    }

    // Open boxes safely
    await _openBoxSafe<UserProfileModel>(_userBox);
    await _openBoxSafe<AcademicDocModel>(_docsBox);
    await _openBoxSafe<EligibilityResultModel>(_eligibilityBox);
  }

  static Future<void> _openBoxSafe<T>(String name) async {
    if (Hive.isBoxOpen(name)) return;
    try {
      await Hive.openBox<T>(name);
    } catch (_) {
      try {
        await Hive.deleteBoxFromDisk(name);
        await Hive.openBox<T>(name);
      } catch (e) {
        print('⚠️ Hive: Could not open box "$name": $e');
      }
    }
  }

  // ── Safe box accessors (reopen lazily if not open) ──────
  static Future<Box<UserProfileModel>> _getUserBox() async {
    if (!Hive.isBoxOpen(_userBox)) await _openBoxSafe<UserProfileModel>(_userBox);
    return Hive.box<UserProfileModel>(_userBox);
  }

  static Future<Box<AcademicDocModel>> _getDocsBox() async {
    if (!Hive.isBoxOpen(_docsBox)) await _openBoxSafe<AcademicDocModel>(_docsBox);
    return Hive.box<AcademicDocModel>(_docsBox);
  }

  static Future<Box<EligibilityResultModel>> _getEligibilityBox() async {
    if (!Hive.isBoxOpen(_eligibilityBox)) await _openBoxSafe<EligibilityResultModel>(_eligibilityBox);
    return Hive.box<EligibilityResultModel>(_eligibilityBox);
  }

  // ── Sync accessors (for build methods — return empty if box not open) ──
  static List<EligibilityResultModel> getAllEligibilityResults() {
    if (!Hive.isBoxOpen(_eligibilityBox)) return [];
    return Hive.box<EligibilityResultModel>(_eligibilityBox).values.toList();
  }

  static List<AcademicDocModel> getAllDocs() {
    if (!Hive.isBoxOpen(_docsBox)) return [];
    return Hive.box<AcademicDocModel>(_docsBox).values.toList();
  }

  static AcademicDocModel? getDoc(String id) {
    if (!Hive.isBoxOpen(_docsBox)) return null;
    return Hive.box<AcademicDocModel>(_docsBox).get(id);
  }

  static UserProfileModel? getUserProfile(String uid) {
    if (!Hive.isBoxOpen(_userBox)) return null;
    return Hive.box<UserProfileModel>(_userBox).get(uid);
  }

  // ── UserProfile CRUD ─────────────────────────────────────
  static Future<void> saveUserProfile(UserProfileModel profile) async {
    final box = await _getUserBox();
    await box.put(profile.id, profile);
  }

  static Future<void> deleteUserProfile(String uid) async {
    final box = await _getUserBox();
    await box.delete(uid);
  }

  // ── AcademicDoc CRUD ─────────────────────────────────────
  static Future<void> saveDoc(AcademicDocModel doc) async {
    final box = await _getDocsBox();
    await box.put(doc.id, doc);
  }

  static Future<void> deleteDoc(String id) async {
    final box = await _getDocsBox();
    await box.delete(id);
  }

  // ── EligibilityResult CRUD ───────────────────────────────
  static Future<void> saveEligibilityResult(EligibilityResultModel result) async {
    final box = await _getEligibilityBox();
    await box.put(result.examId, result);
  }

  static Future<void> clearEligibilityResults() async {
    final box = await _getEligibilityBox();
    await box.clear();
  }
}