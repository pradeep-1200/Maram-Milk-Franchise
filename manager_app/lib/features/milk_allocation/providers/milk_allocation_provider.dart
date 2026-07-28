import 'package:flutter_riverpod/flutter_riverpod.dart';

class RouteMilkAllocation {
  final int qty1LBottle;
  final int qtyHalfLBottle;
  final int qtyHalfLPacket;

  const RouteMilkAllocation({
    this.qty1LBottle = 0,
    this.qtyHalfLBottle = 0,
    this.qtyHalfLPacket = 0,
  });

  RouteMilkAllocation copyWith({
    int? qty1LBottle,
    int? qtyHalfLBottle,
    int? qtyHalfLPacket,
  }) {
    return RouteMilkAllocation(
      qty1LBottle: qty1LBottle ?? this.qty1LBottle,
      qtyHalfLBottle: qtyHalfLBottle ?? this.qtyHalfLBottle,
      qtyHalfLPacket: qtyHalfLPacket ?? this.qtyHalfLPacket,
    );
  }

  double get totalVolume {
    return (qty1LBottle * 1.0) + 
        (qtyHalfLBottle * 0.5) +
        (qtyHalfLPacket * 0.5);
  }
}

class MilkAllocationState {
  final Map<String, RouteMilkAllocation> allocations;

  const MilkAllocationState({
    this.allocations = const {},
  });

  MilkAllocationState copyWith({
    Map<String, RouteMilkAllocation>? allocations,
  }) {
    return MilkAllocationState(
      allocations: allocations ?? this.allocations,
    );
  }
}

class MilkAllocationNotifier extends Notifier<MilkAllocationState> {
  @override
  MilkAllocationState build() {
    return const MilkAllocationState();
  }

  RouteMilkAllocation getAllocation(String routeId) {
    return state.allocations[routeId] ?? const RouteMilkAllocation();
  }

  void _updateAllocation(String routeId, RouteMilkAllocation Function(RouteMilkAllocation) updater) {
    final current = getAllocation(routeId);
    final updated = updater(current);
    final newAllocations = Map<String, RouteMilkAllocation>.from(state.allocations);
    newAllocations[routeId] = updated;
    state = state.copyWith(allocations: newAllocations);
  }

  void initAllocation(String routeId, int initial1L, int initialHalfL, int initialHalfLPacket) {
    if (!state.allocations.containsKey(routeId)) {
      final newAllocations = Map<String, RouteMilkAllocation>.from(state.allocations);
      newAllocations[routeId] = RouteMilkAllocation(qty1LBottle: initial1L, qtyHalfLBottle: initialHalfL, qtyHalfLPacket: initialHalfLPacket);
      state = state.copyWith(allocations: newAllocations);
    }
  }

  void update1LBottle(String routeId, int diff, {int? maxLimit}) {
    _updateAllocation(routeId, (a) {
      final newQty = a.qty1LBottle + diff;
      if (newQty < 0) return a;
      if (maxLimit != null && newQty > maxLimit) return a;
      return a.copyWith(qty1LBottle: newQty);
    });
  }

  void set1LBottle(String routeId, int value, {int? maxLimit}) {
    _updateAllocation(routeId, (a) {
      final clamped = value < 0 ? 0 : (maxLimit != null && value > maxLimit ? maxLimit : value);
      return a.copyWith(qty1LBottle: clamped);
    });
  }

  void updateHalfLBottle(String routeId, int diff, {int? maxLimit}) {
    final allocations = Map<String, RouteMilkAllocation>.from(state.allocations);
    allocations.update(routeId, (a) {
      final newQty = a.qtyHalfLBottle + diff;
      if (newQty < 0 || (maxLimit != null && newQty > maxLimit)) return a;
      return a.copyWith(qtyHalfLBottle: newQty);
    }, ifAbsent: () => RouteMilkAllocation(qtyHalfLBottle: diff));
    state = state.copyWith(allocations: allocations);
  }

  void setHalfLBottle(String routeId, int value, {int? maxLimit}) {
    _updateAllocation(routeId, (a) {
      final clamped = value < 0 ? 0 : (maxLimit != null && value > maxLimit ? maxLimit : value);
      return a.copyWith(qtyHalfLBottle: clamped);
    });
  }

  void updateHalfLPacket(String routeId, int diff, {int? maxLimit}) {
    final allocations = Map<String, RouteMilkAllocation>.from(state.allocations);
    allocations.update(routeId, (a) {
      final newQty = a.qtyHalfLPacket + diff;
      if (newQty < 0 || (maxLimit != null && newQty > maxLimit)) return a;
      return a.copyWith(qtyHalfLPacket: newQty);
    }, ifAbsent: () => RouteMilkAllocation(qtyHalfLPacket: diff));
    state = state.copyWith(allocations: allocations);
  }

  void setHalfLPacket(String routeId, int value, {int? maxLimit}) {
    _updateAllocation(routeId, (a) {
      final clamped = value < 0 ? 0 : (maxLimit != null && value > maxLimit ? maxLimit : value);
      return a.copyWith(qtyHalfLPacket: clamped);
    });
  }
}

final milkAllocationProvider =
    NotifierProvider<MilkAllocationNotifier, MilkAllocationState>(() {
  return MilkAllocationNotifier();
});
