import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';

void main() async {
  final file = File('../../CLASS 10 MARKSHEET DIGILOCKER.pdf');
  final bytes = await file.readAsBytes();
  final document = PdfDocument(inputBytes: bytes);
  final textExtractor = PdfTextExtractor(document);
  String rawText = textExtractor.extractText();
  document.dispose();
  print('--- RAW TEXT ---');
  print(rawText);
}
