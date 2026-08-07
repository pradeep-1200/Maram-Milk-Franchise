import 'package:freezed_annotation/freezed_annotation.dart';

part 'delivery_route.freezed.dart';
part 'delivery_route.g.dart';

@freezed
abstract class RouteAllocation with _$RouteAllocation {
  const factory RouteAllocation({
    String? allocationId,
    required String dpId,
    String? dpName,
    String? dpPhotoUrl,
    @Default(0.0) double dpPetrolBalance,
    @Default(0.0) double litresAllocated,
    @Default(0) int qty1LBottle,
    @Default(0) int qtyHalfLBottle,
    @Default(0) int qtyHalfLPacket,
    int? petrolAllowanceGiven,
    @Default(false) bool isPetrolAllowanceComplete,
    @Default('ASSIGNED') String status,
    bool? deliveryCompleted,
    int? emptyBottles1L,
    int? emptyBottlesHalfL,
    @Default(false) bool hasBottleReturnFlag,
    String? bottleReturnNote,
  }) = _RouteAllocation;

  factory RouteAllocation.fromJson(Map<String, dynamic> json) =>
      _$RouteAllocationFromJson(json);
}

@freezed
abstract class DeliveryRoute with _$DeliveryRoute {
  const factory DeliveryRoute({
    @JsonKey(name: 'routeId') required String id,
    @JsonKey(name: 'routeName') required String name,
    @JsonKey(name: 'zone') required String area,
    required int customerCount,
    @JsonKey(name: 'defaultLitres') required double milkQuantity,
    @Default(0) int expectedEmptyBottles,
    @Default(80) int fixedPetrolAllowance,
    @Default([]) List<RouteAllocation> allocations,
  }) = _DeliveryRoute;

  factory DeliveryRoute.fromJson(Map<String, dynamic> json) =>
      _$DeliveryRouteFromJson(json);
}

extension DeliveryRouteX on DeliveryRoute {
  bool get deliveryCompleted => allocations.isNotEmpty && allocations.every((a) => a.status == 'COMPLETED');
  bool get hasIncompleteDeliveries => allocations.isNotEmpty && allocations.any((a) => a.status != 'COMPLETED');
  bool get hasBottleReturnFlag => allocations.any((a) => a.hasBottleReturnFlag);
  
  double get allocatedLitres => allocations.fold(0.0, (sum, a) => sum + a.litresAllocated);

  String? get assignedDpId => allocations.isNotEmpty ? allocations.first.dpId : null;
  double get assignedDpPetrolBalance => allocations.isNotEmpty ? allocations.first.dpPetrolBalance : 0.0;
  bool get isPetrolAllowanceComplete => allocations.isNotEmpty && allocations.every((a) => a.isPetrolAllowanceComplete);
  int? get petrolAllowanceGiven => allocations.isNotEmpty ? allocations.first.petrolAllowanceGiven : null;
  int get qty1LBottle => allocations.fold(0, (sum, a) => sum + a.qty1LBottle);
  int get qtyHalfLBottle => allocations.fold(0, (sum, a) => sum + a.qtyHalfLBottle);
  int get qtyHalfLPacket => allocations.fold(0, (sum, a) => sum + a.qtyHalfLPacket);
}
