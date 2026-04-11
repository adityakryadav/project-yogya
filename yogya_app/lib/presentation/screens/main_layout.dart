import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  void _onItemTapped(int index, BuildContext context) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/timeline');
        break;
      case 2:
        context.go('/scanner');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yogya', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primary),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          )
        ],
      ),
      drawer: _buildDrawer(context),
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) => _onItemTapped(index, context),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.timeline), label: 'Timeline'),
            BottomNavigationBarItem(icon: Icon(Icons.document_scanner), label: 'Scan'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60, bottom: 24, left: 16, right: 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.darkBackground],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Text('AY', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Aditi Sharma', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('UPSC ASPIRANT', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 8),
              children: [
                _buildDrawerItem(Icons.home_rounded, 'Home', () {
                  Navigator.pop(context);
                  context.go('/dashboard');
                }),
                _buildDrawerItem(Icons.rule, 'Eligibility Engine', () {
                  Navigator.pop(context);
                  context.push('/eligibility_engine');
                }, trailing: Container(
                  width: 8, height: 8,
                  decoration: const BoxDecoration(color: AppColors.warning, shape: BoxShape.circle),
                )),
                _buildDrawerItem(Icons.folder_shared, 'My Documents', () {
                  Navigator.pop(context);
                  context.go('/scanner');
                }),
                _buildDrawerItem(Icons.history, 'Attempt History', () {}),
                const Divider(height: 32),
                const Padding(
                  padding: EdgeInsets.only(left: 16, bottom: 8),
                  child: Text('SUPPORT & ACCOUNT', style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                ),
                _buildDrawerItem(Icons.settings, 'Settings', () {
                  Navigator.pop(context);
                  context.push('/settings');
                }),
                _buildDrawerItem(Icons.help_outline, 'Help & Support', () {}),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.pageBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.primary),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text('Profile 80% complete. Scan Graduation Certificate to finish.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap, {Widget? trailing}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textPrimary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
