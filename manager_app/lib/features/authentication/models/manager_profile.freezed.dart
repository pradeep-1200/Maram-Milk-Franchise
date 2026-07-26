// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manager_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ManagerProfile {

 String get id; String get name; String get role; String get branchName;
/// Create a copy of ManagerProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ManagerProfileCopyWith<ManagerProfile> get copyWith => _$ManagerProfileCopyWithImpl<ManagerProfile>(this as ManagerProfile, _$identity);

  /// Serializes this ManagerProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ManagerProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.branchName, branchName) || other.branchName == branchName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,role,branchName);

@override
String toString() {
  return 'ManagerProfile(id: $id, name: $name, role: $role, branchName: $branchName)';
}


}

/// @nodoc
abstract mixin class $ManagerProfileCopyWith<$Res>  {
  factory $ManagerProfileCopyWith(ManagerProfile value, $Res Function(ManagerProfile) _then) = _$ManagerProfileCopyWithImpl;
@useResult
$Res call({
 String id, String name, String role, String branchName
});




}
/// @nodoc
class _$ManagerProfileCopyWithImpl<$Res>
    implements $ManagerProfileCopyWith<$Res> {
  _$ManagerProfileCopyWithImpl(this._self, this._then);

  final ManagerProfile _self;
  final $Res Function(ManagerProfile) _then;

/// Create a copy of ManagerProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? role = null,Object? branchName = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,branchName: null == branchName ? _self.branchName : branchName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ManagerProfile].
extension ManagerProfilePatterns on ManagerProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ManagerProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ManagerProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ManagerProfile value)  $default,){
final _that = this;
switch (_that) {
case _ManagerProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ManagerProfile value)?  $default,){
final _that = this;
switch (_that) {
case _ManagerProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String role,  String branchName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ManagerProfile() when $default != null:
return $default(_that.id,_that.name,_that.role,_that.branchName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String role,  String branchName)  $default,) {final _that = this;
switch (_that) {
case _ManagerProfile():
return $default(_that.id,_that.name,_that.role,_that.branchName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String role,  String branchName)?  $default,) {final _that = this;
switch (_that) {
case _ManagerProfile() when $default != null:
return $default(_that.id,_that.name,_that.role,_that.branchName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ManagerProfile implements ManagerProfile {
  const _ManagerProfile({this.id = '', this.name = '', this.role = 'Manager', this.branchName = ''});
  factory _ManagerProfile.fromJson(Map<String, dynamic> json) => _$ManagerProfileFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String role;
@override@JsonKey() final  String branchName;

/// Create a copy of ManagerProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ManagerProfileCopyWith<_ManagerProfile> get copyWith => __$ManagerProfileCopyWithImpl<_ManagerProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ManagerProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ManagerProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.branchName, branchName) || other.branchName == branchName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,role,branchName);

@override
String toString() {
  return 'ManagerProfile(id: $id, name: $name, role: $role, branchName: $branchName)';
}


}

/// @nodoc
abstract mixin class _$ManagerProfileCopyWith<$Res> implements $ManagerProfileCopyWith<$Res> {
  factory _$ManagerProfileCopyWith(_ManagerProfile value, $Res Function(_ManagerProfile) _then) = __$ManagerProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String role, String branchName
});




}
/// @nodoc
class __$ManagerProfileCopyWithImpl<$Res>
    implements _$ManagerProfileCopyWith<$Res> {
  __$ManagerProfileCopyWithImpl(this._self, this._then);

  final _ManagerProfile _self;
  final $Res Function(_ManagerProfile) _then;

/// Create a copy of ManagerProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? role = null,Object? branchName = null,}) {
  return _then(_ManagerProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,branchName: null == branchName ? _self.branchName : branchName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
