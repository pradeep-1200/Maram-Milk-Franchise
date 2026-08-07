import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/app_button.dart';
import '../../shared/async_value_widget.dart';
import '../inventory/providers/inventory_provider.dart';
import 'providers/shop_sale_provider.dart';
import 'widgets/shop_sale_history_widget.dart';

class ShopSaleScreen extends ConsumerWidget {
  const ShopSaleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final inventoryStateAsync = ref.watch(inventoryProvider);
    final saleState = ref.watch(shopSaleProvider);
    final saleNotifier = ref.read(shopSaleProvider.notifier);

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
            const Text('Shop Sale', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              DateFormat('MMM d, yyyy').format(DateTime.now()),
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
        data: (loadedState) {
          if (loadedState.items.isEmpty) {
            return const Center(child: Text('No inventory items found'));
          }

          final item1L = loadedState.items.cast<InventoryItemState?>().firstWhere((i) => i?.subtitle == 'Bottle - 1L', orElse: () => null);
          final itemHalfL = loadedState.items.cast<InventoryItemState?>().firstWhere((i) => i?.subtitle == 'Bottle - 500ml', orElse: () => null);
          final itemPacket = loadedState.items.cast<InventoryItemState?>().firstWhere((i) => i?.subtitle == 'Packet - 500ml', orElse: () => null);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Record Direct Sale',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                
                if (item1L != null)
                  _SaleItemCard(
                    title: '1L Bottle',
                    currentStock: item1L.currentStock.toInt(),
                    quantity: saleState.currentQuantities['1L'] ?? 0,
                    onChanged: (val) => saleNotifier.updateQuantity('1L', val),
                  ),
                const SizedBox(height: 12),
                
                if (itemHalfL != null)
                  _SaleItemCard(
                    title: '500ml Bottle',
                    currentStock: itemHalfL.currentStock.toInt(),
                    quantity: saleState.currentQuantities['500ml'] ?? 0,
                    onChanged: (val) => saleNotifier.updateQuantity('500ml', val),
                  ),
                const SizedBox(height: 12),

                if (itemPacket != null)
                  _SaleItemCard(
                    title: '500ml Packet',
                    currentStock: itemPacket.currentStock.toInt(),
                    quantity: saleState.currentQuantities['500ml_Packet'] ?? 0,
                    onChanged: (val) => saleNotifier.updateQuantity('500ml_Packet', val),
                  ),

                const SizedBox(height: 32),
                
                Text(
                  'Today\'s Sales History',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const ShopSaleHistoryWidget(),
                
                const SizedBox(height: 80), // Padding for sticky bottom bar
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: saleState.isDirty ? SafeArea(
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
          child: AppButton(
            text: 'Complete Sale',
            onPressed: saleState.isLoading ? null : () async {
              try {
                await saleNotifier.submitSale();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sale recorded successfully')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  String errMsg = e.toString();
                  if (e is DioException && e.response?.data != null && e.response?.data['error'] != null) {
                    errMsg = e.response?.data['error']['message'] ?? errMsg;
                  }
                  
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Sale Blocked'),
                      content: Text(errMsg),
                      actions: [
                        TextButton(
                          onPressed: () => ctx.pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
          ),
        ),
      ) : null,
    );
  }
}

class _SaleItemCard extends StatelessWidget {
  final String title;
  final int currentStock;
  final int quantity;
  final Function(int) onChanged;

  const _SaleItemCard({
    required this.title,
    required this.currentStock,
    required this.quantity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isError = quantity > currentStock;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Available: $currentStock', 
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: currentStock == 0 ? Colors.red : theme.colorScheme.onSurfaceVariant
                    )
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  color: quantity > 0 ? theme.colorScheme.primary : Colors.grey,
                  onPressed: quantity > 0 ? () => onChanged(quantity - 1) : null,
                ),
                SizedBox(
                  width: 40,
                  child: Text(
                    '$quantity', 
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isError ? Colors.red : null,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  color: theme.colorScheme.primary,
                  onPressed: () => onChanged(quantity + 1),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
