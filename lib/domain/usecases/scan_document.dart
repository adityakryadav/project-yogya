import '../entities/academic_doc.dart';

abstract class ScanDocumentUseCase {
  Future<AcademicDoc> call(String imagePath);
}
