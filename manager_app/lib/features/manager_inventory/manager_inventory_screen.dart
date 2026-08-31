import 'dart:async';
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
import '../../../core/router/app_router.dart';

class ManagerInventoryScreen extends ConsumerStatefulWidget {
  const ManagerInventoryScreen({super.key});

  @override
  ConsumerState<ManagerInventoryScreen> createState() => _ManagerInventoryScreenState();
}

class _ManagerInventoryScreenState extends ConsumerState<ManagerInventoryScreen> with WidgetsBindingObserver, RouteAware {
  final Map<String, TextEditingController> _controllers = {};
  Timer? _timer;
  DateTime? _lastFetchTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    // Called when the top route is popped off, revealing this route.
    _reload(force: true);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 60), (_) {
      _reload();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _reload({bool force = false}) async {
    final now = DateTime.now();
    if (!force && _lastFetchTime != null && now.difference(_lastFetchTime!).inSeconds < 5) {
      return; // Debounce
    }
    _lastFetchTime = now;
    
    // Trigger reloads
    ref.read(inventoryProvider.notifier).reload();
    ref.read(managerInventoryProvider.notifier).reload();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startTimer();
      _reload();
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _stopTimer();
    }
  }

  @override
  void dispose() {
    _stopTimer();
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    try {
      ref.read(managerInventoryProvider.notifier).clearUnsavedEdits();
    } catch (_) {}
    
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
            if (!state.dirtyFields.contains(item.id)) {
              final val = (state.counts[item.id] ?? state.counts[item.name])?.toString() ?? '';
              if (_controllers[item.id]!.text != val) {
                _controllers[item.id]!.text = val;
              }
            }
          }

          return RefreshIndicator(
            onRefresh: () => _reload(force: true),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.spacing16),
              physics: const AlwaysScrollableScrollPhysics(),
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
                    if (state.loadingMessage != null)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 16, height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: theme.colorScheme.onPrimaryContainer),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                state.loadingMessage!,
                                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onPrimaryContainer),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (state.error != null && state.counts.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.colorScheme.error.withAlpha(128)),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.error_outline, color: theme.colorScheme.error, size: 48),
                            const SizedBox(height: 16),
                            Text(
                              'Failed to load inventory data.',
                              style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onErrorContainer),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.error!,
                              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onErrorContainer),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            FilledButton.icon(
                              onPressed: () => notifier.reload(),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Tap to Retry'),
                              style: FilledButton.styleFrom(
                                backgroundColor: theme.colorScheme.error,
                                foregroundColor: theme.colorScheme.onError,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                    (() {
                      final groupedItems = <String, List<dynamic>>{};
                      final sectionKeys = <String>[];
                      for (var item in items) {
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
                          final sectionItems = groupedItems[section]!;
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
                                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                  child: Column(
                                    children: sectionItems.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final item = entry.value;
                                      String subtitle = item.subtitle;

                                      IconData icon = Icons.local_drink;
                                      Color iconColor = Colors.green;
                                      Color bgColor = Colors.green.withAlpha(30);

                                      if (section == 'Milk') {
                                        if (subtitle.contains('Bottle') && subtitle.contains('500ml')) {
                                          iconColor = Colors.blue;
                                          bgColor = Colors.blue.withAlpha(30);
                                        } else if (subtitle.contains('Packet')) {
                                          icon = Icons.inventory_2;
                                          iconColor = Colors.orange;
                                          bgColor = Colors.orange.withAlpha(30);
                                        }
                                      } else if (section == 'Dairy') {
                                        icon = Icons.cookie;
                                        iconColor = Colors.brown;
                                        bgColor = Colors.brown.withAlpha(30);
                                      } else if (section == 'Oils') {
                                        icon = Icons.opacity;
                                        iconColor = Colors.amber;
                                        bgColor = Colors.amber.withAlpha(30);
                                      } else if (section == 'Sweeteners') {
                                        icon = Icons.spa;
                                        iconColor = Colors.purple;
                                        bgColor = Colors.purple.withAlpha(30);
                                      } else {
                                        icon = Icons.inventory_2;
                                        iconColor = Colors.grey;
                                        bgColor = Colors.grey.withAlpha(30);
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
                                                  '${item.name}${subtitle.isNotEmpty ? ' • $subtitle' : ''}',
                                                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              SizedBox(
                                                width: 70,
                                                child: TextFormField(
                                                  controller: _controllers[item.id],
                                                  keyboardType: TextInputType.number,
                                                  textAlign: TextAlign.center,
                                                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                                                  decoration: InputDecoration(
                                                    isDense: true,
                                                    contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
                    const SizedBox(height: AppConstants.spacing8),
                    if (state.error != null && state.counts.isNotEmpty)
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
          ));
        },
      ),
    );
  }
}
