import 'dart:io';

void main() async {
  final text = await File('.gemini/scratch/test_extract_out.txt').readAsString();
  final lines = text.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();

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

  final rollNumber = findNextLine(['Roll No.', 'Enrollment No']);
  final motherName = findNextLine(["Mother's Name", 'Mother Name']);
  final fatherName = findNextLine(["Father's / Guardian's Name", "Father's Name"]);
  final dob = findNextLine(['Date of Birth', 'DOB']);
  final name = findNextLine(['This is to certify that', 'Student Name', 'Name']);
  final school = findNextLine(['School', 'Institution']);

  print('Name: $name');
  print('Roll: $rollNumber');
  print('Mother: $motherName');
  print('Father: $fatherName');
  print('DOB: $dob');
  print('School: $school');

  // Subjects
  Map<String, String> subjects = {};
  for(int i=0; i < lines.length; i++) {
    final line = lines[i];
    // Subject code is usually exactly 3 digits
    if (RegExp(r'^\d{3}$').hasMatch(line)) {
      if (i + 4 < lines.length) {
        final subjName = lines[i+1];
        final totalMarks = lines[i+4];
        if (RegExp(r'^\d{2,3}$').hasMatch(totalMarks) && RegExp(r'[a-zA-Z]').hasMatch(subjName)) {
            subjects[subjName] = totalMarks;
        }
      }
    }
  }
  print('Subjects: $subjects');
}
