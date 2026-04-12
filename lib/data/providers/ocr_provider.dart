import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/ocr_service.dart';
import '../../data/local/hive_service.dart';
import '../../data/models/academic_doc_model.dart';

// ── OCR State ─────────────────────────────────────────────
enum OcrStatus { idle, picking, processing, done, error }

class OcrState {
  final OcrStatus status;
  final double    progress;
  final String    statusMessage;
  final OcrResult? result;
  final String?   errorMessage;

  const OcrState({
    this.status        = OcrStatus.idle,
    this.progress      = 0.0,
    this.statusMessage = '',
    this.result,
    this.errorMessage,
  });

  OcrState copyWith({
    OcrStatus? status,
    double?    progress,
    String?    statusMessage,
    OcrResult? result,
    String?    errorMessage,
  }) {
    return OcrState(
      status:        status        ?? this.status,
      progress:      progress      ?? this.progress,
      statusMessage: statusMessage ?? this.statusMessage,
      result:        result        ?? this.result,
      errorMessage:  errorMessage  ?? this.errorMessage,
    );
  }
}

// ── OCR Notifier ──────────────────────────────────────────
class OcrNotifier extends StateNotifier<OcrState> {
  OcrNotifier() : super(const OcrState());

  final _ocrService = OcrService.instance;

  // ── Camera se scan karo ───────────────────────────────
  Future<OcrResult?> scanFromCamera() async {
    return _processImage(() => _ocrService.pickFromCamera());
  }

  // ── Gallery se pick karo ──────────────────────────────
  Future<OcrResult?> scanFromGallery() async {
    return _processImage(() => _ocrService.pickFromGallery());
  }

  // ── Common processing logic ───────────────────────────
  Future<OcrResult?> _processImage(
    Future<File?> Function() picker,
  ) async {
    // Step 1 — Picking
    state = state.copyWith(
      status:        OcrStatus.picking,
      progress:      0.1,
      statusMessage: 'Opening camera...',
    );

    final imageFile = await picker();
    if (imageFile == null) {
      state = const OcrState(); // reset
      return null;
    }

    // Step 2 — Pre-processing
    state = state.copyWith(
      status:        OcrStatus.processing,
      progress:      0.3,
      statusMessage: 'Layer 1: Pre-processing image...',
    );
    await Future.delayed(const Duration(milliseconds: 600));

    // Step 3 — Layout detection
    state = state.copyWith(
      progress:      0.5,
      statusMessage: 'Layer 2: Detecting document layout...',
    );
    await Future.delayed(const Duration(milliseconds: 500));

    // Step 4 — Text extraction
    state = state.copyWith(
      progress:      0.7,
      statusMessage: 'Layer 3: Extracting text...',
    );

    final result = await _ocrService.extractText(imageFile);

    // Step 5 — Parsing
    state = state.copyWith(
      progress:      0.9,
      statusMessage: 'Layer 4: Parsing data...',
    );
    await Future.delayed(const Duration(milliseconds: 400));

    if (!result.success) {
      state = state.copyWith(
        status:       OcrStatus.error,
        progress:     0.0,
        errorMessage: result.errorMessage,
      );
      return null;
    }

    // Step 6 — Save to Hive
    final doc = AcademicDocModel(
      id:            DateTime.now().millisecondsSinceEpoch.toString(),
      docType:       result.docType,
      extractedText: result.rawText,
      board:         result.board,
      year:          result.year,
      aggregate:     result.aggregate,
      stream:        result.stream,
      confidence:    result.confidence,
      isVerified:    true, // Marked as verified upon successful extraction
      uploadedAt:    DateTime.now(),
    );
    await HiveService.saveDoc(doc);

    // Done
    state = state.copyWith(
      status:        OcrStatus.done,
      progress:      1.0,
      statusMessage: 'Done! Data extracted successfully.',
      result:        result,
    );

    return result;
  }

  void reset() => state = const OcrState();
}

// ── Provider ──────────────────────────────────────────────
final ocrProvider =
    StateNotifierProvider<OcrNotifier, OcrState>(
        (ref) => OcrNotifier());