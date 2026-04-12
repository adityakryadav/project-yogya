import 'package:flutter_test/flutter_test.dart';
import 'package:yogya_app/core/constants/exam_data.dart';
import 'package:yogya_app/core/services/eligibility_service.dart';
import 'package:yogya_app/data/models/academic_doc_model.dart';
import 'package:yogya_app/data/models/user_profile_model.dart';

void main() {
  group('EligibilityService', () {
    final service = EligibilityService.instance;

    UserProfileModel profile({
      String category = 'General',
      String dob = '10/10/2001',
      String qualification = 'Graduation',
      String percentage = '65%',
    }) {
      return UserProfileModel(
        id: 'u1',
        name: 'Aditi',
        email: 'aditi@example.com',
        category: category,
        dateOfBirth: dob,
        qualification: qualification,
        percentage: percentage,
      );
    }

    List<AcademicDocModel> docs() {
      return [
        AcademicDocModel(
          id: 'd10',
          docType: '10th',
          aggregate: '83%',
          uploadedAt: DateTime.now(),
        ),
        AcademicDocModel(
          id: 'd12',
          docType: '12th',
          aggregate: '79%',
          uploadedAt: DateTime.now(),
        ),
        AcademicDocModel(
          id: 'dgrad',
          docType: 'graduation',
          aggregate: '65%',
          uploadedAt: DateTime.now(),
        ),
      ];
    }

    test('marks UPSC as eligible for valid general candidate', () {
      final result = service.evaluate(
        profile: profile(),
        docs: docs(),
        attemptsByExam: {'upsc_cse': 1},
        examIds: {'upsc_cse'},
      );

      expect(result, hasLength(1));
      expect(result.first.exam.id, 'upsc_cse');
      expect(result.first.isEligible, isTrue);
      expect(result.first.status, 'ELIGIBLE');
    });

    test('applies OBC age relaxation for UPSC', () {
      final result = service.evaluate(
        profile: profile(
          category: 'OBC',
          dob: '10/10/1992', // ~33 years in 2026
        ),
        docs: docs(),
        attemptsByExam: {'upsc_cse': 1},
        examIds: {'upsc_cse'},
      );

      expect(result.first.isEligible, isTrue);
      expect(result.first.maxAge, ExamData.allExams
          .firstWhere((e) => e.id == 'upsc_cse')
          .maxAgeOBC);
    });

    test('fails when attempt limit is reached for general UPSC', () {
      final result = service.evaluate(
        profile: profile(),
        docs: docs(),
        attemptsByExam: {'upsc_cse': 6},
        examIds: {'upsc_cse'},
      );

      expect(result.first.isEligible, isFalse);
      expect(result.first.criteria['Attempts'], isFalse);
    });

    test('fails AFCAT when graduation percent is below 60', () {
      final result = service.evaluate(
        profile: profile(percentage: '54%'),
        docs: [
          AcademicDocModel(
            id: 'dgrad',
            docType: 'graduation',
            aggregate: '54%',
            uploadedAt: DateTime.now(),
          ),
        ],
        attemptsByExam: const {},
        examIds: {'afcat'},
      );

      expect(result.first.isEligible, isFalse);
      expect(result.first.criteria['Qualification'], isFalse);
    });

    test('converts CGPA to percentage for min-60 checks', () {
      final result = service.evaluate(
        profile: profile(percentage: 'CGPA 7.0'),
        docs: [
          AcademicDocModel(
            id: 'dgrad',
            docType: 'graduation',
            aggregate: 'CGPA 7.0',
            uploadedAt: DateTime.now(),
          ),
        ],
        attemptsByExam: const {},
        examIds: {'rbi_grade_b'},
      );

      expect(result.first.isEligible, isTrue); // 7.0 * 9.5 = 66.5
    });
  });
}

