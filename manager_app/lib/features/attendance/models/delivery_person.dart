import 'package:freezed_annotation/freezed_annotation.dart';

part 'delivery_person.freezed.dart';
part 'delivery_person.g.dart';

enum AttendanceStatus {
  @JsonValue('NOT_MARKED') pending,
  @JsonValue('PRESENT') present,
  @JsonValue('ABSENT') absent,
  @JsonValue('STANDBY') standby,
}

@freezed
abstract class DeliveryPerson with _$DeliveryPerson {
  const DeliveryPerson._();

  const factory DeliveryPerson({
    required String id,
    required String name,
    @JsonKey(name: 'dpCode') required String employeeId,
    @Default(AttendanceStatus.pending) AttendanceStatus status,
    @Default(false) bool isRouteAssigned,
    
    // Address & Zone
    String? address,
    String? zone,

    // Personal fields
    String? dateOfBirth,
    String? parentNameAndAddress,
    String? parentOrSpouseMobile,
    String? alternativeAddress,
    @Default('') String mobileNumber,
    String? alternativeMobile,
    String? whatsappNumber,
    
    // Identity fields
    String? aadharNumber,
    String? licenseNumber,
    String? vehicleNumber,
    
    // Employment fields
    String? dateOfJoining,
    
    // Payment fields
    String? gpayNumber,
    String? upiId,
    String? bankAccountDetails,
    
    // Placeholder URLs
    String? photoUrl,
    String? aadharCopyUrl,
    String? licenseCopyUrl,
    
    // System fields
    String? createdAt,
    String? updatedAt,
    
    // Attendance specific
    String? recordId,
    String? markedAt,
  }) = _DeliveryPerson;

  factory DeliveryPerson.fromJson(Map<String, dynamic> json) =>
      _$DeliveryPersonFromJson(json);

  AttendanceStatus get displayStatus {
    if (status == AttendanceStatus.present && !isRouteAssigned) {
      return AttendanceStatus.standby;
    }
    return status;
  }
}
