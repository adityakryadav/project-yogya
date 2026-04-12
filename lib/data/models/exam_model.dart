import '../../domain/entities/exam.dart';

class ExamModel extends Exam {
  ExamModel({
    required super.id,
    required super.name,
    required super.code,
    required super.notificationDate,
    required super.applicationStart,
    required super.applicationEnd,
    required super.examDate,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      notificationDate: DateTime.parse(json['notificationDate']),
      applicationStart: DateTime.parse(json['applicationStart']),
      applicationEnd: DateTime.parse(json['applicationEnd']),
      examDate: DateTime.parse(json['examDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'notificationDate': notificationDate.toIso8601String(),
      'applicationStart': applicationStart.toIso8601String(),
      'applicationEnd': applicationEnd.toIso8601String(),
      'examDate': examDate.toIso8601String(),
    };
  }
}
