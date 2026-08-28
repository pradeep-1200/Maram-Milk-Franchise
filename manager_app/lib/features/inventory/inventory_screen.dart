import 'package:manager_app/core/utils/date_util.dart';
import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/app_button.dart';
import '../../shared/async_value_widget.dart';
import 'providers/inventory_provider.dart';
import '../manager_inventory/providers/manager_inventory_provider.dart';
import '../shell/providers/tab_history_provider.dart';

class InventoryScreen extends ConsumerWidget {
  final bool isDispatchContext;
  
  const InventoryScreen({super.key, this.isDispatchContext = false});

  Future<void> _exportReport(BuildContext context, WidgetRef ref, InventoryState state) async {
    if (state.items.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No data available to export.')),
        );
      }
      return;
    }

    try {
      final managerInventoryState = ref.read(managerInventoryProvider);
      final managerCounts = managerInventoryState.counts;

      List<List<dynamic>> rows = [];
      
      // Header row
      List<dynamic> header = ['Metric'];
      for (var item in state.items) {
        header.add(item.name);
      }
      rows.add(header);

      // Rows
      List<dynamic> todaysStockRow = ['Today\'s Stock'];
      List<dynamic> carriedOverRow = ['Carried Over Stocks'];
      List<dynamic> totalStocksRow = ['Total Stocks'];
      List<dynamic> appsRemainingRow = ['App\'s Total Remaining'];
      List<dynamic> managersRemainingRow = ['Manager\'s Remaining'];

      for (var item in state.items) {
        final todaysStock = item.newStockAdded.toInt();
        final carriedOver = item.carryOverQty.toInt();
        final totalStocks = todaysStock + carriedOver;
        final appsRemaining = item.expectedQty.toInt();
        
        final managersRemaining = managerCounts[item.id] ?? managerCounts[item.name] ?? 0;

        todaysStockRow.add(todaysStock);
        carriedOverRow.add(carriedOver);
        totalStocksRow.add(totalStocks);
        appsRemainingRow.add(appsRemaining);
        managersRemainingRow.add(managersRemaining);
      }

      rows.add(todaysStockRow);
      rows.add(carriedOverRow);
      rows.add(totalStocksRow);
      rows.add(appsRemainingRow);
      rows.add(managersRemainingRow);

      String csvData = const ListToCsvConverter().convert(rows);

      final directory = await getTemporaryDirectory();
      final dateLabel = DateFormat('yyyy-MM-dd').format(DateUtil.operatingDay);
      final path = '${directory.path}/Inventory_Report_$dateLabel.csv';
      final file = File(path);
      
      final List<int> bom = [0xEF, 0xBB, 0xBF];
      final List<int> bytes = utf8.encode(csvData);
      
      await file.writeAsBytes([...bom, ...bytes]);

      final xfile = XFile(path, mimeType: 'text/csv; charset=utf-8');
      if (context.mounted) {
        // ignore: deprecated_member_use
        await Share.shareXFiles([xfile], text: 'Inventory Report');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to export: $e')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryStateAsync = ref.watch(inventoryProvider);
    final state = inventoryStateAsync.value ?? const InventoryState(items: []);
    final notifier = ref.read(inventoryProvider.notifier);
    final theme = Theme.of(context);

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
                  tooltip: 'Next: Routes Assigned',
                  onPressed: () {
                    context.push('/dispatch/routes');
                  },
                ),
                const SizedBox(width: 8),
              ]
            : [
                IconButton(
                  icon: const Icon(Icons.download),
                  tooltip: 'Download Report',
                  onPressed: () => _exportReport(context, ref, state),
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

          // Group items by section
          final Map<String, List<InventoryItemState>> groupedItems = {};
          final List<String> sectionKeys = [];
          for (var item in loadedState.items) {
            final section = item.section == 'Snacks / Grocery' ? 'Grocery' : (item.section ?? 'Other');
            if (!groupedItems.containsKey(section)) {
              groupedItems[section] = [];
              sectionKeys.add(section);
            }
            groupedItems[section]!.add(item);
          }
          
          final sectionOrder = ['Milk', 'Dairy', 'Oils', 'Sweeteners', 'Grocery'];
          sectionKeys.sort((a, b) {
            int indexA = sectionOrder.indexOf(a);
            int indexB = sectionOrder.indexOf(b);
            if (indexA == -1) indexA = 999;
            if (indexB == -1) indexB = 999;
            return indexA.compareTo(indexB);
          });

          IconData getSectionIcon(String section) {
            switch (section) {
              case 'Milk': return Icons.local_drink;
              case 'Dairy': return Icons.cookie;
              case 'Oils': return Icons.opacity;
              case 'Sweeteners': return Icons.spa;
              case 'Grocery': return Icons.shopping_bag;
              default: return Icons.inventory_2;
            }
          }

          return ListView.builder(
            padding: const EdgeInsets.only(
              bottom: AppConstants.spacing16,
            ),
            itemCount: sectionKeys.length,
            itemBuilder: (context, index) {
              final section = sectionKeys[index];
              final items = groupedItems[section]!;
              
              return Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  leading: Icon(getSectionIcon(section), color: theme.colorScheme.primary),
                  title: Text(
                    section,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing16, vertical: 8),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AppConstants.spacing16),
                      itemBuilder: (context, itemIndex) {
                        return _InventoryRow(item: items[itemIndex]);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _InventoryRow extends ConsumerWidget {
  final InventoryItemState item;

  const _InventoryRow({
    required this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    Future<void> showReportBrokenDialog() async {
      final controller = TextEditingController();
      bool isSubmitting = false;

      await showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Report Broken Stock'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('How many ${item.name} are broken or damaged today?'),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter quantity',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          final count = int.tryParse(controller.text);
                          if (count == null || count <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter a valid number greater than 0')),
                            );
                            return;
                          }

                          setState(() => isSubmitting = true);
                          try {
                            await ref.read(inventoryProvider.notifier).reportBrokenStock(item.id, count);
                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Broken stock reported successfully')),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString().replaceAll('Exception: ', '')),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } finally {
                            if (context.mounted) {
                              setState(() => isSubmitting = false);
                            }
                          }
                        },
                  child: isSubmitting
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Submit'),
                ),
              ],
            );
          }
        ),
      );
    }


    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
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
                    // Row 1: Name
                    Text(
                      item.name,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    // Row 2: Subtitle
                    Text(
                      'Material: ${item.subtitle}',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              if (item.currentStock > 0)
                IconButton(
                  icon: const Icon(Icons.broken_image_outlined),
                  color: Colors.red.shade400,
                  tooltip: 'Report Broken Stock',
                  onPressed: showReportBrokenDialog,
                ),
            ],
          ),
          const SizedBox(height: AppConstants.spacing16),
          // Row 3: Expected figures integrated into the same card
          const Divider(height: 1),
          const SizedBox(height: AppConstants.spacing16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  if (item.brokenStock > 0)
                    Text(
                      '(${item.brokenStock.toInt()} reported broken)',
                      style: theme.textTheme.labelSmall?.copyWith(color: Colors.red.shade400),
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
        ],
      ),
    );
  }


}
