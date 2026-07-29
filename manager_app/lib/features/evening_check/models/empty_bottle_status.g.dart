// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'empty_bottle_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EmptyBottleStatus _$EmptyBottleStatusFromJson(
  Map<String, dynamic> json,
) => _EmptyBottleStatus(
  routeId: json['routeId'] as String,
  routeName: json['routeName'] as String,
  dpId: json['dpId'] as String?,
  dpName: json['dpName'] as String?,
  deliveryCompleted: json['deliveryCompleted'] as bool,
  oneLBottlesCollected: (json['oneLBottlesCollected'] as num?)?.toInt() ?? 0,
  halfLBottlesCollected: (json['halfLBottlesCollected'] as num?)?.toInt() ?? 0,
  halfLPacketCollected: (json['halfLPacketCollected'] as num?)?.toInt() ?? 0,
  expected1LBottles: (json['expected1LBottles'] as num?)?.toInt() ?? 0,
  expectedHalfLBottles: (json['expectedHalfLBottles'] as num?)?.toInt() ?? 0,
  expectedHalfLPacket: (json['expectedHalfLPacket'] as num?)?.toInt() ?? 0,
  actualDelivered1L: (json['actualDelivered1L'] as num?)?.toInt() ?? 0,
  actualDeliveredHalfL: (json['actualDeliveredHalfL'] as num?)?.toInt() ?? 0,
  actualDeliveredPacket: (json['actualDeliveredPacket'] as num?)?.toInt() ?? 0,
  flagIssue: json['flagIssue'] as bool? ?? false,
  reason: json['reason'] as String?,
  brokenBottleCount1L: (json['brokenBottleCount1L'] as num?)?.toInt(),
  brokenBottleCountHalfL: (json['brokenBottleCountHalfL'] as num?)?.toInt(),
  notes: json['notes'] as String?,
  expectedEmptyBottles: (json['expectedEmptyBottles'] as num?)?.toInt() ?? 0,
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
      'halfLPacketCollected': instance.halfLPacketCollected,
      'expected1LBottles': instance.expected1LBottles,
      'expectedHalfLBottles': instance.expectedHalfLBottles,
      'expectedHalfLPacket': instance.expectedHalfLPacket,
      'actualDelivered1L': instance.actualDelivered1L,
      'actualDeliveredHalfL': instance.actualDeliveredHalfL,
      'actualDeliveredPacket': instance.actualDeliveredPacket,
      'flagIssue': instance.flagIssue,
      'reason': instance.reason,
      'brokenBottleCount1L': instance.brokenBottleCount1L,
      'brokenBottleCountHalfL': instance.brokenBottleCountHalfL,
      'notes': instance.notes,
      'expectedEmptyBottles': instance.expectedEmptyBottles,
      'status': instance.status,
    };
