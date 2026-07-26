// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dp_performance_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DpPerformanceReport {

 String get dpId; String get dpCode; String get name; String? get photoUrl; double get totalLitres; int get totalRoutes; String get attendanceRatio; int get totalBottles;
/// Create a copy of DpPerformanceReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DpPerformanceReportCopyWith<DpPerformanceReport> get copyWith => _$DpPerformanceReportCopyWithImpl<DpPerformanceReport>(this as DpPerformanceReport, _$identity);

  /// Serializes this DpPerformanceReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DpPerformanceReport&&(identical(other.dpId, dpId) || other.dpId == dpId)&&(identical(other.dpCode, dpCode) || other.dpCode == dpCode)&&(identical(other.name, name) || other.name == name)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.totalLitres, totalLitres) || other.totalLitres == totalLitres)&&(identical(other.totalRoutes, totalRoutes) || other.totalRoutes == totalRoutes)&&(identical(other.attendanceRatio, attendanceRatio) || other.attendanceRatio == attendanceRatio)&&(identical(other.totalBottles, totalBottles) || other.totalBottles == totalBottles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dpId,dpCode,name,photoUrl,totalLitres,totalRoutes,attendanceRatio,totalBottles);

@override
String toString() {
  return 'DpPerformanceReport(dpId: $dpId, dpCode: $dpCode, name: $name, photoUrl: $photoUrl, totalLitres: $totalLitres, totalRoutes: $totalRoutes, attendanceRatio: $attendanceRatio, totalBottles: $totalBottles)';
}


}

/// @nodoc
abstract mixin class $DpPerformanceReportCopyWith<$Res>  {
  factory $DpPerformanceReportCopyWith(DpPerformanceReport value, $Res Function(DpPerformanceReport) _then) = _$DpPerformanceReportCopyWithImpl;
@useResult
$Res call({
 String dpId, String dpCode, String name, String? photoUrl, double totalLitres, int totalRoutes, String attendanceRatio, int totalBottles
});




}
/// @nodoc
class _$DpPerformanceReportCopyWithImpl<$Res>
    implements $DpPerformanceReportCopyWith<$Res> {
  _$DpPerformanceReportCopyWithImpl(this._self, this._then);

  final DpPerformanceReport _self;
  final $Res Function(DpPerformanceReport) _then;

/// Create a copy of DpPerformanceReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dpId = null,Object? dpCode = null,Object? name = null,Object? photoUrl = freezed,Object? totalLitres = null,Object? totalRoutes = null,Object? attendanceRatio = null,Object? totalBottles = null,}) {
  return _then(_self.copyWith(
dpId: null == dpId ? _self.dpId : dpId // ignore: cast_nullable_to_non_nullable
as String,dpCode: null == dpCode ? _self.dpCode : dpCode // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,totalLitres: null == totalLitres ? _self.totalLitres : totalLitres // ignore: cast_nullable_to_non_nullable
as double,totalRoutes: null == totalRoutes ? _self.totalRoutes : totalRoutes // ignore: cast_nullable_to_non_nullable
as int,attendanceRatio: null == attendanceRatio ? _self.attendanceRatio : attendanceRatio // ignore: cast_nullable_to_non_nullable
as String,totalBottles: null == totalBottles ? _self.totalBottles : totalBottles // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DpPerformanceReport].
extension DpPerformanceReportPatterns on DpPerformanceReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DpPerformanceReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DpPerformanceReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DpPerformanceReport value)  $default,){
final _that = this;
switch (_that) {
case _DpPerformanceReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DpPerformanceReport value)?  $default,){
final _that = this;
switch (_that) {
case _DpPerformanceReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String dpId,  String dpCode,  String name,  String? photoUrl,  double totalLitres,  int totalRoutes,  String attendanceRatio,  int totalBottles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DpPerformanceReport() when $default != null:
return $default(_that.dpId,_that.dpCode,_that.name,_that.photoUrl,_that.totalLitres,_that.totalRoutes,_that.attendanceRatio,_that.totalBottles);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String dpId,  String dpCode,  String name,  String? photoUrl,  double totalLitres,  int totalRoutes,  String attendanceRatio,  int totalBottles)  $default,) {final _that = this;
switch (_that) {
case _DpPerformanceReport():
return $default(_that.dpId,_that.dpCode,_that.name,_that.photoUrl,_that.totalLitres,_that.totalRoutes,_that.attendanceRatio,_that.totalBottles);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String dpId,  String dpCode,  String name,  String? photoUrl,  double totalLitres,  int totalRoutes,  String attendanceRatio,  int totalBottles)?  $default,) {final _that = this;
switch (_that) {
case _DpPerformanceReport() when $default != null:
return $default(_that.dpId,_that.dpCode,_that.name,_that.photoUrl,_that.totalLitres,_that.totalRoutes,_that.attendanceRatio,_that.totalBottles);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DpPerformanceReport implements DpPerformanceReport {
  const _DpPerformanceReport({required this.dpId, required this.dpCode, required this.name, this.photoUrl, required this.totalLitres, required this.totalRoutes, required this.attendanceRatio, required this.totalBottles});
  factory _DpPerformanceReport.fromJson(Map<String, dynamic> json) => _$DpPerformanceReportFromJson(json);

@override final  String dpId;
@override final  String dpCode;
@override final  String name;
@override final  String? photoUrl;
@override final  double totalLitres;
@override final  int totalRoutes;
@override final  String attendanceRatio;
@override final  int totalBottles;

/// Create a copy of DpPerformanceReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DpPerformanceReportCopyWith<_DpPerformanceReport> get copyWith => __$DpPerformanceReportCopyWithImpl<_DpPerformanceReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DpPerformanceReportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DpPerformanceReport&&(identical(other.dpId, dpId) || other.dpId == dpId)&&(identical(other.dpCode, dpCode) || other.dpCode == dpCode)&&(identical(other.name, name) || other.name == name)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.totalLitres, totalLitres) || other.totalLitres == totalLitres)&&(identical(other.totalRoutes, totalRoutes) || other.totalRoutes == totalRoutes)&&(identical(other.attendanceRatio, attendanceRatio) || other.attendanceRatio == attendanceRatio)&&(identical(other.totalBottles, totalBottles) || other.totalBottles == totalBottles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dpId,dpCode,name,photoUrl,totalLitres,totalRoutes,attendanceRatio,totalBottles);

@override
String toString() {
  return 'DpPerformanceReport(dpId: $dpId, dpCode: $dpCode, name: $name, photoUrl: $photoUrl, totalLitres: $totalLitres, totalRoutes: $totalRoutes, attendanceRatio: $attendanceRatio, totalBottles: $totalBottles)';
}


}

/// @nodoc
abstract mixin class _$DpPerformanceReportCopyWith<$Res> implements $DpPerformanceReportCopyWith<$Res> {
  factory _$DpPerformanceReportCopyWith(_DpPerformanceReport value, $Res Function(_DpPerformanceReport) _then) = __$DpPerformanceReportCopyWithImpl;
@override @useResult
$Res call({
 String dpId, String dpCode, String name, String? photoUrl, double totalLitres, int totalRoutes, String attendanceRatio, int totalBottles
});




}
/// @nodoc
class __$DpPerformanceReportCopyWithImpl<$Res>
    implements _$DpPerformanceReportCopyWith<$Res> {
  __$DpPerformanceReportCopyWithImpl(this._self, this._then);

  final _DpPerformanceReport _self;
  final $Res Function(_DpPerformanceReport) _then;

/// Create a copy of DpPerformanceReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dpId = null,Object? dpCode = null,Object? name = null,Object? photoUrl = freezed,Object? totalLitres = null,Object? totalRoutes = null,Object? attendanceRatio = null,Object? totalBottles = null,}) {
  return _then(_DpPerformanceReport(
dpId: null == dpId ? _self.dpId : dpId // ignore: cast_nullable_to_non_nullable
as String,dpCode: null == dpCode ? _self.dpCode : dpCode // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,totalLitres: null == totalLitres ? _self.totalLitres : totalLitres // ignore: cast_nullable_to_non_nullable
as double,totalRoutes: null == totalRoutes ? _self.totalRoutes : totalRoutes // ignore: cast_nullable_to_non_nullable
as int,attendanceRatio: null == attendanceRatio ? _self.attendanceRatio : attendanceRatio // ignore: cast_nullable_to_non_nullable
as String,totalBottles: null == totalBottles ? _self.totalBottles : totalBottles // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
