// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispatch_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceStats _$AttendanceStatsFromJson(Map<String, dynamic> json) =>
    _AttendanceStats(
      totalDps: (json['totalDps'] as num).toInt(),
      marked: (json['marked'] as num).toInt(),
      present: (json['present'] as num).toInt(),
      absent: (json['absent'] as num).toInt(),
      standby: (json['standby'] as num).toInt(),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$AttendanceStatsToJson(_AttendanceStats instance) =>
    <String, dynamic>{
      'totalDps': instance.totalDps,
      'marked': instance.marked,
      'present': instance.present,
      'absent': instance.absent,
      'standby': instance.standby,
      'completedAt': instance.completedAt?.toIso8601String(),
    };

_RouteStats _$RouteStatsFromJson(Map<String, dynamic> json) => _RouteStats(
  totalRoutes: (json['totalRoutes'] as num).toInt(),
  assigned: (json['assigned'] as num).toInt(),
  unassigned: (json['unassigned'] as num).toInt(),
  totalLitresAllocated: (json['totalLitresAllocated'] as num).toDouble(),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
);

Map<String, dynamic> _$RouteStatsToJson(_RouteStats instance) =>
    <String, dynamic>{
      'totalRoutes': instance.totalRoutes,
      'assigned': instance.assigned,
      'unassigned': instance.unassigned,
      'totalLitresAllocated': instance.totalLitresAllocated,
      'completedAt': instance.completedAt?.toIso8601String(),
    };

_InventoryStats _$InventoryStatsFromJson(Map<String, dynamic> json) =>
    _InventoryStats(
      totalItems: (json['totalItems'] as num).toInt(),
      counted: (json['counted'] as num).toInt(),
      matched: (json['matched'] as num).toInt(),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$InventoryStatsToJson(_InventoryStats instance) =>
    <String, dynamic>{
      'totalItems': instance.totalItems,
      'counted': instance.counted,
      'matched': instance.matched,
      'completedAt': instance.completedAt?.toIso8601String(),
    };

_DispatchSummary _$DispatchSummaryFromJson(Map<String, dynamic> json) =>
    _DispatchSummary(
      date: json['date'] as String,
      attendance: AttendanceStats.fromJson(
        json['attendance'] as Map<String, dynamic>,
      ),
      routes: RouteStats.fromJson(json['routes'] as Map<String, dynamic>),
      inventory: InventoryStats.fromJson(
        json['inventory'] as Map<String, dynamic>,
      ),
      petrolAllowanceTotal: (json['petrolAllowanceTotal'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DispatchSummaryToJson(_DispatchSummary instance) =>
    <String, dynamic>{
      'date': instance.date,
      'attendance': instance.attendance,
      'routes': instance.routes,
      'inventory': instance.inventory,
      'petrolAllowanceTotal': instance.petrolAllowanceTotal,
    };
