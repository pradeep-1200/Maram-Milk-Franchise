// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeliveryPerson _$DeliveryPersonFromJson(Map<String, dynamic> json) =>
    _DeliveryPerson(
      id: json['id'] as String,
      name: json['name'] as String,
      employeeId: json['dpCode'] as String,
      status:
          $enumDecodeNullable(_$AttendanceStatusEnumMap, json['status']) ??
          AttendanceStatus.pending,
      isRouteAssigned: json['isRouteAssigned'] as bool? ?? false,
      address: json['address'] as String?,
      zone: json['zone'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      parentNameAndAddress: json['parentNameAndAddress'] as String?,
      parentOrSpouseMobile: json['parentOrSpouseMobile'] as String?,
      alternativeAddress: json['alternativeAddress'] as String?,
      mobileNumber: json['mobileNumber'] as String? ?? '',
      alternativeMobile: json['alternativeMobile'] as String?,
      whatsappNumber: json['whatsappNumber'] as String?,
      aadharNumber: json['aadharNumber'] as String?,
      licenseNumber: json['licenseNumber'] as String?,
      vehicleNumber: json['vehicleNumber'] as String?,
      dateOfJoining: json['dateOfJoining'] as String?,
      gpayNumber: json['gpayNumber'] as String?,
      upiId: json['upiId'] as String?,
      bankAccountDetails: json['bankAccountDetails'] as String?,
      photoUrl: json['photoUrl'] as String?,
      aadharCopyUrl: json['aadharCopyUrl'] as String?,
      licenseCopyUrl: json['licenseCopyUrl'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      recordId: json['recordId'] as String?,
      markedAt: json['markedAt'] as String?,
    );

Map<String, dynamic> _$DeliveryPersonToJson(_DeliveryPerson instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'dpCode': instance.employeeId,
      'status': _$AttendanceStatusEnumMap[instance.status]!,
      'isRouteAssigned': instance.isRouteAssigned,
      'address': instance.address,
      'zone': instance.zone,
      'dateOfBirth': instance.dateOfBirth,
      'parentNameAndAddress': instance.parentNameAndAddress,
      'parentOrSpouseMobile': instance.parentOrSpouseMobile,
      'alternativeAddress': instance.alternativeAddress,
      'mobileNumber': instance.mobileNumber,
      'alternativeMobile': instance.alternativeMobile,
      'whatsappNumber': instance.whatsappNumber,
      'aadharNumber': instance.aadharNumber,
      'licenseNumber': instance.licenseNumber,
      'vehicleNumber': instance.vehicleNumber,
      'dateOfJoining': instance.dateOfJoining,
      'gpayNumber': instance.gpayNumber,
      'upiId': instance.upiId,
      'bankAccountDetails': instance.bankAccountDetails,
      'photoUrl': instance.photoUrl,
      'aadharCopyUrl': instance.aadharCopyUrl,
      'licenseCopyUrl': instance.licenseCopyUrl,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'recordId': instance.recordId,
      'markedAt': instance.markedAt,
    };

const _$AttendanceStatusEnumMap = {
  AttendanceStatus.pending: 'NOT_MARKED',
  AttendanceStatus.present: 'PRESENT',
  AttendanceStatus.absent: 'ABSENT',
  AttendanceStatus.standby: 'STANDBY',
};
