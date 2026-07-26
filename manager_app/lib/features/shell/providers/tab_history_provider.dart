import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabHistoryNotifier extends Notifier<List<int>> {
  @override
  List<int> build() => [0]; // Starts at Dashboard (index 0)

  void pushTab(int index) {
    if (state.isEmpty || state.last != index) {
      state = [...state, index];
    }
  }

  int? popTab() {
    if (state.length > 1) {
      final newState = List<int>.from(state)..removeLast();
      state = newState;
      return state.last;
    }
    return null;
  }
}

final tabHistoryProvider = NotifierProvider<TabHistoryNotifier, List<int>>(() {
  return TabHistoryNotifier();
});
