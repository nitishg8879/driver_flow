import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../utils/constants/app_enums.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

@freezed
class PaymentModel with _$PaymentModel {
  const factory PaymentModel({
    String? id,
    required String txnId,
    required String studentId,
    required String studentName,
    required double amount,
    @Default(TransactionType.credit) TransactionType txnType,
    required DateTime txnDate,
    @Default([]) List<String> tags,
    @Default([]) List<String> attachments,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PaymentModel;

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);
}
