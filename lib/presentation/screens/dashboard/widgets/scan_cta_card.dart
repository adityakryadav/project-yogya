import 'package:flutter/material.dart';

class ScanCtaCard extends StatelessWidget {
  final VoidCallback onTap;

  ScanCtaCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.camera_alt, size: 40),
              SizedBox(height: 16),
              Text('Scan Document'),
            ],
          ),
        ),
      ),
    );
  }
}
