import 'package:flutter/material.dart';

class ExamCard extends StatelessWidget {
  final String examName;
  final String? code;

  ExamCard({
    super.key,
    required this.examName,
    this.code,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(examName, style: Theme.of(context).textTheme.titleMedium),
            if (code != null) SizedBox(height: 8),
            if (code != null) Text(code!),
          ],
        ),
      ),
    );
  }
}
