// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'empty_bottle_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EmptyBottleStatus _$EmptyBottleStatusFromJson(Map<String, dynamic> json) =>
    _EmptyBottleStatus(
      routeId: json['routeId'] as String,
      routeName: json['routeName'] as String,
      dpId: json['dpId'] as String?,
      dpName: json['dpName'] as String?,
      deliveryCompleted: json['deliveryCompleted'] as bool,
      oneLBottlesCollected: (json['oneLBottlesCollected'] as num).toInt(),
      halfLBottlesCollected: (json['halfLBottlesCollected'] as num).toInt(),
      flagIssue: json['flagIssue'] as bool,
      status: json['status'] as String,
    );

Map<String, dynamic> _$EmptyBottleStatusToJson(_EmptyBottleStatus instance) =>
    <String, dynamic>{
      'routeId': instance.routeId,
      'routeName': instance.routeName,
      'dpId': instance.dpId,
      'dpName': instance.dpName,
      'deliveryCompleted': instance.deliveryCompleted,
      'oneLBottlesCollected': instance.oneLBottlesCollected,
      'halfLBottlesCollected': instance.halfLBottlesCollected,
      'flagIssue': instance.flagIssue,
      'status': instance.status,
    };
