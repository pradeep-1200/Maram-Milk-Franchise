import 'package:manager_app/core/utils/date_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_constants.dart';
import '../../shared/app_card.dart';
import '../../shared/app_text_field.dart';
import '../../shared/async_value_widget.dart';
import 'providers/ledger_provider.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  Future<DateTimeRange?> _selectCustomDateRange(LedgerState state) async {
    final now = DateUtil.operatingDay;
    return await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
      initialDateRange: state.customDateRange ?? DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now),
    );
  }

  Future<DateTimeRange?> _selectCustomDate(LedgerState state) async {
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
    final asyncState = ref.watch(ledgerProvider);
    final notifier = ref.read(ledgerProvider.notifier);
    final theme = Theme.of(context);

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
        title: const Text('Petrol Ledger', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: AppAsyncWidget<LedgerState>(
        value: asyncState,
        data: (state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Filters Section
              Container(
                color: theme.colorScheme.surface,
                padding: const EdgeInsets.symmetric(vertical: AppConstants.spacing8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Date Filters
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing16),
                      child: Row(
                        children: [
                          _FilterChip(
                            label: 'All Time',
                            isSelected: state.period == null || state.period == 'all',
                            onSelected: () => notifier.setPeriod('all'),
                          ),
                          const SizedBox(width: AppConstants.spacing8),
                          _FilterChip(
                            label: 'Today',
                            isSelected: state.period == 'today',
                            onSelected: () => notifier.setPeriod('today'),
                          ),
                          const SizedBox(width: AppConstants.spacing8),
                          _FilterChip(
                            label: 'Yesterday',
                            isSelected: state.period == 'yesterday',
                            onSelected: () => notifier.setPeriod('yesterday'),
                          ),
                          const SizedBox(width: AppConstants.spacing8),
                          _FilterChip(
                            label: 'This Week',
                            isSelected: state.period == 'week',
                            onSelected: () => notifier.setPeriod('week'),
                          ),
                          const SizedBox(width: AppConstants.spacing8),
                          _FilterChip(
                            label: 'This Month',
                            isSelected: state.period == 'month',
                            onSelected: () => notifier.setPeriod('month'),
                          ),
                          const SizedBox(width: AppConstants.spacing8),
                          _FilterChip(
                            label: 'Custom Date',
                            isSelected: state.period == 'custom' && state.customDateRange != null && state.customDateRange!.start == state.customDateRange!.end,
                            onSelected: () async {
                              final picked = await _selectCustomDate(state);
                              if (picked != null) {
                                notifier.setCustomDateRange(picked);
                              }
                            },
                          ),
                          const SizedBox(width: AppConstants.spacing8),
                          _FilterChip(
                            label: 'Custom Range',
                            isSelected: state.period == 'custom' && (state.customDateRange == null || state.customDateRange!.start != state.customDateRange!.end),
                            onSelected: () async {
                              final picked = await _selectCustomDateRange(state);
                              if (picked != null) {
                                notifier.setCustomDateRange(picked);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    if (state.period == 'custom' && state.customDateRange != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                        child: Text(
                          '${DateFormat('MMM d, yyyy').format(state.customDateRange!.start)} - ${DateFormat('MMM d, yyyy').format(state.customDateRange!.end)}',
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    const SizedBox(height: AppConstants.spacing8),
                    // Filter Control and Search
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing16),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 140,
                            child: DropdownButtonFormField<String>(
                              value: state.filterType ?? 'all',
                              isExpanded: true,
                              decoration: const InputDecoration(
                                labelText: 'Filter By',
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'all', child: Text('All', overflow: TextOverflow.ellipsis)),
                                DropdownMenuItem(value: 'fully_paid', child: Text('Fully Paid', overflow: TextOverflow.ellipsis)),
                                DropdownMenuItem(value: 'short_paid', child: Text('Short Paid', overflow: TextOverflow.ellipsis)),
                                DropdownMenuItem(value: 'extra_paid', child: Text('Extra Paid', overflow: TextOverflow.ellipsis)),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  notifier.setFilter(val);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: AppTextField(
                              controller: _searchController,
                              hintText: 'Search Name/ID',
                              prefixIcon: const Icon(Icons.search),
                              onChanged: (val) {
                                notifier.setSearchQuery(val);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(ledgerProvider);
                    try {
                      await ref.read(ledgerProvider.future);
                    } catch (_) {}
                  },
                  child: state.filteredTransactions.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                            Icon(Icons.receipt_long, size: 48, color: theme.colorScheme.onSurfaceVariant.withAlpha(100)),
                            const SizedBox(height: AppConstants.spacing16),
                            Text(
                              'No transactions found',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(AppConstants.spacing16),
                          itemCount: state.filteredTransactions.length,
                          separatorBuilder: (context, index) => const SizedBox(height: AppConstants.spacing12),
                          itemBuilder: (context, index) {
                            final tx = state.filteredTransactions[index];
                            final isPositive = tx.type == 'PETROL_ALLOWANCE' || tx.type == 'EXTRA_PAID';
                            final isShortage = tx.type == 'SHORTAGE';
                            
                            Color statusColor;
                            if (isShortage) {
                              statusColor = Colors.orange;
                            } else if (tx.type == 'EXTRA_PAID') {
                              statusColor = Colors.blue;
                            } else {
                              statusColor = Colors.green;
                            }
                            
                            return AppCard(
                              child: Padding(
                                padding: const EdgeInsets.all(AppConstants.spacing16),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: statusColor.withAlpha(30),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        isPositive ? Icons.add_circle : Icons.remove_circle,
                                        color: statusColor,
                                      ),
                                    ),
                                    const SizedBox(width: AppConstants.spacing16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  tx.dp?.name ?? 'Unknown DP',
                                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Text(
                                                DateFormat('MMM d, yyyy').format(DateTime.parse(tx.date)),
                                                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: statusColor,
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  isShortage ? 'Short Paid' : (tx.type == 'EXTRA_PAID' ? 'Extra Paid' : 'Fully Paid'),
                                                  style: theme.textTheme.labelSmall?.copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              if (tx.route != null) ...[
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    tx.route!['name'],
                                                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ]
                                            ],
                                          ),
                                          if (tx.note != null && tx.note!.isNotEmpty) ...[
                                            const SizedBox(height: 8),
                                            Text(
                                              tx.note!,
                                              style: theme.textTheme.bodyMedium,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: AppConstants.spacing16),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                          Text(
                                            '₹${tx.amount.toStringAsFixed(0)}',
                                            style: theme.textTheme.titleMedium?.copyWith(
                                              color: statusColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (tx.note == null || tx.note!.isEmpty)
                                            Text(
                                              'of ₹${tx.defaultAllowance.toStringAsFixed(0)}',
                                              style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                                            ),
                                        ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
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
    
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
