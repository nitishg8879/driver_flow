import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/helpers/app_logger.dart';
import '../models/tag_model.dart';

abstract class TagRepository {
  Future<List<TagModel>> getTags({
    bool activeOnly = true,
    String? searchQuery,
    int pageSize = 20,
    int pageNumber = 1,
  });
  Future<int> getTagsCount({bool activeOnly = true, String? searchQuery});
  Future<TagModel> createTag(TagModel tag);
  Future<TagModel> updateTag(TagModel tag);
  Future<void> setActiveStatus(String id, bool isActive);
}

class TagRepositoryImpl implements TagRepository {
  final FirebaseFirestore _firestore;
  final _logger = AppLogger('TagRepository');

  TagRepositoryImpl({required this._firestore});

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(AppConstants.tagsCollection);

  @override
  Future<List<TagModel>> getTags({
    bool activeOnly = true,
    String? searchQuery,
    int pageSize = 20,
    int pageNumber = 1,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _collection;
      if (activeOnly) {
        query = query.where('isActive', isEqualTo: true);
      }
      final snapshot = await query.get();
      var tags = snapshot.docs
          .map((doc) => TagModel.fromJson({'id': doc.id, ...doc.data()}))
          .toList();

      // Client-side search filter by name (case-insensitive)
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final lowerQuery = searchQuery.toLowerCase();
        tags = tags
            .where((tag) => tag.name.toLowerCase().contains(lowerQuery))
            .toList();
      }

      // Client-side pagination
      final startIndex = (pageNumber - 1) * pageSize;
      final endIndex = startIndex + pageSize;
      if (startIndex >= tags.length) {
        return [];
      }
      return tags.sublist(startIndex, endIndex.clamp(0, tags.length));
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch tags', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<int> getTagsCount({
    bool activeOnly = true,
    String? searchQuery,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _collection;
      if (activeOnly) {
        query = query.where('isActive', isEqualTo: true);
      }
      final snapshot = await query.get();
      var tags = snapshot.docs
          .map((doc) => TagModel.fromJson({'id': doc.id, ...doc.data()}))
          .toList();

      // Client-side search filter by name (case-insensitive)
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final lowerQuery = searchQuery.toLowerCase();
        tags = tags
            .where((tag) => tag.name.toLowerCase().contains(lowerQuery))
            .toList();
      }

      return tags.length;
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch tags count', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<TagModel> createTag(TagModel tag) async {
    try {
      final docRef = _collection.doc();
      final data = tag.copyWith(
        id: docRef.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await docRef.set(data.toJson()..remove('id'));
      _logger.info('Tag created: ${docRef.id}');
      return data;
    } catch (e, stackTrace) {
      _logger.error('Failed to create tag', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<TagModel> updateTag(TagModel tag) async {
    try {
      final data = tag.copyWith(updatedAt: DateTime.now());
      await _collection.doc(tag.id).update(data.toJson()..remove('id'));
      _logger.info('Tag updated: ${tag.id}');
      return data;
    } catch (e, stackTrace) {
      _logger.error('Failed to update tag', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> setActiveStatus(String id, bool isActive) async {
    try {
      await _collection.doc(id).update({
        'isActive': isActive,
        'updatedAt': DateTime.now(),
      });
      _logger.info('Tag status updated: $id -> $isActive');
    } catch (e, stackTrace) {
      _logger.error('Failed to update tag status', e, stackTrace);
      rethrow;
    }
  }
}
