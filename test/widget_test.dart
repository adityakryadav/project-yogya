import 'package:flutter_test/flutter_test.dart';
import 'package:yogya_app/core/constants/exam_data.dart';
import 'package:yogya_app/core/constants/strings.dart';

void main() {
  test('app constants are configured', () {
    expect(AppStrings.appName, isNotEmpty);
    expect(ExamData.allExams.length, greaterThanOrEqualTo(10));
  });
}
