import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/app_button.dart';
import '../../shared/app_text_field.dart';
import '../shell/providers/tab_history_provider.dart';
import '../authentication/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(authProvider.notifier).logout();
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.cardRadius)),
      ),
      builder: (context) {
        return const _ChangePasswordSheet();
      },
    );
  }

  void _showHelpSupport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Help & Support'),
          content: const Text('Need help? Reach out to our team directly.'),
          actions: [
            TextButton(
              onPressed: () {
                // TODO: Wire up actual WhatsApp/phone number
                // Example: launchUrl(Uri.parse("https://wa.me/919000000000"));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('TODO: Launch WhatsApp/Dialer to +91 90000 00000')),
                );
                context.pop();
              },
              child: const Text('Contact Admin'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Wire up actual developer contact
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('TODO: Launch WhatsApp/Dialer to Developer')),
                );
                context.pop();
              },
              child: const Text('Contact Developer'),
            ),
          ],
        );
      },
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.cardRadius)),
          contentPadding: const EdgeInsets.all(AppConstants.spacing24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo/Monogram
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(Icons.water_drop, size: 32, color: theme.colorScheme.primary),
                ),
              ),
              const SizedBox(height: AppConstants.spacing16),
              
              // App Name
              Text(
                'Milk Manager',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.spacing8),
              
              // Version Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'v1.0.0',
                  style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: AppConstants.spacing24),
              
              // Description
              Text(
                'Streamline your daily branch operations from attendance to delivery performance.',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.spacing24),
              
              // Feature Chips Row
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: const [
                  _FeatureChip(icon: Icons.people, label: 'Attendance'),
                  _FeatureChip(icon: Icons.map, label: 'Routes'),
                  _FeatureChip(icon: Icons.inventory_2, label: 'Inventory'),
                  _FeatureChip(icon: Icons.trending_up, label: 'Performance'),
                ],
              ),
              
              const SizedBox(height: AppConstants.spacing24),
              const Divider(),
              const SizedBox(height: AppConstants.spacing16),
              
              // Footer
              Text(
                'Made by Team CodeNeticZ',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withAlpha(150),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final profile = authState.profile;
    
    final name = profile?.name ?? 'Unknown';
    final role = profile?.role ?? 'Manager';
    final branch = profile?.branchName ?? 'Branch';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              final prevTab = ref.read(tabHistoryProvider.notifier).popTab();
              if (prevTab != null) {
                final paths = ['/dashboard', '/attendance', '/routes', '/inventory', '/profile'];
                context.go(paths[prevTab]);
              } else {
                context.go('/dashboard');
              }
            }
          },
        ),
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing16),
        children: [
          const SizedBox(height: AppConstants.spacing16),
          // Header
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    initial,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spacing16),
                Text(
                  name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    role,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spacing8),
                Text(
                  branch,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacing16),
          
          // Settings Rows
          _ProfileRow(
            icon: Icons.account_balance_wallet,
            title: 'Transactions & Ledger',
            onTap: () => context.push('/transactions'),
          ),
          _ProfileRow(
            icon: Icons.trending_up,
            title: 'Performance Reports',
            onTap: () => context.push('/dp-performance?period=month'),
          ),
          _ProfileRow(
            icon: Icons.people_outline,
            title: 'Staff Directory',
            onTap: () => context.push('/staff-directory'),
          ),
          _ProfileRow(
            icon: Icons.local_drink,
            title: 'Empty Bottle Management',
            onTap: () => context.push('/bottles'),
          ),
          const Divider(height: AppConstants.spacing16),
          _ProfileRow(
            icon: Icons.lock_outline,
            title: 'Change Password',
            onTap: () => _showChangePasswordSheet(context),
          ),
          _ProfileRow(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () => _showHelpSupport(context),
          ),
          _ProfileRow(
            icon: Icons.info_outline,
            title: 'About',
            onTap: () => _showAbout(context),
          ),
          
          const SizedBox(height: AppConstants.spacing16),
          
          // Logout Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showLogoutDialog(context, ref),
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                'Logout',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.all(AppConstants.spacing16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
                ),
              ),
            ),
          ),
          const SizedBox(height: 100), // Padding for FAB in shell
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileRow({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withAlpha(100),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: theme.colorScheme.onSurfaceVariant),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }
}

class _ChangePasswordSheet extends StatefulWidget {
  const _ChangePasswordSheet();

  @override
  State<_ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<_ChangePasswordSheet> {
  final _reasonController = TextEditingController();
  bool _isSubmitted = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: AppConstants.spacing16,
        right: AppConstants.spacing16,
        top: AppConstants.spacing24,
        bottom: bottomPadding + AppConstants.spacing24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _isSubmitted
            ? [
                const Icon(Icons.check_circle, color: Colors.green, size: 64),
                const SizedBox(height: AppConstants.spacing16),
                Text(
                  'Request Sent',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.spacing8),
                Text(
                  'Your admin has been notified and will assist you with changing your password.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.spacing24),
                AppButton(
                  text: 'Back to Profile',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ]
            : [
                Text(
                  'Change Password',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppConstants.spacing8),
                Text(
                  'Password changes are handled by your admin for security. Submit a request and they\'ll assist you.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: AppConstants.spacing24),
                AppTextField(
                  controller: _reasonController,
                  labelText: 'Reason (optional)',
                  hintText: 'e.g. Suspected unauthorized access',
                ),
                const SizedBox(height: AppConstants.spacing24),
                AppButton(
                  text: 'Submit Request',
                  onPressed: () {
                    setState(() {
                      _isSubmitted = true;
                    });
                  },
                ),
              ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withAlpha(100),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.primaryContainer),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.primary),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface)),
        ],
      ),
    );
  }
}
