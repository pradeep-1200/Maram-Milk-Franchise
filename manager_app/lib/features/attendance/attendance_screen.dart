import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/app_card.dart';
import '../../shared/app_text_field.dart';
import '../../shared/async_value_widget.dart';
import '../../shared/dp_avatar.dart';
import '../profile/providers/staff_provider.dart';
import 'providers/attendance_provider.dart';
import 'models/attendance_entry.dart';
import 'models/delivery_person.dart' show AttendanceStatus;
import '../shell/providers/tab_history_provider.dart';

class AttendanceScreen extends ConsumerWidget {
  final bool isDispatchContext;
  
  const AttendanceScreen({super.key, this.isDispatchContext = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceStateAsync = ref.watch(attendanceProvider);
    final theme = Theme.of(context);
    final todayStr = DateFormat('MMM d, yyyy').format(DateTime.now());

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
        title: Column(
          children: [
            const Text('Attendance', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              todayStr,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: isDispatchContext 
            ? [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Step 1 of 3',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  tooltip: 'Next: Inventory',
                  onPressed: () {
                    context.push('/dispatch/inventory');
                  },
                ),
                const SizedBox(width: 8),
              ]
            : null,
      ),
      body: AppAsyncWidget<AttendanceState>(
        value: attendanceStateAsync,
        onRetry: () => ref.read(attendanceProvider.notifier).reload(),
        data: (state) {
          final notifier = ref.read(attendanceProvider.notifier);
          return Column(
            children: [
              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacing16,
                  vertical: AppConstants.spacing8,
                ),
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All ${state.countAll}',
                      isSelected: state.statusFilter == null,
                      onSelected: () => notifier.setStatusFilter(null),
                    ),
                    const SizedBox(width: AppConstants.spacing8),
                    _FilterChip(
                      label: 'Present ${state.countPresent}',
                      isSelected: state.statusFilter == AttendanceStatus.present,
                      onSelected: () => notifier.setStatusFilter(AttendanceStatus.present),
                    ),
                    const SizedBox(width: AppConstants.spacing8),
                    _FilterChip(
                      label: 'Absent ${state.countAbsent}',
                      isSelected: state.statusFilter == AttendanceStatus.absent,
                      onSelected: () => notifier.setStatusFilter(AttendanceStatus.absent),
                    ),
                    const SizedBox(width: AppConstants.spacing8),
                    _FilterChip(
                      label: 'Standby ${state.countStandby}',
                      isSelected: state.statusFilter == AttendanceStatus.standby,
                      onSelected: () => notifier.setStatusFilter(AttendanceStatus.standby),
                    ),
                  ],
                ),
              ),
              
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(AppConstants.spacing16),
                child: AppTextField(
                  hintText: 'Search delivery person...',
                  prefixIcon: const Icon(Icons.search),
                  onChanged: notifier.setSearchQuery,
                ),
              ),

              // DP List
              Expanded(
                child: state.filteredPersons.isEmpty
                    ? Center(
                        child: Text(
                          'No delivery persons found',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(
                          left: AppConstants.spacing16,
                          right: AppConstants.spacing16,
                          bottom: 100, // FAB padding
                        ),
                        itemCount: state.filteredPersons.length,
                        separatorBuilder: (_, __) => const SizedBox(height: AppConstants.spacing8),
                        itemBuilder: (context, index) {
                          final entry = state.filteredPersons[index];
                          return _DPCard(
                            person: entry,
                            onMarked: () => notifier.reload(),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ActionChip(
      label: Text(label),
      backgroundColor: isSelected ? theme.colorScheme.primaryContainer : theme.colorScheme.surface,
      labelStyle: TextStyle(
        color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? theme.colorScheme.primary : theme.dividerColor,
      ),
      onPressed: onSelected,
    );
  }
}

class _DPCard extends ConsumerWidget {
  final AttendanceEntry person;
  final VoidCallback onMarked;

  const _DPCard({
    required this.person,
    required this.onMarked,
  });

  Widget _buildToggleButton({
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isSelected ? Colors.white : color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    Color badgeColor;
    String badgeText;
    switch (person.displayStatus) {
      case AttendanceStatus.present:
        badgeColor = Colors.green;
        badgeText = 'Present';
        break;
      case AttendanceStatus.absent:
        badgeColor = Colors.red;
        badgeText = 'Absent';
        break;
      case AttendanceStatus.standby:
        badgeColor = Colors.orange;
        badgeText = 'Standby';
        break;
      default:
        badgeColor = Colors.grey;
        badgeText = 'Pending';
    }

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing16, vertical: 12.0),
      child: Row(
        children: [
          DpAvatar(
            photoUrl: person.profilePictureUrl,
            name: person.name,
          ),
          const SizedBox(width: AppConstants.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.name,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      person.dpCode,
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: badgeColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: badgeColor),
                      ),
                      child: Text(
                        badgeText,
                        style: TextStyle(color: badgeColor, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppConstants.spacing8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildToggleButton(
                icon: Icons.close,
                color: Colors.red,
                isSelected: person.status == AttendanceStatus.absent,
                onTap: () {
                  ref.read(attendanceProvider.notifier).markAttendance(person.dpId, AttendanceStatus.absent);
                },
              ),
              const SizedBox(width: AppConstants.spacing8),
              _buildToggleButton(
                icon: Icons.check,
                color: Colors.green,
                isSelected: person.status == AttendanceStatus.present,
                onTap: () {
                  ref.read(attendanceProvider.notifier).markAttendance(person.dpId, AttendanceStatus.present);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
