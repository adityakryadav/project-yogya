import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: const Text('AY', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            const Text('Basic Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            _buildInfoCard(),
            const SizedBox(height: 24),
            const Text('Academic Documents', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            _buildDocumentItem('10th Marksheet', isCompulsory: true, scanned: true),
            _buildDocumentItem('12th Marksheet', isCompulsory: false, scanned: true),
            _buildDocumentItem('Graduation Certificate', isCompulsory: false, scanned: false),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Check My Eligibility Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          const Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.textSecondary,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
              ),
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.edit, size: 16, color: Colors.white),
              )
            ],
          ),
          const SizedBox(height: 16),
          const Text('Aditi Sharma', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text('Aspirant ID: YG-882199', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              initialValue: '12/04/2000',
              decoration: const InputDecoration(
                labelText: 'Date of Birth',
                suffixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: 'Female',
              decoration: const InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
              items: ['Male', 'Female', 'Other'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              onChanged: (v) {},
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Social Category', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCategoryPill('General', true),
                    _buildCategoryPill('OBC', false),
                    _buildCategoryPill('SC', false),
                    _buildCategoryPill('ST', false),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPill(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.pageBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDocumentItem(String title, {required bool isCompulsory, required bool scanned}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          scanned ? Icons.check_circle : Icons.error_outline,
          color: scanned ? AppColors.success : AppColors.textSecondary,
          size: 32,
        ),
        title: Row(
          children: [
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
            if (isCompulsory)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(4)),
                child: const Text('COMPULSORY', style: TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
        subtitle: Text(scanned ? 'Verified & Stored Locally' : 'Missing Document', style: TextStyle(color: scanned ? AppColors.success : AppColors.error, fontSize: 12)),
        trailing: scanned
            ? const Icon(Icons.chevron_right)
            : ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: const Text('Add'),
              ),
      ),
    );
  }
}
