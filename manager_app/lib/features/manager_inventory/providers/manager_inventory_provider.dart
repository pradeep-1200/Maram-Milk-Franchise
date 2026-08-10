import 'package:manager_app/core/utils/date_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/network/api_client.dart';

class ManagerInventoryState {
  final Map<String, int> counts;
  final bool isSaved;
  final bool isLoading;
  final String? error;

  const ManagerInventoryState({
    this.counts = const {},
    this.isSaved = false,
    this.isLoading = false,
    this.error,
  });

  ManagerInventoryState copyWith({
    Map<String, int>? counts,
    bool? isSaved,
    bool? isLoading,
    String? error,
  }) {
    return ManagerInventoryState(
      counts: counts ?? this.counts,
      isSaved: isSaved ?? this.isSaved,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ManagerInventoryNotifier extends Notifier<ManagerInventoryState> {
  @override
  ManagerInventoryState build() {
    // Return initial state synchronously.
    // In Riverpod, side effects in build should be deferred or handled in a separate method if they don't block initialization,
    // but typically we can just return the initial state and trigger load.
    Future.microtask(() => _loadTodayCounts());
    return const ManagerInventoryState();
  }

  String _getToday() => DateFormat('yyyy-MM-dd').format(DateUtil.operatingDay);

  Future<void> _loadTodayCounts() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final dio = ref.read(apiClientProvider);
      final response = await dio.get('/manager-inventory', queryParameters: {'date': _getToday()});
      
      final data = response.data as List;
      final Map<String, int> loadedCounts = {};
      for (var item in data) {
        loadedCounts[item['product']] = item['quantity'] as int;
      }
      
      state = state.copyWith(counts: loadedCounts, isLoading: false, isSaved: data.isNotEmpty);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void updateCount(String product, int count) {
    final newCounts = Map<String, int>.from(state.counts);
    newCounts[product] = count;
    state = state.copyWith(counts: newCounts, isSaved: false);
  }

  Future<void> submitCounts() async {
    if (state.counts.isEmpty) return;
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final dio = ref.read(apiClientProvider);
      
      final logs = state.counts.entries
          .map((e) => {'product': e.key, 'quantity': e.value})
          .toList();

      await dio.post(
        '/manager-inventory',
        data: {
          'date': _getToday(),
          'logs': logs,
        },
      );
      
      state = state.copyWith(isLoading: false, isSaved: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }
}

final managerInventoryProvider = NotifierProvider<ManagerInventoryNotifier, ManagerInventoryState>(() {
  return ManagerInventoryNotifier();
});
