import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/network/api_client.dart';
import '../../inventory/providers/inventory_provider.dart';

class ShopSaleState {
  final List<dynamic> salesHistory;
  final Map<String, int> currentQuantities;
  final String? period;
  final DateTimeRange? customDateRange;
  final bool isLoading;
  final String? error;

  ShopSaleState({
    this.salesHistory = const [],
    this.currentQuantities = const {},
    this.period,
    this.customDateRange,
    this.isLoading = false,
    this.error,
  });

  ShopSaleState copyWith({
    List<dynamic>? salesHistory,
    Map<String, int>? currentQuantities,
    String? Function()? period,
    DateTimeRange? Function()? customDateRange,
    bool? isLoading,
    String? error,
  }) {
    return ShopSaleState(
      salesHistory: salesHistory ?? this.salesHistory,
      currentQuantities: currentQuantities ?? this.currentQuantities,
      period: period != null ? period() : this.period,
      customDateRange: customDateRange != null ? customDateRange() : this.customDateRange,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool get isDirty => currentQuantities.values.any((q) => q > 0);
}

class ShopSaleNotifier extends Notifier<ShopSaleState> {
  @override
  ShopSaleState build() {
    Future.microtask(() => loadHistory(period: 'today'));
    return ShopSaleState(period: 'today');
  }

  String _getToday() => DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future<void> loadHistory({String? period, DateTimeRange? customDateRange}) async {
    final activePeriod = period ?? state.period ?? 'today';
    final activeRange = customDateRange ?? state.customDateRange;
    
    state = state.copyWith(
      isLoading: true, 
      error: null,
      period: () => activePeriod,
      customDateRange: () => activeRange,
    );
    
    try {
      final dio = ref.read(apiClientProvider);
      
      Map<String, dynamic> queryParams = {};
      if (activePeriod != 'custom') {
        queryParams['range'] = activePeriod;
      } else if (activeRange != null) {
        queryParams['range'] = 'custom';
        queryParams['from'] = DateFormat('yyyy-MM-dd').format(activeRange.start);
        queryParams['to'] = DateFormat('yyyy-MM-dd').format(activeRange.end);
      } else {
        queryParams['date'] = _getToday();
      }

      final response = await dio.get('/shop-sale', queryParameters: queryParams);
      state = state.copyWith(salesHistory: response.data as List, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> setPeriod(String period) async {
    await loadHistory(period: period, customDateRange: null);
  }

  Future<void> setCustomDateRange(DateTimeRange range) async {
    await loadHistory(period: 'custom', customDateRange: range);
  }

  void updateQuantity(String unit, int qty) {
    final newQuantities = Map<String, int>.from(state.currentQuantities);
    newQuantities[unit] = qty;
    state = state.copyWith(currentQuantities: newQuantities);
  }

  Future<void> submitSale() async {
    final qty1L = state.currentQuantities['1L'] ?? 0;
    final qtyHalfL = state.currentQuantities['500ml'] ?? 0;
    final qtyHalfLPacket = state.currentQuantities['500ml_Packet'] ?? 0;

    if (qty1L == 0 && qtyHalfL == 0 && qtyHalfLPacket == 0) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final dio = ref.read(apiClientProvider);
      await dio.post(
        '/shop-sale',
        data: {
          'date': _getToday(),
          'qty1LBottle': qty1L,
          'qtyHalfLBottle': qtyHalfL,
          'qtyHalfLPacket': qtyHalfLPacket,
        },
      );
      
      // Reset quantities
      state = state.copyWith(
        isLoading: false, 
        currentQuantities: {},
      );
      
      // Reload history and global inventory so the stock check updates
      loadHistory();
      ref.read(inventoryProvider.notifier).reload();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }
}

final shopSaleProvider = NotifierProvider<ShopSaleNotifier, ShopSaleState>(() {
  return ShopSaleNotifier();
});
