import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/app_enums.dart';
import '../../../../utils/helpers/app_logger.dart';
import '../models/payment_model.dart';

abstract class PaymentRepository {
  Future<List<PaymentModel>> getPayments({
    DateTime? monthFilter,
    List<String>? tagFilters,
    String? txnIdSearch,
    String? studentNameSearch,
    TransactionType? txnTypeFilter,
    int pageSize = 20,
    int pageNumber = 1,
  });
  Future<PaymentModel> createPayment(
    PaymentModel payment, {
    Map<String, Uint8List>? attachments,
  });
  Future<PaymentModel> updatePayment(
    PaymentModel payment, {
    Map<String, Uint8List>? addedAttachments,
    List<String>? removedAttachmentUrls,
  });
  Future<void> deletePayment(String id);
  String generateTxnId();
}

class PaymentRepositoryImpl implements PaymentRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final _logger = AppLogger('PaymentRepository');
  final _uuid = const Uuid();

  PaymentRepositoryImpl({required this._firestore, required this._storage});

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(AppConstants.paymentsCollection);

  @override
  String generateTxnId() => 'TXN-${_uuid.v4().substring(0, 12).toUpperCase()}';

  @override
  Future<List<PaymentModel>> getPayments({
    DateTime? monthFilter,
    List<String>? tagFilters,
    String? txnIdSearch,
    String? studentNameSearch,
    TransactionType? txnTypeFilter,
    int pageSize = 20,
    int pageNumber = 1,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _collection;

      // Apply filters
      if (txnTypeFilter != null) {
        query = query.where('txnType', isEqualTo: txnTypeFilter.name);
      }

      final snapshot = await query.get();

      var payments = snapshot.docs
          .map((doc) => PaymentModel.fromJson({'id': doc.id, ...doc.data()}))
          .toList();

      // Client-side filtering
      if (monthFilter != null) {
        final month = monthFilter.month;
        final year = monthFilter.year;
        payments = payments
            .where((p) => p.txnDate.month == month && p.txnDate.year == year)
            .toList();
      }

      if (txnIdSearch != null && txnIdSearch.isNotEmpty) {
        payments = payments
            .where(
              (p) => p.txnId.toLowerCase().contains(txnIdSearch.toLowerCase()),
            )
            .toList();
      }

      if (studentNameSearch != null && studentNameSearch.isNotEmpty) {
        payments = payments
            .where(
              (p) => p.studentName.toLowerCase().contains(
                studentNameSearch.toLowerCase(),
              ),
            )
            .toList();
      }

      if (tagFilters != null && tagFilters.isNotEmpty) {
        payments = payments
            .where((p) => p.tags.any((tag) => tagFilters.contains(tag)))
            .toList();
      }

      // Apply pagination
      final startIndex = (pageNumber - 1) * pageSize;
      final endIndex = (startIndex + pageSize).clamp(0, payments.length);

      if (startIndex >= payments.length) {
        return [];
      }

      return payments.sublist(
        startIndex,
        endIndex > payments.length ? payments.length : endIndex,
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch payments', e, stackTrace);
      rethrow;
    }
  }

  Future<String> _uploadAttachment(Uint8List bytes, String fileName) async {
    final path = 'payments/${_uuid.v4()}-$fileName';
    final ref = _storage.ref(path);
    await ref.putData(bytes);
    return ref.getDownloadURL();
  }

  @override
  Future<PaymentModel> createPayment(
    PaymentModel payment, {
    Map<String, Uint8List>? attachments,
  }) async {
    try {
      List<String> attachmentUrls = [];
      if (attachments != null && attachments.isNotEmpty) {
        for (final entry in attachments.entries) {
          final url = await _uploadAttachment(entry.value, entry.key);
          attachmentUrls.add(url);
        }
      }

      final docRef = _collection.doc();
      final data = payment.copyWith(
        id: docRef.id,
        attachments: attachmentUrls,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await docRef.set(data.toJson()..remove('id'));
      _logger.info('Payment created: ${docRef.id} (txnId: ${data.txnId})');
      return data;
    } catch (e, stackTrace) {
      _logger.error('Failed to create payment', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<PaymentModel> updatePayment(
    PaymentModel payment, {
    Map<String, Uint8List>? addedAttachments,
    List<String>? removedAttachmentUrls,
  }) async {
    try {
      var attachmentUrls = List<String>.from(payment.attachments);

      // Remove old attachments from storage
      if (removedAttachmentUrls != null) {
        for (final url in removedAttachmentUrls) {
          try {
            final ref = _storage.refFromURL(url);
            await ref.delete();
            attachmentUrls.remove(url);
          } catch (e) {
            _logger.warning('Failed to delete attachment: $url', e, null);
          }
        }
      }

      // Upload new attachments
      if (addedAttachments != null && addedAttachments.isNotEmpty) {
        for (final entry in addedAttachments.entries) {
          final url = await _uploadAttachment(entry.value, entry.key);
          attachmentUrls.add(url);
        }
      }

      final data = payment.copyWith(
        attachments: attachmentUrls,
        updatedAt: DateTime.now(),
      );

      await _collection.doc(payment.id).update(data.toJson()..remove('id'));
      _logger.info('Payment updated: ${payment.id}');
      return data;
    } catch (e, stackTrace) {
      _logger.error('Failed to update payment', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deletePayment(String id) async {
    try {
      // Get payment to find attachments
      final doc = await _collection.doc(id).get();
      if (doc.exists) {
        final payment = PaymentModel.fromJson({'id': doc.id, ...doc.data()!});

        // Delete attachments from storage
        for (final url in payment.attachments) {
          try {
            final ref = _storage.refFromURL(url);
            await ref.delete();
          } catch (e) {
            _logger.warning('Failed to delete attachment: $url', e, null);
          }
        }
      }

      // Delete document
      await _collection.doc(id).delete();
      _logger.info('Payment deleted: $id');
    } catch (e, stackTrace) {
      _logger.error('Failed to delete payment', e, stackTrace);
      rethrow;
    }
  }
}
