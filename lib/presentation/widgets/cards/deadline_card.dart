import 'package:flutter/material.dart';

class DeadlineCard extends StatelessWidget {
  final String title;
  final DateTime? deadline;

  DeadlineCard({
    super.key,
    required this.title,
    this.deadline,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            if (deadline != null) SizedBox(height: 8),
            if (deadline != null) Text('Deadline: ${deadline.toString()}'),
          ],
        ),
      ),
    );
  }
}
