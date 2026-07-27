// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery_person.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeliveryPerson {

 String get id; String get name;@JsonKey(name: 'dpCode') String get employeeId; AttendanceStatus get status; bool get isRouteAssigned;// Address & Zone
 String? get address; String? get zone;// Personal fields
 String? get dateOfBirth; String? get parentNameAndAddress; String? get parentOrSpouseMobile; String? get alternativeAddress; String get mobileNumber; String? get alternativeMobile; String? get whatsappNumber;// Identity fields
 String? get aadharNumber; String? get licenseNumber; String? get vehicleNumber;// Employment fields
 String? get dateOfJoining;// Payment fields
 String? get gpayNumber; String? get upiId; String? get bankAccountDetails;// Placeholder URLs
 String? get photoUrl; String? get aadharCopyUrl; String? get licenseCopyUrl;// System fields
 String? get createdAt; String? get updatedAt;// Attendance specific
 String? get recordId; String? get markedAt; int? get petrolAllowanceGivenToday;
/// Create a copy of DeliveryPerson
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeliveryPersonCopyWith<DeliveryPerson> get copyWith => _$DeliveryPersonCopyWithImpl<DeliveryPerson>(this as DeliveryPerson, _$identity);

  /// Serializes this DeliveryPerson to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeliveryPerson&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.status, status) || other.status == status)&&(identical(other.isRouteAssigned, isRouteAssigned) || other.isRouteAssigned == isRouteAssigned)&&(identical(other.address, address) || other.address == address)&&(identical(other.zone, zone) || other.zone == zone)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.parentNameAndAddress, parentNameAndAddress) || other.parentNameAndAddress == parentNameAndAddress)&&(identical(other.parentOrSpouseMobile, parentOrSpouseMobile) || other.parentOrSpouseMobile == parentOrSpouseMobile)&&(identical(other.alternativeAddress, alternativeAddress) || other.alternativeAddress == alternativeAddress)&&(identical(other.mobileNumber, mobileNumber) || other.mobileNumber == mobileNumber)&&(identical(other.alternativeMobile, alternativeMobile) || other.alternativeMobile == alternativeMobile)&&(identical(other.whatsappNumber, whatsappNumber) || other.whatsappNumber == whatsappNumber)&&(identical(other.aadharNumber, aadharNumber) || other.aadharNumber == aadharNumber)&&(identical(other.licenseNumber, licenseNumber) || other.licenseNumber == licenseNumber)&&(identical(other.vehicleNumber, vehicleNumber) || other.vehicleNumber == vehicleNumber)&&(identical(other.dateOfJoining, dateOfJoining) || other.dateOfJoining == dateOfJoining)&&(identical(other.gpayNumber, gpayNumber) || other.gpayNumber == gpayNumber)&&(identical(other.upiId, upiId) || other.upiId == upiId)&&(identical(other.bankAccountDetails, bankAccountDetails) || other.bankAccountDetails == bankAccountDetails)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.aadharCopyUrl, aadharCopyUrl) || other.aadharCopyUrl == aadharCopyUrl)&&(identical(other.licenseCopyUrl, licenseCopyUrl) || other.licenseCopyUrl == licenseCopyUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.recordId, recordId) || other.recordId == recordId)&&(identical(other.markedAt, markedAt) || other.markedAt == markedAt)&&(identical(other.petrolAllowanceGivenToday, petrolAllowanceGivenToday) || other.petrolAllowanceGivenToday == petrolAllowanceGivenToday));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,employeeId,status,isRouteAssigned,address,zone,dateOfBirth,parentNameAndAddress,parentOrSpouseMobile,alternativeAddress,mobileNumber,alternativeMobile,whatsappNumber,aadharNumber,licenseNumber,vehicleNumber,dateOfJoining,gpayNumber,upiId,bankAccountDetails,photoUrl,aadharCopyUrl,licenseCopyUrl,createdAt,updatedAt,recordId,markedAt,petrolAllowanceGivenToday]);

@override
String toString() {
  return 'DeliveryPerson(id: $id, name: $name, employeeId: $employeeId, status: $status, isRouteAssigned: $isRouteAssigned, address: $address, zone: $zone, dateOfBirth: $dateOfBirth, parentNameAndAddress: $parentNameAndAddress, parentOrSpouseMobile: $parentOrSpouseMobile, alternativeAddress: $alternativeAddress, mobileNumber: $mobileNumber, alternativeMobile: $alternativeMobile, whatsappNumber: $whatsappNumber, aadharNumber: $aadharNumber, licenseNumber: $licenseNumber, vehicleNumber: $vehicleNumber, dateOfJoining: $dateOfJoining, gpayNumber: $gpayNumber, upiId: $upiId, bankAccountDetails: $bankAccountDetails, photoUrl: $photoUrl, aadharCopyUrl: $aadharCopyUrl, licenseCopyUrl: $licenseCopyUrl, createdAt: $createdAt, updatedAt: $updatedAt, recordId: $recordId, markedAt: $markedAt, petrolAllowanceGivenToday: $petrolAllowanceGivenToday)';
}


}

/// @nodoc
abstract mixin class $DeliveryPersonCopyWith<$Res>  {
  factory $DeliveryPersonCopyWith(DeliveryPerson value, $Res Function(DeliveryPerson) _then) = _$DeliveryPersonCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(name: 'dpCode') String employeeId, AttendanceStatus status, bool isRouteAssigned, String? address, String? zone, String? dateOfBirth, String? parentNameAndAddress, String? parentOrSpouseMobile, String? alternativeAddress, String mobileNumber, String? alternativeMobile, String? whatsappNumber, String? aadharNumber, String? licenseNumber, String? vehicleNumber, String? dateOfJoining, String? gpayNumber, String? upiId, String? bankAccountDetails, String? photoUrl, String? aadharCopyUrl, String? licenseCopyUrl, String? createdAt, String? updatedAt, String? recordId, String? markedAt, int? petrolAllowanceGivenToday
});




}
/// @nodoc
class _$DeliveryPersonCopyWithImpl<$Res>
    implements $DeliveryPersonCopyWith<$Res> {
  _$DeliveryPersonCopyWithImpl(this._self, this._then);

  final DeliveryPerson _self;
  final $Res Function(DeliveryPerson) _then;

/// Create a copy of DeliveryPerson
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? employeeId = null,Object? status = null,Object? isRouteAssigned = null,Object? address = freezed,Object? zone = freezed,Object? dateOfBirth = freezed,Object? parentNameAndAddress = freezed,Object? parentOrSpouseMobile = freezed,Object? alternativeAddress = freezed,Object? mobileNumber = null,Object? alternativeMobile = freezed,Object? whatsappNumber = freezed,Object? aadharNumber = freezed,Object? licenseNumber = freezed,Object? vehicleNumber = freezed,Object? dateOfJoining = freezed,Object? gpayNumber = freezed,Object? upiId = freezed,Object? bankAccountDetails = freezed,Object? photoUrl = freezed,Object? aadharCopyUrl = freezed,Object? licenseCopyUrl = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? recordId = freezed,Object? markedAt = freezed,Object? petrolAllowanceGivenToday = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceStatus,isRouteAssigned: null == isRouteAssigned ? _self.isRouteAssigned : isRouteAssigned // ignore: cast_nullable_to_non_nullable
as bool,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,zone: freezed == zone ? _self.zone : zone // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String?,parentNameAndAddress: freezed == parentNameAndAddress ? _self.parentNameAndAddress : parentNameAndAddress // ignore: cast_nullable_to_non_nullable
as String?,parentOrSpouseMobile: freezed == parentOrSpouseMobile ? _self.parentOrSpouseMobile : parentOrSpouseMobile // ignore: cast_nullable_to_non_nullable
as String?,alternativeAddress: freezed == alternativeAddress ? _self.alternativeAddress : alternativeAddress // ignore: cast_nullable_to_non_nullable
as String?,mobileNumber: null == mobileNumber ? _self.mobileNumber : mobileNumber // ignore: cast_nullable_to_non_nullable
as String,alternativeMobile: freezed == alternativeMobile ? _self.alternativeMobile : alternativeMobile // ignore: cast_nullable_to_non_nullable
as String?,whatsappNumber: freezed == whatsappNumber ? _self.whatsappNumber : whatsappNumber // ignore: cast_nullable_to_non_nullable
as String?,aadharNumber: freezed == aadharNumber ? _self.aadharNumber : aadharNumber // ignore: cast_nullable_to_non_nullable
as String?,licenseNumber: freezed == licenseNumber ? _self.licenseNumber : licenseNumber // ignore: cast_nullable_to_non_nullable
as String?,vehicleNumber: freezed == vehicleNumber ? _self.vehicleNumber : vehicleNumber // ignore: cast_nullable_to_non_nullable
as String?,dateOfJoining: freezed == dateOfJoining ? _self.dateOfJoining : dateOfJoining // ignore: cast_nullable_to_non_nullable
as String?,gpayNumber: freezed == gpayNumber ? _self.gpayNumber : gpayNumber // ignore: cast_nullable_to_non_nullable
as String?,upiId: freezed == upiId ? _self.upiId : upiId // ignore: cast_nullable_to_non_nullable
as String?,bankAccountDetails: freezed == bankAccountDetails ? _self.bankAccountDetails : bankAccountDetails // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,aadharCopyUrl: freezed == aadharCopyUrl ? _self.aadharCopyUrl : aadharCopyUrl // ignore: cast_nullable_to_non_nullable
as String?,licenseCopyUrl: freezed == licenseCopyUrl ? _self.licenseCopyUrl : licenseCopyUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,recordId: freezed == recordId ? _self.recordId : recordId // ignore: cast_nullable_to_non_nullable
as String?,markedAt: freezed == markedAt ? _self.markedAt : markedAt // ignore: cast_nullable_to_non_nullable
as String?,petrolAllowanceGivenToday: freezed == petrolAllowanceGivenToday ? _self.petrolAllowanceGivenToday : petrolAllowanceGivenToday // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeliveryPerson].
extension DeliveryPersonPatterns on DeliveryPerson {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeliveryPerson value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeliveryPerson() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeliveryPerson value)  $default,){
final _that = this;
switch (_that) {
case _DeliveryPerson():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeliveryPerson value)?  $default,){
final _that = this;
switch (_that) {
case _DeliveryPerson() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'dpCode')  String employeeId,  AttendanceStatus status,  bool isRouteAssigned,  String? address,  String? zone,  String? dateOfBirth,  String? parentNameAndAddress,  String? parentOrSpouseMobile,  String? alternativeAddress,  String mobileNumber,  String? alternativeMobile,  String? whatsappNumber,  String? aadharNumber,  String? licenseNumber,  String? vehicleNumber,  String? dateOfJoining,  String? gpayNumber,  String? upiId,  String? bankAccountDetails,  String? photoUrl,  String? aadharCopyUrl,  String? licenseCopyUrl,  String? createdAt,  String? updatedAt,  String? recordId,  String? markedAt,  int? petrolAllowanceGivenToday)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeliveryPerson() when $default != null:
return $default(_that.id,_that.name,_that.employeeId,_that.status,_that.isRouteAssigned,_that.address,_that.zone,_that.dateOfBirth,_that.parentNameAndAddress,_that.parentOrSpouseMobile,_that.alternativeAddress,_that.mobileNumber,_that.alternativeMobile,_that.whatsappNumber,_that.aadharNumber,_that.licenseNumber,_that.vehicleNumber,_that.dateOfJoining,_that.gpayNumber,_that.upiId,_that.bankAccountDetails,_that.photoUrl,_that.aadharCopyUrl,_that.licenseCopyUrl,_that.createdAt,_that.updatedAt,_that.recordId,_that.markedAt,_that.petrolAllowanceGivenToday);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'dpCode')  String employeeId,  AttendanceStatus status,  bool isRouteAssigned,  String? address,  String? zone,  String? dateOfBirth,  String? parentNameAndAddress,  String? parentOrSpouseMobile,  String? alternativeAddress,  String mobileNumber,  String? alternativeMobile,  String? whatsappNumber,  String? aadharNumber,  String? licenseNumber,  String? vehicleNumber,  String? dateOfJoining,  String? gpayNumber,  String? upiId,  String? bankAccountDetails,  String? photoUrl,  String? aadharCopyUrl,  String? licenseCopyUrl,  String? createdAt,  String? updatedAt,  String? recordId,  String? markedAt,  int? petrolAllowanceGivenToday)  $default,) {final _that = this;
switch (_that) {
case _DeliveryPerson():
return $default(_that.id,_that.name,_that.employeeId,_that.status,_that.isRouteAssigned,_that.address,_that.zone,_that.dateOfBirth,_that.parentNameAndAddress,_that.parentOrSpouseMobile,_that.alternativeAddress,_that.mobileNumber,_that.alternativeMobile,_that.whatsappNumber,_that.aadharNumber,_that.licenseNumber,_that.vehicleNumber,_that.dateOfJoining,_that.gpayNumber,_that.upiId,_that.bankAccountDetails,_that.photoUrl,_that.aadharCopyUrl,_that.licenseCopyUrl,_that.createdAt,_that.updatedAt,_that.recordId,_that.markedAt,_that.petrolAllowanceGivenToday);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(name: 'dpCode')  String employeeId,  AttendanceStatus status,  bool isRouteAssigned,  String? address,  String? zone,  String? dateOfBirth,  String? parentNameAndAddress,  String? parentOrSpouseMobile,  String? alternativeAddress,  String mobileNumber,  String? alternativeMobile,  String? whatsappNumber,  String? aadharNumber,  String? licenseNumber,  String? vehicleNumber,  String? dateOfJoining,  String? gpayNumber,  String? upiId,  String? bankAccountDetails,  String? photoUrl,  String? aadharCopyUrl,  String? licenseCopyUrl,  String? createdAt,  String? updatedAt,  String? recordId,  String? markedAt,  int? petrolAllowanceGivenToday)?  $default,) {final _that = this;
switch (_that) {
case _DeliveryPerson() when $default != null:
return $default(_that.id,_that.name,_that.employeeId,_that.status,_that.isRouteAssigned,_that.address,_that.zone,_that.dateOfBirth,_that.parentNameAndAddress,_that.parentOrSpouseMobile,_that.alternativeAddress,_that.mobileNumber,_that.alternativeMobile,_that.whatsappNumber,_that.aadharNumber,_that.licenseNumber,_that.vehicleNumber,_that.dateOfJoining,_that.gpayNumber,_that.upiId,_that.bankAccountDetails,_that.photoUrl,_that.aadharCopyUrl,_that.licenseCopyUrl,_that.createdAt,_that.updatedAt,_that.recordId,_that.markedAt,_that.petrolAllowanceGivenToday);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeliveryPerson extends DeliveryPerson {
  const _DeliveryPerson({required this.id, required this.name, @JsonKey(name: 'dpCode') required this.employeeId, this.status = AttendanceStatus.pending, this.isRouteAssigned = false, this.address, this.zone, this.dateOfBirth, this.parentNameAndAddress, this.parentOrSpouseMobile, this.alternativeAddress, this.mobileNumber = '', this.alternativeMobile, this.whatsappNumber, this.aadharNumber, this.licenseNumber, this.vehicleNumber, this.dateOfJoining, this.gpayNumber, this.upiId, this.bankAccountDetails, this.photoUrl, this.aadharCopyUrl, this.licenseCopyUrl, this.createdAt, this.updatedAt, this.recordId, this.markedAt, this.petrolAllowanceGivenToday}): super._();
  factory _DeliveryPerson.fromJson(Map<String, dynamic> json) => _$DeliveryPersonFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey(name: 'dpCode') final  String employeeId;
@override@JsonKey() final  AttendanceStatus status;
@override@JsonKey() final  bool isRouteAssigned;
// Address & Zone
@override final  String? address;
@override final  String? zone;
// Personal fields
@override final  String? dateOfBirth;
@override final  String? parentNameAndAddress;
@override final  String? parentOrSpouseMobile;
@override final  String? alternativeAddress;
@override@JsonKey() final  String mobileNumber;
@override final  String? alternativeMobile;
@override final  String? whatsappNumber;
// Identity fields
@override final  String? aadharNumber;
@override final  String? licenseNumber;
@override final  String? vehicleNumber;
// Employment fields
@override final  String? dateOfJoining;
// Payment fields
@override final  String? gpayNumber;
@override final  String? upiId;
@override final  String? bankAccountDetails;
// Placeholder URLs
@override final  String? photoUrl;
@override final  String? aadharCopyUrl;
@override final  String? licenseCopyUrl;
// System fields
@override final  String? createdAt;
@override final  String? updatedAt;
// Attendance specific
@override final  String? recordId;
@override final  String? markedAt;
@override final  int? petrolAllowanceGivenToday;

/// Create a copy of DeliveryPerson
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeliveryPersonCopyWith<_DeliveryPerson> get copyWith => __$DeliveryPersonCopyWithImpl<_DeliveryPerson>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeliveryPersonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeliveryPerson&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.status, status) || other.status == status)&&(identical(other.isRouteAssigned, isRouteAssigned) || other.isRouteAssigned == isRouteAssigned)&&(identical(other.address, address) || other.address == address)&&(identical(other.zone, zone) || other.zone == zone)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.parentNameAndAddress, parentNameAndAddress) || other.parentNameAndAddress == parentNameAndAddress)&&(identical(other.parentOrSpouseMobile, parentOrSpouseMobile) || other.parentOrSpouseMobile == parentOrSpouseMobile)&&(identical(other.alternativeAddress, alternativeAddress) || other.alternativeAddress == alternativeAddress)&&(identical(other.mobileNumber, mobileNumber) || other.mobileNumber == mobileNumber)&&(identical(other.alternativeMobile, alternativeMobile) || other.alternativeMobile == alternativeMobile)&&(identical(other.whatsappNumber, whatsappNumber) || other.whatsappNumber == whatsappNumber)&&(identical(other.aadharNumber, aadharNumber) || other.aadharNumber == aadharNumber)&&(identical(other.licenseNumber, licenseNumber) || other.licenseNumber == licenseNumber)&&(identical(other.vehicleNumber, vehicleNumber) || other.vehicleNumber == vehicleNumber)&&(identical(other.dateOfJoining, dateOfJoining) || other.dateOfJoining == dateOfJoining)&&(identical(other.gpayNumber, gpayNumber) || other.gpayNumber == gpayNumber)&&(identical(other.upiId, upiId) || other.upiId == upiId)&&(identical(other.bankAccountDetails, bankAccountDetails) || other.bankAccountDetails == bankAccountDetails)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.aadharCopyUrl, aadharCopyUrl) || other.aadharCopyUrl == aadharCopyUrl)&&(identical(other.licenseCopyUrl, licenseCopyUrl) || other.licenseCopyUrl == licenseCopyUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.recordId, recordId) || other.recordId == recordId)&&(identical(other.markedAt, markedAt) || other.markedAt == markedAt)&&(identical(other.petrolAllowanceGivenToday, petrolAllowanceGivenToday) || other.petrolAllowanceGivenToday == petrolAllowanceGivenToday));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,employeeId,status,isRouteAssigned,address,zone,dateOfBirth,parentNameAndAddress,parentOrSpouseMobile,alternativeAddress,mobileNumber,alternativeMobile,whatsappNumber,aadharNumber,licenseNumber,vehicleNumber,dateOfJoining,gpayNumber,upiId,bankAccountDetails,photoUrl,aadharCopyUrl,licenseCopyUrl,createdAt,updatedAt,recordId,markedAt,petrolAllowanceGivenToday]);

@override
String toString() {
  return 'DeliveryPerson(id: $id, name: $name, employeeId: $employeeId, status: $status, isRouteAssigned: $isRouteAssigned, address: $address, zone: $zone, dateOfBirth: $dateOfBirth, parentNameAndAddress: $parentNameAndAddress, parentOrSpouseMobile: $parentOrSpouseMobile, alternativeAddress: $alternativeAddress, mobileNumber: $mobileNumber, alternativeMobile: $alternativeMobile, whatsappNumber: $whatsappNumber, aadharNumber: $aadharNumber, licenseNumber: $licenseNumber, vehicleNumber: $vehicleNumber, dateOfJoining: $dateOfJoining, gpayNumber: $gpayNumber, upiId: $upiId, bankAccountDetails: $bankAccountDetails, photoUrl: $photoUrl, aadharCopyUrl: $aadharCopyUrl, licenseCopyUrl: $licenseCopyUrl, createdAt: $createdAt, updatedAt: $updatedAt, recordId: $recordId, markedAt: $markedAt, petrolAllowanceGivenToday: $petrolAllowanceGivenToday)';
}


}

/// @nodoc
abstract mixin class _$DeliveryPersonCopyWith<$Res> implements $DeliveryPersonCopyWith<$Res> {
  factory _$DeliveryPersonCopyWith(_DeliveryPerson value, $Res Function(_DeliveryPerson) _then) = __$DeliveryPersonCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(name: 'dpCode') String employeeId, AttendanceStatus status, bool isRouteAssigned, String? address, String? zone, String? dateOfBirth, String? parentNameAndAddress, String? parentOrSpouseMobile, String? alternativeAddress, String mobileNumber, String? alternativeMobile, String? whatsappNumber, String? aadharNumber, String? licenseNumber, String? vehicleNumber, String? dateOfJoining, String? gpayNumber, String? upiId, String? bankAccountDetails, String? photoUrl, String? aadharCopyUrl, String? licenseCopyUrl, String? createdAt, String? updatedAt, String? recordId, String? markedAt, int? petrolAllowanceGivenToday
});




}
/// @nodoc
class __$DeliveryPersonCopyWithImpl<$Res>
    implements _$DeliveryPersonCopyWith<$Res> {
  __$DeliveryPersonCopyWithImpl(this._self, this._then);

  final _DeliveryPerson _self;
  final $Res Function(_DeliveryPerson) _then;

/// Create a copy of DeliveryPerson
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? employeeId = null,Object? status = null,Object? isRouteAssigned = null,Object? address = freezed,Object? zone = freezed,Object? dateOfBirth = freezed,Object? parentNameAndAddress = freezed,Object? parentOrSpouseMobile = freezed,Object? alternativeAddress = freezed,Object? mobileNumber = null,Object? alternativeMobile = freezed,Object? whatsappNumber = freezed,Object? aadharNumber = freezed,Object? licenseNumber = freezed,Object? vehicleNumber = freezed,Object? dateOfJoining = freezed,Object? gpayNumber = freezed,Object? upiId = freezed,Object? bankAccountDetails = freezed,Object? photoUrl = freezed,Object? aadharCopyUrl = freezed,Object? licenseCopyUrl = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? recordId = freezed,Object? markedAt = freezed,Object? petrolAllowanceGivenToday = freezed,}) {
  return _then(_DeliveryPerson(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceStatus,isRouteAssigned: null == isRouteAssigned ? _self.isRouteAssigned : isRouteAssigned // ignore: cast_nullable_to_non_nullable
as bool,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,zone: freezed == zone ? _self.zone : zone // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String?,parentNameAndAddress: freezed == parentNameAndAddress ? _self.parentNameAndAddress : parentNameAndAddress // ignore: cast_nullable_to_non_nullable
as String?,parentOrSpouseMobile: freezed == parentOrSpouseMobile ? _self.parentOrSpouseMobile : parentOrSpouseMobile // ignore: cast_nullable_to_non_nullable
as String?,alternativeAddress: freezed == alternativeAddress ? _self.alternativeAddress : alternativeAddress // ignore: cast_nullable_to_non_nullable
as String?,mobileNumber: null == mobileNumber ? _self.mobileNumber : mobileNumber // ignore: cast_nullable_to_non_nullable
as String,alternativeMobile: freezed == alternativeMobile ? _self.alternativeMobile : alternativeMobile // ignore: cast_nullable_to_non_nullable
as String?,whatsappNumber: freezed == whatsappNumber ? _self.whatsappNumber : whatsappNumber // ignore: cast_nullable_to_non_nullable
as String?,aadharNumber: freezed == aadharNumber ? _self.aadharNumber : aadharNumber // ignore: cast_nullable_to_non_nullable
as String?,licenseNumber: freezed == licenseNumber ? _self.licenseNumber : licenseNumber // ignore: cast_nullable_to_non_nullable
as String?,vehicleNumber: freezed == vehicleNumber ? _self.vehicleNumber : vehicleNumber // ignore: cast_nullable_to_non_nullable
as String?,dateOfJoining: freezed == dateOfJoining ? _self.dateOfJoining : dateOfJoining // ignore: cast_nullable_to_non_nullable
as String?,gpayNumber: freezed == gpayNumber ? _self.gpayNumber : gpayNumber // ignore: cast_nullable_to_non_nullable
as String?,upiId: freezed == upiId ? _self.upiId : upiId // ignore: cast_nullable_to_non_nullable
as String?,bankAccountDetails: freezed == bankAccountDetails ? _self.bankAccountDetails : bankAccountDetails // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,aadharCopyUrl: freezed == aadharCopyUrl ? _self.aadharCopyUrl : aadharCopyUrl // ignore: cast_nullable_to_non_nullable
as String?,licenseCopyUrl: freezed == licenseCopyUrl ? _self.licenseCopyUrl : licenseCopyUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,recordId: freezed == recordId ? _self.recordId : recordId // ignore: cast_nullable_to_non_nullable
as String?,markedAt: freezed == markedAt ? _self.markedAt : markedAt // ignore: cast_nullable_to_non_nullable
as String?,petrolAllowanceGivenToday: freezed == petrolAllowanceGivenToday ? _self.petrolAllowanceGivenToday : petrolAllowanceGivenToday // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
