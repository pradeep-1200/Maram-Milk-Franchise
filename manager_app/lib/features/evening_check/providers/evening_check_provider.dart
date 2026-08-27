import 'package:manager_app/core/utils/date_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/network/api_client.dart';
import '../models/empty_bottle_status.dart';
import '../../routes/providers/route_provider.dart';

class EveningCheckState {
  final List<EmptyBottleStatus> statuses;
  const EveningCheckState({this.statuses = const []});
}

class EveningCheckNotifier extends AsyncNotifier<EveningCheckState> {
  @override
  Future<EveningCheckState> build() async {
    try {
      return await _fetchStatus(DateUtil.operatingDay);
    } catch (e, st) {
      return Future.error(e, st);
    }
  }

  Future<EveningCheckState> _fetchStatus(DateTime date) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    final response = await ref.read(apiClientProvider).get('/empty-bottles?date=$dateStr');
    
    final List<dynamic> data = response.data;
    final statuses = data.map((json) => EmptyBottleStatus.fromJson(json)).toList();
    
    return EveningCheckState(statuses: statuses);
  }

  Future<void> updateStatus(
      String routeId, {
      required String dpId,
      required bool deliveryCompleted,
      bool flagIssue = false,
      String? reason,
      String? notes,
      required List<Map<String, dynamic>> items,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final dateStr = DateFormat('yyyy-MM-dd').format(DateUtil.operatingDay);
      await ref.read(apiClientProvider).put(
        '/empty-bottles/$routeId?date=$dateStr',
        data: {
          'dpId': dpId,
          'deliveryCompleted': deliveryCompleted,
          'flagIssue': flagIssue,
          if (reason != null) 'reason': reason,
          if (notes != null) 'notes': notes,
          'items': items,
        },
      );
      
      // Invalidate routeProvider to update Routes Assigned status
      ref.invalidate(routeProvider);
      
      return _fetchStatus(DateUtil.operatingDay);
    });
  }
}

final eveningCheckProvider = AsyncNotifierProvider<EveningCheckNotifier, EveningCheckState>(
  () => EveningCheckNotifier(),
);
