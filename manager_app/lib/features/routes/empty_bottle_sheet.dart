import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../evening_check/providers/evening_check_provider.dart';

class EmptyBottleSheet extends ConsumerWidget {
  final String routeId;

  const EmptyBottleSheet({super.key, required this.routeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final statuses = ref.watch(eveningCheckProvider).value?.statuses ?? [];
    
    // Find the route status
    final status = statuses.firstWhere(
      (r) => r.routeId == routeId,
      orElse: () => throw Exception('Route not found'),
    );
    
    // 1. The per-bottle-size Expected numbers (reused directly)
    final expected1L = status.expected1LBottles;
    final expectedHalfL = status.expectedHalfLBottles;

    // 2. The saved collected counts from EmptyBottleLog
    final collected1L = status.oneLBottlesCollected;
    final collectedHalfL = status.halfLBottlesCollected;

    // 3. Remaining = Expected - Collected
    final remaining1L = expected1L - collected1L;
    final remainingHalfL = expectedHalfL - collectedHalfL;

    return Padding(
      padding: const EdgeInsets.only(
        left: AppConstants.spacing16,
        right: AppConstants.spacing16,
        top: AppConstants.spacing24,
        bottom: AppConstants.spacing24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Empty Bottles Detail',
                style: theme.textTheme.titleLarge,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacing16),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withAlpha(100),
              borderRadius: BorderRadius.circular(AppConstants.cardRadius),
            ),
            child: Row(
              children: [
                Icon(Icons.map, color: theme.colorScheme.primary),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(status.routeName, style: theme.textTheme.titleMedium, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text('DP: ${status.dpName ?? "Unassigned"}', style: theme.textTheme.bodySmall, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                Text('Today', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacing24),
          
          Text('Return Summary', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppConstants.spacing16),
          
          _BottleSummaryCard(
            title: '1L Bottles',
            expected: expected1L,
            collected: collected1L,
            remaining: remaining1L,
          ),
          const SizedBox(height: AppConstants.spacing12),
          _BottleSummaryCard(
            title: 'Half L Bottles',
            expected: expectedHalfL,
            collected: collectedHalfL,
            remaining: remainingHalfL,
          ),
        ],
      ),
    );
  }
}

class _BottleSummaryCard extends StatelessWidget {
  final String title;
  final int expected;
  final int collected;
  final int remaining;

  const _BottleSummaryCard({
    required this.title,
    required this.expected,
    required this.collected,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasShortage = remaining > 0;
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatWidget(label: 'Expected', value: expected.toString()),
              _StatWidget(label: 'Collected', value: collected.toString()),
              _StatWidget(
                label: 'Remaining',
                value: remaining.toString(),
                valueColor: hasShortage ? Colors.orange[800] : Colors.green[800],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatWidget extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _StatWidget({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor ?? theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
