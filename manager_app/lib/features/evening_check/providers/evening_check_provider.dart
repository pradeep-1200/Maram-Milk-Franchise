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
      required int oneLBottlesCollected,
      required int halfLBottlesCollected,
      required int halfLPacketCollected,
      required int actualDelivered1L,
      required int? actualDeliveredHalfL,
      int? actualDeliveredPacket,
      bool flagIssue = false,
      String? reason,
      int? brokenBottleCount1L,
      int? brokenBottleCountHalfL,
      String? notes,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final dateStr = DateFormat('yyyy-MM-dd').format(DateUtil.operatingDay);
      await ref.read(apiClientProvider).put(
        '/empty-bottles/$routeId?date=$dateStr',
        data: {
          'dpId': dpId,
          'deliveryCompleted': deliveryCompleted,
          'oneLBottlesCollected': oneLBottlesCollected,
          'halfLBottlesCollected': halfLBottlesCollected,
          'halfLPacketCollected': halfLPacketCollected,
          'actualDelivered1L': actualDelivered1L,
          if (actualDeliveredHalfL != null) 'actualDeliveredHalfL': actualDeliveredHalfL,
          if (actualDeliveredPacket != null) 'actualDeliveredPacket': actualDeliveredPacket,
          'flagIssue': flagIssue,
          if (reason != null) 'reason': reason,
          if (brokenBottleCount1L != null) 'brokenBottleCount1L': brokenBottleCount1L,
          if (brokenBottleCountHalfL != null) 'brokenBottleCountHalfL': brokenBottleCountHalfL,
          if (notes != null) 'notes': notes,
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
