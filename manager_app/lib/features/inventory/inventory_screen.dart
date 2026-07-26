import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/app_button.dart';
import '../../shared/async_value_widget.dart';
import 'providers/inventory_provider.dart';
import '../shell/providers/tab_history_provider.dart';

class InventoryScreen extends ConsumerWidget {
  final bool isDispatchContext;
  
  const InventoryScreen({super.key, this.isDispatchContext = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryStateAsync = ref.watch(inventoryProvider);
    final state = inventoryStateAsync.value ?? const InventoryState(items: []);
    final notifier = ref.read(inventoryProvider.notifier);
    final theme = Theme.of(context);

    // Save condition: if there is a negative manual adjustment or negative current stock,
    // a reason must be provided.
    final bool canSave = !state.items.any((i) {
      final needsReason = i.variance != 0 || i.currentStock < 0;
      return needsReason && (i.reason == null || i.reason!.isEmpty);
    });
    
    String varianceText;
    if (state.totalShort == 0 && state.totalOver == 0) {
      varianceText = 'All matching';
    } else {
      final List<String> parts = [];
      if (state.totalShort > 0) parts.add('${state.totalShort} short');
      if (state.totalOver > 0) parts.add('${state.totalOver} over');
      varianceText = parts.join(' / ');
    }

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Inventory', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              DateFormat('MMM d, yyyy').format(DateTime.now()),
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
                    'Step 2 of 3',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  tooltip: 'Save & Next: Routes Assigned',
                  onPressed: () {
                    if (canSave) {
                      notifier.saveInventory();
                    }
                    context.push('/dispatch/routes');
                  },
                ),
                const SizedBox(width: 8),
              ]
            : [
                IconButton(
                  icon: const Icon(Icons.save),
                  tooltip: 'Save Inventory',
                  onPressed: () {
                    if (canSave) {
                      notifier.saveInventory();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Inventory saved')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please provide reasons for shortages')),
                      );
                    }
                  },
                ),
                const SizedBox(width: 8),
              ],
      ),
      body: AppAsyncWidget<InventoryState>(
        value: inventoryStateAsync,
        onRetry: () => notifier.reload(),
        data: (loadedState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Products List
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(
                    left: AppConstants.spacing16,
                    right: AppConstants.spacing16,
                    top: AppConstants.spacing8,
                    bottom: 100, // Padding for bottom bar / FAB
                  ),
                  itemCount: loadedState.items.length,
                  separatorBuilder: (_, __) => const Divider(height: AppConstants.spacing16),
                  itemBuilder: (context, index) {
                    final item = loadedState.items[index];
                    return _InventoryRow(
                      item: item,
                      onUpdate: (delta) => notifier.updateAdjustment(item.id, delta),
                      onReasonChanged: (reason) => notifier.updateReason(item.id, reason),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      // Sticky Bottom Bar
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing16, vertical: AppConstants.spacing8),
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
                    'Total Variance',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    varianceText,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: (state.totalShort == 0 && state.totalOver == 0) ? Colors.green : Colors.orange.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacing8),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Save Inventory',
                  onPressed: canSave ? () {
                    notifier.saveInventory();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Inventory saved successfully!')),
                    );
                  } : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InventoryRow extends StatelessWidget {
  final InventoryItemState item;
  final Function(double) onUpdate;
  final Function(String?) onReasonChanged;

  const _InventoryRow({
    required this.item,
    required this.onUpdate,
    required this.onReasonChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentQty = item.currentStock;
    
    Widget badge;
    if (item.variance == 0) {
      badge = Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.green.withAlpha(30),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text('Matches', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
      );
    } else if (item.variance > 0) {
      badge = Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.red.withAlpha(30),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text('${item.variance} short', style: const TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
      );
    } else {
      badge = Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.orange.withAlpha(30),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text('${item.variance.abs()} over', style: TextStyle(color: Colors.orange.shade800, fontSize: 10, fontWeight: FontWeight.bold)),
      );
    }

    final bool needsReason = item.variance != 0 || item.currentStock < 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.inventory_2, color: theme.colorScheme.onPrimaryContainer),
            ),
            const SizedBox(width: AppConstants.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: Name & Badge (Wraps gracefully)
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Text(
                        item.name,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      badge,
                    ],
                  ),
                  const SizedBox(height: 2),
                  // Row 2: Subtitle
                  Text(
                    'Material: ${item.subtitle}',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppConstants.spacing8),
                  
                  // Row 3: Expected and Current Stock widgets stacked
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withAlpha(100),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: theme.colorScheme.outlineVariant.withAlpha(100)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Expected Widget
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Expected',
                                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                                ),
                                if (item.carryOverQty > 0 || item.newStockAdded > 0)
                                  Text(
                                    '(${item.carryOverQty} carried over + ${item.newStockAdded} new)',
                                    style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                                  ),
                              ],
                            ),
                            Text(
                              '${item.expectedQty}',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(height: 1),
                        ),
                        // Current Stock Widget
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Current Stock',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                // Removed mock allocations from UI as backend expects physical count.
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  color: currentQty > 0 ? theme.colorScheme.primary : theme.disabledColor,
                                  onPressed: currentQty > 0 ? () => onUpdate(-1.0) : null,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                ),
                                SizedBox(
                                  width: 32,
                                  child: Text(
                                    '$currentQty',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle),
                                  color: theme.colorScheme.primary,
                                  onPressed: () => onUpdate(1.0),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (needsReason)
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 56.0),
            child: DropdownButtonFormField<String>(
              value: item.reason,
              hint: const Text('Select Reason *'),
              isExpanded: true,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                errorText: (item.reason == null || item.reason!.isEmpty) ? 'Required' : null,
              ),
              items: ['Breakage', 'Spillage', 'Unaccounted / missing', 'Other']
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: onReasonChanged,
            ),
          ),
      ],
    );
  }
}
