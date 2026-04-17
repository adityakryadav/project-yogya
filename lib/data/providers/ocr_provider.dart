import 'dart:io';
import 'package:flutter/foundation.dart'; // Add for kIsWeb
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/ocr_service.dart';
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

  Future<OcrResult?> uploadAndParsePdf() async {
    return _processDocument(() => _ocrService.pickPdfDocument());
  }

  Future<OcrResult?> _processDocument(
    Future<PlatformFile?> Function() picker,
  ) async {
    state = state.copyWith(
      status: OcrStatus.picking,
      progress: 0.1,
      statusMessage: 'Opening file picker...',
      errorMessage: null,
      needsReview: false,
    );

    final pdfFile = await picker();
    if (pdfFile == null) {
      state = const OcrState();
      return null;
    }

    state = state.copyWith(
      status: OcrStatus.processing,
      progress: 0.3,
      statusMessage: 'Loading PDF Document...',
    );
    await Future.delayed(const Duration(milliseconds: 350));

    state = state.copyWith(
      progress: 0.5,
      statusMessage: 'Extracting text layer...',
    );
    await Future.delayed(const Duration(milliseconds: 300));

    state = state.copyWith(
      progress: 0.7,
      statusMessage: 'Parsing extracted data...',
    );

    final result = await _ocrService.extractText(pdfFile);

    state = state.copyWith(
      progress: 0.9,
      statusMessage: 'Finalizing PDF parsing...',
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
    if (!kIsWeb) {
      try {
        final docsDir = await getApplicationDocumentsDirectory();
        final ext = p.extension(pdfFile.name);
        final newFileName = 'doc_${DateTime.now().millisecondsSinceEpoch}$ext';
        final newPath = p.join(docsDir.path, newFileName);
        final file = File(pdfFile.path!);
        final savedFile = await file.copy(newPath);
        savedFileName = savedFile.path;
      } catch (e) {
        print('Failed to save document: $e');
      }
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
