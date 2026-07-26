import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/dispatch_summary.dart';
import '../../../core/network/api_client.dart';

class DispatchNotifier extends AsyncNotifier<DispatchSummary> {
  String _getLocalToday() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  Future<DispatchSummary> build() async {
    try {
      return await fetchSummary();
    } catch (e, st) {
      return Future.error(e, st);
    }
  }

  Future<DispatchSummary> fetchSummary() async {
    final dio = ref.read(apiClientProvider);
    final today = _getLocalToday();
    
    final response = await dio.get(
      '/dispatch/summary',
      queryParameters: {'date': today},
    );
    
    return DispatchSummary.fromJson(response.data);
  }

  Future<void> reload() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => fetchSummary());
  }
}

final dispatchProvider = AsyncNotifierProvider<DispatchNotifier, DispatchSummary>(() {
  return DispatchNotifier();
});
