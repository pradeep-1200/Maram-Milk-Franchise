import 'package:freezed_annotation/freezed_annotation.dart';
import 'delivery_person.dart';

part 'attendance_entry.freezed.dart';
part 'attendance_entry.g.dart';

@freezed
abstract class AttendanceEntry with _$AttendanceEntry {
  const AttendanceEntry._();

  const factory AttendanceEntry({
    required String dpId,
    required String dpCode,
    required String name,
    @JsonKey(name: 'photoUrl') String? profilePictureUrl,
    @Default(AttendanceStatus.pending) AttendanceStatus status,
    String? recordId,
    String? markedAt,
    int? petrolAllowanceGivenToday,
  }) = _AttendanceEntry;

  factory AttendanceEntry.fromJson(Map<String, dynamic> json) =>
      _$AttendanceEntryFromJson(json);

  AttendanceStatus get displayStatus {
    return status;
  }
}
