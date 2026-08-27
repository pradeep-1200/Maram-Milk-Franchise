// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'empty_bottle_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EmptyBottleStatusItem {

 String get inventoryItemId; String get name; String get unit; String? get section; String? get material; int get carriedOver; int get allocated; int get expected; int get actualDelivered; int get collected; int get broken; int get outstanding;
/// Create a copy of EmptyBottleStatusItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmptyBottleStatusItemCopyWith<EmptyBottleStatusItem> get copyWith => _$EmptyBottleStatusItemCopyWithImpl<EmptyBottleStatusItem>(this as EmptyBottleStatusItem, _$identity);

  /// Serializes this EmptyBottleStatusItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmptyBottleStatusItem&&(identical(other.inventoryItemId, inventoryItemId) || other.inventoryItemId == inventoryItemId)&&(identical(other.name, name) || other.name == name)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.section, section) || other.section == section)&&(identical(other.material, material) || other.material == material)&&(identical(other.carriedOver, carriedOver) || other.carriedOver == carriedOver)&&(identical(other.allocated, allocated) || other.allocated == allocated)&&(identical(other.expected, expected) || other.expected == expected)&&(identical(other.actualDelivered, actualDelivered) || other.actualDelivered == actualDelivered)&&(identical(other.collected, collected) || other.collected == collected)&&(identical(other.broken, broken) || other.broken == broken)&&(identical(other.outstanding, outstanding) || other.outstanding == outstanding));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inventoryItemId,name,unit,section,material,carriedOver,allocated,expected,actualDelivered,collected,broken,outstanding);

@override
String toString() {
  return 'EmptyBottleStatusItem(inventoryItemId: $inventoryItemId, name: $name, unit: $unit, section: $section, material: $material, carriedOver: $carriedOver, allocated: $allocated, expected: $expected, actualDelivered: $actualDelivered, collected: $collected, broken: $broken, outstanding: $outstanding)';
}


}

/// @nodoc
abstract mixin class $EmptyBottleStatusItemCopyWith<$Res>  {
  factory $EmptyBottleStatusItemCopyWith(EmptyBottleStatusItem value, $Res Function(EmptyBottleStatusItem) _then) = _$EmptyBottleStatusItemCopyWithImpl;
@useResult
$Res call({
 String inventoryItemId, String name, String unit, String? section, String? material, int carriedOver, int allocated, int expected, int actualDelivered, int collected, int broken, int outstanding
});




}
/// @nodoc
class _$EmptyBottleStatusItemCopyWithImpl<$Res>
    implements $EmptyBottleStatusItemCopyWith<$Res> {
  _$EmptyBottleStatusItemCopyWithImpl(this._self, this._then);

  final EmptyBottleStatusItem _self;
  final $Res Function(EmptyBottleStatusItem) _then;

/// Create a copy of EmptyBottleStatusItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inventoryItemId = null,Object? name = null,Object? unit = null,Object? section = freezed,Object? material = freezed,Object? carriedOver = null,Object? allocated = null,Object? expected = null,Object? actualDelivered = null,Object? collected = null,Object? broken = null,Object? outstanding = null,}) {
  return _then(_self.copyWith(
inventoryItemId: null == inventoryItemId ? _self.inventoryItemId : inventoryItemId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,section: freezed == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as String?,material: freezed == material ? _self.material : material // ignore: cast_nullable_to_non_nullable
as String?,carriedOver: null == carriedOver ? _self.carriedOver : carriedOver // ignore: cast_nullable_to_non_nullable
as int,allocated: null == allocated ? _self.allocated : allocated // ignore: cast_nullable_to_non_nullable
as int,expected: null == expected ? _self.expected : expected // ignore: cast_nullable_to_non_nullable
as int,actualDelivered: null == actualDelivered ? _self.actualDelivered : actualDelivered // ignore: cast_nullable_to_non_nullable
as int,collected: null == collected ? _self.collected : collected // ignore: cast_nullable_to_non_nullable
as int,broken: null == broken ? _self.broken : broken // ignore: cast_nullable_to_non_nullable
as int,outstanding: null == outstanding ? _self.outstanding : outstanding // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EmptyBottleStatusItem].
extension EmptyBottleStatusItemPatterns on EmptyBottleStatusItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmptyBottleStatusItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmptyBottleStatusItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmptyBottleStatusItem value)  $default,){
final _that = this;
switch (_that) {
case _EmptyBottleStatusItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmptyBottleStatusItem value)?  $default,){
final _that = this;
switch (_that) {
case _EmptyBottleStatusItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String inventoryItemId,  String name,  String unit,  String? section,  String? material,  int carriedOver,  int allocated,  int expected,  int actualDelivered,  int collected,  int broken,  int outstanding)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmptyBottleStatusItem() when $default != null:
return $default(_that.inventoryItemId,_that.name,_that.unit,_that.section,_that.material,_that.carriedOver,_that.allocated,_that.expected,_that.actualDelivered,_that.collected,_that.broken,_that.outstanding);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String inventoryItemId,  String name,  String unit,  String? section,  String? material,  int carriedOver,  int allocated,  int expected,  int actualDelivered,  int collected,  int broken,  int outstanding)  $default,) {final _that = this;
switch (_that) {
case _EmptyBottleStatusItem():
return $default(_that.inventoryItemId,_that.name,_that.unit,_that.section,_that.material,_that.carriedOver,_that.allocated,_that.expected,_that.actualDelivered,_that.collected,_that.broken,_that.outstanding);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String inventoryItemId,  String name,  String unit,  String? section,  String? material,  int carriedOver,  int allocated,  int expected,  int actualDelivered,  int collected,  int broken,  int outstanding)?  $default,) {final _that = this;
switch (_that) {
case _EmptyBottleStatusItem() when $default != null:
return $default(_that.inventoryItemId,_that.name,_that.unit,_that.section,_that.material,_that.carriedOver,_that.allocated,_that.expected,_that.actualDelivered,_that.collected,_that.broken,_that.outstanding);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmptyBottleStatusItem implements EmptyBottleStatusItem {
  const _EmptyBottleStatusItem({required this.inventoryItemId, required this.name, required this.unit, this.section, this.material, this.carriedOver = 0, this.allocated = 0, this.expected = 0, this.actualDelivered = 0, this.collected = 0, this.broken = 0, this.outstanding = 0});
  factory _EmptyBottleStatusItem.fromJson(Map<String, dynamic> json) => _$EmptyBottleStatusItemFromJson(json);

@override final  String inventoryItemId;
@override final  String name;
@override final  String unit;
@override final  String? section;
@override final  String? material;
@override@JsonKey() final  int carriedOver;
@override@JsonKey() final  int allocated;
@override@JsonKey() final  int expected;
@override@JsonKey() final  int actualDelivered;
@override@JsonKey() final  int collected;
@override@JsonKey() final  int broken;
@override@JsonKey() final  int outstanding;

/// Create a copy of EmptyBottleStatusItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmptyBottleStatusItemCopyWith<_EmptyBottleStatusItem> get copyWith => __$EmptyBottleStatusItemCopyWithImpl<_EmptyBottleStatusItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmptyBottleStatusItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmptyBottleStatusItem&&(identical(other.inventoryItemId, inventoryItemId) || other.inventoryItemId == inventoryItemId)&&(identical(other.name, name) || other.name == name)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.section, section) || other.section == section)&&(identical(other.material, material) || other.material == material)&&(identical(other.carriedOver, carriedOver) || other.carriedOver == carriedOver)&&(identical(other.allocated, allocated) || other.allocated == allocated)&&(identical(other.expected, expected) || other.expected == expected)&&(identical(other.actualDelivered, actualDelivered) || other.actualDelivered == actualDelivered)&&(identical(other.collected, collected) || other.collected == collected)&&(identical(other.broken, broken) || other.broken == broken)&&(identical(other.outstanding, outstanding) || other.outstanding == outstanding));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inventoryItemId,name,unit,section,material,carriedOver,allocated,expected,actualDelivered,collected,broken,outstanding);

@override
String toString() {
  return 'EmptyBottleStatusItem(inventoryItemId: $inventoryItemId, name: $name, unit: $unit, section: $section, material: $material, carriedOver: $carriedOver, allocated: $allocated, expected: $expected, actualDelivered: $actualDelivered, collected: $collected, broken: $broken, outstanding: $outstanding)';
}


}

/// @nodoc
abstract mixin class _$EmptyBottleStatusItemCopyWith<$Res> implements $EmptyBottleStatusItemCopyWith<$Res> {
  factory _$EmptyBottleStatusItemCopyWith(_EmptyBottleStatusItem value, $Res Function(_EmptyBottleStatusItem) _then) = __$EmptyBottleStatusItemCopyWithImpl;
@override @useResult
$Res call({
 String inventoryItemId, String name, String unit, String? section, String? material, int carriedOver, int allocated, int expected, int actualDelivered, int collected, int broken, int outstanding
});




}
/// @nodoc
class __$EmptyBottleStatusItemCopyWithImpl<$Res>
    implements _$EmptyBottleStatusItemCopyWith<$Res> {
  __$EmptyBottleStatusItemCopyWithImpl(this._self, this._then);

  final _EmptyBottleStatusItem _self;
  final $Res Function(_EmptyBottleStatusItem) _then;

/// Create a copy of EmptyBottleStatusItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inventoryItemId = null,Object? name = null,Object? unit = null,Object? section = freezed,Object? material = freezed,Object? carriedOver = null,Object? allocated = null,Object? expected = null,Object? actualDelivered = null,Object? collected = null,Object? broken = null,Object? outstanding = null,}) {
  return _then(_EmptyBottleStatusItem(
inventoryItemId: null == inventoryItemId ? _self.inventoryItemId : inventoryItemId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,section: freezed == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as String?,material: freezed == material ? _self.material : material // ignore: cast_nullable_to_non_nullable
as String?,carriedOver: null == carriedOver ? _self.carriedOver : carriedOver // ignore: cast_nullable_to_non_nullable
as int,allocated: null == allocated ? _self.allocated : allocated // ignore: cast_nullable_to_non_nullable
as int,expected: null == expected ? _self.expected : expected // ignore: cast_nullable_to_non_nullable
as int,actualDelivered: null == actualDelivered ? _self.actualDelivered : actualDelivered // ignore: cast_nullable_to_non_nullable
as int,collected: null == collected ? _self.collected : collected // ignore: cast_nullable_to_non_nullable
as int,broken: null == broken ? _self.broken : broken // ignore: cast_nullable_to_non_nullable
as int,outstanding: null == outstanding ? _self.outstanding : outstanding // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$EmptyBottleStatus {

 String get routeId; String get routeName; String? get dpId; String? get dpName; bool get deliveryCompleted; int get expectedEmptyBottles; bool get flagIssue; String? get reason; String? get notes; String get status; List<EmptyBottleStatusItem> get items;
/// Create a copy of EmptyBottleStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmptyBottleStatusCopyWith<EmptyBottleStatus> get copyWith => _$EmptyBottleStatusCopyWithImpl<EmptyBottleStatus>(this as EmptyBottleStatus, _$identity);

  /// Serializes this EmptyBottleStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmptyBottleStatus&&(identical(other.routeId, routeId) || other.routeId == routeId)&&(identical(other.routeName, routeName) || other.routeName == routeName)&&(identical(other.dpId, dpId) || other.dpId == dpId)&&(identical(other.dpName, dpName) || other.dpName == dpName)&&(identical(other.deliveryCompleted, deliveryCompleted) || other.deliveryCompleted == deliveryCompleted)&&(identical(other.expectedEmptyBottles, expectedEmptyBottles) || other.expectedEmptyBottles == expectedEmptyBottles)&&(identical(other.flagIssue, flagIssue) || other.flagIssue == flagIssue)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,routeId,routeName,dpId,dpName,deliveryCompleted,expectedEmptyBottles,flagIssue,reason,notes,status,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'EmptyBottleStatus(routeId: $routeId, routeName: $routeName, dpId: $dpId, dpName: $dpName, deliveryCompleted: $deliveryCompleted, expectedEmptyBottles: $expectedEmptyBottles, flagIssue: $flagIssue, reason: $reason, notes: $notes, status: $status, items: $items)';
}


}

/// @nodoc
abstract mixin class $EmptyBottleStatusCopyWith<$Res>  {
  factory $EmptyBottleStatusCopyWith(EmptyBottleStatus value, $Res Function(EmptyBottleStatus) _then) = _$EmptyBottleStatusCopyWithImpl;
@useResult
$Res call({
 String routeId, String routeName, String? dpId, String? dpName, bool deliveryCompleted, int expectedEmptyBottles, bool flagIssue, String? reason, String? notes, String status, List<EmptyBottleStatusItem> items
});




}
/// @nodoc
class _$EmptyBottleStatusCopyWithImpl<$Res>
    implements $EmptyBottleStatusCopyWith<$Res> {
  _$EmptyBottleStatusCopyWithImpl(this._self, this._then);

  final EmptyBottleStatus _self;
  final $Res Function(EmptyBottleStatus) _then;

/// Create a copy of EmptyBottleStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? routeId = null,Object? routeName = null,Object? dpId = freezed,Object? dpName = freezed,Object? deliveryCompleted = null,Object? expectedEmptyBottles = null,Object? flagIssue = null,Object? reason = freezed,Object? notes = freezed,Object? status = null,Object? items = null,}) {
  return _then(_self.copyWith(
routeId: null == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as String,routeName: null == routeName ? _self.routeName : routeName // ignore: cast_nullable_to_non_nullable
as String,dpId: freezed == dpId ? _self.dpId : dpId // ignore: cast_nullable_to_non_nullable
as String?,dpName: freezed == dpName ? _self.dpName : dpName // ignore: cast_nullable_to_non_nullable
as String?,deliveryCompleted: null == deliveryCompleted ? _self.deliveryCompleted : deliveryCompleted // ignore: cast_nullable_to_non_nullable
as bool,expectedEmptyBottles: null == expectedEmptyBottles ? _self.expectedEmptyBottles : expectedEmptyBottles // ignore: cast_nullable_to_non_nullable
as int,flagIssue: null == flagIssue ? _self.flagIssue : flagIssue // ignore: cast_nullable_to_non_nullable
as bool,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<EmptyBottleStatusItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [EmptyBottleStatus].
extension EmptyBottleStatusPatterns on EmptyBottleStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmptyBottleStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmptyBottleStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmptyBottleStatus value)  $default,){
final _that = this;
switch (_that) {
case _EmptyBottleStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmptyBottleStatus value)?  $default,){
final _that = this;
switch (_that) {
case _EmptyBottleStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String routeId,  String routeName,  String? dpId,  String? dpName,  bool deliveryCompleted,  int expectedEmptyBottles,  bool flagIssue,  String? reason,  String? notes,  String status,  List<EmptyBottleStatusItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmptyBottleStatus() when $default != null:
return $default(_that.routeId,_that.routeName,_that.dpId,_that.dpName,_that.deliveryCompleted,_that.expectedEmptyBottles,_that.flagIssue,_that.reason,_that.notes,_that.status,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String routeId,  String routeName,  String? dpId,  String? dpName,  bool deliveryCompleted,  int expectedEmptyBottles,  bool flagIssue,  String? reason,  String? notes,  String status,  List<EmptyBottleStatusItem> items)  $default,) {final _that = this;
switch (_that) {
case _EmptyBottleStatus():
return $default(_that.routeId,_that.routeName,_that.dpId,_that.dpName,_that.deliveryCompleted,_that.expectedEmptyBottles,_that.flagIssue,_that.reason,_that.notes,_that.status,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String routeId,  String routeName,  String? dpId,  String? dpName,  bool deliveryCompleted,  int expectedEmptyBottles,  bool flagIssue,  String? reason,  String? notes,  String status,  List<EmptyBottleStatusItem> items)?  $default,) {final _that = this;
switch (_that) {
case _EmptyBottleStatus() when $default != null:
return $default(_that.routeId,_that.routeName,_that.dpId,_that.dpName,_that.deliveryCompleted,_that.expectedEmptyBottles,_that.flagIssue,_that.reason,_that.notes,_that.status,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmptyBottleStatus implements EmptyBottleStatus {
  const _EmptyBottleStatus({required this.routeId, required this.routeName, this.dpId, this.dpName, required this.deliveryCompleted, this.expectedEmptyBottles = 0, this.flagIssue = false, this.reason, this.notes, required this.status, final  List<EmptyBottleStatusItem> items = const []}): _items = items;
  factory _EmptyBottleStatus.fromJson(Map<String, dynamic> json) => _$EmptyBottleStatusFromJson(json);

@override final  String routeId;
@override final  String routeName;
@override final  String? dpId;
@override final  String? dpName;
@override final  bool deliveryCompleted;
@override@JsonKey() final  int expectedEmptyBottles;
@override@JsonKey() final  bool flagIssue;
@override final  String? reason;
@override final  String? notes;
@override final  String status;
 final  List<EmptyBottleStatusItem> _items;
@override@JsonKey() List<EmptyBottleStatusItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of EmptyBottleStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmptyBottleStatusCopyWith<_EmptyBottleStatus> get copyWith => __$EmptyBottleStatusCopyWithImpl<_EmptyBottleStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmptyBottleStatusToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmptyBottleStatus&&(identical(other.routeId, routeId) || other.routeId == routeId)&&(identical(other.routeName, routeName) || other.routeName == routeName)&&(identical(other.dpId, dpId) || other.dpId == dpId)&&(identical(other.dpName, dpName) || other.dpName == dpName)&&(identical(other.deliveryCompleted, deliveryCompleted) || other.deliveryCompleted == deliveryCompleted)&&(identical(other.expectedEmptyBottles, expectedEmptyBottles) || other.expectedEmptyBottles == expectedEmptyBottles)&&(identical(other.flagIssue, flagIssue) || other.flagIssue == flagIssue)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,routeId,routeName,dpId,dpName,deliveryCompleted,expectedEmptyBottles,flagIssue,reason,notes,status,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'EmptyBottleStatus(routeId: $routeId, routeName: $routeName, dpId: $dpId, dpName: $dpName, deliveryCompleted: $deliveryCompleted, expectedEmptyBottles: $expectedEmptyBottles, flagIssue: $flagIssue, reason: $reason, notes: $notes, status: $status, items: $items)';
}


}

/// @nodoc
abstract mixin class _$EmptyBottleStatusCopyWith<$Res> implements $EmptyBottleStatusCopyWith<$Res> {
  factory _$EmptyBottleStatusCopyWith(_EmptyBottleStatus value, $Res Function(_EmptyBottleStatus) _then) = __$EmptyBottleStatusCopyWithImpl;
@override @useResult
$Res call({
 String routeId, String routeName, String? dpId, String? dpName, bool deliveryCompleted, int expectedEmptyBottles, bool flagIssue, String? reason, String? notes, String status, List<EmptyBottleStatusItem> items
});




}
/// @nodoc
class __$EmptyBottleStatusCopyWithImpl<$Res>
    implements _$EmptyBottleStatusCopyWith<$Res> {
  __$EmptyBottleStatusCopyWithImpl(this._self, this._then);

  final _EmptyBottleStatus _self;
  final $Res Function(_EmptyBottleStatus) _then;

/// Create a copy of EmptyBottleStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? routeId = null,Object? routeName = null,Object? dpId = freezed,Object? dpName = freezed,Object? deliveryCompleted = null,Object? expectedEmptyBottles = null,Object? flagIssue = null,Object? reason = freezed,Object? notes = freezed,Object? status = null,Object? items = null,}) {
  return _then(_EmptyBottleStatus(
routeId: null == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as String,routeName: null == routeName ? _self.routeName : routeName // ignore: cast_nullable_to_non_nullable
as String,dpId: freezed == dpId ? _self.dpId : dpId // ignore: cast_nullable_to_non_nullable
as String?,dpName: freezed == dpName ? _self.dpName : dpName // ignore: cast_nullable_to_non_nullable
as String?,deliveryCompleted: null == deliveryCompleted ? _self.deliveryCompleted : deliveryCompleted // ignore: cast_nullable_to_non_nullable
as bool,expectedEmptyBottles: null == expectedEmptyBottles ? _self.expectedEmptyBottles : expectedEmptyBottles // ignore: cast_nullable_to_non_nullable
as int,flagIssue: null == flagIssue ? _self.flagIssue : flagIssue // ignore: cast_nullable_to_non_nullable
as bool,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<EmptyBottleStatusItem>,
  ));
}


}

// dart format on
