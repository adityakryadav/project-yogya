import 'package:hive_flutter/hive_flutter.dart';

part 'eligibility_result_model.g.dart';

@HiveType(typeId: 2)
class EligibilityResultModel extends HiveObject {
  @HiveField(0)
  final String examId;

  @HiveField(1)
  bool isEligible;

  @HiveField(2)
  List<String> missingCriteria;

  @HiveField(3)
  int matchPercent;

  @HiveField(4)
  DateTime checkedAt;

  EligibilityResultModel({
    required this.examId,
    required this.isEligible,
    required this.missingCriteria,
    required this.matchPercent,
    required this.checkedAt,
  });
}