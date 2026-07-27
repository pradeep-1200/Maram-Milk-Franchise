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
      return await _fetchStatus(DateTime.now());
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
      required bool deliveryCompleted,
      required int oneLBottlesCollected,
      required int halfLBottlesCollected,
      required int halfLPacketCollected,
      required int actualDelivered1L,
      required int actualDeliveredHalfL,
      required int actualDeliveredPacket,
      required bool flagIssue,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final dateStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      await ref.read(apiClientProvider).put(
        '/empty-bottles/$routeId?date=$dateStr',
        data: {
          'deliveryCompleted': deliveryCompleted,
          'oneLBottlesCollected': oneLBottlesCollected,
          'halfLBottlesCollected': halfLBottlesCollected,
          'halfLPacketCollected': halfLPacketCollected,
          'actualDelivered1L': actualDelivered1L,
          'actualDeliveredHalfL': actualDeliveredHalfL,
          'actualDeliveredPacket': actualDeliveredPacket,
          'flagIssue': flagIssue,
        },
      );
      
      // Invalidate routeProvider to update Routes Assigned status
      ref.invalidate(routeProvider);
      
      return _fetchStatus(DateTime.now());
    });
  }
}

final eveningCheckProvider = AsyncNotifierProvider<EveningCheckNotifier, EveningCheckState>(
  () => EveningCheckNotifier(),
);
