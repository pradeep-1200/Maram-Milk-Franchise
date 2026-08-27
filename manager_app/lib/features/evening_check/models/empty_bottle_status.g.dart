// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'empty_bottle_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EmptyBottleStatusItem _$EmptyBottleStatusItemFromJson(
  Map<String, dynamic> json,
) => _EmptyBottleStatusItem(
  inventoryItemId: json['inventoryItemId'] as String,
  name: json['name'] as String,
  unit: json['unit'] as String,
  section: json['section'] as String?,
  material: json['material'] as String?,
  carriedOver: (json['carriedOver'] as num?)?.toInt() ?? 0,
  allocated: (json['allocated'] as num?)?.toInt() ?? 0,
  expected: (json['expected'] as num?)?.toInt() ?? 0,
  actualDelivered: (json['actualDelivered'] as num?)?.toInt() ?? 0,
  collected: (json['collected'] as num?)?.toInt() ?? 0,
  broken: (json['broken'] as num?)?.toInt() ?? 0,
  outstanding: (json['outstanding'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$EmptyBottleStatusItemToJson(
  _EmptyBottleStatusItem instance,
) => <String, dynamic>{
  'inventoryItemId': instance.inventoryItemId,
  'name': instance.name,
  'unit': instance.unit,
  'section': instance.section,
  'material': instance.material,
  'carriedOver': instance.carriedOver,
  'allocated': instance.allocated,
  'expected': instance.expected,
  'actualDelivered': instance.actualDelivered,
  'collected': instance.collected,
  'broken': instance.broken,
  'outstanding': instance.outstanding,
};

_EmptyBottleStatus _$EmptyBottleStatusFromJson(Map<String, dynamic> json) =>
    _EmptyBottleStatus(
      routeId: json['routeId'] as String,
      routeName: json['routeName'] as String,
      dpId: json['dpId'] as String?,
      dpName: json['dpName'] as String?,
      deliveryCompleted: json['deliveryCompleted'] as bool,
      expectedEmptyBottles:
          (json['expectedEmptyBottles'] as num?)?.toInt() ?? 0,
      flagIssue: json['flagIssue'] as bool? ?? false,
      reason: json['reason'] as String?,
      notes: json['notes'] as String?,
      status: json['status'] as String,
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) =>
                    EmptyBottleStatusItem.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$EmptyBottleStatusToJson(_EmptyBottleStatus instance) =>
    <String, dynamic>{
      'routeId': instance.routeId,
      'routeName': instance.routeName,
      'dpId': instance.dpId,
      'dpName': instance.dpName,
      'deliveryCompleted': instance.deliveryCompleted,
      'expectedEmptyBottles': instance.expectedEmptyBottles,
      'flagIssue': instance.flagIssue,
      'reason': instance.reason,
      'notes': instance.notes,
      'status': instance.status,
      'items': instance.items,
    };
