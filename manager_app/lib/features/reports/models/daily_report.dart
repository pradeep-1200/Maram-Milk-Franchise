class InventorySnapshot {
  final String id;
  final String name;
  final double expectedQty;
  final double currentStock;
  final double variance;
  final String? reason;

  const InventorySnapshot({
    required this.id,
    required this.name,
    required this.expectedQty,
    required this.currentStock,
    required this.variance,
    this.reason,
  });
}

class DailyReport {
  final DateTime completedAt;
  final int presentCount;
  final int absentCount;
  final int standbyCount;
  final List<InventorySnapshot> inventoryItems;
  final int assignedRoutesCount;
  final int unassignedRoutesCount;
  final double totalMilkAllocated;
  final int totalPetrolGiven;
  final int shortPaidRoutesCount;

  const DailyReport({
    required this.completedAt,
    required this.presentCount,
    required this.absentCount,
    required this.standbyCount,
    required this.inventoryItems,
    required this.assignedRoutesCount,
    required this.unassignedRoutesCount,
    required this.totalMilkAllocated,
    required this.totalPetrolGiven,
    required this.shortPaidRoutesCount,
  });
}
