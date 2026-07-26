import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../shared/app_card.dart';
import '../../shared/async_value_widget.dart';
import 'providers/ledger_provider.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              // Filters
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacing16,
                  vertical: AppConstants.spacing8,
                ),
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      isSelected: state.filterType == null || state.filterType == 'all',
                      onSelected: () => notifier.setFilter('all'),
                    ),
                    const SizedBox(width: AppConstants.spacing8),
                    _FilterChip(
                      label: 'Fully Paid',
                      isSelected: state.filterType == 'fully_paid',
                      onSelected: () => notifier.setFilter('fully_paid'),
                    ),
                    const SizedBox(width: AppConstants.spacing8),
                    _FilterChip(
                      label: 'Short Paid',
                      isSelected: state.filterType == 'short_paid',
                      onSelected: () => notifier.setFilter('short_paid'),
                    ),
                    const SizedBox(width: AppConstants.spacing8),
                    _FilterChip(
                      label: 'Extra Paid',
                      isSelected: state.filterType == 'extra_paid',
                      onSelected: () => notifier.setFilter('extra_paid'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: state.filteredTransactions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.receipt_long, size: 48, color: theme.colorScheme.onSurfaceVariant.withAlpha(100)),
                            const SizedBox(height: AppConstants.spacing16),
                            Text(
                              'No transactions found',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(
                          left: AppConstants.spacing16,
                          right: AppConstants.spacing16,
                          top: AppConstants.spacing8,
                          bottom: 100, // Padding for FAB in MainShell
                        ),
                        itemCount: state.filteredTransactions.length,
                        separatorBuilder: (_, __) => const SizedBox(height: AppConstants.spacing8),
                        itemBuilder: (context, index) {
                          final tx = state.filteredTransactions[index];
                          
                          // Parsing date format (Backend sends YYYY-MM-DD or full ISO date)
                          DateTime txDate;
                          try {
                            txDate = DateTime.parse(tx.date);
                          } catch (e) {
                            txDate = DateTime.now();
                          }

                          Color statusColor;
                          String statusText;
                          IconData statusIcon;

                          if (tx.status == 'fully_paid') {
                            statusColor = Colors.green;
                            statusText = 'Fully Paid';
                            statusIcon = Icons.check_circle;
                          } else if (tx.status == 'short_paid') {
                            statusColor = Colors.orange;
                            statusText = 'Short Paid';
                            statusIcon = Icons.warning;
                          } else {
                            statusColor = Colors.blue;
                            statusText = 'Extra Paid';
                            statusIcon = Icons.add_circle;
                          }

                          return AppCard(
                            padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing16, vertical: AppConstants.spacing12),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: statusColor.withAlpha(30),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    statusIcon,
                                    color: statusColor,
                                  ),
                                ),
                                const SizedBox(width: AppConstants.spacing16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tx.dp?.name ?? 'Unknown DP',
                                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Route: ${tx.route != null ? tx.route!['name'] : 'N/A'}',
                                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: statusColor,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              statusText,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '${txDate.day}/${txDate.month}/${txDate.year}',
                                            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: AppConstants.spacing16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '₹${tx.givenAllowance.toStringAsFixed(0)}',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'of ₹${tx.defaultAllowance.toStringAsFixed(0)}',
                                      style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: theme.colorScheme.primaryContainer,
      labelStyle: TextStyle(
        color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
