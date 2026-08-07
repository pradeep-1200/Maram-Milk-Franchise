import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/shop_sale_provider.dart';

class ShopSaleHistoryWidget extends ConsumerWidget {
  const ShopSaleHistoryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(shopSaleProvider);
    final theme = Theme.of(context);

    if (state.isLoading && state.salesHistory.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.salesHistory.isEmpty) {
      return Center(
        child: Text(
          'No sales history for today',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.salesHistory.length,
      itemBuilder: (context, index) {
        final sale = state.salesHistory[index];
        final qty1L = sale['qty1LBottle'] as int? ?? 0;
        final qtyHalfL = sale['qtyHalfLBottle'] as int? ?? 0;
        final qtyPacket = sale['qtyHalfLPacket'] as int? ?? 0;
        
        final createdAt = DateTime.parse(sale['createdAt']).toLocal();
        final timeStr = DateFormat('h:mm a').format(createdAt);

        List<String> items = [];
        if (qty1L > 0) items.add('$qty1L × 1L Bottle');
        if (qtyHalfL > 0) items.add('$qtyHalfL × 500ml Bottle');
        if (qtyPacket > 0) items.add('$qtyPacket × 500ml Packet');

        return Card(
          elevation: 0,
          color: theme.colorScheme.surfaceContainerHighest.withAlpha(50),
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(Icons.storefront, color: theme.colorScheme.onPrimaryContainer, size: 20),
            ),
            title: Text(items.join(', '), style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: Text(timeStr, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
          ),
        );
      },
    );
  }
}
