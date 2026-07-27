import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../models/ledger_transaction.dart';

class LedgerState {
  final List<LedgerTransaction> transactions;
  final String? filterType;

  const LedgerState({
    required this.transactions,
    this.filterType,
  });

  List<LedgerTransaction> get filteredTransactions {
    if (filterType == null || filterType == 'all') return transactions;
    
    final targetType = filterType == 'fully_paid' ? 'PETROL_ALLOWANCE' :
                       filterType == 'short_paid' ? 'SHORTAGE' :
                       filterType == 'extra_paid' ? 'EXTRA_PAID' : filterType;
                       
    return transactions.where((t) => t.type == targetType).toList();
  }

  LedgerState copyWith({
    List<LedgerTransaction>? transactions,
    String? Function()? filterType,
  }) {
    return LedgerState(
      transactions: transactions ?? this.transactions,
      filterType: filterType != null ? filterType() : this.filterType,
    );
  }
}

class LedgerNotifier extends AsyncNotifier<LedgerState> {
  @override
  Future<LedgerState> build() async {
    try {
      return await _fetchLedger();
    } catch (e, st) {
      return Future.error(e, st);
    }
  }

  Future<LedgerState> _fetchLedger() async {
    final response = await ref.read(apiClientProvider).get('/ledger');
    final List<dynamic> data = response.data;
    final transactions = data.map((json) => LedgerTransaction.fromJson(json)).toList();
    
    // Preserve the filter if we are reloading
    final currentFilter = state.value?.filterType;
    return LedgerState(transactions: transactions, filterType: currentFilter);
  }

  void setFilter(String? type) {
    if (state.value != null) {
      state = AsyncData(state.value!.copyWith(filterType: () => type));
    }
  }

  Future<void> addTransaction({
    String? dpId,
    required String type,
    required double amount,
    String? note,
    required String date,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(apiClientProvider).post('/ledger', data: {
        'dpId': dpId,
        'type': type.toUpperCase(),
        'amount': amount,
        'note': note,
        'date': date,
      });
      return _fetchLedger();
    });
  }
}

final ledgerProvider = AsyncNotifierProvider<LedgerNotifier, LedgerState>(() {
  return LedgerNotifier();
});
