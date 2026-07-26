// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dispatch_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttendanceStats {

 int get totalDps; int get marked; int get present; int get absent; int get standby; DateTime? get completedAt;
/// Create a copy of AttendanceStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceStatsCopyWith<AttendanceStats> get copyWith => _$AttendanceStatsCopyWithImpl<AttendanceStats>(this as AttendanceStats, _$identity);

  /// Serializes this AttendanceStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceStats&&(identical(other.totalDps, totalDps) || other.totalDps == totalDps)&&(identical(other.marked, marked) || other.marked == marked)&&(identical(other.present, present) || other.present == present)&&(identical(other.absent, absent) || other.absent == absent)&&(identical(other.standby, standby) || other.standby == standby)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalDps,marked,present,absent,standby,completedAt);

@override
String toString() {
  return 'AttendanceStats(totalDps: $totalDps, marked: $marked, present: $present, absent: $absent, standby: $standby, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $AttendanceStatsCopyWith<$Res>  {
  factory $AttendanceStatsCopyWith(AttendanceStats value, $Res Function(AttendanceStats) _then) = _$AttendanceStatsCopyWithImpl;
@useResult
$Res call({
 int totalDps, int marked, int present, int absent, int standby, DateTime? completedAt
});




}
/// @nodoc
class _$AttendanceStatsCopyWithImpl<$Res>
    implements $AttendanceStatsCopyWith<$Res> {
  _$AttendanceStatsCopyWithImpl(this._self, this._then);

  final AttendanceStats _self;
  final $Res Function(AttendanceStats) _then;

/// Create a copy of AttendanceStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalDps = null,Object? marked = null,Object? present = null,Object? absent = null,Object? standby = null,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
totalDps: null == totalDps ? _self.totalDps : totalDps // ignore: cast_nullable_to_non_nullable
as int,marked: null == marked ? _self.marked : marked // ignore: cast_nullable_to_non_nullable
as int,present: null == present ? _self.present : present // ignore: cast_nullable_to_non_nullable
as int,absent: null == absent ? _self.absent : absent // ignore: cast_nullable_to_non_nullable
as int,standby: null == standby ? _self.standby : standby // ignore: cast_nullable_to_non_nullable
as int,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceStats].
extension AttendanceStatsPatterns on AttendanceStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceStats value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceStats value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalDps,  int marked,  int present,  int absent,  int standby,  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceStats() when $default != null:
return $default(_that.totalDps,_that.marked,_that.present,_that.absent,_that.standby,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalDps,  int marked,  int present,  int absent,  int standby,  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _AttendanceStats():
return $default(_that.totalDps,_that.marked,_that.present,_that.absent,_that.standby,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalDps,  int marked,  int present,  int absent,  int standby,  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceStats() when $default != null:
return $default(_that.totalDps,_that.marked,_that.present,_that.absent,_that.standby,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceStats implements AttendanceStats {
  const _AttendanceStats({required this.totalDps, required this.marked, required this.present, required this.absent, required this.standby, this.completedAt});
  factory _AttendanceStats.fromJson(Map<String, dynamic> json) => _$AttendanceStatsFromJson(json);

@override final  int totalDps;
@override final  int marked;
@override final  int present;
@override final  int absent;
@override final  int standby;
@override final  DateTime? completedAt;

/// Create a copy of AttendanceStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceStatsCopyWith<_AttendanceStats> get copyWith => __$AttendanceStatsCopyWithImpl<_AttendanceStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceStats&&(identical(other.totalDps, totalDps) || other.totalDps == totalDps)&&(identical(other.marked, marked) || other.marked == marked)&&(identical(other.present, present) || other.present == present)&&(identical(other.absent, absent) || other.absent == absent)&&(identical(other.standby, standby) || other.standby == standby)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalDps,marked,present,absent,standby,completedAt);

@override
String toString() {
  return 'AttendanceStats(totalDps: $totalDps, marked: $marked, present: $present, absent: $absent, standby: $standby, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$AttendanceStatsCopyWith<$Res> implements $AttendanceStatsCopyWith<$Res> {
  factory _$AttendanceStatsCopyWith(_AttendanceStats value, $Res Function(_AttendanceStats) _then) = __$AttendanceStatsCopyWithImpl;
@override @useResult
$Res call({
 int totalDps, int marked, int present, int absent, int standby, DateTime? completedAt
});




}
/// @nodoc
class __$AttendanceStatsCopyWithImpl<$Res>
    implements _$AttendanceStatsCopyWith<$Res> {
  __$AttendanceStatsCopyWithImpl(this._self, this._then);

  final _AttendanceStats _self;
  final $Res Function(_AttendanceStats) _then;

/// Create a copy of AttendanceStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalDps = null,Object? marked = null,Object? present = null,Object? absent = null,Object? standby = null,Object? completedAt = freezed,}) {
  return _then(_AttendanceStats(
totalDps: null == totalDps ? _self.totalDps : totalDps // ignore: cast_nullable_to_non_nullable
as int,marked: null == marked ? _self.marked : marked // ignore: cast_nullable_to_non_nullable
as int,present: null == present ? _self.present : present // ignore: cast_nullable_to_non_nullable
as int,absent: null == absent ? _self.absent : absent // ignore: cast_nullable_to_non_nullable
as int,standby: null == standby ? _self.standby : standby // ignore: cast_nullable_to_non_nullable
as int,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$RouteStats {

 int get totalRoutes; int get assigned; int get unassigned; double get totalLitresAllocated; DateTime? get completedAt;
/// Create a copy of RouteStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteStatsCopyWith<RouteStats> get copyWith => _$RouteStatsCopyWithImpl<RouteStats>(this as RouteStats, _$identity);

  /// Serializes this RouteStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteStats&&(identical(other.totalRoutes, totalRoutes) || other.totalRoutes == totalRoutes)&&(identical(other.assigned, assigned) || other.assigned == assigned)&&(identical(other.unassigned, unassigned) || other.unassigned == unassigned)&&(identical(other.totalLitresAllocated, totalLitresAllocated) || other.totalLitresAllocated == totalLitresAllocated)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalRoutes,assigned,unassigned,totalLitresAllocated,completedAt);

@override
String toString() {
  return 'RouteStats(totalRoutes: $totalRoutes, assigned: $assigned, unassigned: $unassigned, totalLitresAllocated: $totalLitresAllocated, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $RouteStatsCopyWith<$Res>  {
  factory $RouteStatsCopyWith(RouteStats value, $Res Function(RouteStats) _then) = _$RouteStatsCopyWithImpl;
@useResult
$Res call({
 int totalRoutes, int assigned, int unassigned, double totalLitresAllocated, DateTime? completedAt
});




}
/// @nodoc
class _$RouteStatsCopyWithImpl<$Res>
    implements $RouteStatsCopyWith<$Res> {
  _$RouteStatsCopyWithImpl(this._self, this._then);

  final RouteStats _self;
  final $Res Function(RouteStats) _then;

/// Create a copy of RouteStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalRoutes = null,Object? assigned = null,Object? unassigned = null,Object? totalLitresAllocated = null,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
totalRoutes: null == totalRoutes ? _self.totalRoutes : totalRoutes // ignore: cast_nullable_to_non_nullable
as int,assigned: null == assigned ? _self.assigned : assigned // ignore: cast_nullable_to_non_nullable
as int,unassigned: null == unassigned ? _self.unassigned : unassigned // ignore: cast_nullable_to_non_nullable
as int,totalLitresAllocated: null == totalLitresAllocated ? _self.totalLitresAllocated : totalLitresAllocated // ignore: cast_nullable_to_non_nullable
as double,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteStats].
extension RouteStatsPatterns on RouteStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteStats value)  $default,){
final _that = this;
switch (_that) {
case _RouteStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteStats value)?  $default,){
final _that = this;
switch (_that) {
case _RouteStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalRoutes,  int assigned,  int unassigned,  double totalLitresAllocated,  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteStats() when $default != null:
return $default(_that.totalRoutes,_that.assigned,_that.unassigned,_that.totalLitresAllocated,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalRoutes,  int assigned,  int unassigned,  double totalLitresAllocated,  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _RouteStats():
return $default(_that.totalRoutes,_that.assigned,_that.unassigned,_that.totalLitresAllocated,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalRoutes,  int assigned,  int unassigned,  double totalLitresAllocated,  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _RouteStats() when $default != null:
return $default(_that.totalRoutes,_that.assigned,_that.unassigned,_that.totalLitresAllocated,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteStats implements RouteStats {
  const _RouteStats({required this.totalRoutes, required this.assigned, required this.unassigned, required this.totalLitresAllocated, this.completedAt});
  factory _RouteStats.fromJson(Map<String, dynamic> json) => _$RouteStatsFromJson(json);

@override final  int totalRoutes;
@override final  int assigned;
@override final  int unassigned;
@override final  double totalLitresAllocated;
@override final  DateTime? completedAt;

/// Create a copy of RouteStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteStatsCopyWith<_RouteStats> get copyWith => __$RouteStatsCopyWithImpl<_RouteStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteStats&&(identical(other.totalRoutes, totalRoutes) || other.totalRoutes == totalRoutes)&&(identical(other.assigned, assigned) || other.assigned == assigned)&&(identical(other.unassigned, unassigned) || other.unassigned == unassigned)&&(identical(other.totalLitresAllocated, totalLitresAllocated) || other.totalLitresAllocated == totalLitresAllocated)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalRoutes,assigned,unassigned,totalLitresAllocated,completedAt);

@override
String toString() {
  return 'RouteStats(totalRoutes: $totalRoutes, assigned: $assigned, unassigned: $unassigned, totalLitresAllocated: $totalLitresAllocated, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$RouteStatsCopyWith<$Res> implements $RouteStatsCopyWith<$Res> {
  factory _$RouteStatsCopyWith(_RouteStats value, $Res Function(_RouteStats) _then) = __$RouteStatsCopyWithImpl;
@override @useResult
$Res call({
 int totalRoutes, int assigned, int unassigned, double totalLitresAllocated, DateTime? completedAt
});




}
/// @nodoc
class __$RouteStatsCopyWithImpl<$Res>
    implements _$RouteStatsCopyWith<$Res> {
  __$RouteStatsCopyWithImpl(this._self, this._then);

  final _RouteStats _self;
  final $Res Function(_RouteStats) _then;

/// Create a copy of RouteStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalRoutes = null,Object? assigned = null,Object? unassigned = null,Object? totalLitresAllocated = null,Object? completedAt = freezed,}) {
  return _then(_RouteStats(
totalRoutes: null == totalRoutes ? _self.totalRoutes : totalRoutes // ignore: cast_nullable_to_non_nullable
as int,assigned: null == assigned ? _self.assigned : assigned // ignore: cast_nullable_to_non_nullable
as int,unassigned: null == unassigned ? _self.unassigned : unassigned // ignore: cast_nullable_to_non_nullable
as int,totalLitresAllocated: null == totalLitresAllocated ? _self.totalLitresAllocated : totalLitresAllocated // ignore: cast_nullable_to_non_nullable
as double,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$InventoryStats {

 int get totalItems; int get counted; int get matched; DateTime? get completedAt;
/// Create a copy of InventoryStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryStatsCopyWith<InventoryStats> get copyWith => _$InventoryStatsCopyWithImpl<InventoryStats>(this as InventoryStats, _$identity);

  /// Serializes this InventoryStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryStats&&(identical(other.totalItems, totalItems) || other.totalItems == totalItems)&&(identical(other.counted, counted) || other.counted == counted)&&(identical(other.matched, matched) || other.matched == matched)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalItems,counted,matched,completedAt);

@override
String toString() {
  return 'InventoryStats(totalItems: $totalItems, counted: $counted, matched: $matched, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $InventoryStatsCopyWith<$Res>  {
  factory $InventoryStatsCopyWith(InventoryStats value, $Res Function(InventoryStats) _then) = _$InventoryStatsCopyWithImpl;
@useResult
$Res call({
 int totalItems, int counted, int matched, DateTime? completedAt
});




}
/// @nodoc
class _$InventoryStatsCopyWithImpl<$Res>
    implements $InventoryStatsCopyWith<$Res> {
  _$InventoryStatsCopyWithImpl(this._self, this._then);

  final InventoryStats _self;
  final $Res Function(InventoryStats) _then;

/// Create a copy of InventoryStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalItems = null,Object? counted = null,Object? matched = null,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
totalItems: null == totalItems ? _self.totalItems : totalItems // ignore: cast_nullable_to_non_nullable
as int,counted: null == counted ? _self.counted : counted // ignore: cast_nullable_to_non_nullable
as int,matched: null == matched ? _self.matched : matched // ignore: cast_nullable_to_non_nullable
as int,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryStats].
extension InventoryStatsPatterns on InventoryStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryStats value)  $default,){
final _that = this;
switch (_that) {
case _InventoryStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryStats value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalItems,  int counted,  int matched,  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryStats() when $default != null:
return $default(_that.totalItems,_that.counted,_that.matched,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalItems,  int counted,  int matched,  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _InventoryStats():
return $default(_that.totalItems,_that.counted,_that.matched,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalItems,  int counted,  int matched,  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _InventoryStats() when $default != null:
return $default(_that.totalItems,_that.counted,_that.matched,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventoryStats implements InventoryStats {
  const _InventoryStats({required this.totalItems, required this.counted, required this.matched, this.completedAt});
  factory _InventoryStats.fromJson(Map<String, dynamic> json) => _$InventoryStatsFromJson(json);

@override final  int totalItems;
@override final  int counted;
@override final  int matched;
@override final  DateTime? completedAt;

/// Create a copy of InventoryStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryStatsCopyWith<_InventoryStats> get copyWith => __$InventoryStatsCopyWithImpl<_InventoryStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryStats&&(identical(other.totalItems, totalItems) || other.totalItems == totalItems)&&(identical(other.counted, counted) || other.counted == counted)&&(identical(other.matched, matched) || other.matched == matched)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalItems,counted,matched,completedAt);

@override
String toString() {
  return 'InventoryStats(totalItems: $totalItems, counted: $counted, matched: $matched, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$InventoryStatsCopyWith<$Res> implements $InventoryStatsCopyWith<$Res> {
  factory _$InventoryStatsCopyWith(_InventoryStats value, $Res Function(_InventoryStats) _then) = __$InventoryStatsCopyWithImpl;
@override @useResult
$Res call({
 int totalItems, int counted, int matched, DateTime? completedAt
});




}
/// @nodoc
class __$InventoryStatsCopyWithImpl<$Res>
    implements _$InventoryStatsCopyWith<$Res> {
  __$InventoryStatsCopyWithImpl(this._self, this._then);

  final _InventoryStats _self;
  final $Res Function(_InventoryStats) _then;

/// Create a copy of InventoryStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalItems = null,Object? counted = null,Object? matched = null,Object? completedAt = freezed,}) {
  return _then(_InventoryStats(
totalItems: null == totalItems ? _self.totalItems : totalItems // ignore: cast_nullable_to_non_nullable
as int,counted: null == counted ? _self.counted : counted // ignore: cast_nullable_to_non_nullable
as int,matched: null == matched ? _self.matched : matched // ignore: cast_nullable_to_non_nullable
as int,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$DispatchSummary {

 String get date; AttendanceStats get attendance; RouteStats get routes; InventoryStats get inventory; double? get petrolAllowanceTotal;
/// Create a copy of DispatchSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DispatchSummaryCopyWith<DispatchSummary> get copyWith => _$DispatchSummaryCopyWithImpl<DispatchSummary>(this as DispatchSummary, _$identity);

  /// Serializes this DispatchSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DispatchSummary&&(identical(other.date, date) || other.date == date)&&(identical(other.attendance, attendance) || other.attendance == attendance)&&(identical(other.routes, routes) || other.routes == routes)&&(identical(other.inventory, inventory) || other.inventory == inventory)&&(identical(other.petrolAllowanceTotal, petrolAllowanceTotal) || other.petrolAllowanceTotal == petrolAllowanceTotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,attendance,routes,inventory,petrolAllowanceTotal);

@override
String toString() {
  return 'DispatchSummary(date: $date, attendance: $attendance, routes: $routes, inventory: $inventory, petrolAllowanceTotal: $petrolAllowanceTotal)';
}


}

/// @nodoc
abstract mixin class $DispatchSummaryCopyWith<$Res>  {
  factory $DispatchSummaryCopyWith(DispatchSummary value, $Res Function(DispatchSummary) _then) = _$DispatchSummaryCopyWithImpl;
@useResult
$Res call({
 String date, AttendanceStats attendance, RouteStats routes, InventoryStats inventory, double? petrolAllowanceTotal
});


$AttendanceStatsCopyWith<$Res> get attendance;$RouteStatsCopyWith<$Res> get routes;$InventoryStatsCopyWith<$Res> get inventory;

}
/// @nodoc
class _$DispatchSummaryCopyWithImpl<$Res>
    implements $DispatchSummaryCopyWith<$Res> {
  _$DispatchSummaryCopyWithImpl(this._self, this._then);

  final DispatchSummary _self;
  final $Res Function(DispatchSummary) _then;

/// Create a copy of DispatchSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? attendance = null,Object? routes = null,Object? inventory = null,Object? petrolAllowanceTotal = freezed,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,attendance: null == attendance ? _self.attendance : attendance // ignore: cast_nullable_to_non_nullable
as AttendanceStats,routes: null == routes ? _self.routes : routes // ignore: cast_nullable_to_non_nullable
as RouteStats,inventory: null == inventory ? _self.inventory : inventory // ignore: cast_nullable_to_non_nullable
as InventoryStats,petrolAllowanceTotal: freezed == petrolAllowanceTotal ? _self.petrolAllowanceTotal : petrolAllowanceTotal // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}
/// Create a copy of DispatchSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttendanceStatsCopyWith<$Res> get attendance {
  
  return $AttendanceStatsCopyWith<$Res>(_self.attendance, (value) {
    return _then(_self.copyWith(attendance: value));
  });
}/// Create a copy of DispatchSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteStatsCopyWith<$Res> get routes {
  
  return $RouteStatsCopyWith<$Res>(_self.routes, (value) {
    return _then(_self.copyWith(routes: value));
  });
}/// Create a copy of DispatchSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventoryStatsCopyWith<$Res> get inventory {
  
  return $InventoryStatsCopyWith<$Res>(_self.inventory, (value) {
    return _then(_self.copyWith(inventory: value));
  });
}
}


/// Adds pattern-matching-related methods to [DispatchSummary].
extension DispatchSummaryPatterns on DispatchSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DispatchSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DispatchSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DispatchSummary value)  $default,){
final _that = this;
switch (_that) {
case _DispatchSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DispatchSummary value)?  $default,){
final _that = this;
switch (_that) {
case _DispatchSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  AttendanceStats attendance,  RouteStats routes,  InventoryStats inventory,  double? petrolAllowanceTotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DispatchSummary() when $default != null:
return $default(_that.date,_that.attendance,_that.routes,_that.inventory,_that.petrolAllowanceTotal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  AttendanceStats attendance,  RouteStats routes,  InventoryStats inventory,  double? petrolAllowanceTotal)  $default,) {final _that = this;
switch (_that) {
case _DispatchSummary():
return $default(_that.date,_that.attendance,_that.routes,_that.inventory,_that.petrolAllowanceTotal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  AttendanceStats attendance,  RouteStats routes,  InventoryStats inventory,  double? petrolAllowanceTotal)?  $default,) {final _that = this;
switch (_that) {
case _DispatchSummary() when $default != null:
return $default(_that.date,_that.attendance,_that.routes,_that.inventory,_that.petrolAllowanceTotal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DispatchSummary implements DispatchSummary {
  const _DispatchSummary({required this.date, required this.attendance, required this.routes, required this.inventory, this.petrolAllowanceTotal});
  factory _DispatchSummary.fromJson(Map<String, dynamic> json) => _$DispatchSummaryFromJson(json);

@override final  String date;
@override final  AttendanceStats attendance;
@override final  RouteStats routes;
@override final  InventoryStats inventory;
@override final  double? petrolAllowanceTotal;

/// Create a copy of DispatchSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DispatchSummaryCopyWith<_DispatchSummary> get copyWith => __$DispatchSummaryCopyWithImpl<_DispatchSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DispatchSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DispatchSummary&&(identical(other.date, date) || other.date == date)&&(identical(other.attendance, attendance) || other.attendance == attendance)&&(identical(other.routes, routes) || other.routes == routes)&&(identical(other.inventory, inventory) || other.inventory == inventory)&&(identical(other.petrolAllowanceTotal, petrolAllowanceTotal) || other.petrolAllowanceTotal == petrolAllowanceTotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,attendance,routes,inventory,petrolAllowanceTotal);

@override
String toString() {
  return 'DispatchSummary(date: $date, attendance: $attendance, routes: $routes, inventory: $inventory, petrolAllowanceTotal: $petrolAllowanceTotal)';
}


}

/// @nodoc
abstract mixin class _$DispatchSummaryCopyWith<$Res> implements $DispatchSummaryCopyWith<$Res> {
  factory _$DispatchSummaryCopyWith(_DispatchSummary value, $Res Function(_DispatchSummary) _then) = __$DispatchSummaryCopyWithImpl;
@override @useResult
$Res call({
 String date, AttendanceStats attendance, RouteStats routes, InventoryStats inventory, double? petrolAllowanceTotal
});


@override $AttendanceStatsCopyWith<$Res> get attendance;@override $RouteStatsCopyWith<$Res> get routes;@override $InventoryStatsCopyWith<$Res> get inventory;

}
/// @nodoc
class __$DispatchSummaryCopyWithImpl<$Res>
    implements _$DispatchSummaryCopyWith<$Res> {
  __$DispatchSummaryCopyWithImpl(this._self, this._then);

  final _DispatchSummary _self;
  final $Res Function(_DispatchSummary) _then;

/// Create a copy of DispatchSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? attendance = null,Object? routes = null,Object? inventory = null,Object? petrolAllowanceTotal = freezed,}) {
  return _then(_DispatchSummary(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,attendance: null == attendance ? _self.attendance : attendance // ignore: cast_nullable_to_non_nullable
as AttendanceStats,routes: null == routes ? _self.routes : routes // ignore: cast_nullable_to_non_nullable
as RouteStats,inventory: null == inventory ? _self.inventory : inventory // ignore: cast_nullable_to_non_nullable
as InventoryStats,petrolAllowanceTotal: freezed == petrolAllowanceTotal ? _self.petrolAllowanceTotal : petrolAllowanceTotal // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

/// Create a copy of DispatchSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttendanceStatsCopyWith<$Res> get attendance {
  
  return $AttendanceStatsCopyWith<$Res>(_self.attendance, (value) {
    return _then(_self.copyWith(attendance: value));
  });
}/// Create a copy of DispatchSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteStatsCopyWith<$Res> get routes {
  
  return $RouteStatsCopyWith<$Res>(_self.routes, (value) {
    return _then(_self.copyWith(routes: value));
  });
}/// Create a copy of DispatchSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventoryStatsCopyWith<$Res> get inventory {
  
  return $InventoryStatsCopyWith<$Res>(_self.inventory, (value) {
    return _then(_self.copyWith(inventory: value));
  });
}
}

// dart format on
