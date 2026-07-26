// Trigger rebuild
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dispatch_summary.freezed.dart';
part 'dispatch_summary.g.dart';

@freezed
abstract class AttendanceStats with _$AttendanceStats {
  const factory AttendanceStats({
    required int totalDps,
    required int marked,
    required int present,
    required int absent,
    required int standby,
    DateTime? completedAt,
  }) = _AttendanceStats;

  factory AttendanceStats.fromJson(Map<String, dynamic> json) => _$AttendanceStatsFromJson(json);
}

@freezed
abstract class RouteStats with _$RouteStats {
  const factory RouteStats({
    required int totalRoutes,
    required int assigned,
    required int unassigned,
    required double totalLitresAllocated,
    DateTime? completedAt,
  }) = _RouteStats;

  factory RouteStats.fromJson(Map<String, dynamic> json) => _$RouteStatsFromJson(json);
}

@freezed
abstract class InventoryStats with _$InventoryStats {
  const factory InventoryStats({
    required int totalItems,
    required int counted,
    required int matched,
    DateTime? completedAt,
  }) = _InventoryStats;

  factory InventoryStats.fromJson(Map<String, dynamic> json) => _$InventoryStatsFromJson(json);
}

@freezed
abstract class DispatchSummary with _$DispatchSummary {
  const factory DispatchSummary({
    required String date,
    required AttendanceStats attendance,
    required RouteStats routes,
    required InventoryStats inventory,
    double? petrolAllowanceTotal,
  }) = _DispatchSummary;

  factory DispatchSummary.fromJson(Map<String, dynamic> json) => _$DispatchSummaryFromJson(json);
}
