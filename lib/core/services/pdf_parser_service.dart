import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';

import 'ocr_service.dart';

/// Configuration for the local PDF parser microservice.
class PdfParserConfig {
  static const String host = '127.0.0.1';
  static const int port = 5050;
  static String get baseUrl => 'http://$host:$port';
}

/// Service that calls the local Python Flask PDF-parser microservice and
/// maps the JSON response to [OcrResult].
class PdfParserService {
  PdfParserService._();
  static final PdfParserService instance = PdfParserService._();

  final _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 30),
    ),
  );

  // ── Health check ──────────────────────────────────────────────────────────

  Future<bool> isServerAvailable() async {
    try {
      final resp = await _dio.get('${PdfParserConfig.baseUrl}/health');
      return resp.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // ── Parse PDF ─────────────────────────────────────────────────────────────

  Future<OcrResult> parsePdf(
    Uint8List pdfBytes, {
    String method = 'auto',
    int dpi = 300,
    String lang = 'eng',
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(pdfBytes, filename: 'document.pdf'),
      });

      final resp = await _dio.post(
        '${PdfParserConfig.baseUrl}/parse-pdf',
        data: formData,
        queryParameters: {
          'method': method,
          'dpi': dpi.toString(),
          'lang': lang,
        },
      );

      if (resp.statusCode != 200) {
        return const OcrResult.failure(
          'PDF server returned an error. Is the server running?',
        );
      }

      final json = resp.data as Map<String, dynamic>?;
      if (json == null) {
        return const OcrResult.failure('Empty response from PDF parser.');
      }
      if (json.containsKey('error')) {
        return OcrResult.failure('PDF parser error: ${json['error']}');
      }

      return _mapToOcrResult(json);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        return const OcrResult.failure(
          'Cannot connect to PDF parser service.\n'
          'Please start it with: cd tools/pdf_parser && start.bat',
        );
      }
      return OcrResult.failure('Network error: ${e.message}');
    } catch (e) {
      return OcrResult.failure('Unexpected error: $e');
    }
  }

  // ── Parse Image ───────────────────────────────────────────────────────────

  Future<OcrResult> parseImage(
    Uint8List imageBytes, {
    String lang = 'eng',
    String filename = 'image.jpg',
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(imageBytes, filename: filename),
      });
      final resp = await _dio.post(
        '${PdfParserConfig.baseUrl}/parse-image',
        data: formData,
        queryParameters: {'lang': lang},
      );
      final json = resp.data as Map<String, dynamic>?;
      if (json == null || json.containsKey('error')) {
        return OcrResult.failure(
          json?['error']?.toString() ?? 'Empty image parse response.',
        );
      }
      return _mapToOcrResult(json);
    } on DioException catch (e) {
      return OcrResult.failure('Network error: ${e.message}');
    } catch (e) {
      return OcrResult.failure('Unexpected error: $e');
    }
  }

  // ── Mapping ───────────────────────────────────────────────────────────────

  OcrResult _mapToOcrResult(Map<String, dynamic> json) {
    // ── Core fields ──────────────────────────────────────────────────────
    final name = _str(json['name'] ?? json['student_name']);
    final fatherName = _str(json['father_name']);
    final dob = _str(json['dob']);
    final rollNumber = _str(json['roll_number']);
    final regNumber = _str(json['registration_number']);
    final university = _str(json['board_university'] ?? json['university']);
    final year = _str(json['year']);
    final examText = _str(json['exam']);

    // ── Aggregate / percentage ───────────────────────────────────────────
    final percentCgpa = json['percentage_cgpa'];
    final rawPercent = json['percentage'];
    final rawCgpa = json['cgpa'];

    String aggregate = '';
    if (rawCgpa != null) {
      final cgpaNum = rawCgpa is num
          ? rawCgpa as num
          : num.tryParse(rawCgpa.toString());
      if (cgpaNum != null && cgpaNum > 0) {
        aggregate = 'CGPA ${cgpaNum.toStringAsFixed(2)}';
      }
    } else if (rawPercent != null) {
      final pctNum = rawPercent is num
          ? rawPercent as num
          : num.tryParse(rawPercent.toString());
      if (pctNum != null && pctNum > 0) {
        aggregate = '${pctNum.toStringAsFixed(1)}%';
      }
    } else if (percentCgpa != null) {
      final pcNum = percentCgpa is num
          ? percentCgpa as num
          : num.tryParse(percentCgpa.toString());
      if (pcNum != null && pcNum > 0) {
        aggregate = '${pcNum.toStringAsFixed(1)}%';
      }
    }

    // ── Subject details (new structured format) ──────────────────────────
    final subjectDetails =
        (json['subject_details'] as List<dynamic>?) ??
        (json['subjects'] as List<dynamic>?) ??
        [];

    // Build display map: name → "total/max (grade)"
    final subjectMarks = <String, String>{};
    for (final item in subjectDetails) {
      final s = item as Map<String, dynamic>? ?? {};
      final sName = _str(s['name']);
      if (sName.isEmpty) continue;
      final total = s['total_marks'];
      final max = s['max_marks'];
      final grade = _str(s['grade']);
      String display = '';
      if (total != null) {
        display = max != null
            ? '${_numStr(total)}/${_numStr(max)}'
            : _numStr(total);
        if (grade.isNotEmpty) display += ' ($grade)';
      } else if (grade.isNotEmpty) {
        display = grade;
      }
      subjectMarks[sName] = display;
    }

    // Fallback to subjects_and_marks map if no subject_details
    if (subjectMarks.isEmpty) {
      final legacyMap =
          json['subjects_and_marks'] as Map<String, dynamic>? ?? {};
      legacyMap.forEach((k, v) {
        final sub = v as Map<String, dynamic>? ?? {};
        final marks = sub['marks'];
        final max = sub['max'];
        final grade = _str(sub['grade']);
        String display = '';
        if (marks != null) {
          display = max != null
              ? '${_numStr(marks)}/${_numStr(max)}'
              : _numStr(marks);
          if (grade.isNotEmpty) display += ' ($grade)';
        } else if (grade.isNotEmpty) {
          display = grade;
        }
        subjectMarks[k] = display;
      });
    }

    // ── Subjects JSON (for Hive persistence) ────────────────────────────
    final subjectsJson =
        subjectDetails.isNotEmpty ? jsonEncode(subjectDetails) : '';

    // ── Doc type: prefer Python's doc_level, fall back to inference ──────
    final pyDocLevel = _str(json['doc_level']);
    final docType = pyDocLevel.isNotEmpty && pyDocLevel != 'unknown'
        ? pyDocLevel
        : _inferDocType(examText, university, subjectMarks);

    // ── Board detection ──────────────────────────────────────────────────
    final board = _inferBoard(university);

    // ── Confidence ───────────────────────────────────────────────────────
    final confidence = _computeConfidence(
      name: name,
      dob: dob,
      board: board,
      year: year,
      aggregate: aggregate,
      docType: docType,
      rollNumber: rollNumber,
      registrationNumber: regNumber,
      subjectMarks: subjectMarks,
    );

    return OcrResult(
      success: true,
      rawText: _buildRawText(json),
      docType: docType,
      board: board,
      year: year,
      aggregate: aggregate,
      stream: _inferStream(subjectMarks),
      dateOfBirth: dob,
      university: university,
      examName: examText,
      rollNumber: rollNumber,
      registrationNumber: regNumber,
      candidateName: name,
      fatherName: fatherName,
      subjectMarks: subjectMarks,
      subjectsJson: subjectsJson,
      confidence: confidence,
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _str(dynamic v) => v?.toString().trim() ?? '';

  String _numStr(dynamic v) {
    if (v == null) return '';
    if (v is double && v == v.roundToDouble()) return v.toInt().toString();
    return v.toString();
  }

  String _inferDocType(
    String exam,
    String university,
    Map<String, String> subjects,
  ) {
    final text = '${exam.toLowerCase()} ${university.toLowerCase()}';
    // 12th keywords
    if (text.contains('senior secondary') ||
        text.contains('higher secondary') ||
        text.contains('intermediate') ||
        text.contains('12') ||
        text.contains('xii') ||
        text.contains('hsc')) {
      return '12th';
    }
    // 10th keywords
    if (text.contains('secondary') ||
        text.contains('10') ||
        text.contains('matric') ||
        text.contains('sslc') ||
        text.contains('high school')) {
      return '10th';
    }
    // Graduation
    if (text.contains('bachelor') ||
        text.contains('degree') ||
        text.contains('graduation') ||
        text.contains('university') ||
        text.contains('b.tech') ||
        text.contains('b.sc')) {
      return 'graduation';
    }
    // Fingerprint via subjects
    final keys = subjects.keys.map((k) => k.toLowerCase());
    final has10thSubjects = keys.any((k) =>
        k.contains('mathematics standard') ||
        k.contains('social science') ||
        k.contains('science (theory)'));
    final has12thSubjects = keys.any((k) =>
        k.contains('physics') ||
        k.contains('chemistry') ||
        k.contains('accountancy') ||
        k.contains('economics'));
    if (has10thSubjects) return '10th';
    if (has12thSubjects) return '12th';
    if (subjects.length >= 4) return '10th';
    return 'unknown';
  }

  String _inferBoard(String university) {
    final u = university.toLowerCase();
    if (u.contains('cbse') || u.contains('central board')) return 'CBSE';
    if (u.contains('icse') || u.contains('cisce')) return 'ICSE';
    if (u.contains('isc')) return 'ISC';
    if (u.contains('rbse') || u.contains('rajasthan')) return 'RBSE (Rajasthan)';
    if (u.contains('up board') || u.contains('uttar pradesh')) return 'UP Board';
    if (u.contains('maharashtra') || u.contains('msbshse')) {
      return 'Maharashtra State Board';
    }
    if (u.contains('karnataka') || u.contains('kseeb')) return 'Karnataka Board';
    if (u.contains('bihar') || u.contains('bseb')) return 'Bihar Board';
    if (u.contains('mp board') || u.contains('madhya pradesh')) return 'MP Board';
    return university.isNotEmpty ? university : '';
  }

  String _inferStream(Map<String, String> subjects) {
    final keys = subjects.keys.map((k) => k.toLowerCase()).toList();
    final hasMath = keys.any((k) => k.contains('math'));
    final hasBio = keys.any((k) => k.contains('bio'));
    final hasChem = keys.any((k) => k.contains('chem') || k.contains('phy'));
    final hasCommerce =
        keys.any((k) => k.contains('account') || k.contains('commerce'));
    if (hasMath && hasChem) return hasBio ? 'PCB' : 'PCM';
    if (hasCommerce) return 'Commerce';
    return '';
  }

  String _buildRawText(Map<String, dynamic> json) {
    final buf = StringBuffer();
    void add(String label, dynamic val) {
      if (val != null && val.toString().isNotEmpty) buf.writeln('$label: $val');
    }

    add('Doc Level', json['doc_level']);
    add('Name', json['name'] ?? json['student_name']);
    add('Father Name', json['father_name']);
    add('DOB', json['dob']);
    add('Roll No', json['roll_number']);
    add('Registration No', json['registration_number']);
    add('University/Board', json['board_university'] ?? json['university']);
    add('Exam', json['exam']);
    add('Year', json['year']);
    add('Percentage', json['percentage']);
    add('CGPA', json['cgpa']);
    add('Total Marks', json['total_marks_obtained_outoff']);

    final subjects =
        (json['subject_details'] as List<dynamic>?) ??
        (json['subjects'] as List<dynamic>?) ??
        [];
    if (subjects.isNotEmpty) {
      buf.writeln('\nSubjects:');
      for (final item in subjects) {
        final s = item as Map<String, dynamic>? ?? {};
        final name = s['name'] ?? '';
        final total = s['total_marks'];
        final max = s['max_marks'];
        final grade = s['grade'] ?? '';
        buf.writeln('  $name: $total/$max  Grade: $grade');
      }
    }

    return buf.toString().trim();
  }

  double _computeConfidence({
    required String name,
    required String dob,
    required String board,
    required String year,
    required String aggregate,
    required String docType,
    required String rollNumber,
    required String registrationNumber,
    required Map<String, String> subjectMarks,
  }) {
    double score = 0.0;
    if (docType != 'unknown') score += 0.20;
    if (board.isNotEmpty) score += 0.15;
    if (year.isNotEmpty) score += 0.10;
    if (aggregate.isNotEmpty) score += 0.18;
    if (dob.isNotEmpty) score += 0.08;
    if (name.isNotEmpty) score += 0.10;
    if (rollNumber.isNotEmpty) score += 0.07;
    if (registrationNumber.isNotEmpty) score += 0.05;
    if (subjectMarks.isNotEmpty) score += 0.07;
    return score.clamp(0.0, 1.0);
  }
}
