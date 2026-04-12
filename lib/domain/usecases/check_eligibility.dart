import '../entities/eligibility.dart';

abstract class CheckEligibilityUseCase {
  Future<Eligibility> call(String examId);
}
