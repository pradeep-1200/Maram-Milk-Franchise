import 'package:manager_app/core/utils/date_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/network/api_client.dart';

class ManagerInventoryState {
  final Map<String, int> counts;
  final Set<String> dirtyFields;
  final bool isSaved;
  final bool isLoading;
  final String? error;
  final String? loadingMessage;

  const ManagerInventoryState({
    this.counts = const {},
    this.dirtyFields = const {},
    this.isSaved = false,
    this.isLoading = false,
    this.error,
    this.loadingMessage,
  });

  ManagerInventoryState copyWith({
    Map<String, int>? counts,
    Set<String>? dirtyFields,
    bool? isSaved,
    bool? isLoading,
    String? error,
    String? loadingMessage,
  }) {
    return ManagerInventoryState(
      counts: counts ?? this.counts,
      dirtyFields: dirtyFields ?? this.dirtyFields,
      isSaved: isSaved ?? this.isSaved,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      loadingMessage: loadingMessage,
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

  Future<void> reload() async {
    await _loadTodayCounts();
  }

  void clearUnsavedEdits() {
    state = state.copyWith(dirtyFields: const {});
    _loadTodayCounts();
  }

  Future<void> _loadTodayCounts() async {
    int attempts = 0;
    while (attempts < 3) {
      attempts++;
      state = state.copyWith(
        isLoading: true, 
        error: null,
        loadingMessage: attempts > 1 ? 'Retrying (Attempt $attempts of 3)...' : null,
      );
      try {
        final dio = ref.read(apiClientProvider);
        final response = await dio.get('/manager-inventory', queryParameters: {'date': _getToday()});
        
        final data = response.data as List;
        final Map<String, int> loadedCounts = {};
        for (var item in data) {
          loadedCounts[item['product']] = item['quantity'] as int;
        }

        // Preserve any locally dirty fields over the loaded data
        for (final dirtyProduct in state.dirtyFields) {
          if (state.counts.containsKey(dirtyProduct)) {
            loadedCounts[dirtyProduct] = state.counts[dirtyProduct]!;
          }
        }
        
        state = state.copyWith(
          counts: loadedCounts, 
          isLoading: false, 
          isSaved: state.dirtyFields.isEmpty && data.isNotEmpty,
          loadingMessage: null,
        );
        return; // Success
      } catch (e) {
        if (attempts >= 3) {
          state = state.copyWith(isLoading: false, error: e.toString(), loadingMessage: null);
        } else {
          // Wait before retrying
          await Future.delayed(const Duration(seconds: 2));
        }
      }
    }
  }

  void updateCount(String product, int count) {
    final newCounts = Map<String, int>.from(state.counts);
    newCounts[product] = count;
    
    final newDirty = Set<String>.from(state.dirtyFields)..add(product);
    
    state = state.copyWith(counts: newCounts, dirtyFields: newDirty, isSaved: false);
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
      
      state = state.copyWith(isLoading: false, isSaved: true, dirtyFields: const {}, loadingMessage: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString(), loadingMessage: null);
      rethrow;
    }
  }
}

final managerInventoryProvider = NotifierProvider<ManagerInventoryNotifier, ManagerInventoryState>(() {
  return ManagerInventoryNotifier();
});
