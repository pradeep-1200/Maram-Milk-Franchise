import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/app_card.dart';
import '../../shared/app_button.dart';
import 'providers/route_provider.dart';
import 'models/delivery_route.dart';
import '../../shared/dp_avatar.dart';
import '../attendance/providers/attendance_provider.dart';
import '../attendance/models/delivery_person.dart';
import '../milk_allocation/milk_allocation_sheet.dart';
import '../milk_allocation/providers/milk_allocation_provider.dart';
import '../petrol_allowance/petrol_allowance_sheet.dart';
import 'package:intl/intl.dart';
import '../attendance/models/attendance_entry.dart';
import '../shell/providers/tab_history_provider.dart';

class RouteAllocationScreen extends ConsumerWidget {
  final bool isDispatchContext;
  
  const RouteAllocationScreen({super.key, this.isDispatchContext = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(routeProvider);
    final notifier = ref.read(routeProvider.notifier);
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
            const Text('Route Allocation', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    'Step 3 of 3',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.check),
                  tooltip: 'Finish Dispatch',
                  onPressed: () {
                    context.go('/dispatch');
                  },
                ),
                const SizedBox(width: 8),
              ]
            : null,
      ),
      body: Column(
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
                  label: 'All ${(state.value?.countAll ?? 0)}',
                  isSelected: state.value?.isAssignedFilter == null,
                  onSelected: () => notifier.setFilter(null),
                ),
                const SizedBox(width: AppConstants.spacing8),
                _FilterChip(
                  label: 'Assigned ${(state.value?.countAssigned ?? 0)}',
                  isSelected: state.value?.isAssignedFilter == true,
                  onSelected: () => notifier.setFilter(true),
                ),
                const SizedBox(width: AppConstants.spacing8),
                _FilterChip(
                  label: 'Unassigned ${(state.value?.countUnassigned ?? 0)}',
                  isSelected: state.value?.isAssignedFilter == false,
                  onSelected: () => notifier.setFilter(false),
                ),
              ],
            ),
          ),
          
          // Route List
          Expanded(
            child: (state.value?.filteredRoutes ?? []).isEmpty
                ? Center(
                    child: Text(
                      'No routes found',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(
                      left: AppConstants.spacing16,
                      right: AppConstants.spacing16,
                      top: AppConstants.spacing8,
                      bottom: 100, // FAB padding
                    ),
                    itemCount: (state.value?.filteredRoutes ?? []).length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppConstants.spacing8),
                    itemBuilder: (context, index) {
                      final route = (state.value?.filteredRoutes ?? [])[index];
                      return _RouteCard(
                        route: route,
                        onAssignTapped: () => _showAssignSheet(context, ref, route),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showAssignSheet(BuildContext context, WidgetRef ref, DeliveryRoute route) {
    ref.read(milkAllocationProvider.notifier).initAllocation(route.id, route.qty1LBottle, route.qtyHalfLBottle, route.qtyHalfLPacket);
    
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.cardRadius)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            return _AssignDpSheet(route: route, scrollController: scrollController);
          },
        );
      },
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

class _RouteCard extends ConsumerWidget {
  final DeliveryRoute route;
  final VoidCallback onAssignTapped;

  const _RouteCard({
    required this.route,
    required this.onAssignTapped,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isAssigned = route.assignedDpId != null;

    return AppCard(
      onTap: isAssigned ? onAssignTapped : null,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing16, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    route.name,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    route.area,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (isAssigned ? Colors.green : Colors.red).withAlpha(25),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: isAssigned ? Colors.green : Colors.red),
                    ),
                    child: Text(
                      isAssigned ? 'ASSIGNED' : 'UNASSIGNED',
                      style: TextStyle(
                        color: isAssigned ? Colors.green : Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (route.isPetrolAllowanceComplete || route.petrolAllowanceGiven != null) ...[
                    const SizedBox(height: 4),
                    Builder(
                      builder: (context) {
                        final expected = route.fixedPetrolAllowance;
                        final given = route.petrolAllowanceGiven ?? 0;
                        
                        String statusText;
                        Color statusColor;
                        
                        if (given < expected) {
                          statusText = 'Shortage: ₹${(expected - given).toStringAsFixed(0)}';
                          statusColor = Colors.orange;
                        } else if (given > expected) {
                          statusText = 'Extra: ₹${(given - expected).toStringAsFixed(0)}';
                          statusColor = Colors.teal;
                        } else {
                          statusText = 'Fully Paid';
                          statusColor = Colors.green;
                        }

                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Exp: ₹${expected.toStringAsFixed(0)} / Given: ₹${given.toStringAsFixed(0)} / ',
                              style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: statusColor.withAlpha(25),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: statusColor),
                              ),
                              child: Text(
                                statusText,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                  if (route.deliveryCompleted == true) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withAlpha(25),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.green),
                      ),
                      child: const Text(
                        'CHECK COMPLETED',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ] else if (route.deliveryCompleted == false) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.withAlpha(25),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.red),
                      ),
                      child: const Text(
                        'DELIVERY INCOMPLETE',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacing8),
          Row(
            children: [
              const Icon(Icons.people, size: 16, color: Colors.grey),
              const SizedBox(width: AppConstants.spacing4),
              Text('${route.customerCount} Customers', style: const TextStyle(fontSize: 12)),
              const SizedBox(width: AppConstants.spacing16),
              const Icon(Icons.local_drink, size: 16, color: Colors.grey),
              const SizedBox(width: AppConstants.spacing4),
              Text('${route.milkQuantity} Ltr', style: const TextStyle(fontSize: 12)),
              const SizedBox(width: AppConstants.spacing16),
              const Icon(Icons.keyboard_return, size: 16, color: Colors.grey),
              const SizedBox(width: AppConstants.spacing4),
              Text('${route.expectedEmptyBottles} Expected', style: const TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: AppConstants.spacing8),
          if (isAssigned)
            Row(
              children: [
                DpAvatar(
                  photoUrl: route.assignedDpPhotoUrl,
                  name: route.assignedDpName ?? '?',
                  radius: 12,
                ),
                const SizedBox(width: AppConstants.spacing8),
                Text(
                  route.assignedDpName!,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: AppConstants.spacing8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: (route.assignedDpPetrolBalance > 0 ? Colors.teal : (route.assignedDpPetrolBalance < 0 ? Colors.orange : Colors.grey)).withAlpha(25),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: route.assignedDpPetrolBalance > 0 ? Colors.teal : (route.assignedDpPetrolBalance < 0 ? Colors.orange : Colors.grey)),
                  ),
                  child: Text(
                    route.assignedDpPetrolBalance == 0 
                      ? 'Running PA: ₹0' 
                      : 'Running PA: ${route.assignedDpPetrolBalance > 0 ? 'Extra' : 'Short'} ₹${route.assignedDpPetrolBalance.abs().toStringAsFixed(0)}',
                    style: TextStyle(
                      color: route.assignedDpPetrolBalance > 0 ? Colors.teal : (route.assignedDpPetrolBalance < 0 ? Colors.orange : Colors.grey),
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.edit, size: 20, color: theme.colorScheme.primary),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onAssignTapped,
                ),
              ],
            )
          else
            AppButton(
              text: 'Assign Route',
              onPressed: onAssignTapped,
            ),
        ],
      ),
    );
  }
}

class _AssignDpSheet extends ConsumerWidget {
  final DeliveryRoute route;
  final ScrollController scrollController;

  const _AssignDpSheet({
    required this.route,
    required this.scrollController,
  });

  void _showUnassignConfirm(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Unassign Route?'),
        content: const Text('Milk and petrol data for this route will be cleared.'),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(routeProvider.notifier).unassignRoute(route.id);
              ctx.pop(); // close dialog
              context.pop(); // close sheet
            },
            child: const Text('Unassign', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _assign(BuildContext context, WidgetRef ref, AttendanceEntry dp) {
    context.pop(); // Close assign sheet
    
    // Open Milk Allocation sheet
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.cardRadius)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (context, allocationScrollController) {
            return MilkAllocationSheet(
              route: route,
              dp: DeliveryPerson(id: dp.dpId, name: dp.name, employeeId: dp.dpCode),
              scrollController: allocationScrollController,
            );
          },
        );
      },
    );
  }

  void _handleAssign(BuildContext context, WidgetRef ref, AttendanceEntry dp, List<DeliveryRoute> otherRoutes) {
    if (otherRoutes.isNotEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Double Booking'),
          content: Text('${dp.name} is already assigned to ${otherRoutes.map((r) => r.name).join(', ')}. Assign them to ${route.name} as well?'),
          actions: [
            TextButton(
              onPressed: () => ctx.pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                ctx.pop();
                _assign(context, ref, dp);
              },
              child: const Text('Confirm', style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      );
    } else {
      _assign(context, ref, dp);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final allRoutes = (ref.watch(routeProvider).value?.routes ?? []);
    
    final availableDps = (ref.watch(attendanceProvider).value?.persons ?? []).where((dp) {
      return (dp.displayStatus == AttendanceStatus.present || dp.displayStatus == AttendanceStatus.standby)
          && dp.dpId != route.assignedDpId;
    }).toList();
    
    // Sort so unassigned DPs appear first, then by ID
    availableDps.sort((a, b) {
      final aAssigned = allRoutes.any((r) => r.assignedDpId == a.dpId);
      final bAssigned = allRoutes.any((r) => r.assignedDpId == b.dpId);
      
      if (aAssigned == bAssigned) {
        return a.dpId.compareTo(b.dpId); // Or compare by name
      }
      return aAssigned ? 1 : -1;
    });

    AttendanceEntry? currentlyAssignedDp;
    if (route.assignedDpId != null) {
      for (final dp in (ref.read(attendanceProvider).value?.persons ?? [])) {
        if (dp.dpId == route.assignedDpId) {
          currentlyAssignedDp = dp;
          break;
        }
      }
    }
    String paStatusText = 'PA: Not Given';
    Color paColor = theme.colorScheme.primary;

    if (route.petrolAllowanceGiven != null) {
      final given = route.petrolAllowanceGiven!;
      final expected = route.fixedPetrolAllowance;
      if (given < expected) {
        paStatusText = 'PA: Short ₹${expected - given}';
        paColor = Colors.red;
      } else if (given > expected) {
        paStatusText = 'PA: Extra ₹${given - expected}';
        paColor = Colors.orange;
      } else {
        paStatusText = 'PA: Fully Paid';
        paColor = Colors.green;
      }
    }

    return ListView(
      controller: scrollController,
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppConstants.spacing16),
          child: Text(
            route.assignedDpId != null ? 'Reassign DP for ${route.name}' : 'Assign DP to ${route.name}',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const Divider(height: 1),
        
        if (currentlyAssignedDp != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing16, vertical: AppConstants.spacing8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('CURRENTLY ASSIGNED', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing16, vertical: AppConstants.spacing8),
            child: Column(
              children: [
                Row(
                  children: [
                    DpAvatar(
                      photoUrl: currentlyAssignedDp.profilePictureUrl,
                      name: currentlyAssignedDp.name,
                    ),
                    const SizedBox(width: AppConstants.spacing16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentlyAssignedDp.name, 
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            currentlyAssignedDp.dpCode,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacing16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _assign(context, ref, currentlyAssignedDp!),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          minimumSize: const Size(0, 36),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Edit Allocation'),
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacing8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showUnassignConfirm(context, ref),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          minimumSize: const Size(0, 36),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Unassign'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacing8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        useRootNavigator: true,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.cardRadius)),
                        ),
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                            child: PetrolAllowanceSheet(
                              route: route,
                              dp: DeliveryPerson(
                                id: currentlyAssignedDp!.dpId, 
                                name: currentlyAssignedDp.name, 
                                employeeId: currentlyAssignedDp.dpCode,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: paColor,
                      side: BorderSide(color: paColor),
                      minimumSize: const Size(0, 36),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(paStatusText),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
        ],

        if (availableDps.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(child: Text('No other available DPs (Present or Standby)')),
          )
        else
          ...availableDps.map((dp) {
            final otherRoutes = allRoutes.where((r) => r.id != route.id && r.assignedDpId == dp.dpId).toList();
            return Dismissible(
              key: ValueKey(dp.dpId),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20.0),
                color: theme.colorScheme.primary,
                child: const Icon(Icons.assignment_turned_in, color: Colors.white),
              ),
              confirmDismiss: (direction) async {
                if (otherRoutes.isNotEmpty) {
                  final bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Double Booking'),
                      content: Text('${dp.name} is already assigned to ${otherRoutes.map((r) => r.name).join(', ')}. Assign them to ${route.name} as well?'),
                      actions: [
                        TextButton(
                          onPressed: () => ctx.pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => ctx.pop(true),
                          child: const Text('Confirm', style: TextStyle(color: Colors.blue)),
                        ),
                      ],
                    ),
                  );
                  return confirm ?? false;
                }
                return true;
              },
              onDismissed: (_) => _assign(context, ref, dp),
              child: ListTile(
                leading: DpAvatar(
                  photoUrl: dp.profilePictureUrl,
                  name: dp.name,
                ),
                title: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4,
                  children: [
                    Text(dp.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    if (dp.petrolAllowanceGivenToday != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'PA Given: ₹${dp.petrolAllowanceGivenToday}',
                          style: TextStyle(color: Colors.green.shade900, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    if (otherRoutes.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Also on: ${otherRoutes.map((r) => r.name).join(', ')}',
                          style: TextStyle(color: Colors.orange.shade900, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
                subtitle: Text(dp.dpCode),
                trailing: ElevatedButton(
                  onPressed: () => _handleAssign(context, ref, dp, otherRoutes),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    minimumSize: const Size(0, 36),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: const Text('Assign'),
                ),
              ),
            );
          }),
        Padding(
          padding: const EdgeInsets.all(AppConstants.spacing16),
          child: SizedBox(
            width: double.infinity,
            child: AppButton.outlined(
              text: 'Cancel',
              onPressed: () => context.pop(),
            ),
          ),
        ),
      ],
    );
  }
}
