import 'package:manager_app/core/utils/date_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/app_card.dart';
import '../../shared/async_value_widget.dart';
import '../../shared/dp_avatar.dart';
import 'providers/evening_check_provider.dart';
import 'models/empty_bottle_status.dart';

enum EveningCheckFilter { all, pending, delivered, notDelivered }

class EveningCheckScreen extends ConsumerStatefulWidget {
  const EveningCheckScreen({super.key});

  @override
  ConsumerState<EveningCheckScreen> createState() => _EveningCheckScreenState();
}

class _EveningCheckScreenState extends ConsumerState<EveningCheckScreen> {
  EveningCheckFilter _filter = EveningCheckFilter.all;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCheckSheet(BuildContext context, EmptyBottleStatus route) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.cardRadius)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return _EveningCheckSheet(
              route: route,
              scrollController: scrollController,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final asyncState = ref.watch(eveningCheckProvider);
    final nowStr = DateFormat('MMM dd, yyyy').format(DateUtil.operatingDay);

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
          children: [
            const Text('Return Check', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              nowStr,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: AppAsyncWidget<EveningCheckState>(
        value: asyncState,
        data: (state) {
          final allRoutes = state.statuses.toList();
          
          final total = allRoutes.length;
          final checked = allRoutes.where((r) => r.status == 'Delivered').length;
          final pendingCount = allRoutes.where((r) => r.status == 'Pending').length;
          final deliveredCount = allRoutes.where((r) => r.deliveryCompleted == true).length;
          final notDeliveredCount = allRoutes.where((r) => r.status == 'Delivered' && r.deliveryCompleted == false).length;

          final filteredRoutes = allRoutes.where((route) {
            final matchesSearch = _searchQuery.isEmpty || route.routeName.toLowerCase().contains(_searchQuery.toLowerCase());
            if (!matchesSearch) return false;
            
            switch (_filter) {
              case EveningCheckFilter.all:
                return true;
              case EveningCheckFilter.pending:
                return route.status == 'Pending';
              case EveningCheckFilter.delivered:
                return route.deliveryCompleted == true;
              case EveningCheckFilter.notDelivered:
                return route.status == 'Delivered' && route.deliveryCompleted == false;
            }
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing16, vertical: AppConstants.spacing8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$checked of $total checked',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: checked == total ? Colors.green : theme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      '$pendingCount pending',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: pendingCount > 0 ? Colors.orange : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              if (total > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing16),
                  child: LinearProgressIndicator(
                    value: total > 0 ? checked / total : 0,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    color: checked == total ? Colors.green : theme.colorScheme.primary,
                  ),
                ),
              
              const SizedBox(height: AppConstants.spacing8),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by route name...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ),
              const SizedBox(height: AppConstants.spacing8),
              
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacing16,
                  vertical: AppConstants.spacing8,
                ),
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All $total',
                      isSelected: _filter == EveningCheckFilter.all,
                      onSelected: () => setState(() => _filter = EveningCheckFilter.all),
                    ),
                    const SizedBox(width: AppConstants.spacing8),
                    _FilterChip(
                      label: 'Pending $pendingCount',
                      isSelected: _filter == EveningCheckFilter.pending,
                      onSelected: () => setState(() => _filter = EveningCheckFilter.pending),
                    ),
                    const SizedBox(width: AppConstants.spacing8),
                    _FilterChip(
                      label: 'Delivered $deliveredCount',
                      isSelected: _filter == EveningCheckFilter.delivered,
                      onSelected: () => setState(() => _filter = EveningCheckFilter.delivered),
                    ),
                    const SizedBox(width: AppConstants.spacing8),
                    _FilterChip(
                      label: 'Not Delivered $notDeliveredCount',
                      isSelected: _filter == EveningCheckFilter.notDelivered,
                      onSelected: () => setState(() => _filter = EveningCheckFilter.notDelivered),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: filteredRoutes.isEmpty
                    ? Center(
                        child: Text(
                          'No routes found',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(
                          left: AppConstants.spacing16,
                          right: AppConstants.spacing16,
                          top: AppConstants.spacing8,
                          bottom: 100,
                        ),
                        itemCount: filteredRoutes.length,
                        separatorBuilder: (_, __) => const SizedBox(height: AppConstants.spacing8),
                        itemBuilder: (context, index) {
                          final route = filteredRoutes[index];
                          return _RouteDpCard(
                            route: route,
                            onTap: () => _showCheckSheet(context, route),
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ActionChip(
      label: Text(label),
      backgroundColor: isSelected ? theme.colorScheme.primaryContainer : theme.colorScheme.surface,
      labelStyle: TextStyle(
        color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? theme.colorScheme.primary : theme.dividerColor,
      ),
      onPressed: onSelected,
    );
  }
}

class _RouteDpCard extends StatelessWidget {
  final EmptyBottleStatus route;
  final VoidCallback onTap;

  const _RouteDpCard({
    required this.route,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Color badgeColor;
    String badgeText;
    
    if (route.status == 'Unassigned') {
      badgeColor = Colors.grey;
      badgeText = 'Not assigned today';
    } else if (route.status == 'Delivered' && route.deliveryCompleted == true) {
      badgeColor = Colors.green;
      badgeText = 'Delivered ✓';
    } else if (route.status == 'Delivered' && route.deliveryCompleted == false) {
      badgeColor = Colors.red;
      badgeText = 'Not Delivered ✗';
    } else {
      badgeColor = Colors.orange;
      badgeText = 'Pending';
    }

    final isUnassigned = route.status == 'Unassigned';

    return AppCard(
      onTap: isUnassigned ? null : onTap,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing16, vertical: AppConstants.spacing8),
      child: Opacity(
        opacity: isUnassigned ? 0.6 : 1.0,
        child: Row(
          children: [
            Opacity(
              opacity: isUnassigned ? 0.3 : 1.0,
              child: DpAvatar(
                photoUrl: null, // Photo not returned in this API yet
                name: route.dpName ?? '?',
              ),
            ),
            const SizedBox(width: AppConstants.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    route.routeName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isUnassigned ? Colors.grey : theme.colorScheme.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    route.dpName ?? 'Unassigned',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isUnassigned ? Colors.grey : theme.colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (route.dpId != null)
                    Text(
                      'ID: ${route.dpId}',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: badgeColor.withAlpha(25),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: badgeColor),
              ),
              child: Text(
                badgeText,
                style: TextStyle(color: badgeColor, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: AppConstants.spacing8),
            if (!isUnassigned)
              Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _EveningCheckSheet extends ConsumerStatefulWidget {
  final EmptyBottleStatus route;
  final ScrollController scrollController;

  const _EveningCheckSheet({
    required this.route,
    required this.scrollController,
  });

  @override
  ConsumerState<_EveningCheckSheet> createState() => _EveningCheckSheetState();
}

class _EveningCheckSheetState extends ConsumerState<_EveningCheckSheet> {
  bool? _didCompleteDelivery;
  bool _flagNoReturn = false;
  String? _reason;
  late final TextEditingController _ctrlNotes;

  // We maintain a map of text controllers for each dynamic item field
  final Map<String, TextEditingController> _ctrlCollected = {};
  final Map<String, TextEditingController> _ctrlBroken = {};
  final Map<String, TextEditingController> _ctrlActual = {};

  // We also keep the actual values in memory
  final Map<String, int> _valCollected = {};
  final Map<String, int> _valBroken = {};
  final Map<String, int> _valActual = {};

  @override
  void initState() {
    super.initState();
    if (widget.route.status == 'Delivered') {
      _didCompleteDelivery = widget.route.deliveryCompleted;
    }
    _flagNoReturn = widget.route.flagIssue;
    _reason = widget.route.reason;
    _ctrlNotes = TextEditingController(text: widget.route.notes ?? '');

    for (final item in widget.route.items) {
      _valCollected[item.inventoryItemId] = item.collected;
      _valBroken[item.inventoryItemId] = item.broken;
      _valActual[item.inventoryItemId] = item.actualDelivered;

      _ctrlCollected[item.inventoryItemId] = TextEditingController(text: item.collected.toString());
      _ctrlBroken[item.inventoryItemId] = TextEditingController(text: item.broken.toString());
      _ctrlActual[item.inventoryItemId] = TextEditingController(text: item.actualDelivered.toString());
    }
  }

  @override
  void dispose() {
    _ctrlNotes.dispose();
    for (final c in _ctrlCollected.values) { c.dispose(); }
    for (final c in _ctrlBroken.values) { c.dispose(); }
    for (final c in _ctrlActual.values) { c.dispose(); }
    super.dispose();
  }

  void _handleSave() {
    if (_didCompleteDelivery == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select Yes or No')),
      );
      return;
    }
    
    if (_didCompleteDelivery == false && _reason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a reason')),
      );
      return;
    }
    
    if (_didCompleteDelivery == false && _reason == 'Other' && _ctrlNotes.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notes are required for "Other" reason')),
      );
      return;
    }

    final itemsPayload = widget.route.items.map((item) {
      return {
        'inventoryItemId': item.inventoryItemId,
        'actualDelivered': _valActual[item.inventoryItemId] ?? 0,
        'collected': _valCollected[item.inventoryItemId] ?? 0,
        'broken': ((_didCompleteDelivery == false && _reason == 'Bottles broken') || (_didCompleteDelivery == true && _flagNoReturn)) 
            ? (_valBroken[item.inventoryItemId] ?? 0) 
            : 0,
      };
    }).toList();

    ref.read(eveningCheckProvider.notifier).updateStatus(
      widget.route.routeId,
      dpId: widget.route.dpId ?? '',
      deliveryCompleted: _didCompleteDelivery!,
      flagIssue: _flagNoReturn,
      reason: _didCompleteDelivery == false ? _reason : null,
      notes: ((_didCompleteDelivery == false && ['Bottles broken', 'Other'].contains(_reason)) || (_didCompleteDelivery == true && _flagNoReturn)) ? _ctrlNotes.text.trim() : null,
      items: itemsPayload,
    );

    context.pop();
  }

  Widget _buildCounter(
    String label,
    int value,
    TextEditingController ctrl,
    ValueChanged<int> onChanged,
    ThemeData theme,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: value > 0
                  ? () {
                      final newVal = value - 1;
                      onChanged(newVal);
                      ctrl.text = newVal.toString();
                    }
                  : null,
              icon: const Icon(Icons.remove_circle_outline),
              color: theme.colorScheme.primary,
            ),
            SizedBox(
              width: 64,
              child: TextField(
                controller: ctrl,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                  ),
                ),
                onChanged: (raw) {
                  final parsed = int.tryParse(raw);
                  if (parsed != null && parsed >= 0) {
                    onChanged(parsed);
                  }
                },
                onEditingComplete: () {
                  final parsed = int.tryParse(ctrl.text);
                  if (parsed == null || parsed < 0) {
                    ctrl.text = value.toString();
                  } else {
                    ctrl.text = value.toString();
                  }
                  FocusScope.of(context).unfocus();
                },
                onSubmitted: (_) {
                  final parsed = int.tryParse(ctrl.text);
                  if (parsed == null || parsed < 0) {
                    ctrl.text = value.toString();
                  }
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
            IconButton(
              onPressed: () {
                final newVal = value + 1;
                onChanged(newVal);
                ctrl.text = newVal.toString();
              },
              icon: const Icon(Icons.add_circle_outline),
              color: theme.colorScheme.primary,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final glassItems = widget.route.items.where((i) => i.section == 'Milk' && i.material == 'Bottle').toList();

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacing16),
            child: Row(
              children: [
                DpAvatar(
                  photoUrl: null, // Photo not returned in this API yet
                  name: widget.route.dpName ?? '?',
                ),
                const SizedBox(width: AppConstants.spacing16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.route.dpName ?? 'Unknown',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Route: ${widget.route.routeName}',
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),

          Expanded(
            child: ListView(
              controller: widget.scrollController,
              padding: const EdgeInsets.all(AppConstants.spacing16),
              children: [
                Text(
                  'Delivery Status',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppConstants.spacing8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => setState(() => _didCompleteDelivery = true),
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Yes, Delivered'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _didCompleteDelivery == true ? Colors.white : Colors.green,
                          backgroundColor: _didCompleteDelivery == true ? Colors.green : null,
                          side: const BorderSide(color: Colors.green),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacing16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => setState(() => _didCompleteDelivery = false),
                        icon: const Icon(Icons.cancel_outlined),
                        label: const Text('Not Delivered'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _didCompleteDelivery == false ? Colors.white : Colors.red,
                          backgroundColor: _didCompleteDelivery == false ? Colors.red : null,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),

                if (_didCompleteDelivery == true) ...[
                  const SizedBox(height: AppConstants.spacing24),
                  const Divider(),
                  const SizedBox(height: AppConstants.spacing16),
                  
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'Empty Bottles Returned',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Expected Bottles: ${widget.route.expectedEmptyBottles}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacing16),
                  
                  // Iterate over glass items
                  ...glassItems.map((item) {
                    final expected = item.expected;
                    final collected = _valCollected[item.inventoryItemId] ?? 0;
                    final broken = _valBroken[item.inventoryItemId] ?? 0;
                    final remaining = expected - collected - broken;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppConstants.spacing16),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: theme.colorScheme.outlineVariant),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.name} (${item.unit})',
                                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  'Expected: $expected | Rem: $remaining',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: remaining > 0 ? Colors.orange[800] : Colors.green[800],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _buildCounter(
                              'Collected',
                              collected,
                              _ctrlCollected[item.inventoryItemId]!,
                              (v) => setState(() => _valCollected[item.inventoryItemId] = v),
                              theme,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: AppConstants.spacing8),
                  SwitchListTile(
                    title: const Text('Flag issue with returns'),
                    subtitle: const Text('Check if bottles are missing or damaged'),
                    value: _flagNoReturn,
                    onChanged: (bool value) {
                      setState(() {
                        _flagNoReturn = value;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                    activeColor: Colors.orange,
                  ),
                  
                  if (_flagNoReturn) ...[
                    const SizedBox(height: AppConstants.spacing16),
                    ...glassItems.map((item) {
                      final broken = _valBroken[item.inventoryItemId] ?? 0;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppConstants.spacing12),
                        child: _buildCounter(
                          'Broken ${item.name}',
                          broken,
                          _ctrlBroken[item.inventoryItemId]!,
                          (v) => setState(() => _valBroken[item.inventoryItemId] = v),
                          theme,
                        ),
                      );
                    }),
                    const SizedBox(height: AppConstants.spacing8),
                    TextField(
                      controller: _ctrlNotes,
                      decoration: InputDecoration(
                        labelText: 'Notes / Reason for shortage',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                        ),
                      ),
                      maxLines: 2,
                    ),
                  ],
                ],

                if (_didCompleteDelivery == false) ...[
                  const SizedBox(height: AppConstants.spacing24),
                  const Divider(),
                  const SizedBox(height: AppConstants.spacing16),
                  Text(
                    'Reason for Non-Delivery',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppConstants.spacing8),
                  DropdownButtonFormField<String>(
                    value: _reason,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Vehicle breakdown', child: Text('Vehicle breakdown')),
                      DropdownMenuItem(value: 'DP sick / emergency', child: Text('DP sick / emergency')),
                      DropdownMenuItem(value: 'Severe weather', child: Text('Severe weather')),
                      DropdownMenuItem(value: 'Bottles broken', child: Text('Bottles broken in transit')),
                      DropdownMenuItem(value: 'Partial delivery completed', child: Text('Partial delivery completed')),
                      DropdownMenuItem(value: 'Other', child: Text('Other (specify in notes)')),
                    ],
                    onChanged: (value) => setState(() => _reason = value),
                  ),
                  
                  if (_reason == 'Bottles broken') ...[
                    const SizedBox(height: AppConstants.spacing16),
                    ...glassItems.map((item) {
                      final broken = _valBroken[item.inventoryItemId] ?? 0;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppConstants.spacing12),
                        child: _buildCounter(
                          'Broken ${item.name}',
                          broken,
                          _ctrlBroken[item.inventoryItemId]!,
                          (v) => setState(() => _valBroken[item.inventoryItemId] = v),
                          theme,
                        ),
                      );
                    }),
                  ],

                  if (_reason == 'Partial delivery completed') ...[
                    const SizedBox(height: AppConstants.spacing16),
                    Text(
                      'Actual Delivered Quantities',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppConstants.spacing8),
                    ...widget.route.items.map((item) {
                      final actual = _valActual[item.inventoryItemId] ?? 0;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppConstants.spacing12),
                        child: _buildCounter(
                          item.name,
                          actual,
                          _ctrlActual[item.inventoryItemId]!,
                          (v) => setState(() => _valActual[item.inventoryItemId] = v),
                          theme,
                        ),
                      );
                    }),
                  ],
                  
                  const SizedBox(height: AppConstants.spacing16),
                  TextField(
                    controller: _ctrlNotes,
                    decoration: InputDecoration(
                      labelText: 'Notes',
                      hintText: _reason == 'Other' ? 'Required for "Other" reason' : 'Optional details',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                      ),
                    ),
                    maxLines: 2,
                  ),
                ],
              ],
            ),
          ),
          
          Container(
            padding: const EdgeInsets.all(AppConstants.spacing16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _handleSave,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                  ),
                ),
                child: const Text('Save & Check Next', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
