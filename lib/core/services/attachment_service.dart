import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../../utils/constants/app_constants.dart';
import '../../utils/constants/app_enums.dart';
import '../../utils/helpers/app_logger.dart';
import '../models/attachment_model.dart';

/// Shared service for uploading, deleting and fetching attachments.
///
/// This service is intentionally UI-agnostic and generic so it can be
/// reused across features (students, instructors, vehicles, etc.).
class AttachmentService {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final _logger = AppLogger('AttachmentService');
  final _uuid = const Uuid();

  AttachmentService({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
  }) : _firestore = firestore,
       _storage = storage;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(AppConstants.documentsCollection);

  /// Uploads [bytes] to Firebase Storage and creates the corresponding
  /// Firestore document. Returns the created [AttachmentModel].
  Future<AttachmentModel> uploadAttachment({
    required Uint8List bytes,
    required String fileName,
    required AttachmentFileType fileType,
    required AttachmentSource source,
    required String ownerId,
    required String uploadedBy,
  }) async {
    try {
      final id = _uuid.v4();
      final storagePath = 'attachments/${source.name}/$ownerId/$id-$fileName';

      _logger.info('Uploading attachment: $storagePath');

      final ref = _storage.ref(storagePath);
      await ref.putData(bytes);
      final url = await ref.getDownloadURL();

      final attachment = AttachmentModel(
        id: id,
        name: fileName,
        url: url,
        storagePath: storagePath,
        fileType: fileType,
        source: source,
        ownerId: ownerId,
        uploadedBy: uploadedBy,
        uploadedAt: DateTime.now(),
      );

      await _collection.doc(id).set(attachment.toJson());

      _logger.info('Attachment uploaded successfully: $id');
      return attachment;
    } catch (e, stackTrace) {
      _logger.error('Failed to upload attachment', e, stackTrace);
      rethrow;
    }
  }

  /// Deletes the attachment from both Storage and Firestore.
  Future<void> deleteAttachment(AttachmentModel attachment) async {
    try {
      _logger.info('Deleting attachment: ${attachment.id}');
      await _storage.ref(attachment.storagePath).delete();
      await _collection.doc(attachment.id).delete();
      _logger.info('Attachment deleted successfully: ${attachment.id}');
    } catch (e, stackTrace) {
      _logger.error('Failed to delete attachment', e, stackTrace);
      rethrow;
    }
  }

  /// Fetches all attachments belonging to [ownerId] within [source].
  Future<List<AttachmentModel>> getAttachmentsByOwner({
    required String ownerId,
    required AttachmentSource source,
  }) async {
    try {
      final snapshot = await _collection
          .where('ownerId', isEqualTo: ownerId)
          .where('source', isEqualTo: source.name)
          .get();

      return snapshot.docs
          .map((doc) => AttachmentModel.fromJson(doc.data()))
          .toList();
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to fetch attachments for owner: $ownerId',
        e,
        stackTrace,
      );
      rethrow;
    }
  }
}
