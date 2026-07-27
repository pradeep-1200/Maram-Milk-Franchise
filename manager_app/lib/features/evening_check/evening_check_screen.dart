import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/app_button.dart';
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
    final nowStr = DateFormat('MMM dd, yyyy').format(DateTime.now());

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
          final unassignedCount = allRoutes.where((r) => r.status == 'Unassigned').length;
          final deliveredCount = allRoutes.where((r) => r.deliveryCompleted == true).length;
          final notDeliveredCount = allRoutes.where((r) => r.status == 'Delivered' && r.deliveryCompleted == false).length;

          final filteredRoutes = allRoutes.where((route) {
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
                          return _DpRouteCard(
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

class _DpRouteCard extends StatelessWidget {
  final EmptyBottleStatus route;
  final VoidCallback onTap;

  const _DpRouteCard({
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
                    route.dpName ?? 'Unassigned',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isUnassigned ? Colors.grey : null,
                    ),
                  ),
                  if (route.dpId != null)
                    Text(
                      'ID: ${route.dpId}',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    route.routeName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isUnassigned ? Colors.grey : theme.colorScheme.primary,
                    ),
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

  @override
  void initState() {
    super.initState();
    if (widget.route.status == 'Delivered') {
      _didCompleteDelivery = widget.route.deliveryCompleted;
    }
    _bottles1L = widget.route.oneLBottlesCollected;
    _bottlesHalfL = widget.route.halfLBottlesCollected;
    _flagNoReturn = widget.route.flagIssue;
  }

  void _handleSave() {
    if (_didCompleteDelivery == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select Yes or No')),
      );
      return;
    }

    ref.read(eveningCheckProvider.notifier).updateStatus(
      widget.route.routeId,
      deliveryCompleted: _didCompleteDelivery!,
      oneLBottlesCollected: _bottles1L,
      halfLBottlesCollected: _bottlesHalfL,
      halfLPacketCollected: widget.route.halfLPacketCollected,
      actualDelivered1L: widget.route.actualDelivered1L,
      actualDeliveredHalfL: widget.route.actualDeliveredHalfL,
      actualDeliveredPacket: widget.route.actualDeliveredPacket,
      flagIssue: _flagNoReturn,
    );

    context.pop();
  }

  Widget _buildCounter(
    String label,
    int value,
    ValueChanged<int> onChanged,
    ThemeData theme,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: value > 0 ? () => onChanged(value - 1) : null,
              icon: const Icon(Icons.remove_circle_outline),
              color: theme.colorScheme.primary,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value.toString(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: () => onChanged(value + 1),
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
                      ),
                      Text(
                        'Route: ${widget.route.routeName}',
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
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
                  
                  Text(
                    'Empty Bottles Returned',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppConstants.spacing16),

                  _buildCounter(
                    '1L Bottles',
                    _bottles1L,
                    (v) => setState(() => _bottles1L = v),
                    theme,
                  ),
                  const SizedBox(height: AppConstants.spacing16),
                  _buildCounter(
                    '500ml Bottles',
                    _bottlesHalfL,
                    (v) => setState(() => _bottlesHalfL = v),
                    theme,
                  ),

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
                ],
                
                const SizedBox(height: AppConstants.spacing32),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacing16),
            child: SizedBox(
              width: double.infinity,
              child: AppButton(
                text: 'Save Report',
                onPressed: _handleSave,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
