import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/app_button.dart';
import '../../shared/app_card.dart';
import 'providers/dispatch_provider.dart';
import '../attendance/providers/attendance_provider.dart';
import '../attendance/models/delivery_person.dart' show AttendanceStatus;
import '../routes/providers/route_provider.dart';

class DispatchReadyScreen extends ConsumerWidget {
  const DispatchReadyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final attAsync = ref.watch(attendanceProvider);
    final routeAsync = ref.watch(routeProvider);
    final dispatchAsync = ref.watch(dispatchProvider);

    final attCount = attAsync.value?.countAll ?? 0;
    final attPending = attAsync.value?.persons.where((p) => p.status == AttendanceStatus.pending).length ?? 0;
    final attMarked = attCount - attPending;
    final attendanceComplete = attCount > 0 && attMarked >= attCount;

    final routesCount = routeAsync.value?.countAll ?? 0;
    final routesAssigned = routeAsync.value?.countAssigned ?? 0;
    final routesComplete = routesCount > 0 && routesAssigned >= routesCount;

    final bool allComplete = attendanceComplete && routesComplete;

    final List<String> pendingItems = [];
    if (!attendanceComplete) {
      pendingItems.add('${attCount - attMarked} DP(s) need attendance marked');
    }
    if (!routesComplete) {
      pendingItems.add('${routesCount - routesAssigned} route(s) need assignment');
    }
    
    final subtitleText = allComplete 
        ? 'Great job! You have completed today\'s morning operations.' 
        : 'Waiting on:\n- ${pendingItems.join('\n- ')}';

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
        title: const Text('Morning Dispatch', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppConstants.spacing16),
                  // Header Icon
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: (allComplete ? Colors.green : Colors.orange).withAlpha(25),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        allComplete ? Icons.check_circle : Icons.pending_actions,
                        color: allComplete ? Colors.green : Colors.orange,
                        size: 64,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacing16),
                  // Headers
                  Text(
                    allComplete ? 'All Set for Dispatch!' : 'Almost Ready',
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.spacing8),
                  Text(
                    subtitleText,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: allComplete ? theme.colorScheme.onSurfaceVariant : Colors.orange.shade800,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.spacing16),
                  
                  // Checklist
                  Expanded(
                    child: AppCard(
                      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing16, vertical: AppConstants.spacing8),
                      child: ListView(
                        children: [
                          _ChecklistItem(
                            title: 'Attendance',
                            subtitle: '$attMarked/$attCount Marked',
                            isComplete: attendanceComplete,
                            onTap: () => context.push('/dispatch/attendance'),
                          ),
                          const Divider(),
                          _ChecklistItem(
                            title: 'Routes & Allocations',
                            subtitle: '$routesAssigned/$routesCount Assigned',
                            isComplete: routesComplete,
                            onTap: () => context.push('/dispatch/routes'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppConstants.spacing16),
                  // Bottom Button
                  AppButton(
                    text: 'View Summary',
                    onPressed: () {
                      context.push('/dispatch_summary');
                    },
                  ),
                ],
              ),
            ),
        ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isComplete;
  final VoidCallback onTap;

  const _ChecklistItem({
    required this.title,
    required this.subtitle,
    required this.isComplete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppConstants.spacing8),
        child: Row(
          children: [
            Icon(
              isComplete ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isComplete ? Colors.green : theme.disabledColor,
            ),
            const SizedBox(width: AppConstants.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isComplete ? Colors.green : theme.colorScheme.onSurfaceVariant,
                      fontWeight: isComplete ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
