import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/delivery_route.dart';
import '../../attendance/providers/attendance_provider.dart';
import '../../../core/network/api_client.dart';
import '../../inventory/providers/inventory_provider.dart';
import '../../evening_check/providers/evening_check_provider.dart';
import '../../dispatch/providers/dispatch_provider.dart';
import '../../profile/providers/staff_provider.dart';

class RouteState {
  final List<DeliveryRoute> routes;
  final bool? isAssignedFilter;

  const RouteState({
    this.routes = const [],
    this.isAssignedFilter,
  });

  RouteState copyWith({
    List<DeliveryRoute>? routes,
    bool? Function()? isAssignedFilter,
  }) {
    return RouteState(
      routes: routes ?? this.routes,
      isAssignedFilter: isAssignedFilter != null ? isAssignedFilter() : this.isAssignedFilter,
    );
  }

  List<DeliveryRoute> get filteredRoutes {
    return routes.where((r) {
      if (isAssignedFilter == null) return true;
      final isAssigned = r.assignedDpId != null;
      return isAssigned == isAssignedFilter;
    }).toList();
  }

  int get countAll => routes.length;
  int get countAssigned => routes.where((r) => r.assignedDpId != null).length;
  int get countUnassigned => routes.where((r) => r.assignedDpId == null).length;
}

class RouteNotifier extends AsyncNotifier<RouteState> {
  String _getLocalToday() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  Future<RouteState> build() async {
    try {
      return await _fetchRoutes();
    } catch (e, st) {
      return Future.error(e, st);
    }
  }

  Future<RouteState> _fetchRoutes() async {
    final dio = ref.read(apiClientProvider);
    final date = _getLocalToday();

    final response = await dio.get('/routes', queryParameters: {'date': date});
    final List<dynamic> data = response.data;
    
    final routes = data.map((json) {
      // If litresAllocated is present and > 0, we use it as the milkQuantity for this assigned route
      if (json['litresAllocated'] != null && (json['litresAllocated'] as num) > 0) {
        json['defaultLitres'] = (json['litresAllocated'] as num).toDouble();
      }
      json['deliveryCompleted'] = json['status'] == 'COMPLETED';
      json['qty1LBottle'] = json['qty1LBottle'] ?? 0;
      json['qtyHalfLBottle'] = json['qtyHalfLBottle'] ?? 0;
      json['qtyHalfLPacket'] = json['qtyHalfLPacket'] ?? 0;
      json['expectedEmptyBottles'] = json['expectedEmptyBottles'] ?? 0;
      return DeliveryRoute.fromJson(json);
    }).toList();

    return RouteState(
      routes: routes,
      isAssignedFilter: state.value?.isAssignedFilter,
    );
  }

  Future<void> reload() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchRoutes());
  }

  void setFilter(bool? filter) {
    if (state.value != null) {
      state = AsyncValue.data(state.value!.copyWith(isAssignedFilter: () => filter));
    }
  }

  Future<void> assignRoute(String routeId, String dpId, String dpName, double litresAllocated, {int? qty1LBottle, int? qtyHalfLBottle, int? qtyHalfLPacket, int? petrolAllowanceGiven}) async {
    final dio = ref.read(apiClientProvider);
    final date = _getLocalToday();

    if (state.value != null) {
      final updated = state.value!.routes.map((r) {
        if (r.id == routeId) {
          return r.copyWith(
            assignedDpId: dpId, 
            assignedDpName: dpName, 
            milkQuantity: litresAllocated,
            qty1LBottle: qty1LBottle ?? r.qty1LBottle,
            qtyHalfLBottle: qtyHalfLBottle ?? r.qtyHalfLBottle,
          );
        }
        return r;
      }).toList();
      state = AsyncValue.data(state.value!.copyWith(routes: updated));
    }

    try {
      await dio.put(
        '/routes/$routeId/allocation',
        queryParameters: {'date': date},
        data: {
          'dpId': dpId,
          'litresAllocated': litresAllocated,
          'status': 'ASSIGNED',
          if (qty1LBottle != null) 'qty1LBottle': qty1LBottle,
          if (qtyHalfLBottle != null) 'qtyHalfLBottle': qtyHalfLBottle,
          if (qtyHalfLPacket != null) 'qtyHalfLPacket': qtyHalfLPacket,
          if (petrolAllowanceGiven != null) 'petrolAllowanceGiven': petrolAllowanceGiven,
        },
      );
      ref.read(attendanceProvider.notifier).assignRouteToDp(dpId);
      ref.invalidate(inventoryProvider);
      ref.invalidate(eveningCheckProvider);
      ref.invalidate(dispatchProvider);
      ref.invalidate(attendanceProvider);
      ref.invalidate(staffProvider);
      ref.invalidateSelf();
    } catch (e) {
      ref.invalidateSelf();
      rethrow;
    }
  }

  Future<void> updateRouteAllocationLitres(String routeId, double litresAllocated, {int? qty1LBottle, int? qtyHalfLBottle, int? qtyHalfLPacket, int? petrolAllowanceGiven}) async {
    final dio = ref.read(apiClientProvider);
    final date = _getLocalToday();

    // Optimistic update
    if (state.value != null) {
      final updated = state.value!.routes.map((r) {
        if (r.id == routeId) {
          return r.copyWith(
            milkQuantity: litresAllocated,
            qty1LBottle: qty1LBottle ?? r.qty1LBottle,
            qtyHalfLBottle: qtyHalfLBottle ?? r.qtyHalfLBottle,
          );
        }
        return r;
      }).toList();
      state = AsyncValue.data(state.value!.copyWith(routes: updated));
    }

    try {
      // Get current route to get dpId
      final route = state.value?.routes.firstWhere((r) => r.id == routeId);
      if (route == null || route.assignedDpId == null) return;
      
      await dio.put(
        '/routes/$routeId/allocation',
        queryParameters: {'date': date},
        data: {
          'dpId': route.assignedDpId,
          'litresAllocated': litresAllocated,
          'status': 'ASSIGNED',
          if (qty1LBottle != null) 'qty1LBottle': qty1LBottle,
          if (qtyHalfLBottle != null) 'qtyHalfLBottle': qtyHalfLBottle,
          if (qtyHalfLPacket != null) 'qtyHalfLPacket': qtyHalfLPacket,
          if (petrolAllowanceGiven != null) 'petrolAllowanceGiven': petrolAllowanceGiven,
        },
      );
      ref.invalidate(inventoryProvider);
      ref.invalidate(eveningCheckProvider);
      ref.invalidate(dispatchProvider);
      ref.invalidate(attendanceProvider);
      ref.invalidate(staffProvider);
      ref.invalidateSelf();
    } catch (e) {
      ref.invalidateSelf();
      rethrow;
    }
  }

  Future<void> unassignRoute(String routeId) async {
    final dio = ref.read(apiClientProvider);
    final date = _getLocalToday();

    String? dpId;
    if (state.value != null) {
      final route = state.value!.routes.firstWhere((r) => r.id == routeId);
      dpId = route.assignedDpId;
      final updated = state.value!.routes.map((r) {
        if (r.id == routeId) {
          return r.copyWith(
            assignedDpId: null,
            assignedDpName: null,
            isPetrolAllowanceComplete: false,
            petrolAllowanceGiven: null,
          );
        }
        return r;
      }).toList();
      state = AsyncValue.data(state.value!.copyWith(routes: updated));
    }

    try {
      await dio.put(
        '/routes/$routeId/allocation',
        queryParameters: {'date': date},
        data: {
          'dpId': dpId,
          'litresAllocated': 0,
          'status': 'UNASSIGNED',
        },
      );
      ref.invalidate(eveningCheckProvider);
      ref.invalidate(dispatchProvider);
      ref.invalidate(attendanceProvider);
      ref.invalidate(staffProvider);
      ref.invalidateSelf();
    } catch (e) {
      ref.invalidateSelf();
    }
  }

  Future<void> markPetrolAllowanceComplete(String routeId, int givenAmount) async {
    final dio = ref.read(apiClientProvider);
    final date = _getLocalToday();

    if (state.value != null) {
      final route = state.value!.routes.firstWhere((r) => r.id == routeId);
      final updated = state.value!.routes.map((r) {
        if (r.id == routeId) {
          return r.copyWith(
            isPetrolAllowanceComplete: true,
            petrolAllowanceGiven: givenAmount,
          );
        }
        return r;
      }).toList();
      state = AsyncValue.data(state.value!.copyWith(routes: updated));

      try {
        await dio.put(
          '/routes/$routeId/allocation',
          queryParameters: {'date': date},
          data: {
            'dpId': route.assignedDpId,
            'litresAllocated': route.milkQuantity,
            'status': 'ASSIGNED',
            'petrolAllowanceGiven': givenAmount,
          },
        );
        ref.invalidate(eveningCheckProvider);
        ref.invalidate(dispatchProvider);
        ref.invalidate(staffProvider);
        ref.invalidateSelf();
      } catch (e) {
        ref.invalidateSelf();
      }
    }
  }

  void saveEveningCheckData(
    String routeId, {
    required bool completed,
    int? bottles1L,
    int? bottlesHalfL,
    bool? hasFlag,
    String? bottleNote,
  }) {
    if (state.value != null) {
      final updated = state.value!.routes.map((r) {
        if (r.id == routeId) {
          return r.copyWith(
            deliveryCompleted: completed,
            emptyBottles1L: bottles1L,
            emptyBottlesHalfL: bottlesHalfL,
            hasBottleReturnFlag: hasFlag ?? false,
            bottleReturnNote: bottleNote,
          );
        }
        return r;
      }).toList();
      state = AsyncValue.data(state.value!.copyWith(routes: updated));
    }
  }
}

final routeProvider = AsyncNotifierProvider<RouteNotifier, RouteState>(() {
  return RouteNotifier();
});
