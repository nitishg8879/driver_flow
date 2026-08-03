import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_flow_admin/core/models/paginated_result.dart';

import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/app_enums.dart';
import '../../../../utils/helpers/app_logger.dart';
import '../models/user_model.dart';

abstract class UserRepository {
  Future<PaginatedResult<UserModel>> getUsers({
    required bool activeOnly,
    int pageSize = 20,
    DocumentSnapshot? lastDocument,
    String searchQuery = '',
    UserRole? role,
  });

  Future<List<UserModel>> getUsersByRole({
    required UserRole role,
    required bool activeOnly,
    int pageSize = 20,
    DocumentSnapshot? lastDocument,
  });

  Future<UserModel> createUser(UserModel user);
  Future<UserModel> updateUser(UserModel user);
  Future<void> setActiveStatus(String id, bool isActive);

  Future<List<UserModel>> getAllActiveByRole(UserRole role);

  Future<List<UserModel>> searchActiveByRole({
    required UserRole role,
    required String query,
    int limit = 10,
  });
}

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;
  final _logger = AppLogger('UserRepository');

  UserRepositoryImpl({required this._firestore});

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(AppConstants.usersCollection);

  @override
  Future<List<UserModel>> getUsersByRole({
    required UserRole role,
    required bool activeOnly,
    int pageSize = 20,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      _logger.debug(
        'Fetching users - role: ${role.name}, activeOnly: $activeOnly, pageSize: $pageSize, hasCursor: ${lastDocument != null}',
      );

      Query<Map<String, dynamic>> query = _collection
          .where('role', isEqualTo: role.name)
          .where('isActive', isEqualTo: activeOnly)
          .orderBy('createdAt', descending: true)
          .limit(pageSize);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.get();
      final users = snapshot.docs
          .map((doc) => UserModel.fromJson({'id': doc.id, ...doc.data()}))
          .toList();

      _logger.info('Fetched ${users.length} users by role: ${role.name}');
      return users;
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to fetch users by role: ${role.name}',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<UserModel> createUser(UserModel user) async {
    try {
      _logger.debug(
        'Creating new user - name: ${user.name}, role: ${user.role}',
      );

      final docRef = _collection.doc();
      final data = user.copyWith(
        id: docRef.id,
        nameLower: user.name?.toLowerCase(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await docRef.set(data.toJson()..remove('id'));
      _logger.info(
        'User created successfully - id: ${docRef.id}, name: ${data.name}, role: ${data.role}',
      );
      return data;
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to create user - name: ${user.name}, role: ${user.role}',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    try {
      if (user.id == null) {
        throw Exception('User id is required for update');
      }

      _logger.debug('Updating user - id: ${user.id}, name: ${user.name}');

      final data = user.copyWith(
        nameLower: user.name?.toLowerCase(),
        updatedAt: DateTime.now(),
      );
      await _collection.doc(user.id).update(data.toJson()..remove('id'));
      _logger.info(
        'User updated successfully - id: ${user.id}, name: ${data.name}',
      );
      return data;
    } catch (e, stackTrace) {
      _logger.error('Failed to update user - id: ${user.id}', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<PaginatedResult<UserModel>> getUsers({
    required bool activeOnly,
    int pageSize = 20,
    DocumentSnapshot? lastDocument,
    String searchQuery = '',
    UserRole? role,
  }) async {
    try {
      _logger.info(
        'Fetching paginated users - activeOnly: $activeOnly, pageSize: $pageSize, role: ${role?.name}, hasSearch: ${searchQuery.isNotEmpty}, hasCursor: ${lastDocument != null}',
      );

      Query<Map<String, dynamic>> query = _collection.where(
        'isActive',
        isEqualTo: activeOnly,
      );

      if (role != null) {
        query = query.where('role', isEqualTo: role.name);
      }

      final lowerQuery = searchQuery.trim().toLowerCase();
      if (lowerQuery.isNotEmpty) {
        query = query.orderBy('nameLower').startAt([lowerQuery]).endAt([
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

      final users = snapshot.docs
          .map((doc) => UserModel.fromJson({'id': doc.id, ...doc.data()}))
          .toList();

      final hasMore = users.length == pageSize;
      _logger.info(
        'Fetched ${users.length} users (total: $totalCount, hasMore: $hasMore)',
      );

      return PaginatedResult<UserModel>(
        items: users,
        totalCount: totalCount ?? 0,
        lastDocument: snapshot.docs.isNotEmpty
            ? snapshot.docs.last
            : lastDocument,
        hasMore: hasMore,
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch paginated users', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> setActiveStatus(String id, bool isActive) async {
    try {
      _logger.debug(
        'Updating user active status - id: $id, isActive: $isActive',
      );

      await _collection.doc(id).update({
        'isActive': isActive,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      _logger.info('User active status updated - id: $id, isActive: $isActive');
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to update user active status - id: $id, isActive: $isActive',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<List<UserModel>> getAllActiveByRole(UserRole role) async {
    try {
      _logger.debug('Fetching all active users by role: ${role.name}');

      final snapshot = await _collection
          .where('role', isEqualTo: role.name)
          .where('isActive', isEqualTo: true)
          .get();

      final users = snapshot.docs
          .map((doc) => UserModel.fromJson({'id': doc.id, ...doc.data()}))
          .toList();

      _logger.info(
        'Fetched ${users.length} active users by role: ${role.name}',
      );
      return users;
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to fetch all active users by role: ${role.name}',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<List<UserModel>> searchActiveByRole({
    required UserRole role,
    required String query,
    int limit = 10,
  }) async {
    try {
      _logger.debug(
        'Searching active users - role: ${role.name}, query: "$query", limit: $limit',
      );

      final lowerQuery = query.trim().toLowerCase();

      Query<Map<String, dynamic>> firestoreQuery = _collection
          .where('role', isEqualTo: role.name)
          .where('isActive', isEqualTo: true)
          .limit(limit);

      if (lowerQuery.isNotEmpty) {
        firestoreQuery = firestoreQuery
            .orderBy('nameLower')
            .startAt([lowerQuery])
            .endAt(['$lowerQuery\uf8ff']);
      } else {
        firestoreQuery = firestoreQuery.orderBy('createdAt', descending: true);
      }

      final snapshot = await firestoreQuery.get();
      final users = snapshot.docs
          .map((doc) => UserModel.fromJson({'id': doc.id, ...doc.data()}))
          .toList();

      _logger.info(
        'Search found ${users.length} users - role: ${role.name}, query: "$query"',
      );
      return users;
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to search users by role: ${role.name}, query: "$query"',
        e,
        stackTrace,
      );
      rethrow;
    }
  }
}
