class Eligibility {
  final String examId;
  final bool isEligible;
  final List<String> missingCriteria;
  final DateTime checkedAt;

  Eligibility({
    required this.examId,
    required this.isEligible,
    required this.missingCriteria,
    required this.checkedAt,
  });
}
