import 'package:flutter/material.dart';

class OcrViewfinder extends StatelessWidget {
  final VoidCallback onCapture;

  OcrViewfinder({super.key, required this.onCapture});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 400,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onCapture,
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
