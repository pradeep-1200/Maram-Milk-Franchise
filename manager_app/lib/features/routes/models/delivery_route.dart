import 'package:freezed_annotation/freezed_annotation.dart';

part 'delivery_route.freezed.dart';
part 'delivery_route.g.dart';

@freezed
abstract class DeliveryRoute with _$DeliveryRoute {
  const factory DeliveryRoute({
    @JsonKey(name: 'routeId') required String id,
    @JsonKey(name: 'routeName') required String name,
    @JsonKey(name: 'zone') required String area,
    required int customerCount,
    @JsonKey(name: 'defaultLitres') required double milkQuantity,
    String? assignedDpId,
    String? assignedDpName,
    String? assignedDpPhotoUrl,
    String? allocationId,
    @Default(0) int qty1LBottle,
    @Default(0) int qtyHalfLBottle,
    @Default(0) int qtyHalfLPacket,
    @Default(80) int fixedPetrolAllowance,
    @Default(false) bool isPetrolAllowanceComplete,
    int? petrolAllowanceGiven,
    bool? deliveryCompleted,
    int? emptyBottles1L,
    int? emptyBottlesHalfL,
    @Default(false) bool hasBottleReturnFlag,
    String? bottleReturnNote,
  }) = _DeliveryRoute;

  factory DeliveryRoute.fromJson(Map<String, dynamic> json) =>
      _$DeliveryRouteFromJson(json);
}
