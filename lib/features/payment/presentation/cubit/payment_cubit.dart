import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/constants/app_enums.dart';
import '../../data/models/payment_model.dart';
import '../../data/repositories/payment_repository.dart';

part 'payment_cubit.freezed.dart';
part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepository repository;
  static const int pageSize = 20;

  PaymentCubit({required this.repository})
    : super(const PaymentState.initial());

  Future<void> listPayments({
    DateTime? monthFilter,
    List<String>? tagFilters,
    String? txnIdSearch,
    String? studentNameSearch,
    TransactionType? txnTypeFilter,
    int pageNumber = 1,
  }) async {
    try {
      emit(const PaymentState.loading());
      final payments = await repository.getPayments(
        monthFilter: monthFilter,
        tagFilters: tagFilters,
        txnIdSearch: txnIdSearch,
        studentNameSearch: studentNameSearch,
        txnTypeFilter: txnTypeFilter,
        pageSize: pageSize,
        pageNumber: pageNumber,
      );

      // Calculate total pages (rough estimate, would need total count from repo)
      // For now, assume if we got less than pageSize items, we're on the last page
      final totalPages = (payments.length < pageSize)
          ? pageNumber
          : pageNumber + 1;

      emit(PaymentState.loaded(payments, pageNumber, totalPages));
    } catch (e) {
      emit(PaymentState.error(e.toString()));
    }
  }

  Future<String?> createPayment(
    PaymentModel payment, {
    Map<String, Uint8List>? attachments,
  }) async {
    try {
      await repository.createPayment(payment, attachments: attachments);
      // Reload list
      await listPayments();
      return null; // No error
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> updatePayment(
    PaymentModel payment, {
    Map<String, Uint8List>? addedAttachments,
    List<String>? removedAttachmentUrls,
  }) async {
    try {
      await repository.updatePayment(
        payment,
        addedAttachments: addedAttachments,
        removedAttachmentUrls: removedAttachmentUrls,
      );
      // Reload list
      await listPayments();
      return null; // No error
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> deletePayment(String id) async {
    try {
      await repository.deletePayment(id);
      // Reload list
      await listPayments();
      return null; // No error
    } catch (e) {
      return e.toString();
    }
  }

  String generateTxnId() => repository.generateTxnId();
}
