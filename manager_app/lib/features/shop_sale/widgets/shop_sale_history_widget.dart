import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../shared/app_card.dart';
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

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: AppCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withAlpha(30),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(Icons.storefront, color: theme.colorScheme.primary, size: 16),
                          ),
                          const SizedBox(width: 8),
                          const Flexible(
                            child: Text(
                              'Sale recorded', 
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(timeStr, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (qty1L > 0)
                      _ProductPill(
                        text: '${qty1L}x 1L Bottle',
                        bgColor: Colors.green.withAlpha(30),
                        textColor: Colors.green.shade800,
                      ),
                    if (qtyHalfL > 0)
                      _ProductPill(
                        text: '${qtyHalfL}x 500ml Bottle',
                        bgColor: Colors.blue.withAlpha(30),
                        textColor: Colors.blue.shade800,
                      ),
                    if (qtyPacket > 0)
                      _ProductPill(
                        text: '${qtyPacket}x 500ml Packet',
                        bgColor: Colors.orange.withAlpha(30),
                        textColor: Colors.orange.shade800,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
  }
}

class _ProductPill extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color textColor;

  const _ProductPill({required this.text, required this.bgColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
