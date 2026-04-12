import '../entities/eligibility.dart';

abstract class EligibilityRepository {
  Future<Eligibility> checkEligibility(String examId);
  Future<List<Eligibility>> getAllEligibilities();
}
