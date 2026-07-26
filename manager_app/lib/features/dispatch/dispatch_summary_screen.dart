import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../shared/app_card.dart';
import '../../shared/app_button.dart';
import '../../shared/async_value_widget.dart';
import 'providers/dispatch_provider.dart';
import 'models/dispatch_summary.dart';

class DispatchSummaryScreen extends ConsumerWidget {
  const DispatchSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dispatchStateAsync = ref.watch(dispatchProvider);

    // Date
    final now = DateTime.now();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final todayDate = '${months[now.month - 1]} ${now.day}, ${now.year}';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Morning Dispatch Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(
              todayDate,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      body: AppAsyncWidget<DispatchSummary>(
        value: dispatchStateAsync,
        onRetry: () => ref.read(dispatchProvider.notifier).reload(),
        data: (summary) {
          final att = summary.attendance;
          final inv = summary.inventory;
          final routes = summary.routes;
          final petrol = summary.petrolAllowanceTotal ?? 0;

          return ListView(
            padding: const EdgeInsets.all(AppConstants.spacing16),
            children: [
              _SummarySection(
                title: 'Attendance',
                icon: Icons.people,
                children: [
                  _SummaryRow('Marked', '${att.marked}/${att.totalDps}', theme.colorScheme.primary),
                  _SummaryRow('Present', '${att.present}', Colors.green),
                  _SummaryRow('Absent', '${att.absent}', Colors.red),
                  _SummaryRow('Standby', '${att.standby}', Colors.orange),
                ],
              ),
              const SizedBox(height: AppConstants.spacing8),
              
              _SummarySection(
                title: 'Inventory',
                icon: Icons.inventory_2,
                children: [
                  _SummaryRow('Counted', '${inv.counted}/${inv.totalItems}', theme.colorScheme.primary),
                  _SummaryRow('Matches', '${inv.matched}', Colors.green),
                  if ((inv.counted - inv.matched) > 0)
                    _SummaryRow('Mismatches', '${inv.counted - inv.matched}', Colors.orange.shade800),
                ],
              ),
              const SizedBox(height: AppConstants.spacing8),
              
              _SummarySection(
                title: 'Routes',
                icon: Icons.map,
                children: [
                  _SummaryRow('Assigned', '${routes.assigned}/${routes.totalRoutes}', Colors.green),
                  _SummaryRow('Unassigned', '${routes.unassigned}', Colors.red),
                ],
              ),
              const SizedBox(height: AppConstants.spacing8),
              
              _SummarySection(
                title: 'Milk Allocation',
                icon: Icons.local_drink,
                children: [
                  _SummaryRow('Total Allocated', '${routes.totalLitresAllocated.toStringAsFixed(1)} Ltr', theme.colorScheme.primary),
                ],
              ),
              const SizedBox(height: AppConstants.spacing8),
              
              _SummarySection(
                title: 'Petrol Allowance',
                icon: Icons.local_gas_station,
                children: [
                  _SummaryRow('Total Given', '₹$petrol', theme.colorScheme.primary),
                ],
              ),
              const SizedBox(height: AppConstants.spacing24),
              
              AppButton(
                text: 'Back to Dashboard',
                onPressed: () {
                  context.go('/dashboard');
                },
              ),
              const SizedBox(height: AppConstants.spacing24),
            ],
          );
        },
      ),
    );
  }
}

class _SummarySection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SummarySection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(width: AppConstants.spacing8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: AppConstants.spacing24),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _SummaryRow(this.label, this.value, this.valueColor);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
