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
      totalBottles: (json['totalBottles'] as num).toInt(),
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
  'totalBottles': instance.totalBottles,
};
