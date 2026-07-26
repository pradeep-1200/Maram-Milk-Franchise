import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/app_button.dart';
import '../routes/models/delivery_route.dart';
import '../attendance/models/delivery_person.dart';
import '../petrol_allowance/petrol_allowance_sheet.dart';
import 'providers/milk_allocation_provider.dart';
import '../routes/providers/route_provider.dart';
import '../inventory/providers/inventory_provider.dart';
import 'package:dio/dio.dart';

class MilkAllocationSheet extends ConsumerWidget {
  final DeliveryRoute route;
  final DeliveryPerson dp;
  final ScrollController scrollController;
  final bool isInStepFlow;

  const MilkAllocationSheet({
    super.key,
    required this.route,
    required this.dp,
    required this.scrollController,
    this.isInStepFlow = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeAllocation = ref.watch(milkAllocationProvider.select((state) => state.allocations[route.id] ?? const RouteMilkAllocation()));
    final notifier = ref.read(milkAllocationProvider.notifier);
    final theme = Theme.of(context);
    
    final inventoryState = ref.watch(inventoryProvider).value;
    int max1L = 0;
    int maxHalfL = 0;
    if (inventoryState != null) {
      final item1L = inventoryState.items.where((i) => i.name.toLowerCase().contains('1l')).firstOrNull;
      final itemHalfL = inventoryState.items.where((i) => i.name.toLowerCase().contains('500') || i.name.toLowerCase().contains('half')).firstOrNull;
      // Max limit is current available stock + what was already allocated to this route previously
      max1L = (item1L?.currentStock.toInt() ?? 0) + route.qty1LBottle;
      maxHalfL = (itemHalfL?.currentStock.toInt() ?? 0) + route.qtyHalfLBottle;
    }

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(AppConstants.spacing16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Milk Allocation',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppConstants.spacing4),
                    Text(
                      route.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacing4),
                    Text(
                      'Assigned to: ${dp.name} (${dp.employeeId})',
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              if (!isInStepFlow)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => context.pop(),
                ),
            ],
          ),
        ),
        const Divider(height: 1),
        
        // Products List
        Expanded(
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(vertical: AppConstants.spacing8),
            children: [
              _ProductRow(
                icon: Icons.local_drink,
                title: '1L Bottle',
                subtitle: 'Standard Glass',
                quantity: routeAllocation.qty1LBottle,
                onDecrement: () => notifier.update1LBottle(route.id, -1),
                onIncrement: () => notifier.update1LBottle(route.id, 1, maxLimit: max1L),
              ),
              _ProductRow(
                icon: Icons.local_drink,
                title: 'Half L Bottle',
                subtitle: 'Standard Glass',
                quantity: routeAllocation.qtyHalfLBottle,
                onDecrement: () => notifier.updateHalfLBottle(route.id, -1),
                onIncrement: () => notifier.updateHalfLBottle(route.id, 1, maxLimit: maxHalfL),
              ),
            ],
          ),
        ),
        
        // Bottom Area (Total & Action)
        Container(
          padding: const EdgeInsets.all(AppConstants.spacing16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Milk',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${routeAllocation.totalVolume.toStringAsFixed(1)} L',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacing8),
              AppButton(
                text: 'Confirm & Next',
                onPressed: () async {
                  final totalVolume = routeAllocation.totalVolume;
                  if (totalVolume <= 0) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Total milk allocated must be greater than 0.')),
                      );
                    }
                    return;
                  }

                  try {
                    if (route.assignedDpId == null || route.assignedDpId != dp.id) {
                      await ref.read(routeProvider.notifier).assignRoute(
                        route.id, 
                        dp.id, 
                        dp.name, 
                        totalVolume,
                        qty1LBottle: routeAllocation.qty1LBottle,
                        qtyHalfLBottle: routeAllocation.qtyHalfLBottle,
                      );
                    } else {
                      await ref.read(routeProvider.notifier).updateRouteAllocationLitres(
                        route.id, 
                        totalVolume,
                        qty1LBottle: routeAllocation.qty1LBottle,
                        qtyHalfLBottle: routeAllocation.qtyHalfLBottle,
                      );
                    }

                    if (context.mounted) {
                      if (isInStepFlow) {
                        context.push('/dispatch/petrol-allowance');
                      } else {
                        context.pop();
                        _showPetrolAllowanceSheet(context, route, dp);
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      String message = 'Failed to update allocation';
                      if (e is DioException) {
                        message = e.response?.data?['error']?['message'] ?? message;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showPetrolAllowanceSheet(BuildContext context, DeliveryRoute route, DeliveryPerson dp) {
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
          child: PetrolAllowanceSheet(route: route, dp: dp),
        );
      },
    );
  }
}

class _ProductRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _ProductRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacing16,
        vertical: AppConstants.spacing8,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: theme.colorScheme.onPrimaryContainer),
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
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                color: quantity > 0 ? theme.colorScheme.primary : theme.disabledColor,
                onPressed: quantity > 0 ? onDecrement : null,
              ),
              SizedBox(
                width: 32,
                child: Text(
                  quantity.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle),
                color: theme.colorScheme.primary,
                onPressed: onIncrement,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
