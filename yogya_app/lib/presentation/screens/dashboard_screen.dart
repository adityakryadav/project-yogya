import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildAlertBanner(),
          const SizedBox(height: 24),
          _buildDonutCard(),
          const SizedBox(height: 24),
          _buildScanCTA(context),
          const SizedBox(height: 24),
          const Text('Upcoming Deadlines', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          _buildDeadlineCard('CDS II 2024 Application', '12 Days', true),
          const SizedBox(height: 12),
          _buildDeadlineCard('SSC CGL Registration', '28 Days', false),
          const SizedBox(height: 24),
          _buildRecentDocument(),
          const SizedBox(height: 24),
          _buildMotivationalQuote(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildAlertBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1), // Pastel Gold
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.star, color: AppColors.warning),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'You are eligible for upcoming CDS II 2024 - Check Details',
              style: TextStyle(color: Colors.orange[900], fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonutCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      startDegreeOffset: -90,
                      sections: [
                        PieChartSectionData(color: AppColors.primary, value: 3, radius: 10, showTitle: false),
                        PieChartSectionData(color: AppColors.pageBackground, value: 3, radius: 10, showTitle: false),
                      ],
                    ),
                  ),
                  const Center(
                    child: Text('3 / 6', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('UPSC CSE', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  SizedBox(height: 4),
                  Text('Attempts Left', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                  SizedBox(height: 8),
                  Text('General Category', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanCTA(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [AppColors.primary, Color(0xFF5A75ED)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Row(
          children: [
            Icon(Icons.document_scanner, color: Colors.white, size: 32),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Scan Marksheet', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Extract marks & verify eligibility instantly', style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDeadlineCard(String title, String timeRemaining, bool isHighPriority) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isHighPriority ? AppColors.error.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(timeRemaining.split(' ')[0], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isHighPriority ? AppColors.error : AppColors.primary)),
                  Text(timeRemaining.split(' ')[1].toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: isHighPriority ? AppColors.error : AppColors.primary)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isHighPriority)
                    Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(4)),
                      child: const Text('HIGH PRIORITY', style: TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentDocument() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent Verification', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                Icon(Icons.verified, color: AppColors.success, size: 18),
              ],
            ),
            const SizedBox(height: 12),
            const Text('10th Grade Marksheet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            const Text('Data successfully extracted and saved locally.', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(onPressed: () {}, child: const Text('Update Data', style: TextStyle(color: AppColors.textPrimary))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(onPressed: () {}, child: const Text('View File')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationalQuote() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.format_quote, color: Colors.white54, size: 32),
          SizedBox(height: 8),
          Text(
            '"Success is not final, failure is not fatal: it is the courage to continue that counts."',
            style: TextStyle(color: Colors.white, fontSize: 16, fontStyle: FontStyle.italic, height: 1.5),
          ),
          SizedBox(height: 12),
          Text('- Daily Aspirant Pulse', style: TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
