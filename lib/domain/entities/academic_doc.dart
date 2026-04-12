class AcademicDoc {
  final String id;
  final String docType;
  final String? fileName;
  final String? extractedText;
  final DateTime uploadedAt;

  AcademicDoc({
    required this.id,
    required this.docType,
    this.fileName,
    this.extractedText,
    required this.uploadedAt,
  });
}
