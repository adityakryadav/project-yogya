import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class DocumentsScannerScreen extends StatelessWidget {
  const DocumentsScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        title: const Text('My Documents', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(icon: const Icon(Icons.help_outline), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildViewfinderPlaceholder(),
            const SizedBox(height: 24),
            _buildProgressCard(),
            const SizedBox(height: 24),
            const Text('Recently Scanned', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildPrimaryRecord(),
            const SizedBox(height: 16),
            _buildCompactRecord('JEE Advanced Rank Card'),
            _buildCompactRecord('IELTS Score Certificate'),
            const SizedBox(height: 24),
            _buildImportBanner(),
          ],
        ),
      ),
    );
  }

  Widget _buildViewfinderPlaceholder() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.document_scanner_outlined, color: Colors.white54, size: 64),
              SizedBox(height: 16),
              Text(
                'ALIGN DOCUMENT WITHIN FRAME',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5),
              ),
              SizedBox(height: 8),
              Text('Camera feed disabled in mockup', style: TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
          Positioned(
            bottom: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.small(
                  heroTag: 'flash',
                  onPressed: () {},
                  backgroundColor: Colors.white24,
                  child: const Icon(Icons.flash_off, color: Colors.white),
                ),
                const SizedBox(width: 24),
                FloatingActionButton(
                  heroTag: 'shutter',
                  onPressed: () {},
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.camera_alt, color: Colors.white),
                ),
                const SizedBox(width: 24),
                FloatingActionButton.small(
                  heroTag: 'gallery',
                  onPressed: () {},
                  backgroundColor: Colors.white24,
                  child: const Icon(Icons.photo_library, color: Colors.white),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Extracting Marks Data...', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                Text('68%', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink[400])),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: const LinearGradient(colors: [AppColors.primary, Colors.pink]),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStepBadge('Table Detected', true),
                const SizedBox(width: 8),
                _buildStepBadge('Text Alignment', true),
                const SizedBox(width: 8),
                _buildStepBadge('Processing', false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepBadge(String text, bool completed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: completed ? AppColors.success.withOpacity(0.1) : AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(completed ? Icons.check_circle : Icons.sync, size: 12, color: completed ? AppColors.success : AppColors.warning),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 10, color: completed ? AppColors.success : AppColors.warning, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPrimaryRecord() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4)),
                  child: const Text('PRIMARY RECORD', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const Icon(Icons.share, size: 20, color: AppColors.textSecondary),
              ],
            ),
            const SizedBox(height: 12),
            const Text('12th Grade Marksheet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            const Row(
              children: [
                Text('Aggregate: ', style: TextStyle(color: AppColors.textSecondary)),
                Text('88.4%', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                SizedBox(width: 16),
                Text('Confidence: ', style: TextStyle(color: AppColors.textSecondary)),
                Text('99.2%', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.success)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () {}, child: const Text('Verify Data')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactRecord(String title) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.description, color: AppColors.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.chevron_right),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  Widget _buildImportBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.folder_zip, color: Colors.white, size: 36),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Missing a document?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text('Import existing PDFs directly.', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, visualDensity: VisualDensity.compact),
            child: const Text('Import Files'),
          ),
        ],
      ),
    );
  }
}
