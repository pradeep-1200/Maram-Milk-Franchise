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
        
        String legacyName = item.name;
        if (legacyName == 'Half Litre Bottle') legacyName = '500ml Bottle';
        final managersRemaining = managerCounts[item.id] ?? managerCounts[legacyName] ?? 0;

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
                    bottom: AppConstants.spacing16,
                  ),
                  itemCount: loadedState.items.length,
                  separatorBuilder: (_, __) => const Divider(height: AppConstants.spacing16),
                  itemBuilder: (context, index) {
                    final item = loadedState.items[index];
                    return _InventoryRow(
                      item: item,
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

class _InventoryRow extends StatelessWidget {
  final InventoryItemState item;

  const _InventoryRow({
    required this.item,
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
