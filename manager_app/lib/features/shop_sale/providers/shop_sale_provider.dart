import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/network/api_client.dart';
import '../../inventory/providers/inventory_provider.dart';

class ShopSaleState {
  final List<dynamic> salesHistory;
  final Map<String, int> currentQuantities;
  final bool isLoading;
  final String? error;

  ShopSaleState({
    this.salesHistory = const [],
    this.currentQuantities = const {},
    this.isLoading = false,
    this.error,
  });

  ShopSaleState copyWith({
    List<dynamic>? salesHistory,
    Map<String, int>? currentQuantities,
    bool? isLoading,
    String? error,
  }) {
    return ShopSaleState(
      salesHistory: salesHistory ?? this.salesHistory,
      currentQuantities: currentQuantities ?? this.currentQuantities,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool get isDirty => currentQuantities.values.any((q) => q > 0);
}

class ShopSaleNotifier extends Notifier<ShopSaleState> {
  @override
  ShopSaleState build() {
    Future.microtask(() => loadHistory());
    return ShopSaleState();
  }

  String _getToday() => DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future<void> loadHistory() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final dio = ref.read(apiClientProvider);
      final response = await dio.get('/shop-sale', queryParameters: {'date': _getToday()});
      state = state.copyWith(salesHistory: response.data as List, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
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
