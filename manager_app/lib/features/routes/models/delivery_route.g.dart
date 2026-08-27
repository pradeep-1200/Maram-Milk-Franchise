// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RouteAllocation _$RouteAllocationFromJson(Map<String, dynamic> json) =>
    _RouteAllocation(
      allocationId: json['allocationId'] as String?,
      dpId: json['dpId'] as String,
      dpName: json['dpName'] as String?,
      dpPhotoUrl: json['dpPhotoUrl'] as String?,
      dpPetrolBalance: (json['dpPetrolBalance'] as num?)?.toDouble() ?? 0.0,
      litresAllocated: (json['litresAllocated'] as num?)?.toDouble() ?? 0.0,
      items:
          (json['items'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      petrolAllowanceGiven: (json['petrolAllowanceGiven'] as num?)?.toInt(),
      isPetrolAllowanceComplete:
          json['isPetrolAllowanceComplete'] as bool? ?? false,
      status: json['status'] as String? ?? 'ASSIGNED',
      deliveryCompleted: json['deliveryCompleted'] as bool?,
      emptyBottles1L: (json['emptyBottles1L'] as num?)?.toInt(),
      emptyBottlesHalfL: (json['emptyBottlesHalfL'] as num?)?.toInt(),
      hasBottleReturnFlag: json['hasBottleReturnFlag'] as bool? ?? false,
      bottleReturnNote: json['bottleReturnNote'] as String?,
    );

Map<String, dynamic> _$RouteAllocationToJson(_RouteAllocation instance) =>
    <String, dynamic>{
      'allocationId': instance.allocationId,
      'dpId': instance.dpId,
      'dpName': instance.dpName,
      'dpPhotoUrl': instance.dpPhotoUrl,
      'dpPetrolBalance': instance.dpPetrolBalance,
      'litresAllocated': instance.litresAllocated,
      'items': instance.items,
      'petrolAllowanceGiven': instance.petrolAllowanceGiven,
      'isPetrolAllowanceComplete': instance.isPetrolAllowanceComplete,
      'status': instance.status,
      'deliveryCompleted': instance.deliveryCompleted,
      'emptyBottles1L': instance.emptyBottles1L,
      'emptyBottlesHalfL': instance.emptyBottlesHalfL,
      'hasBottleReturnFlag': instance.hasBottleReturnFlag,
      'bottleReturnNote': instance.bottleReturnNote,
    };

_DeliveryRoute _$DeliveryRouteFromJson(
  Map<String, dynamic> json,
) => _DeliveryRoute(
  id: json['routeId'] as String,
  name: json['routeName'] as String,
  area: json['zone'] as String,
  customerCount: (json['customerCount'] as num).toInt(),
  milkQuantity: (json['defaultLitres'] as num).toDouble(),
  expectedEmptyBottles: (json['expectedEmptyBottles'] as num?)?.toInt() ?? 0,
  fixedPetrolAllowance: (json['fixedPetrolAllowance'] as num?)?.toInt() ?? 80,
  allocations:
      (json['allocations'] as List<dynamic>?)
          ?.map((e) => RouteAllocation.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$DeliveryRouteToJson(_DeliveryRoute instance) =>
    <String, dynamic>{
      'routeId': instance.id,
      'routeName': instance.name,
      'zone': instance.area,
      'customerCount': instance.customerCount,
      'defaultLitres': instance.milkQuantity,
      'expectedEmptyBottles': instance.expectedEmptyBottles,
      'fixedPetrolAllowance': instance.fixedPetrolAllowance,
      'allocations': instance.allocations,
    };
