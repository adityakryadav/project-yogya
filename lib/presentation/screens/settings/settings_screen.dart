import '../../../core/theme/theme_colors.dart';
// import 'package:flutter/material.dart';
// import '../../../core/constants/colors.dart';
// import '../../../core/constants/strings.dart';
// import '../../../core/constants/app_animations.dart';

// class SettingsScreen extends StatefulWidget {
//   SettingsScreen({super.key});

//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen>
//     with SingleTickerProviderStateMixin {
//   bool _darkMode = true;
//   bool _pushNotifications = true;
//   bool _examReminders = true;
//   bool _deadlineAlerts = true;

//   late AnimationController _ctrl;
//   late List<Animation<double>> _fadeAnims;
//   late List<Animation<Offset>> _slideAnims;

//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 1200),
//     );

//     _fadeAnims = List.generate(5, (i) {
//       return Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
//         parent: _ctrl,
//         curve: Interval(i * 0.12, 0.5 + i * 0.1, curve: Curves.easeOut),
//       ));
//     });

//     _slideAnims = List.generate(5, (i) {
//       return Tween<Offset>(
//         begin: Offset(0, 0.15),
//         end: Offset.zero,
//       ).animate(CurvedAnimation(
//         parent: _ctrl,
//         curve: Interval(i * 0.12, 0.5 + i * 0.1, curve: Curves.easeOutCubic),
//       ));
//     });

//     _ctrl.forward();
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }

//   Widget _animItem(int index, Widget child) {
//     final i = index.clamp(0, 4);
//     return SlideTransition(
//       position: _slideAnims[i],
//       child: FadeTransition(opacity: _fadeAnims[i], child: child),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: context.colors.bgDark,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_rounded, color: context.colors.textPrimary),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Text(
//           'Settings',
//           style: TextStyle(
//             color: context.colors.textPrimary,
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//             fontFamily: 'Poppins',
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           physics: BouncingScrollPhysics(),
//           padding: EdgeInsets.all(20),
//           child: Column(
//             children: [
//               // Appearance
//               _animItem(
//                 0,
//                 _buildSection(
//                   'Appearance',
//                   Icons.palette_outlined,
//                   [
//                     _buildToggleTile(
//                       'Dark Mode',
//                       'Switch between light and dark theme',
//                       Icons.dark_mode_rounded,
//                       _darkMode,
//                       (val) => setState(() => _darkMode = val),
//                     ),
//                   ],
//                 ),
//               ),

//               SizedBox(height: 16),

//               // Notifications
//               _animItem(
//                 1,
//                 _buildSection(
//                   'Notifications',
//                   Icons.notifications_outlined,
//                   [
//                     _buildToggleTile(
//                       'Push Notifications',
//                       'Receive push notifications',
//                       Icons.notifications_active_rounded,
//                       _pushNotifications,
//                       (val) => setState(() => _pushNotifications = val),
//                     ),
//                     Divider(color: context.colors.glassBorder, height: 1),
//                     _buildToggleTile(
//                       'Exam Reminders',
//                       'Get notified before exam dates',
//                       Icons.alarm_rounded,
//                       _examReminders,
//                       (val) => setState(() => _examReminders = val),
//                     ),
//                     Divider(color: context.colors.glassBorder, height: 1),
//                     _buildToggleTile(
//                       'Deadline Alerts',
//                       'Application deadline notifications',
//                       Icons.timer_rounded,
//                       _deadlineAlerts,
//                       (val) => setState(() => _deadlineAlerts = val),
//                     ),
//                   ],
//                 ),
//               ),

//               SizedBox(height: 16),

//               // Data & Storage
//               _animItem(
//                 2,
//                 _buildSection(
//                   'Data & Storage',
//                   Icons.storage_rounded,
//                   [
//                     _buildActionTile(
//                       'Clear Cache',
//                       'Free up storage space',
//                       Icons.cleaning_services_rounded,
//                       () => _showSnack('Cache cleared'),
//                     ),
//                     Divider(color: context.colors.glassBorder, height: 1),
//                     _buildActionTile(
//                       'Export Data',
//                       'Download your data as JSON',
//                       Icons.download_rounded,
//                       () => _showSnack('Data exported'),
//                     ),
//                   ],
//                 ),
//               ),

//               SizedBox(height: 16),

//               // About
//               _animItem(
//                 3,
//                 _buildSection(
//                   'About',
//                   Icons.info_outline_rounded,
//                   [
//                     _buildInfoTile('Version', AppStrings.version, Icons.tag_rounded),
//                     Divider(color: context.colors.glassBorder, height: 1),
//                     _buildActionTile(
//                       'Terms of Service',
//                       'Read our terms',
//                       Icons.description_rounded,
//                       () {},
//                     ),
//                     Divider(color: context.colors.glassBorder, height: 1),
//                     _buildActionTile(
//                       'Privacy Policy',
//                       'How we handle your data',
//                       Icons.privacy_tip_rounded,
//                       () {},
//                     ),
//                     Divider(color: context.colors.glassBorder, height: 1),
//                     _buildActionTile(
//                       'Open Source Licenses',
//                       'Third party licenses',
//                       Icons.code_rounded,
//                       () {},
//                     ),
//                   ],
//                 ),
//               ),

//               SizedBox(height: 16),

//               // Logout
//               _animItem(
//                 4,
//                 GestureDetector(
//                   onTap: () {
//                     showDialog(
//                       context: context,
//                       builder: (context) => AlertDialog(
//                         backgroundColor: context.colors.bgCard,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         title: Text(
//                           'Logout',
//                           style: TextStyle(
//                             color: context.colors.textPrimary,
//                             fontFamily: 'Poppins',
//                           ),
//                         ),
//                         content: Text(
//                           'Are you sure you want to logout?',
//                           style: TextStyle(
//                             color: context.colors.textSecondary,
//                             fontFamily: 'Poppins',
//                           ),
//                         ),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(context),
//                             child: Text('Cancel'),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                               // TODO: Implement actual logout
//                             },
//                             child: Text(
//                               'Logout',
//                               style: TextStyle(color: context.colors.ineligible),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                   child: Container(
//                     padding: EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: context.colors.ineligible.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(14),
//                       border: Border.all(
//                         color: context.colors.ineligible.withOpacity(0.3),
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.logout_rounded,
//                             color: context.colors.ineligible, size: 20),
//                         SizedBox(width: 10),
//                         Text(
//                           'Logout',
//                           style: TextStyle(
//                             color: context.colors.ineligible,
//                             fontSize: 15,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: 'Poppins',
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               SizedBox(height: 30),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSection(String title, IconData icon, List<Widget> children) {
//     return Container(
//       decoration: BoxDecoration(
//         color: context.colors.bgCard,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: context.colors.glassBorder),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
//             child: Row(
//               children: [
//                 Icon(icon, color: context.colors.primaryLight, size: 18),
//                 SizedBox(width: 10),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     color: context.colors.textPrimary,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w600,
//                     fontFamily: 'Poppins',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           ...children,
//         ],
//       ),
//     );
//   }

//   Widget _buildToggleTile(
//     String title,
//     String subtitle,
//     IconData icon,
//     bool value,
//     ValueChanged<bool> onChanged,
//   ) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       child: Row(
//         children: [
//           Container(
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               color: context.colors.bgCardLight,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(icon, color: context.colors.textSecondary, size: 18),
//           ),
//           SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     color: context.colors.textPrimary,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     fontFamily: 'Poppins',
//                   ),
//                 ),
//                 Text(
//                   subtitle,
//                   style: TextStyle(
//                     color: context.colors.textHint,
//                     fontSize: 11,
//                     fontFamily: 'Poppins',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Switch(
//             value: value,
//             onChanged: onChanged,
//             activeColor: context.colors.primary,
//             activeTrackColor: context.colors.primary.withOpacity(0.3),
//             inactiveThumbColor: context.colors.textHint,
//             inactiveTrackColor: context.colors.bgCardLight,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionTile(
//     String title,
//     String subtitle,
//     IconData icon,
//     VoidCallback onTap,
//   ) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         child: Row(
//           children: [
//             Container(
//               width: 36,
//               height: 36,
//               decoration: BoxDecoration(
//                 color: context.colors.bgCardLight,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(icon, color: context.colors.textSecondary, size: 18),
//             ),
//             SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       color: context.colors.textPrimary,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                       fontFamily: 'Poppins',
//                     ),
//                   ),
//                   Text(
//                     subtitle,
//                     style: TextStyle(
//                       color: context.colors.textHint,
//                       fontSize: 11,
//                       fontFamily: 'Poppins',
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Icon(Icons.chevron_right_rounded,
//                 color: context.colors.textHint, size: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoTile(String title, String value, IconData icon) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Row(
//         children: [
//           Container(
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               color: context.colors.bgCardLight,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(icon, color: context.colors.textSecondary, size: 18),
//           ),
//           SizedBox(width: 12),
//           Text(
//             title,
//             style: TextStyle(
//               color: context.colors.textPrimary,
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               fontFamily: 'Poppins',
//             ),
//           ),
//           Spacer(),
//           Text(
//             value,
//             style: TextStyle(
//               color: context.colors.textHint,
//               fontSize: 13,
//               fontFamily: 'Poppins',
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showSnack(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(msg),
//         backgroundColor: context.colors.eligible,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import '../../../data/providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/settings_provider.dart';

// ── Change 1: StatefulWidget → ConsumerStatefulWidget ──────
class SettingsScreen extends ConsumerStatefulWidget {
  SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

// ── Change 2: State → ConsumerState ────────────────────────
class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late List<Animation<double>> _fadeAnims;
  late List<Animation<Offset>> _slideAnims;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );

    _fadeAnims = List.generate(5, (i) {
      return Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _ctrl,
        curve: Interval(i * 0.12, 0.5 + i * 0.1, curve: Curves.easeOut),
      ));
    });

    _slideAnims = List.generate(5, (i) {
      return Tween<Offset>(
        begin: Offset(0, 0.15),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _ctrl,
        curve: Interval(i * 0.12, 0.5 + i * 0.1, curve: Curves.easeOutCubic),
      ));
    });

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _animItem(int index, Widget child) {
    final i = index.clamp(0, 4);
    return SlideTransition(
      position: _slideAnims[i],
      child: FadeTransition(opacity: _fadeAnims[i], child: child),
    );
  }

  // ── Change 3: Logout function — real Firebase logout ──────
  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.colors.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Logout',
          style: TextStyle(
            color: context.colors.textPrimary,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(
            color: context.colors.textSecondary,
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancel',
              style: TextStyle(color: context.colors.textHint),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Logout',
              style: TextStyle(
                color: context.colors.ineligible,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    // User ne confirm kiya → real Firebase logout
    if (confirm == true && mounted) {
      await ref.read(authNotifierProvider.notifier).logout();
      // Router automatically /login par redirect kar dega
      // authStateProvider stream trigger hogi — kuch aur nahi karna
    }
  }

  @override
  Widget build(BuildContext context) {
    // Loading state watch karo (logout ke time spinner dikhayenge)
    final isLoggingOut = ref.watch(authNotifierProvider).isLoading;
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      backgroundColor: context.colors.bgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded,
              color: context.colors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: context.colors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // ── Profile Card ──────────────────────────
              _animItem(0, _buildProfileCard()),
              SizedBox(height: 24),
              // Appearance — same as before
              _animItem(
                1,
                _buildSection(
                  'Appearance',
                  Icons.palette_outlined,
                  [
                    _buildToggleTile(
                      'Dark Mode',
                      'Switch between light and dark theme',
                      Icons.dark_mode_rounded,
                      settings.darkMode,
                      (val) => settingsNotifier.setDarkMode(val),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Notifications — same as before
              _animItem(
                2,
                _buildSection(
                  'Notifications',
                  Icons.notifications_outlined,
                  [
                    _buildToggleTile(
                      'Push Notifications',
                      'Receive push notifications',
                      Icons.notifications_active_rounded,
                      settings.pushNotifications,
                      (val) => settingsNotifier.setPushNotifications(val),
                    ),
                    Divider(color: context.colors.glassBorder, height: 1),
                    _buildToggleTile(
                      'Exam Reminders',
                      'Get notified before exam dates',
                      Icons.alarm_rounded,
                      settings.examReminders,
                      (val) => settingsNotifier.setExamReminders(val),
                    ),
                    Divider(color: context.colors.glassBorder, height: 1),
                    _buildToggleTile(
                      'Deadline Alerts',
                      'Application deadline notifications',
                      Icons.timer_rounded,
                      settings.deadlineAlerts,
                      (val) => settingsNotifier.setDeadlineAlerts(val),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // About
              _animItem(
                3,
                _buildSection(
                  'About',
                  Icons.info_outline_rounded,
                  [
                    _buildInfoTile(
                        'Version', AppStrings.version, Icons.tag_rounded),
                    Divider(color: context.colors.glassBorder, height: 1),
                    _buildInfoTile(
                        'Developer', 'Team Yogya', Icons.groups_rounded),
                    Divider(color: context.colors.glassBorder, height: 1),
                    _buildActionTile(
                      'Terms of Service',
                      'Read our terms',
                      Icons.description_rounded,
                      () => _showTermsOfService(),
                    ),
                    Divider(color: context.colors.glassBorder, height: 1),
                    _buildActionTile(
                      'Privacy Policy',
                      'How we handle your data',
                      Icons.privacy_tip_rounded,
                      () => _showPrivacyPolicy(),
                    ),
                    Divider(color: context.colors.glassBorder, height: 1),
                    _buildActionTile(
                      'Open Source Licenses',
                      'Third party licenses',
                      Icons.code_rounded,
                      () => _showOpenSourceLicenses(),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // ── Logout button — ab real Firebase logout ───
              _animItem(
                4,
                GestureDetector(
                  onTap: isLoggingOut ? null : _handleLogout,
                  child: AnimatedOpacity(
                    opacity: isLoggingOut ? 0.6 : 1.0,
                    duration: Duration(milliseconds: 200),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.colors.ineligible.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: context.colors.ineligible.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logout ho raha hai to spinner, warna icon
                          if (isLoggingOut)
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: context.colors.ineligible,
                              ),
                            )
                          else
                            Icon(Icons.logout_rounded,
                                color: context.colors.ineligible, size: 20),
                          SizedBox(width: 10),
                          Text(
                            isLoggingOut ? 'Logging out...' : 'Logout',
                            style: TextStyle(
                              color: context.colors.ineligible,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helper Widgets ──────────────────────────────────────

  Widget _buildProfileCard() {
    final profileState = ref.watch(profileNotifierProvider);
    final user = ref.watch(currentUserProvider);

    final name = profileState.profile?.name ?? user?.displayName ?? 'User';
    final email = profileState.profile?.email ?? user?.email ?? '';
    final role = profileState.profile?.qualification.isNotEmpty == true
        ? '${profileState.profile!.qualification} Aspirant'
        : 'Exam Aspirant';

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: context.colors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Center(
              child: Icon(Icons.person_rounded, color: Colors.white, size: 40),
            ),
          ),
          SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'PREMIUM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  role,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  email,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 11,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(icon, color: context.colors.primaryLight, size: 18),
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    color: context.colors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildToggleTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: context.colors.bgCardLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: context.colors.textSecondary, size: 18),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: context.colors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: context.colors.textHint,
                    fontSize: 11,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: context.colors.primary,
            activeTrackColor: context.colors.primary.withOpacity(0.3),
            inactiveThumbColor: context.colors.textHint,
            inactiveTrackColor: context.colors.bgCardLight,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: context.colors.bgCardLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: context.colors.textSecondary, size: 18),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: context.colors.textHint,
                      fontSize: 11,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: context.colors.textHint, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: context.colors.bgCardLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: context.colors.textSecondary, size: 18),
          ),
          SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
          Spacer(),
          Text(
            value,
            style: TextStyle(
              color: context.colors.textHint,
              fontSize: 13,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: context.colors.eligible,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ── About Dialogs ────────────────────────────────────────

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.colors.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.description_rounded,
                color: context.colors.primaryLight, size: 22),
            SizedBox(width: 10),
            Text(
              'Terms of Service',
              style: TextStyle(
                color: context.colors.textPrimary,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _tosSection('1. Acceptance of Terms',
                  'By downloading, installing, or using the Yogya application, you agree to be bound by these Terms of Service. If you do not agree, please do not use the app.'),
              _tosSection('2. Description of Service',
                  'Yogya is an exam eligibility tracking and preparation platform. It provides tools to check eligibility criteria, manage academic documents, and track exam timelines. The information is for guidance purposes only.'),
              _tosSection('3. User Accounts',
                  'You are responsible for maintaining the confidentiality of your account credentials. You must provide accurate and complete information during registration. You must be at least 13 years old to use this service.'),
              _tosSection('4. Acceptable Use',
                  'You agree not to misuse the service, upload false documents, attempt to reverse-engineer the app, or use automated tools to access the service. Any violation may result in account termination.'),
              _tosSection('5. Intellectual Property',
                  'All content, features, and functionality of Yogya are owned by Team Yogya and are protected by copyright and trademark laws.'),
              _tosSection('6. Disclaimer',
                  'Yogya provides eligibility information based on publicly available data. We do not guarantee accuracy of eligibility results. Always verify with official exam authorities before making decisions.'),
              _tosSection('7. Limitation of Liability',
                  'Yogya shall not be liable for any indirect, incidental, or consequential damages arising from use of the application.'),
              _tosSection('8. Changes to Terms',
                  'We reserve the right to modify these terms at any time. Continued use of the app after changes constitutes acceptance of the new terms.'),
              SizedBox(height: 8),
              Text(
                'Last updated: April 2026',
                style: TextStyle(
                  color: context.colors.textHint,
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Close',
              style: TextStyle(
                color: context.colors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tosSection(String title, String body) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 4),
          Text(
            body,
            style: TextStyle(
              color: context.colors.textSecondary,
              fontSize: 12,
              height: 1.5,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.colors.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.privacy_tip_rounded,
                color: context.colors.primaryLight, size: 22),
            SizedBox(width: 10),
            Text(
              'Privacy Policy',
              style: TextStyle(
                color: context.colors.textPrimary,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _tosSection('1. Information We Collect',
                  'We collect information you provide directly: name, email address, academic qualifications, and scanned document data. We also collect usage analytics such as feature usage frequency and app performance data.'),
              _tosSection('2. How We Use Your Information',
                  'Your information is used to provide eligibility checking services, personalize your experience, send exam deadline reminders, and improve our services. We do not sell your personal data to third parties.'),
              _tosSection('3. Data Storage',
                  'Your data is stored securely using Firebase services with encryption at rest and in transit. Academic documents are stored locally on your device using Hive encrypted storage and are not uploaded to our servers unless you explicitly choose to sync.'),
              _tosSection('4. Data Sharing',
                  'We do not share your personal information with third parties except: when required by law, to protect our rights, or with service providers who assist in operating our app (e.g., Firebase, Google Analytics) under strict data processing agreements.'),
              _tosSection('5. Your Rights',
                  'You have the right to access, correct, or delete your personal data at any time. You can export your data or request account deletion through the app settings or by contacting us.'),
              _tosSection('6. Cookies & Tracking',
                  'We use Firebase Analytics to collect anonymous usage data. You can opt out of analytics collection in the app notification settings.'),
              _tosSection('7. Children\'s Privacy',
                  'Yogya is not intended for children under 13. We do not knowingly collect personal information from children under 13 years of age.'),
              _tosSection('8. Contact Us',
                  'If you have questions about this Privacy Policy, please contact us at support@yogya-app.com.'),
              SizedBox(height: 8),
              Text(
                'Last updated: April 2026',
                style: TextStyle(
                  color: context.colors.textHint,
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Close',
              style: TextStyle(
                color: context.colors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOpenSourceLicenses() {
    showLicensePage(
      context: context,
      applicationName: 'Yogya',
      applicationVersion: '1.0.0',
      applicationIcon: Padding(
        padding: EdgeInsets.all(16),
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: context.colors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              'Y',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ),
      ),
      applicationLegalese:
          '© 2026 Team Yogya. All rights reserved.\n\n'
          'Yogya uses the following open source packages:\n'
          '• Flutter & Dart — BSD 3-Clause License\n'
          '• Firebase — Apache License 2.0\n'
          '• Riverpod — MIT License\n'
          '• GoRouter — BSD 3-Clause License\n'
          '• Hive — Apache License 2.0\n'
          '• Google Fonts — Apache License 2.0\n'
          '• FL Chart — MIT License\n'
          '• Flutter Secure Storage — BSD 3-Clause License\n\n'
          'Full license texts are available in the list below.',
    );
  }
}
