import 'package:manager_app/core/utils/date_util.dart';
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

class ShopSaleScreen extends ConsumerStatefulWidget {
  const ShopSaleScreen({super.key});

  @override
  ConsumerState<ShopSaleScreen> createState() => _ShopSaleScreenState();
}

class _ShopSaleScreenState extends ConsumerState<ShopSaleScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inventoryStateAsync = ref.watch(inventoryProvider);
    final saleState = ref.watch(shopSaleProvider);
    final saleNotifier = ref.read(shopSaleProvider.notifier);

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
            const Text('Shop Sale', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              DateFormat('MMM d, yyyy').format(DateUtil.operatingDay),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push('/shop-sale/history'),
            tooltip: 'Sale History',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: AppAsyncWidget<InventoryState>(
        value: inventoryStateAsync,
        onRetry: () => ref.read(inventoryProvider.notifier).reload(),
        data: (loadedState) {
          if (loadedState.items.isEmpty) {
            return const Center(child: Text('No inventory items found'));
          }

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
                
                (() {
                  final groupedItems = <String, List<dynamic>>{};
                  final sectionKeys = <String>[];
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

                  return Column(
                    children: sectionKeys.map((section) {
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
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing16, vertical: 8.0),
                              child: Column(
                                children: items.map((item) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12.0),
                                    child: _SaleItemCard(
                                      title: item.name,
                                      subtitle: item.subtitle,
                                      currentStock: item.currentStock.toInt(),
                                      quantity: saleState.currentQuantities[item.id] ?? 0,
                                      onChanged: (val) => saleNotifier.updateQuantity(item.id, val),
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  );
                })(),

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
  final String subtitle;
  final int currentStock;
  final int quantity;
  final Function(int) onChanged;

  const _SaleItemCard({
    required this.title,
    required this.subtitle,
    required this.currentStock,
    required this.quantity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isError = quantity > currentStock;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant.withAlpha(50)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$title${subtitle.isNotEmpty ? ' • $subtitle' : ''}',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: currentStock == 0 ? Colors.red.withAlpha(30) : theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Av: $currentStock',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: currentStock == 0 ? Colors.red : theme.colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _EditableStepper(
              value: quantity,
              isError: isError,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _EditableStepper extends StatefulWidget {
  final int value;
  final Function(int) onChanged;
  final bool isError;

  const _EditableStepper({required this.value, required this.onChanged, required this.isError});

  @override
  State<_EditableStepper> createState() => _EditableStepperState();
}

class _EditableStepperState extends State<_EditableStepper> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void didUpdateWidget(_EditableStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value.toString() != _controller.text) {
      final currentVal = int.tryParse(_controller.text);
      if (currentVal != widget.value) {
        _controller.text = widget.value.toString();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: widget.value > 0 ? () => widget.onChanged(widget.value - 1) : null,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.remove_circle_outline,
              color: widget.value > 0 ? theme.colorScheme.primary : Colors.grey,
              size: 24,
            ),
          ),
        ),
        SizedBox(
          width: 44,
          child: TextFormField(
            controller: _controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: widget.isError ? Colors.red : null,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            ),
            onChanged: (val) {
              final numValue = int.tryParse(val);
              if (numValue != null) {
                widget.onChanged(numValue);
              } else if (val.isEmpty) {
                widget.onChanged(0);
              }
            },
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => widget.onChanged(widget.value + 1),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.add_circle_outline,
              color: theme.colorScheme.primary,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}
