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
mixin _$RouteAllocation {

 String? get allocationId; String get dpId; String? get dpName; String? get dpPhotoUrl; double get dpPetrolBalance; double get litresAllocated; Map<String, int> get items; int? get petrolAllowanceGiven; bool get isPetrolAllowanceComplete; String get status; bool? get deliveryCompleted; int? get emptyBottles1L; int? get emptyBottlesHalfL; bool get hasBottleReturnFlag; String? get bottleReturnNote;
/// Create a copy of RouteAllocation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteAllocationCopyWith<RouteAllocation> get copyWith => _$RouteAllocationCopyWithImpl<RouteAllocation>(this as RouteAllocation, _$identity);

  /// Serializes this RouteAllocation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteAllocation&&(identical(other.allocationId, allocationId) || other.allocationId == allocationId)&&(identical(other.dpId, dpId) || other.dpId == dpId)&&(identical(other.dpName, dpName) || other.dpName == dpName)&&(identical(other.dpPhotoUrl, dpPhotoUrl) || other.dpPhotoUrl == dpPhotoUrl)&&(identical(other.dpPetrolBalance, dpPetrolBalance) || other.dpPetrolBalance == dpPetrolBalance)&&(identical(other.litresAllocated, litresAllocated) || other.litresAllocated == litresAllocated)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.petrolAllowanceGiven, petrolAllowanceGiven) || other.petrolAllowanceGiven == petrolAllowanceGiven)&&(identical(other.isPetrolAllowanceComplete, isPetrolAllowanceComplete) || other.isPetrolAllowanceComplete == isPetrolAllowanceComplete)&&(identical(other.status, status) || other.status == status)&&(identical(other.deliveryCompleted, deliveryCompleted) || other.deliveryCompleted == deliveryCompleted)&&(identical(other.emptyBottles1L, emptyBottles1L) || other.emptyBottles1L == emptyBottles1L)&&(identical(other.emptyBottlesHalfL, emptyBottlesHalfL) || other.emptyBottlesHalfL == emptyBottlesHalfL)&&(identical(other.hasBottleReturnFlag, hasBottleReturnFlag) || other.hasBottleReturnFlag == hasBottleReturnFlag)&&(identical(other.bottleReturnNote, bottleReturnNote) || other.bottleReturnNote == bottleReturnNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,allocationId,dpId,dpName,dpPhotoUrl,dpPetrolBalance,litresAllocated,const DeepCollectionEquality().hash(items),petrolAllowanceGiven,isPetrolAllowanceComplete,status,deliveryCompleted,emptyBottles1L,emptyBottlesHalfL,hasBottleReturnFlag,bottleReturnNote);

@override
String toString() {
  return 'RouteAllocation(allocationId: $allocationId, dpId: $dpId, dpName: $dpName, dpPhotoUrl: $dpPhotoUrl, dpPetrolBalance: $dpPetrolBalance, litresAllocated: $litresAllocated, items: $items, petrolAllowanceGiven: $petrolAllowanceGiven, isPetrolAllowanceComplete: $isPetrolAllowanceComplete, status: $status, deliveryCompleted: $deliveryCompleted, emptyBottles1L: $emptyBottles1L, emptyBottlesHalfL: $emptyBottlesHalfL, hasBottleReturnFlag: $hasBottleReturnFlag, bottleReturnNote: $bottleReturnNote)';
}


}

/// @nodoc
abstract mixin class $RouteAllocationCopyWith<$Res>  {
  factory $RouteAllocationCopyWith(RouteAllocation value, $Res Function(RouteAllocation) _then) = _$RouteAllocationCopyWithImpl;
@useResult
$Res call({
 String? allocationId, String dpId, String? dpName, String? dpPhotoUrl, double dpPetrolBalance, double litresAllocated, Map<String, int> items, int? petrolAllowanceGiven, bool isPetrolAllowanceComplete, String status, bool? deliveryCompleted, int? emptyBottles1L, int? emptyBottlesHalfL, bool hasBottleReturnFlag, String? bottleReturnNote
});




}
/// @nodoc
class _$RouteAllocationCopyWithImpl<$Res>
    implements $RouteAllocationCopyWith<$Res> {
  _$RouteAllocationCopyWithImpl(this._self, this._then);

  final RouteAllocation _self;
  final $Res Function(RouteAllocation) _then;

/// Create a copy of RouteAllocation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? allocationId = freezed,Object? dpId = null,Object? dpName = freezed,Object? dpPhotoUrl = freezed,Object? dpPetrolBalance = null,Object? litresAllocated = null,Object? items = null,Object? petrolAllowanceGiven = freezed,Object? isPetrolAllowanceComplete = null,Object? status = null,Object? deliveryCompleted = freezed,Object? emptyBottles1L = freezed,Object? emptyBottlesHalfL = freezed,Object? hasBottleReturnFlag = null,Object? bottleReturnNote = freezed,}) {
  return _then(_self.copyWith(
allocationId: freezed == allocationId ? _self.allocationId : allocationId // ignore: cast_nullable_to_non_nullable
as String?,dpId: null == dpId ? _self.dpId : dpId // ignore: cast_nullable_to_non_nullable
as String,dpName: freezed == dpName ? _self.dpName : dpName // ignore: cast_nullable_to_non_nullable
as String?,dpPhotoUrl: freezed == dpPhotoUrl ? _self.dpPhotoUrl : dpPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,dpPetrolBalance: null == dpPetrolBalance ? _self.dpPetrolBalance : dpPetrolBalance // ignore: cast_nullable_to_non_nullable
as double,litresAllocated: null == litresAllocated ? _self.litresAllocated : litresAllocated // ignore: cast_nullable_to_non_nullable
as double,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as Map<String, int>,petrolAllowanceGiven: freezed == petrolAllowanceGiven ? _self.petrolAllowanceGiven : petrolAllowanceGiven // ignore: cast_nullable_to_non_nullable
as int?,isPetrolAllowanceComplete: null == isPetrolAllowanceComplete ? _self.isPetrolAllowanceComplete : isPetrolAllowanceComplete // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,deliveryCompleted: freezed == deliveryCompleted ? _self.deliveryCompleted : deliveryCompleted // ignore: cast_nullable_to_non_nullable
as bool?,emptyBottles1L: freezed == emptyBottles1L ? _self.emptyBottles1L : emptyBottles1L // ignore: cast_nullable_to_non_nullable
as int?,emptyBottlesHalfL: freezed == emptyBottlesHalfL ? _self.emptyBottlesHalfL : emptyBottlesHalfL // ignore: cast_nullable_to_non_nullable
as int?,hasBottleReturnFlag: null == hasBottleReturnFlag ? _self.hasBottleReturnFlag : hasBottleReturnFlag // ignore: cast_nullable_to_non_nullable
as bool,bottleReturnNote: freezed == bottleReturnNote ? _self.bottleReturnNote : bottleReturnNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteAllocation].
extension RouteAllocationPatterns on RouteAllocation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteAllocation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteAllocation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteAllocation value)  $default,){
final _that = this;
switch (_that) {
case _RouteAllocation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteAllocation value)?  $default,){
final _that = this;
switch (_that) {
case _RouteAllocation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? allocationId,  String dpId,  String? dpName,  String? dpPhotoUrl,  double dpPetrolBalance,  double litresAllocated,  Map<String, int> items,  int? petrolAllowanceGiven,  bool isPetrolAllowanceComplete,  String status,  bool? deliveryCompleted,  int? emptyBottles1L,  int? emptyBottlesHalfL,  bool hasBottleReturnFlag,  String? bottleReturnNote)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteAllocation() when $default != null:
return $default(_that.allocationId,_that.dpId,_that.dpName,_that.dpPhotoUrl,_that.dpPetrolBalance,_that.litresAllocated,_that.items,_that.petrolAllowanceGiven,_that.isPetrolAllowanceComplete,_that.status,_that.deliveryCompleted,_that.emptyBottles1L,_that.emptyBottlesHalfL,_that.hasBottleReturnFlag,_that.bottleReturnNote);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? allocationId,  String dpId,  String? dpName,  String? dpPhotoUrl,  double dpPetrolBalance,  double litresAllocated,  Map<String, int> items,  int? petrolAllowanceGiven,  bool isPetrolAllowanceComplete,  String status,  bool? deliveryCompleted,  int? emptyBottles1L,  int? emptyBottlesHalfL,  bool hasBottleReturnFlag,  String? bottleReturnNote)  $default,) {final _that = this;
switch (_that) {
case _RouteAllocation():
return $default(_that.allocationId,_that.dpId,_that.dpName,_that.dpPhotoUrl,_that.dpPetrolBalance,_that.litresAllocated,_that.items,_that.petrolAllowanceGiven,_that.isPetrolAllowanceComplete,_that.status,_that.deliveryCompleted,_that.emptyBottles1L,_that.emptyBottlesHalfL,_that.hasBottleReturnFlag,_that.bottleReturnNote);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? allocationId,  String dpId,  String? dpName,  String? dpPhotoUrl,  double dpPetrolBalance,  double litresAllocated,  Map<String, int> items,  int? petrolAllowanceGiven,  bool isPetrolAllowanceComplete,  String status,  bool? deliveryCompleted,  int? emptyBottles1L,  int? emptyBottlesHalfL,  bool hasBottleReturnFlag,  String? bottleReturnNote)?  $default,) {final _that = this;
switch (_that) {
case _RouteAllocation() when $default != null:
return $default(_that.allocationId,_that.dpId,_that.dpName,_that.dpPhotoUrl,_that.dpPetrolBalance,_that.litresAllocated,_that.items,_that.petrolAllowanceGiven,_that.isPetrolAllowanceComplete,_that.status,_that.deliveryCompleted,_that.emptyBottles1L,_that.emptyBottlesHalfL,_that.hasBottleReturnFlag,_that.bottleReturnNote);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteAllocation implements RouteAllocation {
  const _RouteAllocation({this.allocationId, required this.dpId, this.dpName, this.dpPhotoUrl, this.dpPetrolBalance = 0.0, this.litresAllocated = 0.0, final  Map<String, int> items = const {}, this.petrolAllowanceGiven, this.isPetrolAllowanceComplete = false, this.status = 'ASSIGNED', this.deliveryCompleted, this.emptyBottles1L, this.emptyBottlesHalfL, this.hasBottleReturnFlag = false, this.bottleReturnNote}): _items = items;
  factory _RouteAllocation.fromJson(Map<String, dynamic> json) => _$RouteAllocationFromJson(json);

@override final  String? allocationId;
@override final  String dpId;
@override final  String? dpName;
@override final  String? dpPhotoUrl;
@override@JsonKey() final  double dpPetrolBalance;
@override@JsonKey() final  double litresAllocated;
 final  Map<String, int> _items;
@override@JsonKey() Map<String, int> get items {
  if (_items is EqualUnmodifiableMapView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_items);
}

@override final  int? petrolAllowanceGiven;
@override@JsonKey() final  bool isPetrolAllowanceComplete;
@override@JsonKey() final  String status;
@override final  bool? deliveryCompleted;
@override final  int? emptyBottles1L;
@override final  int? emptyBottlesHalfL;
@override@JsonKey() final  bool hasBottleReturnFlag;
@override final  String? bottleReturnNote;

/// Create a copy of RouteAllocation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteAllocationCopyWith<_RouteAllocation> get copyWith => __$RouteAllocationCopyWithImpl<_RouteAllocation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteAllocationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteAllocation&&(identical(other.allocationId, allocationId) || other.allocationId == allocationId)&&(identical(other.dpId, dpId) || other.dpId == dpId)&&(identical(other.dpName, dpName) || other.dpName == dpName)&&(identical(other.dpPhotoUrl, dpPhotoUrl) || other.dpPhotoUrl == dpPhotoUrl)&&(identical(other.dpPetrolBalance, dpPetrolBalance) || other.dpPetrolBalance == dpPetrolBalance)&&(identical(other.litresAllocated, litresAllocated) || other.litresAllocated == litresAllocated)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.petrolAllowanceGiven, petrolAllowanceGiven) || other.petrolAllowanceGiven == petrolAllowanceGiven)&&(identical(other.isPetrolAllowanceComplete, isPetrolAllowanceComplete) || other.isPetrolAllowanceComplete == isPetrolAllowanceComplete)&&(identical(other.status, status) || other.status == status)&&(identical(other.deliveryCompleted, deliveryCompleted) || other.deliveryCompleted == deliveryCompleted)&&(identical(other.emptyBottles1L, emptyBottles1L) || other.emptyBottles1L == emptyBottles1L)&&(identical(other.emptyBottlesHalfL, emptyBottlesHalfL) || other.emptyBottlesHalfL == emptyBottlesHalfL)&&(identical(other.hasBottleReturnFlag, hasBottleReturnFlag) || other.hasBottleReturnFlag == hasBottleReturnFlag)&&(identical(other.bottleReturnNote, bottleReturnNote) || other.bottleReturnNote == bottleReturnNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,allocationId,dpId,dpName,dpPhotoUrl,dpPetrolBalance,litresAllocated,const DeepCollectionEquality().hash(_items),petrolAllowanceGiven,isPetrolAllowanceComplete,status,deliveryCompleted,emptyBottles1L,emptyBottlesHalfL,hasBottleReturnFlag,bottleReturnNote);

@override
String toString() {
  return 'RouteAllocation(allocationId: $allocationId, dpId: $dpId, dpName: $dpName, dpPhotoUrl: $dpPhotoUrl, dpPetrolBalance: $dpPetrolBalance, litresAllocated: $litresAllocated, items: $items, petrolAllowanceGiven: $petrolAllowanceGiven, isPetrolAllowanceComplete: $isPetrolAllowanceComplete, status: $status, deliveryCompleted: $deliveryCompleted, emptyBottles1L: $emptyBottles1L, emptyBottlesHalfL: $emptyBottlesHalfL, hasBottleReturnFlag: $hasBottleReturnFlag, bottleReturnNote: $bottleReturnNote)';
}


}

/// @nodoc
abstract mixin class _$RouteAllocationCopyWith<$Res> implements $RouteAllocationCopyWith<$Res> {
  factory _$RouteAllocationCopyWith(_RouteAllocation value, $Res Function(_RouteAllocation) _then) = __$RouteAllocationCopyWithImpl;
@override @useResult
$Res call({
 String? allocationId, String dpId, String? dpName, String? dpPhotoUrl, double dpPetrolBalance, double litresAllocated, Map<String, int> items, int? petrolAllowanceGiven, bool isPetrolAllowanceComplete, String status, bool? deliveryCompleted, int? emptyBottles1L, int? emptyBottlesHalfL, bool hasBottleReturnFlag, String? bottleReturnNote
});




}
/// @nodoc
class __$RouteAllocationCopyWithImpl<$Res>
    implements _$RouteAllocationCopyWith<$Res> {
  __$RouteAllocationCopyWithImpl(this._self, this._then);

  final _RouteAllocation _self;
  final $Res Function(_RouteAllocation) _then;

/// Create a copy of RouteAllocation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? allocationId = freezed,Object? dpId = null,Object? dpName = freezed,Object? dpPhotoUrl = freezed,Object? dpPetrolBalance = null,Object? litresAllocated = null,Object? items = null,Object? petrolAllowanceGiven = freezed,Object? isPetrolAllowanceComplete = null,Object? status = null,Object? deliveryCompleted = freezed,Object? emptyBottles1L = freezed,Object? emptyBottlesHalfL = freezed,Object? hasBottleReturnFlag = null,Object? bottleReturnNote = freezed,}) {
  return _then(_RouteAllocation(
allocationId: freezed == allocationId ? _self.allocationId : allocationId // ignore: cast_nullable_to_non_nullable
as String?,dpId: null == dpId ? _self.dpId : dpId // ignore: cast_nullable_to_non_nullable
as String,dpName: freezed == dpName ? _self.dpName : dpName // ignore: cast_nullable_to_non_nullable
as String?,dpPhotoUrl: freezed == dpPhotoUrl ? _self.dpPhotoUrl : dpPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,dpPetrolBalance: null == dpPetrolBalance ? _self.dpPetrolBalance : dpPetrolBalance // ignore: cast_nullable_to_non_nullable
as double,litresAllocated: null == litresAllocated ? _self.litresAllocated : litresAllocated // ignore: cast_nullable_to_non_nullable
as double,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as Map<String, int>,petrolAllowanceGiven: freezed == petrolAllowanceGiven ? _self.petrolAllowanceGiven : petrolAllowanceGiven // ignore: cast_nullable_to_non_nullable
as int?,isPetrolAllowanceComplete: null == isPetrolAllowanceComplete ? _self.isPetrolAllowanceComplete : isPetrolAllowanceComplete // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,deliveryCompleted: freezed == deliveryCompleted ? _self.deliveryCompleted : deliveryCompleted // ignore: cast_nullable_to_non_nullable
as bool?,emptyBottles1L: freezed == emptyBottles1L ? _self.emptyBottles1L : emptyBottles1L // ignore: cast_nullable_to_non_nullable
as int?,emptyBottlesHalfL: freezed == emptyBottlesHalfL ? _self.emptyBottlesHalfL : emptyBottlesHalfL // ignore: cast_nullable_to_non_nullable
as int?,hasBottleReturnFlag: null == hasBottleReturnFlag ? _self.hasBottleReturnFlag : hasBottleReturnFlag // ignore: cast_nullable_to_non_nullable
as bool,bottleReturnNote: freezed == bottleReturnNote ? _self.bottleReturnNote : bottleReturnNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DeliveryRoute {

@JsonKey(name: 'routeId') String get id;@JsonKey(name: 'routeName') String get name;@JsonKey(name: 'zone') String get area; int get customerCount;@JsonKey(name: 'defaultLitres') double get milkQuantity; int get expectedEmptyBottles; int get fixedPetrolAllowance; List<RouteAllocation> get allocations;
/// Create a copy of DeliveryRoute
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeliveryRouteCopyWith<DeliveryRoute> get copyWith => _$DeliveryRouteCopyWithImpl<DeliveryRoute>(this as DeliveryRoute, _$identity);

  /// Serializes this DeliveryRoute to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeliveryRoute&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.area, area) || other.area == area)&&(identical(other.customerCount, customerCount) || other.customerCount == customerCount)&&(identical(other.milkQuantity, milkQuantity) || other.milkQuantity == milkQuantity)&&(identical(other.expectedEmptyBottles, expectedEmptyBottles) || other.expectedEmptyBottles == expectedEmptyBottles)&&(identical(other.fixedPetrolAllowance, fixedPetrolAllowance) || other.fixedPetrolAllowance == fixedPetrolAllowance)&&const DeepCollectionEquality().equals(other.allocations, allocations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,area,customerCount,milkQuantity,expectedEmptyBottles,fixedPetrolAllowance,const DeepCollectionEquality().hash(allocations));

@override
String toString() {
  return 'DeliveryRoute(id: $id, name: $name, area: $area, customerCount: $customerCount, milkQuantity: $milkQuantity, expectedEmptyBottles: $expectedEmptyBottles, fixedPetrolAllowance: $fixedPetrolAllowance, allocations: $allocations)';
}


}

/// @nodoc
abstract mixin class $DeliveryRouteCopyWith<$Res>  {
  factory $DeliveryRouteCopyWith(DeliveryRoute value, $Res Function(DeliveryRoute) _then) = _$DeliveryRouteCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'routeId') String id,@JsonKey(name: 'routeName') String name,@JsonKey(name: 'zone') String area, int customerCount,@JsonKey(name: 'defaultLitres') double milkQuantity, int expectedEmptyBottles, int fixedPetrolAllowance, List<RouteAllocation> allocations
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? area = null,Object? customerCount = null,Object? milkQuantity = null,Object? expectedEmptyBottles = null,Object? fixedPetrolAllowance = null,Object? allocations = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String,customerCount: null == customerCount ? _self.customerCount : customerCount // ignore: cast_nullable_to_non_nullable
as int,milkQuantity: null == milkQuantity ? _self.milkQuantity : milkQuantity // ignore: cast_nullable_to_non_nullable
as double,expectedEmptyBottles: null == expectedEmptyBottles ? _self.expectedEmptyBottles : expectedEmptyBottles // ignore: cast_nullable_to_non_nullable
as int,fixedPetrolAllowance: null == fixedPetrolAllowance ? _self.fixedPetrolAllowance : fixedPetrolAllowance // ignore: cast_nullable_to_non_nullable
as int,allocations: null == allocations ? _self.allocations : allocations // ignore: cast_nullable_to_non_nullable
as List<RouteAllocation>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'routeId')  String id, @JsonKey(name: 'routeName')  String name, @JsonKey(name: 'zone')  String area,  int customerCount, @JsonKey(name: 'defaultLitres')  double milkQuantity,  int expectedEmptyBottles,  int fixedPetrolAllowance,  List<RouteAllocation> allocations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeliveryRoute() when $default != null:
return $default(_that.id,_that.name,_that.area,_that.customerCount,_that.milkQuantity,_that.expectedEmptyBottles,_that.fixedPetrolAllowance,_that.allocations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'routeId')  String id, @JsonKey(name: 'routeName')  String name, @JsonKey(name: 'zone')  String area,  int customerCount, @JsonKey(name: 'defaultLitres')  double milkQuantity,  int expectedEmptyBottles,  int fixedPetrolAllowance,  List<RouteAllocation> allocations)  $default,) {final _that = this;
switch (_that) {
case _DeliveryRoute():
return $default(_that.id,_that.name,_that.area,_that.customerCount,_that.milkQuantity,_that.expectedEmptyBottles,_that.fixedPetrolAllowance,_that.allocations);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'routeId')  String id, @JsonKey(name: 'routeName')  String name, @JsonKey(name: 'zone')  String area,  int customerCount, @JsonKey(name: 'defaultLitres')  double milkQuantity,  int expectedEmptyBottles,  int fixedPetrolAllowance,  List<RouteAllocation> allocations)?  $default,) {final _that = this;
switch (_that) {
case _DeliveryRoute() when $default != null:
return $default(_that.id,_that.name,_that.area,_that.customerCount,_that.milkQuantity,_that.expectedEmptyBottles,_that.fixedPetrolAllowance,_that.allocations);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeliveryRoute implements DeliveryRoute {
  const _DeliveryRoute({@JsonKey(name: 'routeId') required this.id, @JsonKey(name: 'routeName') required this.name, @JsonKey(name: 'zone') required this.area, required this.customerCount, @JsonKey(name: 'defaultLitres') required this.milkQuantity, this.expectedEmptyBottles = 0, this.fixedPetrolAllowance = 80, final  List<RouteAllocation> allocations = const []}): _allocations = allocations;
  factory _DeliveryRoute.fromJson(Map<String, dynamic> json) => _$DeliveryRouteFromJson(json);

@override@JsonKey(name: 'routeId') final  String id;
@override@JsonKey(name: 'routeName') final  String name;
@override@JsonKey(name: 'zone') final  String area;
@override final  int customerCount;
@override@JsonKey(name: 'defaultLitres') final  double milkQuantity;
@override@JsonKey() final  int expectedEmptyBottles;
@override@JsonKey() final  int fixedPetrolAllowance;
 final  List<RouteAllocation> _allocations;
@override@JsonKey() List<RouteAllocation> get allocations {
  if (_allocations is EqualUnmodifiableListView) return _allocations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allocations);
}


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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeliveryRoute&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.area, area) || other.area == area)&&(identical(other.customerCount, customerCount) || other.customerCount == customerCount)&&(identical(other.milkQuantity, milkQuantity) || other.milkQuantity == milkQuantity)&&(identical(other.expectedEmptyBottles, expectedEmptyBottles) || other.expectedEmptyBottles == expectedEmptyBottles)&&(identical(other.fixedPetrolAllowance, fixedPetrolAllowance) || other.fixedPetrolAllowance == fixedPetrolAllowance)&&const DeepCollectionEquality().equals(other._allocations, _allocations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,area,customerCount,milkQuantity,expectedEmptyBottles,fixedPetrolAllowance,const DeepCollectionEquality().hash(_allocations));

@override
String toString() {
  return 'DeliveryRoute(id: $id, name: $name, area: $area, customerCount: $customerCount, milkQuantity: $milkQuantity, expectedEmptyBottles: $expectedEmptyBottles, fixedPetrolAllowance: $fixedPetrolAllowance, allocations: $allocations)';
}


}

/// @nodoc
abstract mixin class _$DeliveryRouteCopyWith<$Res> implements $DeliveryRouteCopyWith<$Res> {
  factory _$DeliveryRouteCopyWith(_DeliveryRoute value, $Res Function(_DeliveryRoute) _then) = __$DeliveryRouteCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'routeId') String id,@JsonKey(name: 'routeName') String name,@JsonKey(name: 'zone') String area, int customerCount,@JsonKey(name: 'defaultLitres') double milkQuantity, int expectedEmptyBottles, int fixedPetrolAllowance, List<RouteAllocation> allocations
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? area = null,Object? customerCount = null,Object? milkQuantity = null,Object? expectedEmptyBottles = null,Object? fixedPetrolAllowance = null,Object? allocations = null,}) {
  return _then(_DeliveryRoute(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String,customerCount: null == customerCount ? _self.customerCount : customerCount // ignore: cast_nullable_to_non_nullable
as int,milkQuantity: null == milkQuantity ? _self.milkQuantity : milkQuantity // ignore: cast_nullable_to_non_nullable
as double,expectedEmptyBottles: null == expectedEmptyBottles ? _self.expectedEmptyBottles : expectedEmptyBottles // ignore: cast_nullable_to_non_nullable
as int,fixedPetrolAllowance: null == fixedPetrolAllowance ? _self.fixedPetrolAllowance : fixedPetrolAllowance // ignore: cast_nullable_to_non_nullable
as int,allocations: null == allocations ? _self._allocations : allocations // ignore: cast_nullable_to_non_nullable
as List<RouteAllocation>,
  ));
}


}

// dart format on
