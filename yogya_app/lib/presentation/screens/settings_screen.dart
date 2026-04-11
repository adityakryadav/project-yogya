import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileCard(),
            const SizedBox(height: 24),
            _buildSectionHeader('Account Management'),
            _buildSettingsTile(Icons.person_outline, 'Profile Information'),
            _buildSettingsTile(Icons.notifications_none, 'Notifications'),
            _buildSettingsTile(Icons.security, 'Security & Privacy'),
            const SizedBox(height: 24),
            _buildSectionHeader('App Preferences'),
            _buildSettingsTile(Icons.language, 'App Language', trailing: const Text('English (UK)', style: TextStyle(color: AppColors.textSecondary))),
            _buildDarkThemeToggle(),
            const SizedBox(height: 24),
            _buildSectionHeader('Legal & Support'),
            _buildSettingsTile(Icons.privacy_tip_outlined, 'Privacy Policy'),
            _buildSettingsTile(Icons.description_outlined, 'Terms of Service'),
            _buildSettingsTile(Icons.help_outline, 'Help Center & FAQ'),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: () {
                  context.go('/login');
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                ),
                child: const Text('Sign Out', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 24),
            const Text('VERSION 2.4.1 (SCHOLAR PULSE)', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.textSecondary,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Aditi Sharma', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  const Text('UPSC Aspirant • Delhi, IN', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFF39C12)]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('PREMIUM MEMBER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, {Widget? trailing}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        trailing: trailing ?? const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        onTap: () {},
      ),
    );
  }

  Widget _buildDarkThemeToggle() {
    return Card(
      margin: const EdgeInsets.only(bottom: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: SwitchListTile(
        title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        secondary: const Icon(Icons.dark_mode_outlined, color: AppColors.primary),
        value: false,
        onChanged: (val) {},
        activeColor: AppColors.primary,
      ),
    );
  }
}
