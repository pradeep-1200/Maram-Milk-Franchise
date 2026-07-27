// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttendanceEntry {

 String get dpId; String get dpCode; String get name;@JsonKey(name: 'photoUrl') String? get profilePictureUrl; AttendanceStatus get status; String? get recordId; String? get markedAt; int? get petrolAllowanceGivenToday;
/// Create a copy of AttendanceEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceEntryCopyWith<AttendanceEntry> get copyWith => _$AttendanceEntryCopyWithImpl<AttendanceEntry>(this as AttendanceEntry, _$identity);

  /// Serializes this AttendanceEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceEntry&&(identical(other.dpId, dpId) || other.dpId == dpId)&&(identical(other.dpCode, dpCode) || other.dpCode == dpCode)&&(identical(other.name, name) || other.name == name)&&(identical(other.profilePictureUrl, profilePictureUrl) || other.profilePictureUrl == profilePictureUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.recordId, recordId) || other.recordId == recordId)&&(identical(other.markedAt, markedAt) || other.markedAt == markedAt)&&(identical(other.petrolAllowanceGivenToday, petrolAllowanceGivenToday) || other.petrolAllowanceGivenToday == petrolAllowanceGivenToday));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dpId,dpCode,name,profilePictureUrl,status,recordId,markedAt,petrolAllowanceGivenToday);

@override
String toString() {
  return 'AttendanceEntry(dpId: $dpId, dpCode: $dpCode, name: $name, profilePictureUrl: $profilePictureUrl, status: $status, recordId: $recordId, markedAt: $markedAt, petrolAllowanceGivenToday: $petrolAllowanceGivenToday)';
}


}

/// @nodoc
abstract mixin class $AttendanceEntryCopyWith<$Res>  {
  factory $AttendanceEntryCopyWith(AttendanceEntry value, $Res Function(AttendanceEntry) _then) = _$AttendanceEntryCopyWithImpl;
@useResult
$Res call({
 String dpId, String dpCode, String name,@JsonKey(name: 'photoUrl') String? profilePictureUrl, AttendanceStatus status, String? recordId, String? markedAt, int? petrolAllowanceGivenToday
});




}
/// @nodoc
class _$AttendanceEntryCopyWithImpl<$Res>
    implements $AttendanceEntryCopyWith<$Res> {
  _$AttendanceEntryCopyWithImpl(this._self, this._then);

  final AttendanceEntry _self;
  final $Res Function(AttendanceEntry) _then;

/// Create a copy of AttendanceEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dpId = null,Object? dpCode = null,Object? name = null,Object? profilePictureUrl = freezed,Object? status = null,Object? recordId = freezed,Object? markedAt = freezed,Object? petrolAllowanceGivenToday = freezed,}) {
  return _then(_self.copyWith(
dpId: null == dpId ? _self.dpId : dpId // ignore: cast_nullable_to_non_nullable
as String,dpCode: null == dpCode ? _self.dpCode : dpCode // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,profilePictureUrl: freezed == profilePictureUrl ? _self.profilePictureUrl : profilePictureUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceStatus,recordId: freezed == recordId ? _self.recordId : recordId // ignore: cast_nullable_to_non_nullable
as String?,markedAt: freezed == markedAt ? _self.markedAt : markedAt // ignore: cast_nullable_to_non_nullable
as String?,petrolAllowanceGivenToday: freezed == petrolAllowanceGivenToday ? _self.petrolAllowanceGivenToday : petrolAllowanceGivenToday // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceEntry].
extension AttendanceEntryPatterns on AttendanceEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceEntry value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceEntry value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String dpId,  String dpCode,  String name, @JsonKey(name: 'photoUrl')  String? profilePictureUrl,  AttendanceStatus status,  String? recordId,  String? markedAt,  int? petrolAllowanceGivenToday)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceEntry() when $default != null:
return $default(_that.dpId,_that.dpCode,_that.name,_that.profilePictureUrl,_that.status,_that.recordId,_that.markedAt,_that.petrolAllowanceGivenToday);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String dpId,  String dpCode,  String name, @JsonKey(name: 'photoUrl')  String? profilePictureUrl,  AttendanceStatus status,  String? recordId,  String? markedAt,  int? petrolAllowanceGivenToday)  $default,) {final _that = this;
switch (_that) {
case _AttendanceEntry():
return $default(_that.dpId,_that.dpCode,_that.name,_that.profilePictureUrl,_that.status,_that.recordId,_that.markedAt,_that.petrolAllowanceGivenToday);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String dpId,  String dpCode,  String name, @JsonKey(name: 'photoUrl')  String? profilePictureUrl,  AttendanceStatus status,  String? recordId,  String? markedAt,  int? petrolAllowanceGivenToday)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceEntry() when $default != null:
return $default(_that.dpId,_that.dpCode,_that.name,_that.profilePictureUrl,_that.status,_that.recordId,_that.markedAt,_that.petrolAllowanceGivenToday);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceEntry extends AttendanceEntry {
  const _AttendanceEntry({required this.dpId, required this.dpCode, required this.name, @JsonKey(name: 'photoUrl') this.profilePictureUrl, this.status = AttendanceStatus.pending, this.recordId, this.markedAt, this.petrolAllowanceGivenToday}): super._();
  factory _AttendanceEntry.fromJson(Map<String, dynamic> json) => _$AttendanceEntryFromJson(json);

@override final  String dpId;
@override final  String dpCode;
@override final  String name;
@override@JsonKey(name: 'photoUrl') final  String? profilePictureUrl;
@override@JsonKey() final  AttendanceStatus status;
@override final  String? recordId;
@override final  String? markedAt;
@override final  int? petrolAllowanceGivenToday;

/// Create a copy of AttendanceEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceEntryCopyWith<_AttendanceEntry> get copyWith => __$AttendanceEntryCopyWithImpl<_AttendanceEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceEntry&&(identical(other.dpId, dpId) || other.dpId == dpId)&&(identical(other.dpCode, dpCode) || other.dpCode == dpCode)&&(identical(other.name, name) || other.name == name)&&(identical(other.profilePictureUrl, profilePictureUrl) || other.profilePictureUrl == profilePictureUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.recordId, recordId) || other.recordId == recordId)&&(identical(other.markedAt, markedAt) || other.markedAt == markedAt)&&(identical(other.petrolAllowanceGivenToday, petrolAllowanceGivenToday) || other.petrolAllowanceGivenToday == petrolAllowanceGivenToday));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dpId,dpCode,name,profilePictureUrl,status,recordId,markedAt,petrolAllowanceGivenToday);

@override
String toString() {
  return 'AttendanceEntry(dpId: $dpId, dpCode: $dpCode, name: $name, profilePictureUrl: $profilePictureUrl, status: $status, recordId: $recordId, markedAt: $markedAt, petrolAllowanceGivenToday: $petrolAllowanceGivenToday)';
}


}

/// @nodoc
abstract mixin class _$AttendanceEntryCopyWith<$Res> implements $AttendanceEntryCopyWith<$Res> {
  factory _$AttendanceEntryCopyWith(_AttendanceEntry value, $Res Function(_AttendanceEntry) _then) = __$AttendanceEntryCopyWithImpl;
@override @useResult
$Res call({
 String dpId, String dpCode, String name,@JsonKey(name: 'photoUrl') String? profilePictureUrl, AttendanceStatus status, String? recordId, String? markedAt, int? petrolAllowanceGivenToday
});




}
/// @nodoc
class __$AttendanceEntryCopyWithImpl<$Res>
    implements _$AttendanceEntryCopyWith<$Res> {
  __$AttendanceEntryCopyWithImpl(this._self, this._then);

  final _AttendanceEntry _self;
  final $Res Function(_AttendanceEntry) _then;

/// Create a copy of AttendanceEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dpId = null,Object? dpCode = null,Object? name = null,Object? profilePictureUrl = freezed,Object? status = null,Object? recordId = freezed,Object? markedAt = freezed,Object? petrolAllowanceGivenToday = freezed,}) {
  return _then(_AttendanceEntry(
dpId: null == dpId ? _self.dpId : dpId // ignore: cast_nullable_to_non_nullable
as String,dpCode: null == dpCode ? _self.dpCode : dpCode // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,profilePictureUrl: freezed == profilePictureUrl ? _self.profilePictureUrl : profilePictureUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceStatus,recordId: freezed == recordId ? _self.recordId : recordId // ignore: cast_nullable_to_non_nullable
as String?,markedAt: freezed == markedAt ? _self.markedAt : markedAt // ignore: cast_nullable_to_non_nullable
as String?,petrolAllowanceGivenToday: freezed == petrolAllowanceGivenToday ? _self.petrolAllowanceGivenToday : petrolAllowanceGivenToday // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
