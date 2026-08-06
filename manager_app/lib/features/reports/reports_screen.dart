import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../shared/app_card.dart';
import '../attendance/providers/attendance_provider.dart';
import '../routes/providers/route_provider.dart';
import '../inventory/providers/inventory_provider.dart';
import 'providers/report_provider.dart';
import 'models/daily_report.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    final report = ref.watch(reportProvider);

    // Providers (fallback for live state)
    final attendanceState = ref.watch(attendanceProvider).value ?? const AttendanceState();
    final routeState = ref.watch(routeProvider).value ?? const RouteState();
    final inventoryState = ref.watch(inventoryProvider).value ?? const InventoryState(items: []);

    // Use report values if available, else fallback to live state
    final presentCount = report?.presentCount ?? attendanceState.countPresent;
    final absentCount = report?.absentCount ?? attendanceState.countAbsent;
    final standbyCount = report?.standbyCount ?? attendanceState.countStandby;

    final inventoryItems = report?.inventoryItems ?? 
        inventoryState.items.map((i) => InventorySnapshot(
          id: i.id, 
          name: i.name, 
          expectedQty: i.expectedQty,
          currentStock: i.currentStock,
          variance: i.variance,
          reason: i.reason,
        )).toList();
    final double totalInventoryExpected = inventoryItems.fold(0.0, (sum, i) => sum + i.expectedQty);
    final double totalInventoryCurrent = inventoryItems.fold(0.0, (sum, i) => sum + i.currentStock);

    final assignedRoutes = report?.assignedRoutesCount ?? routeState.countAssigned;
    final unassignedRoutes = report?.unassignedRoutesCount ?? routeState.countUnassigned;
    
    final paCompletedCount = report != null 
        ? report.assignedRoutesCount // If complete, all assigned have PA completed
        : routeState.routes.where((r) => r.isPetrolAllowanceComplete).length;
        
    final totalPAExpense = report?.totalPetrolGiven ?? paCompletedCount * 80;
    final totalExpenses = totalPAExpense + 450; // Mock fixed expenses

    final totalRevenue = (totalInventoryCurrent * 25) + 1200; // Mock calculation using currentStock

    // Empty Bottles (always live since it happens post-dispatch)
    final totalBottles1L = routeState.routes.fold(0, (sum, r) => sum + r.allocations.fold(0, (s, a) => s + (a.emptyBottles1L ?? 0)));
    final totalBottlesHalfL = routeState.routes.fold(0, (sum, r) => sum + r.allocations.fold(0, (s, a) => s + (a.emptyBottlesHalfL ?? 0)));
    final flaggedCount = routeState.routes.where((r) => r.hasBottleReturnFlag).length;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/dashboard');
            }
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Reports', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Text(
                  'Date: Today',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Icon(Icons.arrow_drop_down, size: 16),
              ],
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        children: [
          if (report == null)
            Container(
              margin: const EdgeInsets.only(bottom: AppConstants.spacing16),
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: AppConstants.spacing8),
              decoration: BoxDecoration(
                color: Colors.orange.withAlpha(25),
                borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                border: Border.all(color: Colors.orange),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange, size: 20),
                  SizedBox(width: AppConstants.spacing8),
                  Text('Live — not yet finalized', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          _ReportCard(
            title: 'Attendance Summary',
            icon: Icons.people,
            children: [
              _ReportRow('Present', '$presentCount', Colors.green),
              _ReportRow('Absent', '$absentCount', Colors.red),
              _ReportRow('Standby', '$standbyCount', Colors.orange),
            ],
          ),
          const SizedBox(height: AppConstants.spacing8),
          
          _ReportCard(
            title: 'Inventory Summary',
            icon: Icons.inventory_2,
            children: [
              ...inventoryItems.map((item) {
                final varianceText = item.variance == 0 ? 'Matches' : (item.variance > 0 ? '${item.variance} short' : '${item.variance.abs()} over');
                final color = item.variance == 0 ? Colors.green : (item.variance > 0 ? Colors.red : Colors.orange.shade800);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Exp: ${item.expectedQty} | Curr: ${item.currentStock}', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                          Text(varianceText, style: theme.textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              const Divider(),
              _ReportRow('Total (Exp vs Curr)', '$totalInventoryExpected vs $totalInventoryCurrent', theme.colorScheme.primary),
            ],
          ),
          const SizedBox(height: AppConstants.spacing8),
          
          _ReportCard(
            title: 'Empty Bottle Returns',
            icon: Icons.local_drink,
            children: [
              _ReportRow('1L Collected', '$totalBottles1L', theme.colorScheme.onSurface),
              _ReportRow('Half L Collected', '$totalBottlesHalfL', theme.colorScheme.onSurface),
              if (flaggedCount > 0) ...[
                const Divider(),
                _ReportRow('Flagged Routes', '$flaggedCount', Colors.orange),
              ] else ...[
                const Divider(),
                _ReportRow('Flagged Routes', '0', Colors.green),
              ]
            ],
          ),
          const SizedBox(height: AppConstants.spacing8),
          
          _ReportCard(
            title: 'Route Allocation',
            icon: Icons.map,
            children: [
              _ReportRow('Assigned Routes', '$assignedRoutes', Colors.green),
              _ReportRow('Unassigned Routes', '$unassignedRoutes', Colors.red),
              _ReportRow('PA Completed', '$paCompletedCount', Colors.orange),
            ],
          ),
          const SizedBox(height: AppConstants.spacing8),
          
          _ReportCard(
            title: 'Financials',
            icon: Icons.attach_money,
            children: [
              _ReportRow('Estimated Revenue', '₹$totalRevenue', Colors.green),
              _ReportRow('Estimated Expenses', '₹$totalExpenses', Colors.red),
              _ReportRow('Net (Mock)', '₹${totalRevenue - totalExpenses}', theme.colorScheme.primary),
            ],
          ),
          const SizedBox(height: AppConstants.spacing8),
          

          
          _ReportCard(
            title: 'Top Delivery Persons',
            icon: Icons.star,
            children: [
              _ReportRow('1. Rajesh Kumar', '142 Deliveries', theme.colorScheme.onSurface),
              _ReportRow('2. Amit Singh', '138 Deliveries', theme.colorScheme.onSurface),
              _ReportRow('3. Suresh Das', '125 Deliveries', theme.colorScheme.onSurface),
            ],
          ),
          const SizedBox(height: AppConstants.spacing8),
          
          _ReportCard(
            title: 'Leave Statistics',
            icon: Icons.event_busy,
            children: [
              _ReportBarRow(label: 'Week 1', presentPct: 0.9, absentPct: 0.1),
              const SizedBox(height: AppConstants.spacing8),
              _ReportBarRow(label: 'Week 2', presentPct: 0.85, absentPct: 0.15),
              const SizedBox(height: AppConstants.spacing8),
              _ReportBarRow(label: 'Week 3 (Current)', presentPct: 0.95, absentPct: 0.05),
            ],
          ),
          const SizedBox(height: 100), // FAB padding
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _ReportCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      padding: EdgeInsets.zero,
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          leading: Icon(icon, color: theme.colorScheme.primary),
          title: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          childrenPadding: const EdgeInsets.only(
            left: AppConstants.spacing16,
            right: AppConstants.spacing16,
            bottom: AppConstants.spacing16,
          ),
          children: children,
        ),
      ),
    );
  }
}

class _ReportRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _ReportRow(this.label, this.value, this.valueColor);

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
            style: theme.textTheme.titleSmall?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportBarRow extends StatelessWidget {
  final String label;
  final double presentPct;
  final double absentPct;

  const _ReportBarRow({
    required this.label,
    required this.presentPct,
    required this.absentPct,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              flex: (presentPct * 100).toInt(),
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              flex: (absentPct * 100).toInt(),
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
