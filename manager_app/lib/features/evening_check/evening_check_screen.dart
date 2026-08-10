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
  late int _bottles1L;
  late int _bottlesHalfL;
  late bool _flagNoReturn;

  String? _reason;
  late int _brokenBottleCount1L;
  late int _brokenBottleCountHalfL;
  late int _actualDelivered1L;
  late int _actualDeliveredHalfL;
  late int _actualDeliveredPacket;
  late final TextEditingController _ctrl1L;
  late final TextEditingController _ctrlHalfL;
  late final TextEditingController _ctrlBroken1L;
  late final TextEditingController _ctrlBrokenHalfL;
  late final TextEditingController _ctrlActual1L;
  late final TextEditingController _ctrlActualHalfL;
  late final TextEditingController _ctrlActualPacket;
  late final TextEditingController _ctrlNotes;

  @override
  void initState() {
    super.initState();
    if (widget.route.status == 'Delivered') {
      _didCompleteDelivery = widget.route.deliveryCompleted;
    }
    _bottles1L = widget.route.oneLBottlesCollected;
    _bottlesHalfL = widget.route.halfLBottlesCollected;
    _flagNoReturn = widget.route.flagIssue;
    
    _reason = widget.route.reason;
    _brokenBottleCount1L = widget.route.brokenBottleCount1L ?? 0;
    _brokenBottleCountHalfL = widget.route.brokenBottleCountHalfL ?? 0;
    _actualDelivered1L = widget.route.actualDelivered1L;
    _actualDeliveredHalfL = widget.route.actualDeliveredHalfL;
    _actualDeliveredPacket = widget.route.actualDeliveredPacket;
    
    _ctrl1L = TextEditingController(text: _bottles1L.toString());
    _ctrlHalfL = TextEditingController(text: _bottlesHalfL.toString());
    _ctrlBroken1L = TextEditingController(text: _brokenBottleCount1L.toString());
    _ctrlBrokenHalfL = TextEditingController(text: _brokenBottleCountHalfL.toString());
    _ctrlActual1L = TextEditingController(text: _actualDelivered1L.toString());
    _ctrlActualHalfL = TextEditingController(text: _actualDeliveredHalfL.toString());
    _ctrlActualPacket = TextEditingController(text: _actualDeliveredPacket.toString());
    _ctrlNotes = TextEditingController(text: widget.route.notes ?? '');
  }

  @override
  void dispose() {
    _ctrl1L.dispose();
    _ctrlHalfL.dispose();
    _ctrlBroken1L.dispose();
    _ctrlBrokenHalfL.dispose();
    _ctrlActual1L.dispose();
    _ctrlActualHalfL.dispose();
    _ctrlActualPacket.dispose();
    _ctrlNotes.dispose();
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

    ref.read(eveningCheckProvider.notifier).updateStatus(
      widget.route.routeId,
      deliveryCompleted: _didCompleteDelivery!,
      oneLBottlesCollected: _bottles1L,
      halfLBottlesCollected: _bottlesHalfL,
      halfLPacketCollected: widget.route.halfLPacketCollected,
      actualDelivered1L: _actualDelivered1L,
      actualDeliveredHalfL: _actualDeliveredHalfL,
      actualDeliveredPacket: _actualDeliveredPacket,
      flagIssue: _flagNoReturn,
      reason: _didCompleteDelivery == false ? _reason : null,
      brokenBottleCount1L: ((_didCompleteDelivery == false && _reason == 'Bottles broken') || (_didCompleteDelivery == true && _flagNoReturn)) ? _brokenBottleCount1L : null,
      brokenBottleCountHalfL: ((_didCompleteDelivery == false && _reason == 'Bottles broken') || (_didCompleteDelivery == true && _flagNoReturn)) ? _brokenBottleCountHalfL : null,
      notes: ((_didCompleteDelivery == false && ['Bottles broken', 'Other'].contains(_reason)) || (_didCompleteDelivery == true && _flagNoReturn)) ? _ctrlNotes.text.trim() : null,
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
            // Editable text field replaces the static Container+Text display
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
                    // Reset to last valid value
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
                          'Total Expected: ${widget.route.expected1LBottles + widget.route.expectedHalfLBottles} | Remaining: ${(widget.route.expected1LBottles - _bottles1L - _brokenBottleCount1L) + (widget.route.expectedHalfLBottles - _bottlesHalfL - _brokenBottleCountHalfL)}',
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
                  
                  // 1L Bottles Section
                  Container(
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
                            Text(
                              '1L Bottles',
                              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Expected: ${widget.route.expected1LBottles} | Rem: ${widget.route.expected1LBottles - _bottles1L - _brokenBottleCount1L}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: (widget.route.expected1LBottles - _bottles1L - _brokenBottleCount1L) > 0 ? Colors.orange[800] : Colors.green[800],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _buildCounter(
                          'Collected',
                          _bottles1L,
                          _ctrl1L,
                          (v) => setState(() => _bottles1L = v),
                          theme,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacing16),
                  
                  // Half L Bottles Section
                  Container(
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
                            Text(
                              'Half L Bottles',
                              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Expected: ${widget.route.expectedHalfLBottles} | Rem: ${widget.route.expectedHalfLBottles - _bottlesHalfL - _brokenBottleCountHalfL}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: (widget.route.expectedHalfLBottles - _bottlesHalfL - _brokenBottleCountHalfL) > 0 ? Colors.orange[800] : Colors.green[800],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _buildCounter(
                          'Collected',
                          _bottlesHalfL,
                          _ctrlHalfL,
                          (v) => setState(() => _bottlesHalfL = v),
                          theme,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacing16),


                  const SizedBox(height: AppConstants.spacing24),
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
                    _buildCounter(
                      'Broken 1L Bottles',
                      _brokenBottleCount1L,
                      _ctrlBroken1L,
                      (v) => setState(() => _brokenBottleCount1L = v),
                      theme,
                    ),
                    const SizedBox(height: AppConstants.spacing8),
                    _buildCounter(
                      'Broken Half L Bottles',
                      _brokenBottleCountHalfL,
                      _ctrlBrokenHalfL,
                      (v) => setState(() => _brokenBottleCountHalfL = v),
                      theme,
                    ),
                    const SizedBox(height: AppConstants.spacing16),
                    TextField(
                      controller: _ctrlNotes,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Notes (optional)',
                        hintText: 'Enter details about missing/broken bottles...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ],
                
                if (_didCompleteDelivery == false) ...[
                  const SizedBox(height: AppConstants.spacing24),
                  const Divider(),
                  const SizedBox(height: AppConstants.spacing16),
                  
                  Text(
                    'Reason for non-delivery',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppConstants.spacing8),
                  
                  DropdownButtonFormField<String>(
                    value: _reason,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Bottles broken', child: Text('Bottles broken')),
                      DropdownMenuItem(value: 'Full delivery not completed', child: Text('Full delivery not completed')),
                      DropdownMenuItem(value: 'Partial delivery completed', child: Text('Partial delivery completed')),
                      DropdownMenuItem(value: 'Other', child: Text('Other')),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _reason = val;
                      });
                    },
                  ),
                  
                  if (_reason == 'Bottles broken') ...[
                    const SizedBox(height: AppConstants.spacing16),
                    _buildCounter(
                      'Broken 1L Bottles',
                      _brokenBottleCount1L,
                      _ctrlBroken1L,
                      (v) => setState(() => _brokenBottleCount1L = v),
                      theme,
                    ),
                    const SizedBox(height: AppConstants.spacing8),
                    _buildCounter(
                      'Broken Half L Bottles',
                      _brokenBottleCountHalfL,
                      _ctrlBrokenHalfL,
                      (v) => setState(() => _brokenBottleCountHalfL = v),
                      theme,
                    ),
                  ],
                  
                  if (_reason == 'Partial delivery completed') ...[
                    const SizedBox(height: AppConstants.spacing16),
                    Text(
                      'Actually Delivered',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppConstants.spacing8),
                    _buildCounter(
                      '1L Bottles Delivered',
                      _actualDelivered1L,
                      _ctrlActual1L,
                      (v) => setState(() => _actualDelivered1L = v),
                      theme,
                    ),
                    const SizedBox(height: AppConstants.spacing16),
                    _buildCounter(
                      'Half L Bottles Delivered',
                      _actualDeliveredHalfL,
                      _ctrlActualHalfL,
                      (v) => setState(() => _actualDeliveredHalfL = v),
                      theme,
                    ),
                    const SizedBox(height: AppConstants.spacing16),
                    _buildCounter(
                      'Half L Packets Delivered',
                      _actualDeliveredPacket,
                      _ctrlActualPacket,
                      (v) => setState(() => _actualDeliveredPacket = v),
                      theme,
                    ),
                  ],
                  
                  if (['Bottles broken', 'Other'].contains(_reason)) ...[
                    const SizedBox(height: AppConstants.spacing16),
                    TextField(
                      controller: _ctrlNotes,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Notes',
                        hintText: 'Enter details here...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ],
                
                const SizedBox(height: AppConstants.spacing32),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacing16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.cardRadius)),
                ),
                onPressed: _handleSave,
                child: const Text('Save Report', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
