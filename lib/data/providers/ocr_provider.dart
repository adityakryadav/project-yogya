// import 'dart:io';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../core/services/ocr_service.dart';
// import '../../data/local/hive_service.dart';
// import '../../data/models/academic_doc_model.dart';

// // ── OCR State ─────────────────────────────────────────────
// enum OcrStatus { idle, picking, processing, done, error }

// class OcrState {
//   final OcrStatus status;
//   final double    progress;
//   final String    statusMessage;
//   final OcrResult? result;
//   final String?   errorMessage;

//   const OcrState({
//     this.status        = OcrStatus.idle,
//     this.progress      = 0.0,
//     this.statusMessage = '',
//     this.result,
//     this.errorMessage,
//   });

//   OcrState copyWith({
//     OcrStatus? status,
//     double?    progress,
//     String?    statusMessage,
//     OcrResult? result,
//     String?    errorMessage,
//   }) {
//     return OcrState(
//       status:        status        ?? this.status,
//       progress:      progress      ?? this.progress,
//       statusMessage: statusMessage ?? this.statusMessage,
//       result:        result        ?? this.result,
//       errorMessage:  errorMessage  ?? this.errorMessage,
//     );
//   }
// }

// // ── OCR Notifier ──────────────────────────────────────────
// class OcrNotifier extends StateNotifier<OcrState> {
//   OcrNotifier() : super(const OcrState());

//   final _ocrService = OcrService.instance;

//   // ── Camera se scan karo ───────────────────────────────
//   Future<OcrResult?> scanFromCamera() async {
//     return _processImage(() => _ocrService.pickFromCamera());
//   }

//   // ── Gallery se pick karo ──────────────────────────────
//   Future<OcrResult?> scanFromGallery() async {
//     return _processImage(() => _ocrService.pickFromGallery());
//   }

//   // ── Common processing logic ───────────────────────────
//   Future<OcrResult?> _processImage(
//     Future<File?> Function() picker,
//   ) async {
//     // Step 1 — Picking
//     state = state.copyWith(
//       status:        OcrStatus.picking,
//       progress:      0.1,
//       statusMessage: 'Opening camera...',
//     );

//     final imageFile = await picker();
//     if (imageFile == null) {
//       state = const OcrState(); // reset
//       return null;
//     }

//     // Step 2 — Pre-processing
//     state = state.copyWith(
//       status:        OcrStatus.processing,
//       progress:      0.3,
//       statusMessage: 'Layer 1: Pre-processing image...',
//     );
//     await Future.delayed(const Duration(milliseconds: 600));

//     // Step 3 — Layout detection
//     state = state.copyWith(
//       progress:      0.5,
//       statusMessage: 'Layer 2: Detecting document layout...',
//     );
//     await Future.delayed(const Duration(milliseconds: 500));

//     // Step 4 — Text extraction
//     state = state.copyWith(
//       progress:      0.7,
//       statusMessage: 'Layer 3: Extracting text...',
//     );

//     final result = await _ocrService.extractText(imageFile);

//     // Step 5 — Parsing
//     state = state.copyWith(
//       progress:      0.9,
//       statusMessage: 'Layer 4: Parsing data...',
//     );
//     await Future.delayed(const Duration(milliseconds: 400));

//     if (!result.success) {
//       state = state.copyWith(
//         status:       OcrStatus.error,
//         progress:     0.0,
//         errorMessage: result.errorMessage,
//       );
//       return null;
//     }

//     // Step 6 — Save to Hive
//     final doc = AcademicDocModel(
//       id:            DateTime.now().millisecondsSinceEpoch.toString(),
//       docType:       result.docType,
//       extractedText: result.rawText,
//       board:         result.board,
//       year:          result.year,
//       aggregate:     result.aggregate,
//       stream:        result.stream,
//       confidence:    result.confidence,
//       isVerified:    true, // Marked as verified upon successful extraction
//       uploadedAt:    DateTime.now(),
//     );
//     await HiveService.saveDoc(doc);

//     // Done
//     state = state.copyWith(
//       status:        OcrStatus.done,
//       progress:      1.0,
//       statusMessage: 'Done! Data extracted successfully.',
//       result:        result,
//     );

//     return result;
//   }

//   void reset() => state = const OcrState();
// }

// // ── Provider ──────────────────────────────────────────────
// final ocrProvider =
//     StateNotifierProvider<OcrNotifier, OcrState>(
//         (ref) => OcrNotifier());






import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/ocr_service.dart';
import '../../core/services/pdf_parser_service.dart';
import '../../data/local/hive_service.dart';
import '../../data/models/academic_doc_model.dart';

// ── OCR State ─────────────────────────────────────────────
enum OcrStatus { idle, picking, processing, done, error }

class OcrState {
  final OcrStatus status;
  final double progress;
  final String statusMessage;
  final OcrResult? result;
  final String? errorMessage;
  final bool needsReview; // NEW: low confidence marker

  const OcrState({
    this.status = OcrStatus.idle,
    this.progress = 0.0,
    this.statusMessage = '',
    this.result,
    this.errorMessage,
    this.needsReview = false,
  });

  OcrState copyWith({
    OcrStatus? status,
    double? progress,
    String? statusMessage,
    OcrResult? result,
    String? errorMessage,
    bool? needsReview,
  }) {
    return OcrState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      statusMessage: statusMessage ?? this.statusMessage,
      result: result ?? this.result,
      errorMessage: errorMessage,
      needsReview: needsReview ?? this.needsReview,
    );
  }
}

// ── OCR Notifier ──────────────────────────────────────────
class OcrNotifier extends StateNotifier<OcrState> {
  OcrNotifier() : super(const OcrState());

  final _ocrService = OcrService.instance;
  static const double _reviewThreshold = 0.85;

  Future<OcrResult?> scanFromCamera() async {
    return _processImage(() => _ocrService.pickFromCamera());
  }

  Future<OcrResult?> scanFromGallery() async {
    return _processImage(() => _ocrService.pickFromGallery());
  }

  /// Pick a PDF from storage and send it to the local PDF-parser microservice.
  Future<OcrResult?> scanFromPdf() async {
    state = state.copyWith(
      status: OcrStatus.picking,
      progress: 0.05,
      statusMessage: 'Opening file picker…',
      errorMessage: null,
      needsReview: false,
    );

    // Let user pick a PDF file
    FilePickerResult? picked;
    try {
      picked = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );
    } catch (_) {
      state = state.copyWith(
        status: OcrStatus.error,
        errorMessage: 'Could not open file picker.',
      );
      return null;
    }

    if (picked == null || picked.files.isEmpty) {
      state = const OcrState();
      return null;
    }

    final pickedFile = picked.files.first;
    Uint8List? pdfBytes = pickedFile.bytes;
    if (pdfBytes == null && pickedFile.path != null) {
      pdfBytes = await File(pickedFile.path!).readAsBytes();
    }
    if (pdfBytes == null) {
      state = state.copyWith(
        status: OcrStatus.error,
        errorMessage: 'Failed to read PDF file.',
      );
      return null;
    }

    // Check server availability first
    state = state.copyWith(
      status: OcrStatus.processing,
      progress: 0.15,
      statusMessage: 'Connecting to PDF parser…',
    );

    final isAvailable = await PdfParserService.instance.isServerAvailable();
    if (!isAvailable) {
      state = state.copyWith(
        status: OcrStatus.error,
        errorMessage:
            'PDF parser service is offline.\nPlease start it: cd tools/pdf_parser && start.bat',
      );
      return null;
    }

    state = state.copyWith(
      progress: 0.30,
      statusMessage: 'Layer 1: Reading PDF pages…',
    );
    await Future.delayed(const Duration(milliseconds: 200));

    state = state.copyWith(
      progress: 0.50,
      statusMessage: 'Layer 2: Running OCR on pages…',
    );

    final result = await PdfParserService.instance.parsePdf(pdfBytes);

    state = state.copyWith(
      progress: 0.80,
      statusMessage: 'Layer 3: Parsing marksheet fields…',
    );
    await Future.delayed(const Duration(milliseconds: 200));

    if (!result.success) {
      state = state.copyWith(
        status: OcrStatus.error,
        progress: 0.0,
        errorMessage: result.errorMessage ?? 'PDF parsing failed.',
        needsReview: false,
      );
      return null;
    }

    final needsReview = result.confidence < _reviewThreshold;

    // Save a record in Hive (no image file for PDFs)
    final doc = AcademicDocModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      docType: result.docType,
      fileName: '', // PDFs have no cached image path
      extractedText: result.rawText,
      board: result.board,
      year: result.year,
      aggregate: result.aggregate,
      stream: result.stream,
      confidence: result.confidence,
      isVerified: !needsReview,
      uploadedAt: DateTime.now(),
    );
    await HiveService.saveDoc(doc);

    state = state.copyWith(
      status: OcrStatus.done,
      progress: 1.0,
      statusMessage: needsReview
          ? 'PDF parsed. Please review detected fields.'
          : 'Done! PDF data extracted successfully.',
      result: result,
      needsReview: needsReview,
      errorMessage: null,
    );

    return result;
  }

  Future<OcrResult?> _processImage(
    Future<File?> Function() picker,
  ) async {
    state = state.copyWith(
      status: OcrStatus.picking,
      progress: 0.1,
      statusMessage: 'Opening camera...',
      errorMessage: null,
      needsReview: false,
    );

    final imageFile = await picker();
    if (imageFile == null) {
      state = const OcrState();
      return null;
    }

    state = state.copyWith(
      status: OcrStatus.processing,
      progress: 0.3,
      statusMessage: 'Layer 1: Pre-processing image...',
    );
    await Future.delayed(const Duration(milliseconds: 350));

    state = state.copyWith(
      progress: 0.5,
      statusMessage: 'Layer 2: Detecting document layout...',
    );
    await Future.delayed(const Duration(milliseconds: 300));

    state = state.copyWith(
      progress: 0.7,
      statusMessage: 'Layer 3: Extracting text...',
    );

    final result = await _ocrService.extractText(imageFile);

    state = state.copyWith(
      progress: 0.9,
      statusMessage: 'Layer 4: Parsing data...',
    );
    await Future.delayed(const Duration(milliseconds: 250));

    if (!result.success) {
      state = state.copyWith(
        status: OcrStatus.error,
        progress: 0.0,
        errorMessage: result.errorMessage ?? 'OCR failed',
        needsReview: false,
      );
      return null;
    }

    final needsReview = result.confidence < _reviewThreshold;

    // Save image permanently for the viewer feature
    String savedFileName = '';
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final ext = p.extension(imageFile.path);
      final newFileName = 'doc_${DateTime.now().millisecondsSinceEpoch}$ext';
      final newPath = p.join(docsDir.path, newFileName);
      final savedFile = await imageFile.copy(newPath);
      savedFileName = savedFile.path;
    } catch (e) {
      print('Failed to save document image: $e');
    }

    final doc = AcademicDocModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      docType: result.docType,
      fileName: savedFileName,
      extractedText: result.rawText,
      board: result.board,
      year: result.year,
      aggregate: result.aggregate,
      stream: result.stream,
      confidence: result.confidence,
      isVerified: !needsReview,
      uploadedAt: DateTime.now(),
    );
    await HiveService.saveDoc(doc);

    state = state.copyWith(
      status: OcrStatus.done,
      progress: 1.0,
      statusMessage: needsReview
          ? 'Extraction done. Please review detected fields.'
          : 'Done! Data extracted successfully.',
      result: result,
      needsReview: needsReview,
      errorMessage: null,
    );

    return result;
  }

  void markReviewed() {
    state = state.copyWith(needsReview: false);
  }

  void reset() => state = const OcrState();
}

// ── Provider ──────────────────────────────────────────────
final ocrProvider = StateNotifierProvider<OcrNotifier, OcrState>(
  (ref) => OcrNotifier(),
);