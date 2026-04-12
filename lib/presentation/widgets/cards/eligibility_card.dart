import 'package:flutter/material.dart';

class EligibilityCard extends StatelessWidget {
  final String title;
  final bool isEligible;

  EligibilityCard({
    super.key,
    required this.title,
    required this.isEligible,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isEligible ? Colors.green[50] : Colors.red[50],
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              isEligible ? Icons.check_circle : Icons.cancel,
              color: isEligible ? Colors.green : Colors.red,
            ),
            SizedBox(width: 16),
            Text(title),
          ],
        ),
      ),
    );
  }
}
