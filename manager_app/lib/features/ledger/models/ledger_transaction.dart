import 'package:freezed_annotation/freezed_annotation.dart';
import '../../attendance/models/delivery_person.dart';

part 'ledger_transaction.freezed.dart';
part 'ledger_transaction.g.dart';

@freezed
abstract class LedgerTransaction with _$LedgerTransaction {
  const factory LedgerTransaction({
    required String id,
    String? dpId,
    required String date,
    DeliveryPerson? dp,
    String? routeId,
    Map<String, dynamic>? route,
    @Default(0) double givenAllowance,
    @Default(0) double defaultAllowance,
    required String status,
  }) = _LedgerTransaction;

  factory LedgerTransaction.fromJson(Map<String, dynamic> json) => _$LedgerTransactionFromJson(json);
}
