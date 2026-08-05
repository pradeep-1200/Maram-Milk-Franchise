import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../models/ledger_transaction.dart';

class LedgerState {
  final List<LedgerTransaction> transactions;
  final String? filterType;
  final String? period;
  final DateTimeRange? customDateRange;
  final String searchQuery;

  const LedgerState({
    required this.transactions,
    this.filterType,
    this.period,
    this.customDateRange,
    this.searchQuery = '',
  });

  // Filter client-side by search query
  List<LedgerTransaction> get filteredTransactions {
    if (searchQuery.isEmpty) return transactions;
    final query = searchQuery.toLowerCase();
    return transactions.where((t) {
      final nameMatches = t.dp?.name.toLowerCase().contains(query) ?? false;
      final codeMatches = t.dp?.employeeId.toLowerCase().contains(query) ?? false;
      return nameMatches || codeMatches;
    }).toList();
  }

  LedgerState copyWith({
    List<LedgerTransaction>? transactions,
    String? Function()? filterType,
    String? Function()? period,
    DateTimeRange? Function()? customDateRange,
    String? searchQuery,
  }) {
    return LedgerState(
      transactions: transactions ?? this.transactions,
      filterType: filterType != null ? filterType() : this.filterType,
      period: period != null ? period() : this.period,
      customDateRange: customDateRange != null ? customDateRange() : this.customDateRange,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class LedgerNotifier extends AsyncNotifier<LedgerState> {
  @override
  Future<LedgerState> build() async {
    try {
      return await _fetchLedger(filterType: 'all', period: 'all');
    } catch (e, st) {
      return Future.error(e, st);
    }
  }

  Future<LedgerState> _fetchLedger({
    String? filterType,
    String? period,
    DateTimeRange? customDateRange,
  }) async {
    String url = '/ledger?';
    if (filterType != null && filterType != 'all') {
      url += 'type=$filterType&';
    }
    if (period != null && period != 'all') {
      if (period != 'custom') {
        url += 'range=$period&';
      } else if (customDateRange != null) {
        url += 'range=custom&';
        final from = DateFormat('yyyy-MM-dd').format(customDateRange.start);
        final to = DateFormat('yyyy-MM-dd').format(customDateRange.end);
        url += 'from=$from&to=$to&';
      }
    }

    final response = await ref.read(apiClientProvider).get(url);
    final List<dynamic> data = response.data;
    final transactions = data.map((json) => LedgerTransaction.fromJson(json)).toList();
    
    return LedgerState(
      transactions: transactions,
      filterType: filterType,
      period: period,
      customDateRange: customDateRange,
    );
  }

  Future<void> setFilter(String? type) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final current = state.value;
      final newState = await _fetchLedger(
        filterType: type,
        period: current?.period,
        customDateRange: current?.customDateRange,
      );
      return newState.copyWith(searchQuery: current?.searchQuery);
    });
  }

  void setSearchQuery(String query) {
    final current = state.value;
    if (current != null) {
      state = AsyncData(current.copyWith(searchQuery: query));
    }
  }

  Future<void> setPeriod(String period) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final current = state.value;
      final newState = await _fetchLedger(
        filterType: current?.filterType,
        period: period,
        customDateRange: null,
      );
      return newState.copyWith(searchQuery: current?.searchQuery);
    });
  }

  Future<void> setCustomDateRange(DateTimeRange range) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final current = state.value;
      final newState = await _fetchLedger(
        filterType: current?.filterType,
        period: 'custom',
        customDateRange: range,
      );
      return newState.copyWith(searchQuery: current?.searchQuery);
    });
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
      final current = state.value;
      final newState = await _fetchLedger(
        filterType: current?.filterType,
        period: current?.period,
        customDateRange: current?.customDateRange,
      );
      return newState.copyWith(searchQuery: current?.searchQuery);
    });
  }
}

final ledgerProvider = AsyncNotifierProvider<LedgerNotifier, LedgerState>(() {
  return LedgerNotifier();
});
