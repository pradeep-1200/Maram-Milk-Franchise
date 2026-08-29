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
import 'widgets/shop_sale_history_widget.dart';

class ShopSaleScreen extends ConsumerStatefulWidget {
  const ShopSaleScreen({super.key});

  @override
  ConsumerState<ShopSaleScreen> createState() => _ShopSaleScreenState();
}

class _ShopSaleScreenState extends ConsumerState<ShopSaleScreen> {
  Future<DateTimeRange?> _selectCustomDateRange(ShopSaleState state) async {
    final now = DateUtil.operatingDay;
    return await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
      initialDateRange: state.customDateRange ?? DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now),
    );
  }

  Future<DateTimeRange?> _selectCustomDate(ShopSaleState state) async {
    final now = DateUtil.operatingDay;
    final picked = await showDatePicker(
      context: context,
      initialDate: state.customDateRange?.start ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
    );
    if (picked != null) {
      return DateTimeRange(start: picked, end: picked);
    }
    return null;
  }

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

                const SizedBox(height: 32),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'History',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    _DateFilterDropdown(
                      state: saleState,
                      onPeriodChanged: (period) async {
                        if (period == 'custom_date') {
                          final picked = await _selectCustomDate(saleState);
                          if (picked != null) {
                            saleNotifier.setCustomDateRange(picked);
                          }
                        } else if (period == 'custom_range') {
                          final picked = await _selectCustomDateRange(saleState);
                          if (picked != null) {
                            saleNotifier.setCustomDateRange(picked);
                          }
                        } else {
                          saleNotifier.setPeriod(period);
                        }
                      },
                    ),
                  ],
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

class _DateFilterDropdown extends StatelessWidget {
  final ShopSaleState state;
  final Function(String) onPeriodChanged;

  const _DateFilterDropdown({
    required this.state,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Determine the current dropdown value based on state
    String currentValue = 'today';
    if (state.period == 'yesterday') currentValue = 'yesterday';
    if (state.period == 'week') currentValue = 'week';
    if (state.period == 'month') currentValue = 'month';
    if (state.period == 'custom') {
      if (state.customDateRange != null && state.customDateRange!.start == state.customDateRange!.end) {
        currentValue = 'custom_date';
      } else {
        currentValue = 'custom_range';
      }
    }

    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(100),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outlineVariant.withAlpha(100)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentValue,
          icon: const Icon(Icons.arrow_drop_down, size: 20),
          isDense: true,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
          items: const [
            DropdownMenuItem(value: 'today', child: Text('Today')),
            DropdownMenuItem(value: 'yesterday', child: Text('Yesterday')),
            DropdownMenuItem(value: 'week', child: Text('This week')),
            DropdownMenuItem(value: 'month', child: Text('This month')),
            DropdownMenuItem(value: 'custom_date', child: Text('Custom date')),
            DropdownMenuItem(value: 'custom_range', child: Text('Custom range')),
          ],
          onChanged: (val) {
            if (val != null) {
              onPeriodChanged(val);
            }
          },
        ),
      ),
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

    IconData icon = Icons.local_drink;
    Color iconColor = Colors.green;
    Color bgColor = Colors.green.withAlpha(30);

    if (subtitle.contains('Bottle') && subtitle.contains('500ml')) {
      iconColor = Colors.blue;
      bgColor = Colors.blue.withAlpha(30);
    } else if (subtitle.contains('Packet')) {
      icon = Icons.inventory_2;
      iconColor = Colors.orange;
      bgColor = Colors.orange.withAlpha(30);
    } else if (title.contains('Oil')) {
      icon = Icons.oil_barrel;
      iconColor = Colors.amber;
      bgColor = Colors.amber.withAlpha(30);
    } else if (title.contains('Ghee')) {
      icon = Icons.cookie;
      iconColor = Colors.brown;
      bgColor = Colors.brown.withAlpha(30);
    }

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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$title${subtitle.isNotEmpty ? ' • $subtitle' : ''}',
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
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
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          color: widget.value > 0 ? theme.colorScheme.primary : Colors.grey,
          onPressed: widget.value > 0 ? () => widget.onChanged(widget.value - 1) : null,
        ),
        SizedBox(
          width: 50,
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          color: theme.colorScheme.primary,
          onPressed: () => widget.onChanged(widget.value + 1),
        ),
      ],
    );
  }
}
