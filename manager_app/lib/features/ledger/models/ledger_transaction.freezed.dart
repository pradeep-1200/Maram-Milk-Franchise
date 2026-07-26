// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ledger_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LedgerTransaction {

 String get id; String? get dpId; String get date; DeliveryPerson? get dp; String? get routeId; Map<String, dynamic>? get route; double get givenAllowance; double get defaultAllowance; String get status;
/// Create a copy of LedgerTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LedgerTransactionCopyWith<LedgerTransaction> get copyWith => _$LedgerTransactionCopyWithImpl<LedgerTransaction>(this as LedgerTransaction, _$identity);

  /// Serializes this LedgerTransaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LedgerTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.dpId, dpId) || other.dpId == dpId)&&(identical(other.date, date) || other.date == date)&&(identical(other.dp, dp) || other.dp == dp)&&(identical(other.routeId, routeId) || other.routeId == routeId)&&const DeepCollectionEquality().equals(other.route, route)&&(identical(other.givenAllowance, givenAllowance) || other.givenAllowance == givenAllowance)&&(identical(other.defaultAllowance, defaultAllowance) || other.defaultAllowance == defaultAllowance)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,dpId,date,dp,routeId,const DeepCollectionEquality().hash(route),givenAllowance,defaultAllowance,status);

@override
String toString() {
  return 'LedgerTransaction(id: $id, dpId: $dpId, date: $date, dp: $dp, routeId: $routeId, route: $route, givenAllowance: $givenAllowance, defaultAllowance: $defaultAllowance, status: $status)';
}


}

/// @nodoc
abstract mixin class $LedgerTransactionCopyWith<$Res>  {
  factory $LedgerTransactionCopyWith(LedgerTransaction value, $Res Function(LedgerTransaction) _then) = _$LedgerTransactionCopyWithImpl;
@useResult
$Res call({
 String id, String? dpId, String date, DeliveryPerson? dp, String? routeId, Map<String, dynamic>? route, double givenAllowance, double defaultAllowance, String status
});


$DeliveryPersonCopyWith<$Res>? get dp;

}
/// @nodoc
class _$LedgerTransactionCopyWithImpl<$Res>
    implements $LedgerTransactionCopyWith<$Res> {
  _$LedgerTransactionCopyWithImpl(this._self, this._then);

  final LedgerTransaction _self;
  final $Res Function(LedgerTransaction) _then;

/// Create a copy of LedgerTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? dpId = freezed,Object? date = null,Object? dp = freezed,Object? routeId = freezed,Object? route = freezed,Object? givenAllowance = null,Object? defaultAllowance = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dpId: freezed == dpId ? _self.dpId : dpId // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,dp: freezed == dp ? _self.dp : dp // ignore: cast_nullable_to_non_nullable
as DeliveryPerson?,routeId: freezed == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as String?,route: freezed == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,givenAllowance: null == givenAllowance ? _self.givenAllowance : givenAllowance // ignore: cast_nullable_to_non_nullable
as double,defaultAllowance: null == defaultAllowance ? _self.defaultAllowance : defaultAllowance // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of LedgerTransaction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeliveryPersonCopyWith<$Res>? get dp {
    if (_self.dp == null) {
    return null;
  }

  return $DeliveryPersonCopyWith<$Res>(_self.dp!, (value) {
    return _then(_self.copyWith(dp: value));
  });
}
}


/// Adds pattern-matching-related methods to [LedgerTransaction].
extension LedgerTransactionPatterns on LedgerTransaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LedgerTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LedgerTransaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LedgerTransaction value)  $default,){
final _that = this;
switch (_that) {
case _LedgerTransaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LedgerTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _LedgerTransaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? dpId,  String date,  DeliveryPerson? dp,  String? routeId,  Map<String, dynamic>? route,  double givenAllowance,  double defaultAllowance,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LedgerTransaction() when $default != null:
return $default(_that.id,_that.dpId,_that.date,_that.dp,_that.routeId,_that.route,_that.givenAllowance,_that.defaultAllowance,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? dpId,  String date,  DeliveryPerson? dp,  String? routeId,  Map<String, dynamic>? route,  double givenAllowance,  double defaultAllowance,  String status)  $default,) {final _that = this;
switch (_that) {
case _LedgerTransaction():
return $default(_that.id,_that.dpId,_that.date,_that.dp,_that.routeId,_that.route,_that.givenAllowance,_that.defaultAllowance,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? dpId,  String date,  DeliveryPerson? dp,  String? routeId,  Map<String, dynamic>? route,  double givenAllowance,  double defaultAllowance,  String status)?  $default,) {final _that = this;
switch (_that) {
case _LedgerTransaction() when $default != null:
return $default(_that.id,_that.dpId,_that.date,_that.dp,_that.routeId,_that.route,_that.givenAllowance,_that.defaultAllowance,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LedgerTransaction implements LedgerTransaction {
  const _LedgerTransaction({required this.id, this.dpId, required this.date, this.dp, this.routeId, final  Map<String, dynamic>? route, this.givenAllowance = 0, this.defaultAllowance = 0, required this.status}): _route = route;
  factory _LedgerTransaction.fromJson(Map<String, dynamic> json) => _$LedgerTransactionFromJson(json);

@override final  String id;
@override final  String? dpId;
@override final  String date;
@override final  DeliveryPerson? dp;
@override final  String? routeId;
 final  Map<String, dynamic>? _route;
@override Map<String, dynamic>? get route {
  final value = _route;
  if (value == null) return null;
  if (_route is EqualUnmodifiableMapView) return _route;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey() final  double givenAllowance;
@override@JsonKey() final  double defaultAllowance;
@override final  String status;

/// Create a copy of LedgerTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LedgerTransactionCopyWith<_LedgerTransaction> get copyWith => __$LedgerTransactionCopyWithImpl<_LedgerTransaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LedgerTransactionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LedgerTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.dpId, dpId) || other.dpId == dpId)&&(identical(other.date, date) || other.date == date)&&(identical(other.dp, dp) || other.dp == dp)&&(identical(other.routeId, routeId) || other.routeId == routeId)&&const DeepCollectionEquality().equals(other._route, _route)&&(identical(other.givenAllowance, givenAllowance) || other.givenAllowance == givenAllowance)&&(identical(other.defaultAllowance, defaultAllowance) || other.defaultAllowance == defaultAllowance)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,dpId,date,dp,routeId,const DeepCollectionEquality().hash(_route),givenAllowance,defaultAllowance,status);

@override
String toString() {
  return 'LedgerTransaction(id: $id, dpId: $dpId, date: $date, dp: $dp, routeId: $routeId, route: $route, givenAllowance: $givenAllowance, defaultAllowance: $defaultAllowance, status: $status)';
}


}

/// @nodoc
abstract mixin class _$LedgerTransactionCopyWith<$Res> implements $LedgerTransactionCopyWith<$Res> {
  factory _$LedgerTransactionCopyWith(_LedgerTransaction value, $Res Function(_LedgerTransaction) _then) = __$LedgerTransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, String? dpId, String date, DeliveryPerson? dp, String? routeId, Map<String, dynamic>? route, double givenAllowance, double defaultAllowance, String status
});


@override $DeliveryPersonCopyWith<$Res>? get dp;

}
/// @nodoc
class __$LedgerTransactionCopyWithImpl<$Res>
    implements _$LedgerTransactionCopyWith<$Res> {
  __$LedgerTransactionCopyWithImpl(this._self, this._then);

  final _LedgerTransaction _self;
  final $Res Function(_LedgerTransaction) _then;

/// Create a copy of LedgerTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? dpId = freezed,Object? date = null,Object? dp = freezed,Object? routeId = freezed,Object? route = freezed,Object? givenAllowance = null,Object? defaultAllowance = null,Object? status = null,}) {
  return _then(_LedgerTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dpId: freezed == dpId ? _self.dpId : dpId // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,dp: freezed == dp ? _self.dp : dp // ignore: cast_nullable_to_non_nullable
as DeliveryPerson?,routeId: freezed == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as String?,route: freezed == route ? _self._route : route // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,givenAllowance: null == givenAllowance ? _self.givenAllowance : givenAllowance // ignore: cast_nullable_to_non_nullable
as double,defaultAllowance: null == defaultAllowance ? _self.defaultAllowance : defaultAllowance // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of LedgerTransaction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeliveryPersonCopyWith<$Res>? get dp {
    if (_self.dp == null) {
    return null;
  }

  return $DeliveryPersonCopyWith<$Res>(_self.dp!, (value) {
    return _then(_self.copyWith(dp: value));
  });
}
}

// dart format on
