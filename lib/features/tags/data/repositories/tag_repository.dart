import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:driver_flow_admin/core/models/paginated_result.dart';

import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/helpers/app_logger.dart';
import '../models/tag_model.dart';

abstract class TagRepository {
  Future<PaginatedResult<TagModel>> getTags({
    required bool activeOnly,
    int pageSize = 20,
    DocumentSnapshot? lastDocument,
    String searchQuery = '',
  });
  Future<int> getTagsCount({required bool activeOnly, String searchQuery = ''});
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
  Future<PaginatedResult<TagModel>> getTags({
    required bool activeOnly,
    int pageSize = 20,
    DocumentSnapshot? lastDocument,
    String searchQuery = '',
  }) async {
    try {
      _logger.info(
        'Fetching paginated tags - activeOnly: $activeOnly, pageSize: $pageSize, hasSearch: ${searchQuery.isNotEmpty}, hasCursor: ${lastDocument != null}',
      );

      Query<Map<String, dynamic>> query = _collection;
      if (activeOnly) {
        query = query.where('isActive', isEqualTo: true);
      }

      final lowerQuery = searchQuery.trim().toLowerCase();
      if (lowerQuery.isNotEmpty) {
        query = query.orderBy('name').startAt([lowerQuery]).endAt([
          '$lowerQuery\uf8ff',
        ]);
        _logger.info('Applied search filter: "$searchQuery"');
      } else {
        query = query.orderBy('createdAt', descending: true);
      }

      // Run count query in parallel
      final countFuture = query.count().get();

      // Apply pagination
      Query<Map<String, dynamic>> paginatedQuery = query.limit(pageSize);

      if (lastDocument != null) {
        paginatedQuery = paginatedQuery.startAfterDocument(lastDocument);
      }

      final dataFuture = paginatedQuery.get();

      final results = await Future.wait([countFuture, dataFuture]);

      final totalCount = (results[0] as AggregateQuerySnapshot).count;
      final snapshot = results[1] as QuerySnapshot<Map<String, dynamic>>;

      final tags = snapshot.docs
          .map((doc) => TagModel.fromJson({'id': doc.id, ...doc.data()}))
          .toList();

      final hasMore = tags.length == pageSize;
      _logger.info(
        'Fetched ${tags.length} tags (total: $totalCount, hasMore: $hasMore)',
      );

      return PaginatedResult<TagModel>(
        items: tags,
        totalCount: totalCount ?? 0,
        lastDocument: snapshot.docs.isNotEmpty
            ? snapshot.docs.last
            : lastDocument,
        hasMore: hasMore,
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch paginated tags', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<int> getTagsCount({
    required bool activeOnly,
    String searchQuery = '',
  }) async {
    try {
      _logger.debug(
        'Fetching tags count - activeOnly: $activeOnly, hasSearch: ${searchQuery.isNotEmpty}',
      );

      Query<Map<String, dynamic>> query = _collection;
      if (activeOnly) {
        query = query.where('isActive', isEqualTo: true);
      }

      final lowerQuery = searchQuery.trim().toLowerCase();
      if (lowerQuery.isNotEmpty) {
        query = query.orderBy('name').startAt([lowerQuery]).endAt([
          '$lowerQuery\uf8ff',
        ]);
      }

      final snapshot = await query.count().get();
      final totalCount = snapshot.count ?? 0;

      _logger.info('Total tags count: $totalCount');
      return totalCount;
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch tags count', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<TagModel> createTag(TagModel tag) async {
    try {
      _logger.debug('Creating new tag - name: ${tag.name}');

      final docRef = _collection.doc();
      final data = tag.copyWith(
        id: docRef.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await docRef.set(data.toJson()..remove('id'));
      _logger.info(
        'Tag created successfully - id: ${docRef.id}, name: ${data.name}',
      );
      return data;
    } catch (e, stackTrace) {
      _logger.error('Failed to create tag - name: ${tag.name}', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<TagModel> updateTag(TagModel tag) async {
    try {
      if (tag.id == null) {
        throw Exception('Tag id is required for update');
      }

      _logger.debug('Updating tag - id: ${tag.id}, name: ${tag.name}');

      final data = tag.copyWith(updatedAt: DateTime.now());
      await _collection.doc(tag.id).update(data.toJson()..remove('id'));
      _logger.info(
        'Tag updated successfully - id: ${tag.id}, name: ${data.name}',
      );
      return data;
    } catch (e, stackTrace) {
      _logger.error('Failed to update tag - id: ${tag.id}', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> setActiveStatus(String id, bool isActive) async {
    try {
      _logger.debug(
        'Updating tag active status - id: $id, isActive: $isActive',
      );

      await _collection.doc(id).update({
        'isActive': isActive,
        'updatedAt': DateTime.now(),
      });
      _logger.info('Tag active status updated - id: $id, isActive: $isActive');
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to update tag active status - id: $id, isActive: $isActive',
        e,
        stackTrace,
      );
      rethrow;
    }
  }
}

final tagRepositoryProvider = Provider<TagRepository>((ref) {
  return TagRepositoryImpl(firestore: FirebaseFirestore.instance);
});
