import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manager_app/features/milk_allocation/providers/milk_allocation_provider.dart';

void main() {
  test('MilkAllocationNotifier state is isolated by composite key', () {
    final container = ProviderContainer();
    final notifier = container.read(milkAllocationProvider.notifier);

    const routeId = 'route_123';
    const dpA = 'dp_A';
    const dpB = 'dp_B';

    final keyA = '${routeId}_$dpA';
    final keyB = '${routeId}_$dpB';

    // Init DP A with some items
    notifier.initAllocation(keyA, {'item_1': 5, 'item_2': 10});
    
    // DP B starts empty
    notifier.initAllocation(keyB, {});

    // Modify DP A
    notifier.updateItem(keyA, 'item_1', 2); // 5 + 2 = 7
    
    // Modify DP B
    notifier.updateItem(keyB, 'item_1', 3); // 0 + 3 = 3

    final stateA = notifier.getAllocation(keyA);
    final stateB = notifier.getAllocation(keyB);

    expect(stateA.items['item_1'], 7, reason: 'DP A state should not be overwritten');
    expect(stateB.items['item_1'], 3, reason: 'DP B state should be isolated');
    expect(stateB.items['item_2'], null, reason: 'DP B should not bleed item_2 from DP A');
  });
}
