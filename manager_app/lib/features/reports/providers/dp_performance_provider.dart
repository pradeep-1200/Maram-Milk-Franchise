import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/network/api_client.dart';
import '../models/dp_performance_report.dart';

enum DpSortOption {
  litres,
  routes,
  attendance,
  bottles
}

class DpPerformanceState {
  final List<DpPerformanceReport> reports;
  final String period; // 'today', 'week', 'month', 'custom'
  final DateTimeRange? customDateRange;
  final DpSortOption sortOption;
  final String searchQuery;

  DpPerformanceState({
    required this.reports,
    this.period = 'month',
    this.customDateRange,
    this.sortOption = DpSortOption.litres,
    this.searchQuery = '',
  });

  List<DpPerformanceReport> get filteredReports {
    if (searchQuery.isEmpty) return reports;
    return reports.where((r) => r.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();
  }

  DpPerformanceState copyWith({
    List<DpPerformanceReport>? reports,
    String? period,
    DateTimeRange? customDateRange,
    DpSortOption? sortOption,
    String? searchQuery,
  }) {
    return DpPerformanceState(
      reports: reports ?? this.reports,
      period: period ?? this.period,
      customDateRange: customDateRange ?? this.customDateRange,
      sortOption: sortOption ?? this.sortOption,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class DpPerformanceNotifier extends AsyncNotifier<DpPerformanceState> {
  @override
  Future<DpPerformanceState> build() async {
    try {
      return await _fetchPerformance(
        period: 'month',
        sortOption: DpSortOption.litres,
      );
    } catch (e, st) {
      return Future.error(e, st);
    }
  }

  Future<DpPerformanceState> _fetchPerformance({
    required String period,
    DateTimeRange? customDateRange,
    required DpSortOption sortOption,
    String searchQuery = '',
  }) async {
    String url = '/reports/dp-performance?range=$period&sortBy=${sortOption.name}';
    
    if (period == 'custom' && customDateRange != null) {
      final from = DateFormat('yyyy-MM-dd').format(customDateRange.start);
      final to = DateFormat('yyyy-MM-dd').format(customDateRange.end);
      url += '&from=$from&to=$to';
    }

    final response = await ref.read(apiClientProvider).get(url);
    final List<dynamic> data = response.data;
    final reports = data.map((json) => DpPerformanceReport.fromJson(json)).toList();
    
    return DpPerformanceState(
      reports: reports,
      period: period,
      customDateRange: customDateRange,
      sortOption: sortOption,
      searchQuery: searchQuery,
    );
  }

  Future<void> setPeriod(String period) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final current = state.value;
      return _fetchPerformance(
        period: period,
        customDateRange: null,
        sortOption: current?.sortOption ?? DpSortOption.litres,
        searchQuery: current?.searchQuery ?? '',
      );
    });
  }

  Future<void> setCustomDateRange(DateTimeRange range) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final current = state.value;
      return _fetchPerformance(
        period: 'custom',
        customDateRange: range,
        sortOption: current?.sortOption ?? DpSortOption.litres,
        searchQuery: current?.searchQuery ?? '',
      );
    });
  }

  Future<void> setSortOption(DpSortOption option) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final current = state.value;
      return _fetchPerformance(
        period: current?.period ?? 'month',
        customDateRange: current?.customDateRange,
        sortOption: option,
        searchQuery: current?.searchQuery ?? '',
      );
    });
  }

  void setSearchQuery(String query) {
    if (state.value != null) {
      state = AsyncData(state.value!.copyWith(searchQuery: query));
    }
  }
}

final dpPerformanceProvider = AsyncNotifierProvider<DpPerformanceNotifier, DpPerformanceState>(() {
  return DpPerformanceNotifier();
});
