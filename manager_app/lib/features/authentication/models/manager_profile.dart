import 'package:freezed_annotation/freezed_annotation.dart';

part 'manager_profile.freezed.dart';
part 'manager_profile.g.dart';

@freezed
abstract class ManagerProfile with _$ManagerProfile {
  const factory ManagerProfile({
    @Default('') String id,
    @Default('') String name,
    @Default('Manager') String role,
    @Default('') String branchName,
  }) = _ManagerProfile;

  factory ManagerProfile.fromJson(Map<String, dynamic> json) =>
      _$ManagerProfileFromJson(json);
}
