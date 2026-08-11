import 'package:manager_app/core/utils/date_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/app_button.dart';
import '../../shared/async_value_widget.dart';
import 'providers/manager_inventory_provider.dart';
import '../inventory/providers/inventory_provider.dart';

import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ManagerInventoryScreen extends ConsumerStatefulWidget {
  const ManagerInventoryScreen({super.key});

  @override
  ConsumerState<ManagerInventoryScreen> createState() => _ManagerInventoryScreenState();
}

class _ManagerInventoryScreenState extends ConsumerState<ManagerInventoryScreen> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inventoryStateAsync = ref.watch(inventoryProvider);
    final state = ref.watch(managerInventoryProvider);
    final notifier = ref.read(managerInventoryProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
          children: [
            const Text('Manager Inventory', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              DateFormat('MMM d, yyyy').format(DateUtil.operatingDay),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      body: AppAsyncWidget<InventoryState>(
        value: inventoryStateAsync,
        onRetry: () => ref.read(inventoryProvider.notifier).reload(),
        data: (inventoryState) {
          final items = inventoryState.items;

          // Sync controllers with state if loaded
          for (var item in items) {
            if (!_controllers.containsKey(item.id)) {
              _controllers[item.id] = TextEditingController();
            }
            
            String legacyName = item.name;
            if (legacyName == 'Half Litre Bottle') legacyName = '500ml Bottle';
            final val = (state.counts[item.id] ?? state.counts[legacyName])?.toString() ?? '';
            
            if (_controllers[item.id]!.text.isEmpty && val.isNotEmpty) {
              _controllers[item.id]!.text = val;
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.spacing16),
            child: Card(
              elevation: 2,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.cardRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacing16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.inventory_rounded, color: theme.colorScheme.primary),
                        const SizedBox(width: AppConstants.spacing8),
                        Text(
                          'Physical Count',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacing8),
                    Text(
                      'Physically count and enter the remaining stock for today.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacing16),
                    ...items.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      String subtitle = item.subtitle;

                      IconData icon = Icons.local_drink;
                      Color iconColor = Colors.green;
                      Color bgColor = Colors.green.withAlpha(30);

                      if (item.name.contains('Half')) {
                        iconColor = Colors.blue;
                        bgColor = Colors.blue.withAlpha(30);
                      } else if (item.name.contains('Packet')) {
                        icon = Icons.inventory_2;
                        iconColor = Colors.orange;
                        bgColor = Colors.orange.withAlpha(30);
                      }

                      return Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(icon, color: iconColor),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      subtitle,
                                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 80,
                                child: TextFormField(
                                  controller: _controllers[item.id],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                    border: OutlineInputBorder(),
                                    hintText: '0',
                                  ),
                                  onChanged: (val) {
                                    final count = int.tryParse(val);
                                    if (count != null) {
                                      notifier.updateCount(item.id, count);
                                    } else if (val.isEmpty) {
                                      notifier.updateCount(item.id, 0);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          if (index < items.length - 1)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Divider(height: 1),
                            )
                          else
                            const SizedBox(height: 16),
                        ],
                      );
                    }).toList(),
                    const SizedBox(height: AppConstants.spacing8),
                    if (state.error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          state.error!,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        text: state.isSaved ? 'Saved' : 'Save Physical Count',
                        icon: Icon(Icons.check, color: theme.colorScheme.onPrimary, size: 20),
                        onPressed: (state.isLoading || state.counts.isEmpty) ? null : () async {
                          try {
                            await notifier.submitCounts();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Manager Inventory saved successfully')),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to save: $e'), backgroundColor: Colors.red),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
