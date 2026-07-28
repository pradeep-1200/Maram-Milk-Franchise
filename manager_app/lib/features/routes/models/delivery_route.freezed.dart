// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery_route.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeliveryRoute {

@JsonKey(name: 'routeId') String get id;@JsonKey(name: 'routeName') String get name;@JsonKey(name: 'zone') String get area; int get customerCount;@JsonKey(name: 'defaultLitres') double get milkQuantity; String? get assignedDpId; String? get assignedDpName; String? get assignedDpPhotoUrl; double get assignedDpPetrolBalance; String? get allocationId; int get qty1LBottle; int get qtyHalfLBottle; int get qtyHalfLPacket; int get expectedEmptyBottles; int get fixedPetrolAllowance; bool get isPetrolAllowanceComplete; int? get petrolAllowanceGiven; bool? get deliveryCompleted; int? get emptyBottles1L; int? get emptyBottlesHalfL; bool get hasBottleReturnFlag; String? get bottleReturnNote;
/// Create a copy of DeliveryRoute
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeliveryRouteCopyWith<DeliveryRoute> get copyWith => _$DeliveryRouteCopyWithImpl<DeliveryRoute>(this as DeliveryRoute, _$identity);

  /// Serializes this DeliveryRoute to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeliveryRoute&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.area, area) || other.area == area)&&(identical(other.customerCount, customerCount) || other.customerCount == customerCount)&&(identical(other.milkQuantity, milkQuantity) || other.milkQuantity == milkQuantity)&&(identical(other.assignedDpId, assignedDpId) || other.assignedDpId == assignedDpId)&&(identical(other.assignedDpName, assignedDpName) || other.assignedDpName == assignedDpName)&&(identical(other.assignedDpPhotoUrl, assignedDpPhotoUrl) || other.assignedDpPhotoUrl == assignedDpPhotoUrl)&&(identical(other.assignedDpPetrolBalance, assignedDpPetrolBalance) || other.assignedDpPetrolBalance == assignedDpPetrolBalance)&&(identical(other.allocationId, allocationId) || other.allocationId == allocationId)&&(identical(other.qty1LBottle, qty1LBottle) || other.qty1LBottle == qty1LBottle)&&(identical(other.qtyHalfLBottle, qtyHalfLBottle) || other.qtyHalfLBottle == qtyHalfLBottle)&&(identical(other.qtyHalfLPacket, qtyHalfLPacket) || other.qtyHalfLPacket == qtyHalfLPacket)&&(identical(other.expectedEmptyBottles, expectedEmptyBottles) || other.expectedEmptyBottles == expectedEmptyBottles)&&(identical(other.fixedPetrolAllowance, fixedPetrolAllowance) || other.fixedPetrolAllowance == fixedPetrolAllowance)&&(identical(other.isPetrolAllowanceComplete, isPetrolAllowanceComplete) || other.isPetrolAllowanceComplete == isPetrolAllowanceComplete)&&(identical(other.petrolAllowanceGiven, petrolAllowanceGiven) || other.petrolAllowanceGiven == petrolAllowanceGiven)&&(identical(other.deliveryCompleted, deliveryCompleted) || other.deliveryCompleted == deliveryCompleted)&&(identical(other.emptyBottles1L, emptyBottles1L) || other.emptyBottles1L == emptyBottles1L)&&(identical(other.emptyBottlesHalfL, emptyBottlesHalfL) || other.emptyBottlesHalfL == emptyBottlesHalfL)&&(identical(other.hasBottleReturnFlag, hasBottleReturnFlag) || other.hasBottleReturnFlag == hasBottleReturnFlag)&&(identical(other.bottleReturnNote, bottleReturnNote) || other.bottleReturnNote == bottleReturnNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,area,customerCount,milkQuantity,assignedDpId,assignedDpName,assignedDpPhotoUrl,assignedDpPetrolBalance,allocationId,qty1LBottle,qtyHalfLBottle,qtyHalfLPacket,expectedEmptyBottles,fixedPetrolAllowance,isPetrolAllowanceComplete,petrolAllowanceGiven,deliveryCompleted,emptyBottles1L,emptyBottlesHalfL,hasBottleReturnFlag,bottleReturnNote]);

@override
String toString() {
  return 'DeliveryRoute(id: $id, name: $name, area: $area, customerCount: $customerCount, milkQuantity: $milkQuantity, assignedDpId: $assignedDpId, assignedDpName: $assignedDpName, assignedDpPhotoUrl: $assignedDpPhotoUrl, assignedDpPetrolBalance: $assignedDpPetrolBalance, allocationId: $allocationId, qty1LBottle: $qty1LBottle, qtyHalfLBottle: $qtyHalfLBottle, qtyHalfLPacket: $qtyHalfLPacket, expectedEmptyBottles: $expectedEmptyBottles, fixedPetrolAllowance: $fixedPetrolAllowance, isPetrolAllowanceComplete: $isPetrolAllowanceComplete, petrolAllowanceGiven: $petrolAllowanceGiven, deliveryCompleted: $deliveryCompleted, emptyBottles1L: $emptyBottles1L, emptyBottlesHalfL: $emptyBottlesHalfL, hasBottleReturnFlag: $hasBottleReturnFlag, bottleReturnNote: $bottleReturnNote)';
}


}

/// @nodoc
abstract mixin class $DeliveryRouteCopyWith<$Res>  {
  factory $DeliveryRouteCopyWith(DeliveryRoute value, $Res Function(DeliveryRoute) _then) = _$DeliveryRouteCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'routeId') String id,@JsonKey(name: 'routeName') String name,@JsonKey(name: 'zone') String area, int customerCount,@JsonKey(name: 'defaultLitres') double milkQuantity, String? assignedDpId, String? assignedDpName, String? assignedDpPhotoUrl, double assignedDpPetrolBalance, String? allocationId, int qty1LBottle, int qtyHalfLBottle, int qtyHalfLPacket, int expectedEmptyBottles, int fixedPetrolAllowance, bool isPetrolAllowanceComplete, int? petrolAllowanceGiven, bool? deliveryCompleted, int? emptyBottles1L, int? emptyBottlesHalfL, bool hasBottleReturnFlag, String? bottleReturnNote
});




}
/// @nodoc
class _$DeliveryRouteCopyWithImpl<$Res>
    implements $DeliveryRouteCopyWith<$Res> {
  _$DeliveryRouteCopyWithImpl(this._self, this._then);

  final DeliveryRoute _self;
  final $Res Function(DeliveryRoute) _then;

/// Create a copy of DeliveryRoute
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? area = null,Object? customerCount = null,Object? milkQuantity = null,Object? assignedDpId = freezed,Object? assignedDpName = freezed,Object? assignedDpPhotoUrl = freezed,Object? assignedDpPetrolBalance = null,Object? allocationId = freezed,Object? qty1LBottle = null,Object? qtyHalfLBottle = null,Object? qtyHalfLPacket = null,Object? expectedEmptyBottles = null,Object? fixedPetrolAllowance = null,Object? isPetrolAllowanceComplete = null,Object? petrolAllowanceGiven = freezed,Object? deliveryCompleted = freezed,Object? emptyBottles1L = freezed,Object? emptyBottlesHalfL = freezed,Object? hasBottleReturnFlag = null,Object? bottleReturnNote = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String,customerCount: null == customerCount ? _self.customerCount : customerCount // ignore: cast_nullable_to_non_nullable
as int,milkQuantity: null == milkQuantity ? _self.milkQuantity : milkQuantity // ignore: cast_nullable_to_non_nullable
as double,assignedDpId: freezed == assignedDpId ? _self.assignedDpId : assignedDpId // ignore: cast_nullable_to_non_nullable
as String?,assignedDpName: freezed == assignedDpName ? _self.assignedDpName : assignedDpName // ignore: cast_nullable_to_non_nullable
as String?,assignedDpPhotoUrl: freezed == assignedDpPhotoUrl ? _self.assignedDpPhotoUrl : assignedDpPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,assignedDpPetrolBalance: null == assignedDpPetrolBalance ? _self.assignedDpPetrolBalance : assignedDpPetrolBalance // ignore: cast_nullable_to_non_nullable
as double,allocationId: freezed == allocationId ? _self.allocationId : allocationId // ignore: cast_nullable_to_non_nullable
as String?,qty1LBottle: null == qty1LBottle ? _self.qty1LBottle : qty1LBottle // ignore: cast_nullable_to_non_nullable
as int,qtyHalfLBottle: null == qtyHalfLBottle ? _self.qtyHalfLBottle : qtyHalfLBottle // ignore: cast_nullable_to_non_nullable
as int,qtyHalfLPacket: null == qtyHalfLPacket ? _self.qtyHalfLPacket : qtyHalfLPacket // ignore: cast_nullable_to_non_nullable
as int,expectedEmptyBottles: null == expectedEmptyBottles ? _self.expectedEmptyBottles : expectedEmptyBottles // ignore: cast_nullable_to_non_nullable
as int,fixedPetrolAllowance: null == fixedPetrolAllowance ? _self.fixedPetrolAllowance : fixedPetrolAllowance // ignore: cast_nullable_to_non_nullable
as int,isPetrolAllowanceComplete: null == isPetrolAllowanceComplete ? _self.isPetrolAllowanceComplete : isPetrolAllowanceComplete // ignore: cast_nullable_to_non_nullable
as bool,petrolAllowanceGiven: freezed == petrolAllowanceGiven ? _self.petrolAllowanceGiven : petrolAllowanceGiven // ignore: cast_nullable_to_non_nullable
as int?,deliveryCompleted: freezed == deliveryCompleted ? _self.deliveryCompleted : deliveryCompleted // ignore: cast_nullable_to_non_nullable
as bool?,emptyBottles1L: freezed == emptyBottles1L ? _self.emptyBottles1L : emptyBottles1L // ignore: cast_nullable_to_non_nullable
as int?,emptyBottlesHalfL: freezed == emptyBottlesHalfL ? _self.emptyBottlesHalfL : emptyBottlesHalfL // ignore: cast_nullable_to_non_nullable
as int?,hasBottleReturnFlag: null == hasBottleReturnFlag ? _self.hasBottleReturnFlag : hasBottleReturnFlag // ignore: cast_nullable_to_non_nullable
as bool,bottleReturnNote: freezed == bottleReturnNote ? _self.bottleReturnNote : bottleReturnNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeliveryRoute].
extension DeliveryRoutePatterns on DeliveryRoute {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeliveryRoute value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeliveryRoute() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeliveryRoute value)  $default,){
final _that = this;
switch (_that) {
case _DeliveryRoute():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeliveryRoute value)?  $default,){
final _that = this;
switch (_that) {
case _DeliveryRoute() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'routeId')  String id, @JsonKey(name: 'routeName')  String name, @JsonKey(name: 'zone')  String area,  int customerCount, @JsonKey(name: 'defaultLitres')  double milkQuantity,  String? assignedDpId,  String? assignedDpName,  String? assignedDpPhotoUrl,  double assignedDpPetrolBalance,  String? allocationId,  int qty1LBottle,  int qtyHalfLBottle,  int qtyHalfLPacket,  int expectedEmptyBottles,  int fixedPetrolAllowance,  bool isPetrolAllowanceComplete,  int? petrolAllowanceGiven,  bool? deliveryCompleted,  int? emptyBottles1L,  int? emptyBottlesHalfL,  bool hasBottleReturnFlag,  String? bottleReturnNote)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeliveryRoute() when $default != null:
return $default(_that.id,_that.name,_that.area,_that.customerCount,_that.milkQuantity,_that.assignedDpId,_that.assignedDpName,_that.assignedDpPhotoUrl,_that.assignedDpPetrolBalance,_that.allocationId,_that.qty1LBottle,_that.qtyHalfLBottle,_that.qtyHalfLPacket,_that.expectedEmptyBottles,_that.fixedPetrolAllowance,_that.isPetrolAllowanceComplete,_that.petrolAllowanceGiven,_that.deliveryCompleted,_that.emptyBottles1L,_that.emptyBottlesHalfL,_that.hasBottleReturnFlag,_that.bottleReturnNote);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'routeId')  String id, @JsonKey(name: 'routeName')  String name, @JsonKey(name: 'zone')  String area,  int customerCount, @JsonKey(name: 'defaultLitres')  double milkQuantity,  String? assignedDpId,  String? assignedDpName,  String? assignedDpPhotoUrl,  double assignedDpPetrolBalance,  String? allocationId,  int qty1LBottle,  int qtyHalfLBottle,  int qtyHalfLPacket,  int expectedEmptyBottles,  int fixedPetrolAllowance,  bool isPetrolAllowanceComplete,  int? petrolAllowanceGiven,  bool? deliveryCompleted,  int? emptyBottles1L,  int? emptyBottlesHalfL,  bool hasBottleReturnFlag,  String? bottleReturnNote)  $default,) {final _that = this;
switch (_that) {
case _DeliveryRoute():
return $default(_that.id,_that.name,_that.area,_that.customerCount,_that.milkQuantity,_that.assignedDpId,_that.assignedDpName,_that.assignedDpPhotoUrl,_that.assignedDpPetrolBalance,_that.allocationId,_that.qty1LBottle,_that.qtyHalfLBottle,_that.qtyHalfLPacket,_that.expectedEmptyBottles,_that.fixedPetrolAllowance,_that.isPetrolAllowanceComplete,_that.petrolAllowanceGiven,_that.deliveryCompleted,_that.emptyBottles1L,_that.emptyBottlesHalfL,_that.hasBottleReturnFlag,_that.bottleReturnNote);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'routeId')  String id, @JsonKey(name: 'routeName')  String name, @JsonKey(name: 'zone')  String area,  int customerCount, @JsonKey(name: 'defaultLitres')  double milkQuantity,  String? assignedDpId,  String? assignedDpName,  String? assignedDpPhotoUrl,  double assignedDpPetrolBalance,  String? allocationId,  int qty1LBottle,  int qtyHalfLBottle,  int qtyHalfLPacket,  int expectedEmptyBottles,  int fixedPetrolAllowance,  bool isPetrolAllowanceComplete,  int? petrolAllowanceGiven,  bool? deliveryCompleted,  int? emptyBottles1L,  int? emptyBottlesHalfL,  bool hasBottleReturnFlag,  String? bottleReturnNote)?  $default,) {final _that = this;
switch (_that) {
case _DeliveryRoute() when $default != null:
return $default(_that.id,_that.name,_that.area,_that.customerCount,_that.milkQuantity,_that.assignedDpId,_that.assignedDpName,_that.assignedDpPhotoUrl,_that.assignedDpPetrolBalance,_that.allocationId,_that.qty1LBottle,_that.qtyHalfLBottle,_that.qtyHalfLPacket,_that.expectedEmptyBottles,_that.fixedPetrolAllowance,_that.isPetrolAllowanceComplete,_that.petrolAllowanceGiven,_that.deliveryCompleted,_that.emptyBottles1L,_that.emptyBottlesHalfL,_that.hasBottleReturnFlag,_that.bottleReturnNote);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeliveryRoute implements DeliveryRoute {
  const _DeliveryRoute({@JsonKey(name: 'routeId') required this.id, @JsonKey(name: 'routeName') required this.name, @JsonKey(name: 'zone') required this.area, required this.customerCount, @JsonKey(name: 'defaultLitres') required this.milkQuantity, this.assignedDpId, this.assignedDpName, this.assignedDpPhotoUrl, this.assignedDpPetrolBalance = 0.0, this.allocationId, this.qty1LBottle = 0, this.qtyHalfLBottle = 0, this.qtyHalfLPacket = 0, this.expectedEmptyBottles = 0, this.fixedPetrolAllowance = 80, this.isPetrolAllowanceComplete = false, this.petrolAllowanceGiven, this.deliveryCompleted, this.emptyBottles1L, this.emptyBottlesHalfL, this.hasBottleReturnFlag = false, this.bottleReturnNote});
  factory _DeliveryRoute.fromJson(Map<String, dynamic> json) => _$DeliveryRouteFromJson(json);

@override@JsonKey(name: 'routeId') final  String id;
@override@JsonKey(name: 'routeName') final  String name;
@override@JsonKey(name: 'zone') final  String area;
@override final  int customerCount;
@override@JsonKey(name: 'defaultLitres') final  double milkQuantity;
@override final  String? assignedDpId;
@override final  String? assignedDpName;
@override final  String? assignedDpPhotoUrl;
@override@JsonKey() final  double assignedDpPetrolBalance;
@override final  String? allocationId;
@override@JsonKey() final  int qty1LBottle;
@override@JsonKey() final  int qtyHalfLBottle;
@override@JsonKey() final  int qtyHalfLPacket;
@override@JsonKey() final  int expectedEmptyBottles;
@override@JsonKey() final  int fixedPetrolAllowance;
@override@JsonKey() final  bool isPetrolAllowanceComplete;
@override final  int? petrolAllowanceGiven;
@override final  bool? deliveryCompleted;
@override final  int? emptyBottles1L;
@override final  int? emptyBottlesHalfL;
@override@JsonKey() final  bool hasBottleReturnFlag;
@override final  String? bottleReturnNote;

/// Create a copy of DeliveryRoute
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeliveryRouteCopyWith<_DeliveryRoute> get copyWith => __$DeliveryRouteCopyWithImpl<_DeliveryRoute>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeliveryRouteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeliveryRoute&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.area, area) || other.area == area)&&(identical(other.customerCount, customerCount) || other.customerCount == customerCount)&&(identical(other.milkQuantity, milkQuantity) || other.milkQuantity == milkQuantity)&&(identical(other.assignedDpId, assignedDpId) || other.assignedDpId == assignedDpId)&&(identical(other.assignedDpName, assignedDpName) || other.assignedDpName == assignedDpName)&&(identical(other.assignedDpPhotoUrl, assignedDpPhotoUrl) || other.assignedDpPhotoUrl == assignedDpPhotoUrl)&&(identical(other.assignedDpPetrolBalance, assignedDpPetrolBalance) || other.assignedDpPetrolBalance == assignedDpPetrolBalance)&&(identical(other.allocationId, allocationId) || other.allocationId == allocationId)&&(identical(other.qty1LBottle, qty1LBottle) || other.qty1LBottle == qty1LBottle)&&(identical(other.qtyHalfLBottle, qtyHalfLBottle) || other.qtyHalfLBottle == qtyHalfLBottle)&&(identical(other.qtyHalfLPacket, qtyHalfLPacket) || other.qtyHalfLPacket == qtyHalfLPacket)&&(identical(other.expectedEmptyBottles, expectedEmptyBottles) || other.expectedEmptyBottles == expectedEmptyBottles)&&(identical(other.fixedPetrolAllowance, fixedPetrolAllowance) || other.fixedPetrolAllowance == fixedPetrolAllowance)&&(identical(other.isPetrolAllowanceComplete, isPetrolAllowanceComplete) || other.isPetrolAllowanceComplete == isPetrolAllowanceComplete)&&(identical(other.petrolAllowanceGiven, petrolAllowanceGiven) || other.petrolAllowanceGiven == petrolAllowanceGiven)&&(identical(other.deliveryCompleted, deliveryCompleted) || other.deliveryCompleted == deliveryCompleted)&&(identical(other.emptyBottles1L, emptyBottles1L) || other.emptyBottles1L == emptyBottles1L)&&(identical(other.emptyBottlesHalfL, emptyBottlesHalfL) || other.emptyBottlesHalfL == emptyBottlesHalfL)&&(identical(other.hasBottleReturnFlag, hasBottleReturnFlag) || other.hasBottleReturnFlag == hasBottleReturnFlag)&&(identical(other.bottleReturnNote, bottleReturnNote) || other.bottleReturnNote == bottleReturnNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,area,customerCount,milkQuantity,assignedDpId,assignedDpName,assignedDpPhotoUrl,assignedDpPetrolBalance,allocationId,qty1LBottle,qtyHalfLBottle,qtyHalfLPacket,expectedEmptyBottles,fixedPetrolAllowance,isPetrolAllowanceComplete,petrolAllowanceGiven,deliveryCompleted,emptyBottles1L,emptyBottlesHalfL,hasBottleReturnFlag,bottleReturnNote]);

@override
String toString() {
  return 'DeliveryRoute(id: $id, name: $name, area: $area, customerCount: $customerCount, milkQuantity: $milkQuantity, assignedDpId: $assignedDpId, assignedDpName: $assignedDpName, assignedDpPhotoUrl: $assignedDpPhotoUrl, assignedDpPetrolBalance: $assignedDpPetrolBalance, allocationId: $allocationId, qty1LBottle: $qty1LBottle, qtyHalfLBottle: $qtyHalfLBottle, qtyHalfLPacket: $qtyHalfLPacket, expectedEmptyBottles: $expectedEmptyBottles, fixedPetrolAllowance: $fixedPetrolAllowance, isPetrolAllowanceComplete: $isPetrolAllowanceComplete, petrolAllowanceGiven: $petrolAllowanceGiven, deliveryCompleted: $deliveryCompleted, emptyBottles1L: $emptyBottles1L, emptyBottlesHalfL: $emptyBottlesHalfL, hasBottleReturnFlag: $hasBottleReturnFlag, bottleReturnNote: $bottleReturnNote)';
}


}

/// @nodoc
abstract mixin class _$DeliveryRouteCopyWith<$Res> implements $DeliveryRouteCopyWith<$Res> {
  factory _$DeliveryRouteCopyWith(_DeliveryRoute value, $Res Function(_DeliveryRoute) _then) = __$DeliveryRouteCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'routeId') String id,@JsonKey(name: 'routeName') String name,@JsonKey(name: 'zone') String area, int customerCount,@JsonKey(name: 'defaultLitres') double milkQuantity, String? assignedDpId, String? assignedDpName, String? assignedDpPhotoUrl, double assignedDpPetrolBalance, String? allocationId, int qty1LBottle, int qtyHalfLBottle, int qtyHalfLPacket, int expectedEmptyBottles, int fixedPetrolAllowance, bool isPetrolAllowanceComplete, int? petrolAllowanceGiven, bool? deliveryCompleted, int? emptyBottles1L, int? emptyBottlesHalfL, bool hasBottleReturnFlag, String? bottleReturnNote
});




}
/// @nodoc
class __$DeliveryRouteCopyWithImpl<$Res>
    implements _$DeliveryRouteCopyWith<$Res> {
  __$DeliveryRouteCopyWithImpl(this._self, this._then);

  final _DeliveryRoute _self;
  final $Res Function(_DeliveryRoute) _then;

/// Create a copy of DeliveryRoute
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? area = null,Object? customerCount = null,Object? milkQuantity = null,Object? assignedDpId = freezed,Object? assignedDpName = freezed,Object? assignedDpPhotoUrl = freezed,Object? assignedDpPetrolBalance = null,Object? allocationId = freezed,Object? qty1LBottle = null,Object? qtyHalfLBottle = null,Object? qtyHalfLPacket = null,Object? expectedEmptyBottles = null,Object? fixedPetrolAllowance = null,Object? isPetrolAllowanceComplete = null,Object? petrolAllowanceGiven = freezed,Object? deliveryCompleted = freezed,Object? emptyBottles1L = freezed,Object? emptyBottlesHalfL = freezed,Object? hasBottleReturnFlag = null,Object? bottleReturnNote = freezed,}) {
  return _then(_DeliveryRoute(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String,customerCount: null == customerCount ? _self.customerCount : customerCount // ignore: cast_nullable_to_non_nullable
as int,milkQuantity: null == milkQuantity ? _self.milkQuantity : milkQuantity // ignore: cast_nullable_to_non_nullable
as double,assignedDpId: freezed == assignedDpId ? _self.assignedDpId : assignedDpId // ignore: cast_nullable_to_non_nullable
as String?,assignedDpName: freezed == assignedDpName ? _self.assignedDpName : assignedDpName // ignore: cast_nullable_to_non_nullable
as String?,assignedDpPhotoUrl: freezed == assignedDpPhotoUrl ? _self.assignedDpPhotoUrl : assignedDpPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,assignedDpPetrolBalance: null == assignedDpPetrolBalance ? _self.assignedDpPetrolBalance : assignedDpPetrolBalance // ignore: cast_nullable_to_non_nullable
as double,allocationId: freezed == allocationId ? _self.allocationId : allocationId // ignore: cast_nullable_to_non_nullable
as String?,qty1LBottle: null == qty1LBottle ? _self.qty1LBottle : qty1LBottle // ignore: cast_nullable_to_non_nullable
as int,qtyHalfLBottle: null == qtyHalfLBottle ? _self.qtyHalfLBottle : qtyHalfLBottle // ignore: cast_nullable_to_non_nullable
as int,qtyHalfLPacket: null == qtyHalfLPacket ? _self.qtyHalfLPacket : qtyHalfLPacket // ignore: cast_nullable_to_non_nullable
as int,expectedEmptyBottles: null == expectedEmptyBottles ? _self.expectedEmptyBottles : expectedEmptyBottles // ignore: cast_nullable_to_non_nullable
as int,fixedPetrolAllowance: null == fixedPetrolAllowance ? _self.fixedPetrolAllowance : fixedPetrolAllowance // ignore: cast_nullable_to_non_nullable
as int,isPetrolAllowanceComplete: null == isPetrolAllowanceComplete ? _self.isPetrolAllowanceComplete : isPetrolAllowanceComplete // ignore: cast_nullable_to_non_nullable
as bool,petrolAllowanceGiven: freezed == petrolAllowanceGiven ? _self.petrolAllowanceGiven : petrolAllowanceGiven // ignore: cast_nullable_to_non_nullable
as int?,deliveryCompleted: freezed == deliveryCompleted ? _self.deliveryCompleted : deliveryCompleted // ignore: cast_nullable_to_non_nullable
as bool?,emptyBottles1L: freezed == emptyBottles1L ? _self.emptyBottles1L : emptyBottles1L // ignore: cast_nullable_to_non_nullable
as int?,emptyBottlesHalfL: freezed == emptyBottlesHalfL ? _self.emptyBottlesHalfL : emptyBottlesHalfL // ignore: cast_nullable_to_non_nullable
as int?,hasBottleReturnFlag: null == hasBottleReturnFlag ? _self.hasBottleReturnFlag : hasBottleReturnFlag // ignore: cast_nullable_to_non_nullable
as bool,bottleReturnNote: freezed == bottleReturnNote ? _self.bottleReturnNote : bottleReturnNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
