// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeliveryRoute _$DeliveryRouteFromJson(Map<String, dynamic> json) =>
    _DeliveryRoute(
      id: json['routeId'] as String,
      name: json['routeName'] as String,
      area: json['zone'] as String,
      customerCount: (json['customerCount'] as num).toInt(),
      milkQuantity: (json['defaultLitres'] as num).toDouble(),
      assignedDpId: json['assignedDpId'] as String?,
      assignedDpName: json['assignedDpName'] as String?,
      assignedDpPhotoUrl: json['assignedDpPhotoUrl'] as String?,
      allocationId: json['allocationId'] as String?,
      qty1LBottle: (json['qty1LBottle'] as num?)?.toInt() ?? 0,
      qtyHalfLBottle: (json['qtyHalfLBottle'] as num?)?.toInt() ?? 0,
      fixedPetrolAllowance:
          (json['fixedPetrolAllowance'] as num?)?.toInt() ?? 80,
      isPetrolAllowanceComplete:
          json['isPetrolAllowanceComplete'] as bool? ?? false,
      petrolAllowanceGiven: (json['petrolAllowanceGiven'] as num?)?.toInt(),
      deliveryCompleted: json['deliveryCompleted'] as bool?,
      emptyBottles1L: (json['emptyBottles1L'] as num?)?.toInt(),
      emptyBottlesHalfL: (json['emptyBottlesHalfL'] as num?)?.toInt(),
      hasBottleReturnFlag: json['hasBottleReturnFlag'] as bool? ?? false,
      bottleReturnNote: json['bottleReturnNote'] as String?,
    );

Map<String, dynamic> _$DeliveryRouteToJson(_DeliveryRoute instance) =>
    <String, dynamic>{
      'routeId': instance.id,
      'routeName': instance.name,
      'zone': instance.area,
      'customerCount': instance.customerCount,
      'defaultLitres': instance.milkQuantity,
      'assignedDpId': instance.assignedDpId,
      'assignedDpName': instance.assignedDpName,
      'assignedDpPhotoUrl': instance.assignedDpPhotoUrl,
      'allocationId': instance.allocationId,
      'qty1LBottle': instance.qty1LBottle,
      'qtyHalfLBottle': instance.qtyHalfLBottle,
      'fixedPetrolAllowance': instance.fixedPetrolAllowance,
      'isPetrolAllowanceComplete': instance.isPetrolAllowanceComplete,
      'petrolAllowanceGiven': instance.petrolAllowanceGiven,
      'deliveryCompleted': instance.deliveryCompleted,
      'emptyBottles1L': instance.emptyBottles1L,
      'emptyBottlesHalfL': instance.emptyBottlesHalfL,
      'hasBottleReturnFlag': instance.hasBottleReturnFlag,
      'bottleReturnNote': instance.bottleReturnNote,
    };
