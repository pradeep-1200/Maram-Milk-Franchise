import 'package:manager_app/core/utils/date_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/network/api_client.dart';
import '../../dispatch/providers/dispatch_provider.dart';

class InventoryItemState {
  final String id;
  final String recordId;
  final String name;
  final String subtitle;
  final double expectedQty;
  final double carryOverQty;
  final double newStockAdded;
  final double currentStock;
  final double litresPerUnit;
  final String? reason;

  const InventoryItemState({
    required this.id,
    required this.recordId,
    required this.name,
    required this.subtitle,
    this.expectedQty = 0.0,
    this.carryOverQty = 0.0,
    this.newStockAdded = 0.0,
    this.currentStock = 0.0,
    this.litresPerUnit = 0.0,
    this.reason,
  });

  double get variance => expectedQty - currentStock;

  InventoryItemState copyWith({
    double? currentStock,
    String? reason,
    double? newStockAdded,
    double? expectedQty,
  }) {
    return InventoryItemState(
      id: id,
      recordId: recordId,
      name: name,
      subtitle: subtitle,
      expectedQty: expectedQty ?? this.expectedQty,
      carryOverQty: carryOverQty,
      newStockAdded: newStockAdded ?? this.newStockAdded,
      currentStock: currentStock ?? this.currentStock,
      litresPerUnit: litresPerUnit,
      reason: reason ?? this.reason,
    );
  }

  factory InventoryItemState.fromJson(Map<String, dynamic> json) {
    return InventoryItemState(
      id: json['inventoryItemId'] ?? '',
      recordId: json['recordId'] ?? '',
      name: json['name'] ?? '',
      subtitle: '${json['material'] ?? ''} - ${json['unit'] ?? ''}',
      expectedQty: (json['expectedStock'] as num?)?.toDouble() ?? 0.0,
      carryOverQty: (json['carriedOverStock'] as num?)?.toDouble() ?? 0.0,
      newStockAdded: (json['newStockAdded'] as num?)?.toDouble() ?? 0.0,
      currentStock: (json['currentStock'] as num?)?.toDouble() ?? 0.0,
      litresPerUnit: (json['litresPerUnit'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class InventoryState {
  final List<InventoryItemState> items;
  final bool isSaved;
  final bool isDirty;

  const InventoryState({
    required this.items,
    this.isSaved = false,
    this.isDirty = false,
  });

  double get totalExpected => items.fold(0.0, (sum, item) => sum + item.expectedQty);
  double get totalCurrentStock => items.fold(0.0, (sum, item) => sum + item.currentStock);
  
  double get totalShort => items.where((i) => i.variance > 0).fold(0.0, (sum, item) => sum + item.variance);
  double get totalOver => items.where((i) => i.variance < 0).fold(0.0, (sum, item) => sum + item.variance.abs());

  InventoryState copyWith({
    List<InventoryItemState>? items,
    bool? isSaved,
    bool? isDirty,
  }) {
    return InventoryState(
      items: items ?? this.items,
      isSaved: isSaved ?? this.isSaved,
      isDirty: isDirty ?? this.isDirty,
    );
  }
}

class InventoryNotifier extends AsyncNotifier<InventoryState> {
  String _getLocalToday() {
    return DateFormat('yyyy-MM-dd').format(DateUtil.operatingDay);
  }

  @override
  Future<InventoryState> build() async {
    try {
      return await fetchInventory();
    } catch (e, st) {
      return Future.error(e, st);
    }
  }

  Future<InventoryState> fetchInventory() async {
    final dio = ref.read(apiClientProvider);
    final response = await dio.get(
      '/inventory',
      queryParameters: {'date': _getLocalToday()},
    );
    
    final data = response.data as List;
    final items = data.map((json) => InventoryItemState.fromJson(json)).toList();

    return InventoryState(
      items: items,
      isSaved: false,
    );
  }

  Future<void> reload() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => fetchInventory());
  }


}

final inventoryProvider = AsyncNotifierProvider<InventoryNotifier, InventoryState>(() {
  return InventoryNotifier();
});
