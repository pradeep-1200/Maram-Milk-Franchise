import 'package:manager_app/core/utils/date_util.dart';
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

    // Save condition: must have items.
    final bool canSave = state.items.isNotEmpty;
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
              DateFormat('MMM d, yyyy').format(DateUtil.operatingDay),
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
                  onPressed: () async {
                    if (canSave) {
                      try {
                        await notifier.saveInventory();
                        if (context.mounted) {
                          context.push('/dispatch/routes');
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Save failed: $e'), backgroundColor: Colors.red),
                          );
                        }
                      }
                    }
                  },
                ),
                const SizedBox(width: 8),
              ]
            : [
                IconButton(
                  icon: const Icon(Icons.save),
                  tooltip: 'Save Inventory',
                  onPressed: () async {
                    if (canSave) {
                      try {
                        await notifier.saveInventory();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Inventory saved')),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Save failed: $e'), backgroundColor: Colors.red),
                          );
                        }
                      }
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
          if (loadedState.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('No inventory items found', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Wait for backend initialization or check connection.', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => notifier.reload(),
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

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
      bottomNavigationBar: state.isDirty ? SafeArea(
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

              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Save Inventory',
                  onPressed: () async {
                    if (canSave) {
                      try {
                        await notifier.saveInventory();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Inventory saved successfully!')),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Save failed: $e'), backgroundColor: Colors.red),
                          );
                        }
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please provide reasons for shortages')),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ) : null,
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
                            Expanded(
                              child: Column(
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
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${item.expectedQty.toInt()}',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (item.litresPerUnit > 0)
                                  Text(
                                    '${(item.expectedQty * item.litresPerUnit).toStringAsFixed(1)} L total',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant.withAlpha(150),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        // TEMPORARY_MANUAL_STOCK_ENTRY
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(height: 1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'New Stock (Manual)',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Temp admin override',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.primary.withAlpha(200),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 80,
                              child: Consumer(
                                builder: (context, ref, child) {
                                  return Focus(
                                    onFocusChange: (hasFocus) {
                                      if (!hasFocus) {
                                        // The action happens inside the TextField's onSubmitted or onEditingComplete typically,
                                        // but we can also rely on a check button. 
                                        // However, providing a dedicated IconButton is better.
                                      }
                                    },
                                    child: TextFormField(
                                      initialValue: item.newStockAdded.toInt().toString(),
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (val) {
                                        final numValue = double.tryParse(val);
                                        if (numValue != null) {
                                          ref.read(inventoryProvider.notifier).updateNewStockLocally(item.id, numValue);
                                        } else if (val.isEmpty) {
                                          ref.read(inventoryProvider.notifier).updateNewStockLocally(item.id, 0);
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
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
      ],
    );
  }


}
