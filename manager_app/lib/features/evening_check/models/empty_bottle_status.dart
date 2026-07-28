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
    @Default(0) int halfLPacketCollected,
    @Default(0) int expected1LBottles,
    @Default(0) int expectedHalfLBottles,
    @Default(0) int expectedHalfLPacket,
    @Default(0) int actualDelivered1L,
    @Default(0) int actualDeliveredHalfL,
    @Default(0) int actualDeliveredPacket,
    @Default(false) bool flagIssue,
    String? reason,
    int? brokenBottleCount,
    String? notes,
    @Default(0) int expectedEmptyBottles,
    required String status,
  }) = _EmptyBottleStatus;

  factory EmptyBottleStatus.fromJson(Map<String, dynamic> json) => _$EmptyBottleStatusFromJson(json);
}
