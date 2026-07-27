// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceEntry _$AttendanceEntryFromJson(Map<String, dynamic> json) =>
    _AttendanceEntry(
      dpId: json['dpId'] as String,
      dpCode: json['dpCode'] as String,
      name: json['name'] as String,
      profilePictureUrl: json['photoUrl'] as String?,
      status:
          $enumDecodeNullable(_$AttendanceStatusEnumMap, json['status']) ??
          AttendanceStatus.pending,
      recordId: json['recordId'] as String?,
      markedAt: json['markedAt'] as String?,
      petrolAllowanceGivenToday: (json['petrolAllowanceGivenToday'] as num?)
          ?.toInt(),
    );

Map<String, dynamic> _$AttendanceEntryToJson(_AttendanceEntry instance) =>
    <String, dynamic>{
      'dpId': instance.dpId,
      'dpCode': instance.dpCode,
      'name': instance.name,
      'photoUrl': instance.profilePictureUrl,
      'status': _$AttendanceStatusEnumMap[instance.status]!,
      'recordId': instance.recordId,
      'markedAt': instance.markedAt,
      'petrolAllowanceGivenToday': instance.petrolAllowanceGivenToday,
    };

const _$AttendanceStatusEnumMap = {
  AttendanceStatus.pending: 'NOT_MARKED',
  AttendanceStatus.present: 'PRESENT',
  AttendanceStatus.absent: 'ABSENT',
  AttendanceStatus.standby: 'STANDBY',
};
