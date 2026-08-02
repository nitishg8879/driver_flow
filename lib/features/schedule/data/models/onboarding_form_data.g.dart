// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_form_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InstallmentDetailImpl _$$InstallmentDetailImplFromJson(
  Map<String, dynamic> json,
) => _$InstallmentDetailImpl(
  index: (json['index'] as num?)?.toInt(),
  dueDate: json['dueDate'] == null
      ? null
      : DateTime.parse(json['dueDate'] as String),
  amount: (json['amount'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$InstallmentDetailImplToJson(
  _$InstallmentDetailImpl instance,
) => <String, dynamic>{
  'index': instance.index,
  'dueDate': instance.dueDate?.toIso8601String(),
  'amount': instance.amount,
};
