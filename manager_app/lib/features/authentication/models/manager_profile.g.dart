// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ManagerProfile _$ManagerProfileFromJson(Map<String, dynamic> json) =>
    _ManagerProfile(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? 'Manager',
      branchName: json['branchName'] as String? ?? '',
    );

Map<String, dynamic> _$ManagerProfileToJson(_ManagerProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'role': instance.role,
      'branchName': instance.branchName,
    };
