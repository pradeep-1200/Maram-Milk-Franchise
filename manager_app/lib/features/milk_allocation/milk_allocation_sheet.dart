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

class MilkAllocationSheet extends ConsumerStatefulWidget {
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
  ConsumerState<MilkAllocationSheet> createState() => _MilkAllocationSheetState();
}

class _MilkAllocationSheetState extends ConsumerState<MilkAllocationSheet> {
  bool _isSubmitting = false;
  bool _showSummary = false;
  late final String _allocationKey;

  @override
  void initState() {
    super.initState();
    _allocationKey = '${widget.route.id}_${widget.dp.id}';
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final existingAlloc = widget.route.allocations.where((a) => a.dpId == widget.dp.id).firstOrNull;
      if (existingAlloc != null) {
        ref.read(milkAllocationProvider.notifier).initAllocation(_allocationKey, existingAlloc.items);
      } else {
        ref.read(milkAllocationProvider.notifier).initAllocation(_allocationKey, {});
      }
    });
  }

  IconData _getIconForSection(String? section) {
    switch (section) {
      case 'Milk': return Icons.local_drink;
      case 'Dairy': return Icons.cookie;
      case 'Oils': return Icons.opacity;
      case 'Sweeteners': return Icons.spa;
      case 'Grocery': return Icons.shopping_bag;
      default: return Icons.inventory_2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeAllocation = ref.watch(milkAllocationProvider.select((state) => state.allocations[_allocationKey] ?? const RouteMilkAllocation()));
    final notifier = ref.read(milkAllocationProvider.notifier);
    final theme = Theme.of(context);
    
    final inventoryState = ref.watch(inventoryProvider).value;
    final List<InventoryItemState> allItems = inventoryState?.items ?? [];
    
    // Group by section
    final Map<String, List<InventoryItemState>> sectionedItems = {};
    for (final item in allItems) {
      final section = item.section == 'Snacks / Grocery' ? 'Grocery' : (item.section ?? 'Other');
      sectionedItems.putIfAbsent(section, () => []).add(item);
    }
    
    // Sort sections
    final sectionOrder = ['Milk', 'Dairy', 'Oils', 'Sweeteners', 'Grocery'];
    final sections = sectionedItems.keys.toList()
      ..sort((a, b) {
        int indexA = sectionOrder.indexOf(a);
        int indexB = sectionOrder.indexOf(b);
        if (indexA == -1) indexA = 999;
        if (indexB == -1) indexB = 999;
        return indexA.compareTo(indexB);
      });

    // Calculate total Milk volume
    double totalMilkVolume = 0.0;
    if (sectionedItems.containsKey('Milk')) {
      for (final item in sectionedItems['Milk']!) {
        final qty = routeAllocation.items[item.id] ?? 0;
        totalMilkVolume += (item.litresPerUnit ?? 0.0) * qty;
      }
    }

    // Previous allocations for this route to determine maxLimit
    final Map<String, int> prevAllocations = {};
    for (final a in widget.route.allocations) {
      a.items.forEach((key, value) {
        prevAllocations[key] = (prevAllocations[key] ?? 0) + value;
      });
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
                      'Stock Allocation',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppConstants.spacing4),
                    Text(
                      widget.route.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppConstants.spacing4),
                    Text(
                      'Assigned to: ${widget.dp.name} (${widget.dp.employeeId})',
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
                if (!widget.isInStepFlow && !_showSummary)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => context.pop(),
                  )
                else if (_showSummary)
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => setState(() => _showSummary = false),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          
          // Products List
          Expanded(
            child: _showSummary
                ? _buildSummaryList(context, routeAllocation, allItems)
                : ListView.builder(
                    controller: widget.scrollController,
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: sections.length,
                    itemBuilder: (context, index) {
                      final section = sections[index];
                      final items = sectionedItems[section]!;
                      final sectionIcon = _getIconForSection(section);
                      
                      return ExpansionTile(
                        initiallyExpanded: section == 'Milk',
                        leading: Icon(sectionIcon, color: theme.colorScheme.primary),
                        title: Text(
                          section,
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        children: items.map((item) {
                          final qty = routeAllocation.items[item.id] ?? 0;
                          final prevQty = prevAllocations[item.id] ?? 0;
                          final maxLimit = (item.currentStock.toInt()) + prevQty;
                          
                          return _ProductRow(
                            icon: sectionIcon,
                            title: item.name,
                            subtitle: item.subtitle,
                            quantity: qty,
                            onDecrement: () => notifier.updateItem(_allocationKey, item.id, -1),
                            onIncrement: () => notifier.updateItem(_allocationKey, item.id, 1, maxLimit: maxLimit),
                            onSetValue: (v) => notifier.setItem(_allocationKey, item.id, v, maxLimit: maxLimit),
                            maxLimit: maxLimit,
                          );
                        }).toList(),
                      );
                    },
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
                    '${totalMilkVolume.toStringAsFixed(1)} L',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacing8),
              AppButton(
                text: _showSummary ? 'Confirm & Next' : 'Next',
                isLoading: _isSubmitting,
                onPressed: _isSubmitting ? null : () async {
                  if (!_showSummary) {
                    // Check if at least one item is allocated to show summary
                    final totalQty = routeAllocation.items.values.fold<int>(0, (a, b) => a + b);
                    if (totalQty == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please allocate at least one product.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    setState(() => _showSummary = true);
                    return;
                  }

                  setState(() => _isSubmitting = true);

                  try {
                    if (!widget.route.allocations.any((a) => a.dpId == widget.dp.id)) {
                      await ref.read(routeProvider.notifier).assignRoute(
                        widget.route.id, 
                        widget.dp.id, 
                        widget.dp.name, 
                        totalMilkVolume,
                        items: routeAllocation.items,
                      );
                    } else {
                      await ref.read(routeProvider.notifier).updateRouteAllocationLitres(
                        widget.route.id, 
                        widget.dp.id,
                        totalMilkVolume,
                        items: routeAllocation.items,
                      );
                    }

                    if (context.mounted) {
                      if (widget.isInStepFlow) {
                        context.push('/dispatch/petrol-allowance');
                      } else {
                        context.pop();
                        _showPetrolAllowanceSheet(context, widget.route, widget.dp);
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
                  } finally {
                    if (mounted) {
                      setState(() => _isSubmitting = false);
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

  Widget _buildSummaryList(BuildContext context, RouteMilkAllocation routeAllocation, List<InventoryItemState> allItems) {
    final theme = Theme.of(context);
    final allocatedItems = allItems.where((item) => (routeAllocation.items[item.id] ?? 0) > 0).toList();

    return ListView.separated(
      controller: widget.scrollController,
      padding: const EdgeInsets.only(bottom: 80, top: 16),
      itemCount: allocatedItems.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final item = allocatedItems[index];
        final qty = routeAllocation.items[item.id]!;
        final icon = _getIconForSection(item.section);

        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withAlpha(100),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: theme.colorScheme.onSurfaceVariant),
          ),
          title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(item.subtitle),
          trailing: Text(
            qty.toString(),
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
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

class _ProductRow extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  /// Called when the user types a value directly; same max-limit clamping applies.
  final ValueChanged<int>? onSetValue;
  final int? maxLimit;

  const _ProductRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
    this.onSetValue,
    this.maxLimit,
  });

  @override
  State<_ProductRow> createState() => _ProductRowState();
}

class _ProductRowState extends State<_ProductRow> {
  late final TextEditingController _controller;
  // Track whether the field is being edited so we don't override mid-type.
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.quantity.toString());
  }

  @override
  void didUpdateWidget(_ProductRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync external quantity changes (e.g. from +/- taps) unless user is mid-edit.
    if (!_isEditing && oldWidget.quantity != widget.quantity) {
      _controller.text = widget.quantity.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged(String raw) {
    final parsed = int.tryParse(raw);
    if (parsed == null || parsed < 0) return; // wait for valid input
    final clamped = widget.maxLimit != null && parsed > widget.maxLimit!
        ? widget.maxLimit!
        : parsed;
    widget.onSetValue?.call(clamped);
  }

  void _onEditingComplete() {
    _isEditing = false;
    final parsed = int.tryParse(_controller.text);
    if (parsed == null || parsed < 0) {
      // Reset to current valid quantity
      _controller.text = widget.quantity.toString();
    } else {
      // Ensure display matches (may have been clamped by onSetValue)
      _controller.text = widget.quantity.toString();
    }
    FocusScope.of(context).unfocus();
  }

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
            child: Icon(widget.icon, color: theme.colorScheme.onPrimaryContainer),
          ),
          const SizedBox(width: AppConstants.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.subtitle,
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
                color: widget.quantity > 0 ? theme.colorScheme.primary : theme.disabledColor,
                onPressed: widget.quantity > 0
                    ? () {
                        widget.onDecrement();
                        // Controller will sync via didUpdateWidget
                      }
                    : null,
              ),
              // Editable quantity field — replaces the static Text display
              SizedBox(
                width: 56,
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                    ),
                  ),
                  onTap: () => setState(() => _isEditing = true),
                  onChanged: _onTextChanged,
                  onEditingComplete: _onEditingComplete,
                  onSubmitted: (_) => _onEditingComplete(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle),
                color: theme.colorScheme.primary,
                onPressed: () {
                  widget.onIncrement();
                  // Controller will sync via didUpdateWidget
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
