import 'package:flutter_riverpod/flutter_riverpod.dart';

class RouteMilkAllocation {
  final Map<String, int> items;

  const RouteMilkAllocation({
    this.items = const {},
  });

  RouteMilkAllocation copyWith({
    Map<String, int>? items,
  }) {
    return RouteMilkAllocation(
      items: items ?? this.items,
    );
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

  void initAllocation(String routeId, Map<String, int> initialItems) {
    final newAllocations = Map<String, RouteMilkAllocation>.from(state.allocations);
    newAllocations[routeId] = RouteMilkAllocation(items: Map.from(initialItems));
    state = state.copyWith(allocations: newAllocations);
  }

  void updateItem(String routeId, String itemId, int diff, {int? maxLimit}) {
    _updateAllocation(routeId, (a) {
      final currentQty = a.items[itemId] ?? 0;
      final newQty = currentQty + diff;
      if (newQty < 0) return a;
      if (maxLimit != null && newQty > maxLimit) return a;
      
      final newItems = Map<String, int>.from(a.items);
      newItems[itemId] = newQty;
      return a.copyWith(items: newItems);
    });
  }

  void setItem(String routeId, String itemId, int value, {int? maxLimit}) {
    _updateAllocation(routeId, (a) {
      final clamped = value < 0 ? 0 : (maxLimit != null && value > maxLimit ? maxLimit : value);
      
      final newItems = Map<String, int>.from(a.items);
      newItems[itemId] = clamped;
      return a.copyWith(items: newItems);
    });
  }
}

final milkAllocationProvider =
    NotifierProvider<MilkAllocationNotifier, MilkAllocationState>(() {
  return MilkAllocationNotifier();
});
