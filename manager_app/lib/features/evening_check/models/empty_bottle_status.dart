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
    required int oneLBottlesCollected,
    required int halfLBottlesCollected,
    required bool flagIssue,
    required String status,
  }) = _EmptyBottleStatus;

  factory EmptyBottleStatus.fromJson(Map<String, dynamic> json) => _$EmptyBottleStatusFromJson(json);
}
