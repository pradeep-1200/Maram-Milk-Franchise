import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:manager_app/core/network/api_client.dart';
import 'package:manager_app/features/manager_inventory/providers/manager_inventory_provider.dart';

class MockInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path == '/manager-inventory') {
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: [
            {'product': 'item_a', 'quantity': 50},
            {'product': 'item_b', 'quantity': 75},
          ],
        ),
      );
      return;
    }
    super.onRequest(options, handler);
  }
}

void main() {
  test('Granular merge protects dirty fields', () async {
    final dio = Dio();
    dio.interceptors.add(MockInterceptor());

    final container = ProviderContainer(
      overrides: [
        apiClientProvider.overrideWithValue(dio),
      ],
    );

    final notifier = container.read(managerInventoryProvider.notifier);
    
    // Allow initial load to finish (since build does Future.microtask)
    await Future.delayed(const Duration(milliseconds: 100));

    // Simulate user typing '100' into Item A
    notifier.updateCount('item_a', 100);
    
    // Check state before reload
    var state = container.read(managerInventoryProvider);
    expect(state.counts['item_a'], 100);
    expect(state.dirtyFields.contains('item_a'), isTrue);
    
    // Simulate background admin dashboard reload
    await notifier.reload();
    
    // Check state after reload
    state = container.read(managerInventoryProvider);
    
    // Item A should STILL be 100 because it was dirty
    expect(state.counts['item_a'], 100, reason: 'Item A should be protected by dirtyFields');
    
    // Item B should be updated to 75 from the backend because it wasn't dirty
    expect(state.counts['item_b'], 75, reason: 'Item B should update from backend');
    
    print('Test passed: Item A kept its unsaved value of ${state.counts['item_a']}, while Item B updated to ${state.counts['item_b']} from the backend.');
  });
}
