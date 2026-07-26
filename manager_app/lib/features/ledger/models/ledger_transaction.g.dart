// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LedgerTransaction _$LedgerTransactionFromJson(Map<String, dynamic> json) =>
    _LedgerTransaction(
      id: json['id'] as String,
      dpId: json['dpId'] as String?,
      date: json['date'] as String,
      dp: json['dp'] == null
          ? null
          : DeliveryPerson.fromJson(json['dp'] as Map<String, dynamic>),
      routeId: json['routeId'] as String?,
      route: json['route'] as Map<String, dynamic>?,
      givenAllowance: (json['givenAllowance'] as num?)?.toDouble() ?? 0,
      defaultAllowance: (json['defaultAllowance'] as num?)?.toDouble() ?? 0,
      status: json['status'] as String,
    );

Map<String, dynamic> _$LedgerTransactionToJson(_LedgerTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dpId': instance.dpId,
      'date': instance.date,
      'dp': instance.dp,
      'routeId': instance.routeId,
      'route': instance.route,
      'givenAllowance': instance.givenAllowance,
      'defaultAllowance': instance.defaultAllowance,
      'status': instance.status,
    };
