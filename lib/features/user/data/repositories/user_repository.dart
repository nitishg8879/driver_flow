import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/models/firestore_cursor.dart';
import '../../../../core/models/paginated_result.dart';
import '../../../../core/models/pagination_cursor.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/app_enums.dart';
import '../../../../utils/helpers/app_logger.dart';
import '../models/user_model.dart';

/// Shared repository for the `users` collection. Students and instructors
/// are just users with `role == UserRole.student` / `UserRole.instructor`
/// — there is no separate `students`/`instructors` collection.
abstract class UserRepository {
  Future<PaginatedResult<UserModel>> getUsersByRole({
    required UserRole role,
    required bool activeOnly,
    required int pageSize,
    PaginationCursor? cursor,
  });

  Future<PaginatedResult<UserModel>> getUsers({
    required bool activeOnly,
    required int pageSize,
    PaginationCursor? cursor,
    String searchQuery = '',
    UserRole? role,
  });

  Future<UserModel> createUser(UserModel user);
  Future<UserModel> updateUser(UserModel user);
  Future<void> setActiveStatus(String id, bool isActive);

  /// Fetches all active users with [role] in one call (no pagination).
  /// Used by dropdowns (e.g. schedule feature) where the full list is
  /// small enough to load once and filter client-side.
  Future<List<UserModel>> getAllActiveByRole(UserRole role);

  /// Searches active users with [role] by name prefix (case-insensitive),
  /// returning at most [limit] results. Used by dropdowns backed by large
  /// collections instead of full pagination.
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
  Future<PaginatedResult<UserModel>> getUsersByRole({
    required UserRole role,
    required bool activeOnly,
    required int pageSize,
    PaginationCursor? cursor,
  }) async {
    try {
      final countQuery = _collection
          .where('role', isEqualTo: role.name)
          .where('isActive', isEqualTo: activeOnly);
      final countSnapshot = await countQuery.count().get();
      final totalCount = countSnapshot.count ?? 0;

      Query<Map<String, dynamic>> query = _collection
          .where('role', isEqualTo: role.name)
          .where('isActive', isEqualTo: activeOnly)
          .orderBy('createdAt', descending: true)
          .limit(pageSize);

      if (cursor != null) {
        query = query.startAfterDocument((cursor as FirestoreCursor).document);
      }

      final snapshot = await query.get();
      final users = snapshot.docs
          .map((doc) => UserModel.fromJson({'id': doc.id, ...doc.data()}))
          .toList();

      return PaginatedResult(
        items: users,
        cursor: snapshot.docs.isNotEmpty
            ? FirestoreCursor(snapshot.docs.last)
            : null,
        hasMore: snapshot.docs.length == pageSize,
        totalCount: totalCount,
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch users by role', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<UserModel> createUser(UserModel user) async {
    try {
      final docRef = _collection.doc();
      final data = user.copyWith(
        id: docRef.id,
        nameLower: user.name?.toLowerCase(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await docRef.set(data.toJson()..remove('id'));
      _logger.info('User created: ${docRef.id} (role: ${user.role})');
      return data;
    } catch (e, stackTrace) {
      _logger.error('Failed to create user', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    try {
      if (user.id == null) {
        throw Exception('User id is required for update');
      }
      final data = user.copyWith(
        nameLower: user.name?.toLowerCase(),
        updatedAt: DateTime.now(),
      );
      await _collection.doc(user.id).update(data.toJson()..remove('id'));
      _logger.info('User updated: ${user.id}');
      return data;
    } catch (e, stackTrace) {
      _logger.error('Failed to update user', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<PaginatedResult<UserModel>> getUsers({
    required bool activeOnly,
    required int pageSize,
    PaginationCursor? cursor,
    String searchQuery = '',
    UserRole? role,
  }) async {
    try {
      Query<Map<String, dynamic>> countBaseQuery = _collection.where(
        'isActive',
        isEqualTo: activeOnly,
      );

      if (role != null) {
        countBaseQuery = countBaseQuery.where('role', isEqualTo: role.name);
      }

      final countSnapshot = await countBaseQuery.count().get();
      final totalCount = countSnapshot.count ?? 0;

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
      } else {
        query = query.orderBy('createdAt', descending: true);
      }

      query = query.limit(pageSize);

      if (cursor != null) {
        query = query.startAfterDocument((cursor as FirestoreCursor).document);
      }

      final snapshot = await query.get();
      final users = snapshot.docs
          .map((doc) => UserModel.fromJson({'id': doc.id, ...doc.data()}))
          .toList();

      return PaginatedResult(
        items: users,
        cursor: snapshot.docs.isNotEmpty
            ? FirestoreCursor(snapshot.docs.last)
            : null,
        hasMore: snapshot.docs.length == pageSize,
        totalCount: totalCount,
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch users', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> setActiveStatus(String id, bool isActive) async {
    try {
      await _collection.doc(id).update({
        'isActive': isActive,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      _logger.info('User $id active status set to $isActive');
    } catch (e, stackTrace) {
      _logger.error('Failed to update user status', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<UserModel>> getAllActiveByRole(UserRole role) async {
    try {
      final snapshot = await _collection
          .where('role', isEqualTo: role.name)
          .where('isActive', isEqualTo: true)
          .get();
      return snapshot.docs
          .map((doc) => UserModel.fromJson({'id': doc.id, ...doc.data()}))
          .toList();
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch all active users by role', e, stackTrace);
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
      return snapshot.docs
          .map((doc) => UserModel.fromJson({'id': doc.id, ...doc.data()}))
          .toList();
    } catch (e, stackTrace) {
      _logger.error('Failed to search users by role', e, stackTrace);
      rethrow;
    }
  }
}
