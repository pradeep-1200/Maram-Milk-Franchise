import 'package:freezed_annotation/freezed_annotation.dart';

part 'empty_bottle_status.freezed.dart';
part 'empty_bottle_status.g.dart';

@freezed
abstract class EmptyBottleStatus with _$EmptyBottleStatus {
  const factory EmptyBottleStatus({
    required String routeId,
    required String routeName,
    String? dpId,
    String? dpName,
    required bool deliveryCompleted,
    @Default(0) int oneLBottlesCollected,
    @Default(0) int halfLBottlesCollected,
    @Default(0) int expected1LBottles,
    @Default(0) int expectedHalfLBottles,
    @Default(false) bool flagIssue,
    required String status,
  }) = _EmptyBottleStatus;

  factory EmptyBottleStatus.fromJson(Map<String, dynamic> json) => _$EmptyBottleStatusFromJson(json);
}
