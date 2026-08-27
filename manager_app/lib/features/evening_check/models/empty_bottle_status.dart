import 'package:freezed_annotation/freezed_annotation.dart';

part 'empty_bottle_status.freezed.dart';
part 'empty_bottle_status.g.dart';

@freezed
abstract class EmptyBottleStatusItem with _$EmptyBottleStatusItem {
  const factory EmptyBottleStatusItem({
    required String inventoryItemId,
    required String name,
    required String unit,
    String? section,
    String? material,
    @Default(0) int carriedOver,
    @Default(0) int allocated,
    @Default(0) int expected,
    @Default(0) int actualDelivered,
    @Default(0) int collected,
    @Default(0) int broken,
    @Default(0) int outstanding,
  }) = _EmptyBottleStatusItem;

  factory EmptyBottleStatusItem.fromJson(Map<String, dynamic> json) => _$EmptyBottleStatusItemFromJson(json);
}

@freezed
abstract class EmptyBottleStatus with _$EmptyBottleStatus {
  const factory EmptyBottleStatus({
    required String routeId,
    required String routeName,
    String? dpId,
    String? dpName,
    required bool deliveryCompleted,
    @Default(0) int expectedEmptyBottles,
    @Default(false) bool flagIssue,
    String? reason,
    String? notes,
    required String status,
    @Default([]) List<EmptyBottleStatusItem> items,
  }) = _EmptyBottleStatus;

  factory EmptyBottleStatus.fromJson(Map<String, dynamic> json) => _$EmptyBottleStatusFromJson(json);
}
