import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../shared/app_card.dart';
import '../evening_check/providers/evening_check_provider.dart';
import 'empty_bottle_sheet.dart';

class EmptyBottleListScreen extends ConsumerWidget {
  const EmptyBottleListScreen({super.key});

  void _showEmptyBottleSheet(BuildContext context, String routeId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.cardRadius)),
      ),
      builder: (context) => EmptyBottleSheet(routeId: routeId),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final statuses = ref.watch(eveningCheckProvider).value?.statuses ?? [];
    final assignedRoutes = statuses.where((r) => r.dpId != null).toList();

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

        title: const Text('Empty Bottle Management'),
      ),
      body: SafeArea(
        child: assignedRoutes.isEmpty
            ? Center(
                child: Text(
                  'No assigned routes yet.',
                  style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(AppConstants.spacing16),
                itemCount: assignedRoutes.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12.0),
                itemBuilder: (context, index) {
                  final status = assignedRoutes[index];
                  final isLogged = status.deliveryCompleted == true;
                  final isIncomplete = status.deliveryCompleted == false && status.status == 'Delivered';

                  return AppCard(
                    onTap: () => _showEmptyBottleSheet(context, status.routeId),
                    padding: const EdgeInsets.all(AppConstants.spacing16),
                    accentColor: isLogged ? Colors.green : Colors.orange,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.local_drink, color: theme.colorScheme.primary),
                        ),
                        const SizedBox(width: AppConstants.spacing16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(status.routeName, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Text('DP: ${status.dpName}', style: theme.textTheme.bodyMedium, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        if (isLogged) ...[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.check_circle, color: Colors.green, size: 16),
                                  const SizedBox(width: 4),
                                  Text('Logged', style: theme.textTheme.bodySmall?.copyWith(color: Colors.green, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              if (status.flagIssue) ...[
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.warning, color: Colors.orange, size: 14),
                                    const SizedBox(width: 4),
                                    Text('Flagged', style: theme.textTheme.bodySmall?.copyWith(color: Colors.orange, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 4),
                                  Builder(
                                builder: (context) {
                                  final totalCollected = status.items.fold(0, (sum, item) => sum + item.collected);
                                  final totalExpected = status.items.fold(0, (sum, item) => sum + item.expected);

                                  String tagText;
                                  Color tagColor;

                                  if (totalCollected > totalExpected) {
                                    tagText = 'Extra: ${totalCollected - totalExpected}';
                                    tagColor = Colors.teal;
                                  } else if (totalCollected == totalExpected && totalExpected > 0) {
                                    tagText = 'Fully Collected';
                                    tagColor = Colors.green;
                                  } else if (totalCollected > 0 && totalCollected < totalExpected) {
                                    tagText = 'Shortage: ${totalExpected - totalCollected}';
                                    tagColor = Colors.orange;
                                  } else if (totalExpected > 0) {
                                    tagText = 'Shortage: $totalExpected';
                                    tagColor = Colors.red;
                                  } else {
                                    tagText = 'No Expected Returns';
                                    tagColor = Colors.grey;
                                  }

                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: tagColor.withAlpha(20),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: tagColor.withAlpha(50)),
                                    ),
                                    child: Text(
                                      tagText,
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: tagColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        ] else if (isIncomplete) ...[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.cancel, color: Colors.red, size: 16),
                                  const SizedBox(width: 4),
                                  Text('Incomplete', style: theme.textTheme.bodySmall?.copyWith(color: Colors.red, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          )
                        ] else
                          Text('Pending', style: theme.textTheme.bodySmall?.copyWith(color: Colors.orange, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
