import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../core/theme/app_colors.dart';

class EligibilityTimelineScreen extends StatelessWidget {
  const EligibilityTimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        title: const Text('Eligibility Timeline', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        automaticallyImplyLeading: false,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildNextDeadlineBanner(),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildTimelineNode(
                isFirst: true,
                isLast: false,
                color: AppColors.success,
                exam: 'UPSC CSE Prelims',
                status: 'ACTIVE',
                isEligible: true,
                details: 'Eligible • Attempt #2 / 6',
              ),
              _buildTimelineNode(
                isFirst: false,
                isLast: false,
                color: AppColors.error,
                exam: 'AFCAT',
                status: 'INELIGIBLE',
                isEligible: false,
                details: 'Age exceeded by 2 months',
              ),
              _buildTimelineNode(
                isFirst: false,
                isLast: true,
                color: AppColors.success,
                exam: 'CDS II 2024',
                status: 'UPCOMING',
                isEligible: true,
                details: 'Eligible • Register Now',
                showRegisterButton: true,
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildStrategicOverview(),
              ),
              const SizedBox(height: 32),
            ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildNextDeadlineBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.primary, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.timer, color: AppColors.primary),
              const SizedBox(width: 8),
              Text('NEXT DEADLINE IN 12 DAYS', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          const Text('CDS II 2024 Application', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('REGISTER NOW'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineNode({
    required bool isFirst,
    required bool isLast,
    required Color color,
    required String exam,
    required String status,
    required bool isEligible,
    required String details,
    bool showRegisterButton = false,
  }) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 20,
        color: color,
        padding: const EdgeInsets.all(6),
      ),
      beforeLineStyle: const LineStyle(color: Colors.grey, thickness: 2),
      endChild: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(exam, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(status, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(isEligible ? Icons.check_circle : Icons.cancel, color: color, size: 16),
                const SizedBox(width: 8),
                Text(details, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
            if (showRegisterButton) ...[
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                ),
                child: const Text('Official Portal Link'),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildStrategicOverview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.timeline, color: Colors.white),
              SizedBox(width: 8),
              Text('Strategic Overview', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Current Age:', style: TextStyle(color: Colors.white70)),
              Text('23 YRS 4 MOS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Valid Attempts:', style: TextStyle(color: Colors.white70)),
              Text('14 across 5 exams', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download, color: AppColors.primary),
              label: const Text('DOWNLOAD ROADMAP', style: TextStyle(color: AppColors.primary)),
              style: TextButton.styleFrom(backgroundColor: AppColors.primary.withOpacity(0.1)),
            ),
          )
        ],
      ),
    );
  }
}
