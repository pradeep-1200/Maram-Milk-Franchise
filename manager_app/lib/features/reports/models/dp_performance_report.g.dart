// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dp_performance_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DpPerformanceReport _$DpPerformanceReportFromJson(Map<String, dynamic> json) =>
    _DpPerformanceReport(
      dpId: json['dpId'] as String,
      dpCode: json['dpCode'] as String,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String?,
      totalLitres: (json['totalLitres'] as num).toDouble(),
      totalRoutes: (json['totalRoutes'] as num).toInt(),
      attendanceRatio: json['attendanceRatio'] as String,
      totalDays: (json['totalDays'] as num?)?.toInt() ?? 0,
      presentDays: (json['presentDays'] as num?)?.toInt() ?? 0,
      absentDays: (json['absentDays'] as num?)?.toInt() ?? 0,
      totalBottles: (json['totalBottles'] as num).toInt(),
      total1LBottles: (json['total1LBottles'] as num?)?.toInt() ?? 0,
      totalHalfLBottles: (json['totalHalfLBottles'] as num?)?.toInt() ?? 0,
      totalPackets: (json['totalPackets'] as num?)?.toInt() ?? 0,
      totalPetrolAllowance:
          (json['totalPetrolAllowance'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$DpPerformanceReportToJson(
  _DpPerformanceReport instance,
) => <String, dynamic>{
  'dpId': instance.dpId,
  'dpCode': instance.dpCode,
  'name': instance.name,
  'photoUrl': instance.photoUrl,
  'totalLitres': instance.totalLitres,
  'totalRoutes': instance.totalRoutes,
  'attendanceRatio': instance.attendanceRatio,
  'totalDays': instance.totalDays,
  'presentDays': instance.presentDays,
  'absentDays': instance.absentDays,
  'totalBottles': instance.totalBottles,
  'total1LBottles': instance.total1LBottles,
  'totalHalfLBottles': instance.totalHalfLBottles,
  'totalPackets': instance.totalPackets,
  'totalPetrolAllowance': instance.totalPetrolAllowance,
};
