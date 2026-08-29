import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/date_util.dart';
import '../../core/constants/app_constants.dart';
import 'providers/shop_sale_provider.dart';
import 'widgets/shop_sale_history_widget.dart';

class ShopSaleHistoryScreen extends ConsumerStatefulWidget {
  const ShopSaleHistoryScreen({super.key});

  @override
  ConsumerState<ShopSaleHistoryScreen> createState() => _ShopSaleHistoryScreenState();
}

class _ShopSaleHistoryScreenState extends ConsumerState<ShopSaleHistoryScreen> {
  Future<DateTimeRange?> _selectCustomDateRange(ShopSaleState state) async {
    final now = DateUtil.operatingDay;
    return await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
      initialDateRange: state.customDateRange ?? DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now),
    );
  }

  Future<DateTimeRange?> _selectCustomDate(ShopSaleState state) async {
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
    final saleState = ref.watch(shopSaleProvider);
    final saleNotifier = ref.read(shopSaleProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sale History'),
        actions: [
          _DateFilterDropdown(
            state: saleState,
            onPeriodChanged: (period) async {
              if (period == 'custom_date') {
                final picked = await _selectCustomDate(saleState);
                if (picked != null) {
                  saleNotifier.setCustomDateRange(picked);
                }
              } else if (period == 'custom_range') {
                final picked = await _selectCustomDateRange(saleState);
                if (picked != null) {
                  saleNotifier.setCustomDateRange(picked);
                }
              } else {
                saleNotifier.setPeriod(period);
              }
            },
          ),
          const SizedBox(width: AppConstants.spacing16),
        ],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(AppConstants.spacing16),
        child: ShopSaleHistoryWidget(),
      ),
    );
  }
}

class _DateFilterDropdown extends StatelessWidget {
  final ShopSaleState state;
  final Function(String) onPeriodChanged;

  const _DateFilterDropdown({
    required this.state,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Determine the current dropdown value based on state
    String currentValue = 'today';
    if (state.period == 'yesterday') currentValue = 'yesterday';
    if (state.period == 'week') currentValue = 'week';
    if (state.period == 'month') currentValue = 'month';
    if (state.period == 'custom') {
      if (state.customDateRange != null && state.customDateRange!.start == state.customDateRange!.end) {
        currentValue = 'custom_date';
      } else {
        currentValue = 'custom_range';
      }
    }

    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(100),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outlineVariant.withAlpha(100)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentValue,
          icon: const Icon(Icons.arrow_drop_down, size: 20),
          isDense: true,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
          items: const [
            DropdownMenuItem(value: 'today', child: Text('Today')),
            DropdownMenuItem(value: 'yesterday', child: Text('Yesterday')),
            DropdownMenuItem(value: 'week', child: Text('This week')),
            DropdownMenuItem(value: 'month', child: Text('This month')),
            DropdownMenuItem(value: 'custom_date', child: Text('Custom date')),
            DropdownMenuItem(value: 'custom_range', child: Text('Custom range')),
          ],
          onChanged: (val) {
            if (val != null) {
              onPeriodChanged(val);
            }
          },
        ),
      ),
    );
  }
}
