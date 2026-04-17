import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class OcrResult {
  final bool success;
  final String rawText;
  final String docType;
  final String board;
  final String year;
  final String aggregate;
  final String stream;
  final String dateOfBirth;
  final String university;
  final String courseName;
  final String graduationStatus;
  final String examName;
  final String rollNumber;
  final String registrationNumber;
  final String candidateName;
  final String fatherName;
  final String motherName;
  final Map<String, String> subjectMarks;
  final double confidence;
  final String? imagePath;
  final String? errorMessage;

  const OcrResult({
    required this.success,
    required this.rawText,
    this.docType = '',
    this.board = '',
    this.year = '',
    this.aggregate = '',
    this.stream = '',
    this.dateOfBirth = '',
    this.university = '',
    this.courseName = '',
    this.graduationStatus = '',
    this.examName = '',
    this.rollNumber = '',
    this.registrationNumber = '',
    this.candidateName = '',
    this.fatherName = '',
    this.motherName = '',
    this.subjectMarks = const {},
    this.confidence = 0.0,
    this.imagePath,
    this.errorMessage,
  });

  const OcrResult.failure(this.errorMessage)
      : success = false,
        rawText = '',
        docType = '',
        board = '',
        year = '',
        aggregate = '',
        stream = '',
        dateOfBirth = '',
        university = '',
        courseName = '',
        graduationStatus = '',
        examName = '',
        rollNumber = '',
        registrationNumber = '',
        candidateName = '',
        fatherName = '',
        motherName = '',
        subjectMarks = const {},
        confidence = 0.0,
        imagePath = null;
}

class OcrService {
  OcrService._();
  static final OcrService instance = OcrService._();

  Future<PlatformFile?> pickPdfDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );
      if (result != null) {
        return result.files.single;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<OcrResult> extractText(PlatformFile pdfFile) async {
    try {
      final Uint8List bytes = pdfFile.bytes ?? await File(pdfFile.path!).readAsBytes();
      final document = PdfDocument(inputBytes: bytes);
      final textExtractor = PdfTextExtractor(document);
      String rawText = textExtractor.extractText();
      document.dispose();

      if (rawText.trim().isEmpty) {
        return const OcrResult.failure('No text found in this PDF. It might be a scanned image without a text layer.');
      }

      return _parseText(rawText, pdfFile.name);
    } catch (e) {
      return OcrResult.failure('PDF Parsing failed: ${e.toString()}');
    }
  }

  String? _findFirst(List<String> patterns, String text) {
    for (final p in patterns) {
      final regExp = RegExp(p, caseSensitive: false, multiLine: true);
      final match = regExp.firstMatch(text);
      if (match != null && match.groupCount >= 1) {
        return match.group(1)?.trim();
      }
    }
    return null;
  }

  OcrResult _parseText(String text, String? filePath) {
    // Basic normalization
    String norm = text.replaceAll('\u2013', '-').replaceAll('\u2014', '-').replaceAll('\u2212', '-');
    norm = norm.replaceAll('\u00A0', ' ').replaceAll('\u2009', ' ').replaceAll('\u2026', '...');
    norm = norm.replaceAll(RegExp(r'\s+'), ' ');
    
    final lines = norm.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();

    String findNextLine(List<String> labels) {
      for (int i = 0; i < lines.length - 1; i++) {
        final line = lines[i].toLowerCase();
        for (final label in labels) {
          if (line == label.toLowerCase() || line.startsWith(label.toLowerCase())) {
            return lines[i + 1];
          }
        }
      }
      return '';
    }

    final name = findNextLine(['This is to certify that', 'Student Name', 'Candidate Name', 'Name']);
    final rollNumber = findNextLine(['Roll No.', 'Roll number', 'Enrollment No', 'Enrolment No']);
    final fatherName = findNextLine(["Father's / Guardian's Name", "Father's Name", "Father Name", "Guardian Name"]);
    final motherName = findNextLine(["Mother's Name", "Mother Name"]);
    final dob = findNextLine(['Date of Birth', 'DOB']);
    final university = findNextLine(['School', 'Institution', 'Board', 'University']);
    final examName = findNextLine(['Examination', 'Exam', 'Course', 'Programme', 'Program']);
    final registrationNumber = findNextLine(['Registration No', 'Reg. No', 'Registration Number']);
    
    // Fallback passing year extraction
    String year = '';
    final yearMatch = RegExp(r'([12]\d{3})').firstMatch(findNextLine(['Year of Passing', 'Passing Year', 'Session', 'Year']));
    if (yearMatch != null) year = yearMatch.group(1)!;

    String percentageStr = findNextLine(['Percentage', 'Marks Percentage', 'Percent']);
    String cgpaStr = findNextLine(['CGPA', 'SGPA']);

    String docType = 'unknown';
    final lowerText = norm.toLowerCase();
    if (lowerText.contains('senior secondary') || lowerText.contains('higher secondary') || lowerText.contains('class xii') || lowerText.contains('12th')) {
      docType = '12th';
    } else if (lowerText.contains('secondary') || lowerText.contains('class x') || lowerText.contains('10th') || lowerText.contains('matric')) {
      docType = '10th';
    } else if (lowerText.contains('bachelor') || lowerText.contains('degree') || lowerText.contains('graduation') || lowerText.contains('university')) {
      docType = 'graduation';
    }

    // Subjects Extraction
    Map<String, String> subjectsMap = {};
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (RegExp(r'^\d{3}$').hasMatch(line)) {
        if (i + 4 < lines.length) {
          final subjName = lines[i + 1];
          final totalMarks = lines[i + 4];
          if (RegExp(r'^\d{2,3}$').hasMatch(totalMarks) && RegExp(r'[a-zA-Z]').hasMatch(subjName)) {
            subjectsMap[subjName] = totalMarks;
          }
        }
      }
    }

    // Calculate Confidence
    double conf = 0.0;
    if (docType != 'unknown') conf += 0.3;
    if (university.isNotEmpty) conf += 0.2;
    if (percentageStr.isNotEmpty || cgpaStr.isNotEmpty) conf += 0.25;
    if (name.isNotEmpty) conf += 0.15;
    if (subjectsMap.isNotEmpty) conf += 0.10;

    return OcrResult(
      success: true,
      rawText: text,
      docType: docType,
      board: university,
      year: year,
      aggregate: percentageStr.isNotEmpty ? percentageStr : (cgpaStr.isNotEmpty ? 'CGPA $cgpaStr' : ''),
      stream: '',
      dateOfBirth: dob,
      university: university,
      courseName: examName,
      graduationStatus: '',
      examName: examName,
      rollNumber: rollNumber,
      registrationNumber: registrationNumber,
      candidateName: name,
      fatherName: fatherName,
      motherName: motherName,
      subjectMarks: subjectsMap,
      confidence: conf.clamp(0.0, 1.0),
      imagePath: filePath,
    );
  }
}