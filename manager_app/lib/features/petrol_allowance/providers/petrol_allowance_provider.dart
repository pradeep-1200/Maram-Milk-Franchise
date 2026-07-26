import 'package:flutter_riverpod/flutter_riverpod.dart';

class PetrolAllowanceNotifier extends Notifier<int> {
  @override
  int build() {
    return 80; // Default fixed amount
  }

  void init(int fixedAmount) {
    Future.microtask(() => state = fixedAmount);
  }

  void updateAmount(int diff) {
    final newAmount = state + diff;
    if (newAmount >= 0) {
      state = newAmount;
    }
  }

  void setAmount(int amount) {
    if (amount >= 0) {
      state = amount;
    }
  }
}

final petrolAllowanceProvider = NotifierProvider<PetrolAllowanceNotifier, int>(() {
  return PetrolAllowanceNotifier();
});
