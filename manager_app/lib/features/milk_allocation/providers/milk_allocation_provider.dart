import 'package:flutter_riverpod/flutter_riverpod.dart';

class RouteMilkAllocation {
  final int qty1LBottle;
  final int qtyHalfLBottle;

  const RouteMilkAllocation({
    this.qty1LBottle = 0,
    this.qtyHalfLBottle = 0,
  });

  RouteMilkAllocation copyWith({
    int? qty1LBottle,
    int? qtyHalfLBottle,
  }) {
    return RouteMilkAllocation(
      qty1LBottle: qty1LBottle ?? this.qty1LBottle,
      qtyHalfLBottle: qtyHalfLBottle ?? this.qtyHalfLBottle,
    );
  }

  double get totalVolume {
    return (qty1LBottle * 1.0) +
        (qtyHalfLBottle * 0.5);
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

  void initAllocation(String routeId, int initial1L, int initialHalfL) {
    if (!state.allocations.containsKey(routeId)) {
      final newAllocations = Map<String, RouteMilkAllocation>.from(state.allocations);
      newAllocations[routeId] = RouteMilkAllocation(qty1LBottle: initial1L, qtyHalfLBottle: initialHalfL);
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

  void updateHalfLBottle(String routeId, int diff, {int? maxLimit}) {
    _updateAllocation(routeId, (a) {
      final newQty = a.qtyHalfLBottle + diff;
      if (newQty < 0) return a;
      if (maxLimit != null && newQty > maxLimit) return a;
      return a.copyWith(qtyHalfLBottle: newQty);
    });
  }

}

final milkAllocationProvider =
    NotifierProvider<MilkAllocationNotifier, MilkAllocationState>(() {
  return MilkAllocationNotifier();
});
