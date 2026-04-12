import '../../../core/theme/theme_colors.dart';
// ============================================================
// YOGYA — settings_screen_logout_patch.dart
// SPRINT 1: Sirf logout button patch
//
// Apni existing settings_screen.dart mein yeh changes karo:
//
// 1. StatelessWidget → ConsumerWidget
// 2. Import add karo
// 3. _buildLogoutButton replace karo
//
// Neeche puri updated logout method hai.
// ============================================================

// ── Step 1: Imports add karo settings_screen.dart ke top par ──
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../data/providers/auth_provider.dart';
// import '../../../core/router/app_router.dart';

// ── Step 2: class SignOut button ya logout ListTile ko
//    replace karo with yeh widget: ─────────────────────────

/*
  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GestureDetector(
        onTap: () async {
          // Confirm dialog
          final confirm = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: context.colors.bgCard,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Sign Out',
                style: TextStyle(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
              content: Text(
                'Are you sure you want to sign out?',
                style: TextStyle(
                  color: context.colors.textSecondary,
                  fontFamily: 'Poppins',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text('Cancel',
                      style: TextStyle(color: context.colors.textHint)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(
                      color: context.colors.ineligible,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );

          if (confirm == true && context.mounted) {
            await ref.read(authNotifierProvider.notifier).logout();
            // Router redirect handles navigation to /login automatically
          }
        },
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.colors.ineligible.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: context.colors.ineligible.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded, color: context.colors.ineligible, size: 20),
              SizedBox(width: 10),
              Text(
                'Sign Out',
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
    );
  }
*/

// ── Full logout-aware settings tile helper ─────────────────

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../data/providers/auth_provider.dart';

/// Drop-in replacement for the Sign Out row in settings_screen.dart
/// Usage: replace your existing sign out tile with LogoutTile()
class LogoutTile extends ConsumerWidget {
  LogoutTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authNotifierProvider).isLoading;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GestureDetector(
        onTap: isLoading
            ? null
            : () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: context.colors.bgCard,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(
                      'Sign Out',
                      style: TextStyle(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    content: Text(
                      'Are you sure you want to sign out?',
                      style: TextStyle(
                        color: context.colors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text('Cancel',
                            style: TextStyle(color: context.colors.textHint)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                            color: context.colors.ineligible,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirm == true && context.mounted) {
                  await ref.read(authNotifierProvider.notifier).logout();
                  // authStateProvider stream triggers router redirect to /login
                }
              },
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.colors.ineligible.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: context.colors.ineligible.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                SizedBox(
                  width: 18,
                  height: 18,
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
                'Sign Out',
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
    );
  }
}
