import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

void main() {
  test('Extract PDF text', () async {
    final file = File('CLASS 10 MARKSHEET DIGILOCKER.pdf');
    final bytes = await file.readAsBytes();
    final document = PdfDocument(inputBytes: bytes);
    final textExtractor = PdfTextExtractor(document);
    String rawText = textExtractor.extractText();
    document.dispose();
    
    final outFile = File('.gemini/scratch/test_extract_out.txt');
    await outFile.writeAsString(rawText);
    print('Wrote output to file');
  });
}
