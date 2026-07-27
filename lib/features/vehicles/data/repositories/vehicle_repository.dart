import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/bloc/paginated_repository.dart';
import '../../../../core/models/firestore_cursor.dart';
import '../../../../core/models/paginated_result.dart';
import '../../../../core/models/pagination_cursor.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/helpers/app_logger.dart';
import '../models/vehicle_model.dart';

abstract class VehicleRepository implements PaginatedRepository<VehicleModel> {
  @override
  Future<PaginatedResult<VehicleModel>> getPage({
    required bool activeOnly,
    required int pageSize,
    PaginationCursor? cursor,
  });
  Future<VehicleModel> createVehicle(VehicleModel vehicle);
  Future<VehicleModel> updateVehicle(VehicleModel vehicle);
  Future<void> setActiveStatus(String id, bool isActive);

  /// Fetches all active vehicles in one call (no pagination). Used by
  /// dropdowns (e.g. schedule feature) where the full list is small enough
  /// to load once and filter client-side.
  Future<List<VehicleModel>> getAllActive();
}

class VehicleRepositoryImpl implements VehicleRepository {
  final FirebaseFirestore _firestore;
  final _logger = AppLogger('VehicleRepository');

  VehicleRepositoryImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(AppConstants.vehiclesCollection);

  @override
  Future<PaginatedResult<VehicleModel>> getPage({
    required bool activeOnly,
    required int pageSize,
    PaginationCursor? cursor,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _collection
          .where('isActive', isEqualTo: activeOnly)
          .orderBy('createdAt', descending: true)
          .limit(pageSize);

      if (cursor != null) {
        query = query.startAfterDocument((cursor as FirestoreCursor).document);
      }

      final countQuery = _collection.where('isActive', isEqualTo: activeOnly);
      final countSnapshot = await countQuery.count().get();
      final totalCount = countSnapshot.count ?? 0;

      final snapshot = await query.get();
      final vehicles = snapshot.docs
          .map((doc) => VehicleModel.fromJson({'id': doc.id, ...doc.data()}))
          .toList();

      return PaginatedResult(
        items: vehicles,
        cursor: snapshot.docs.isNotEmpty
            ? FirestoreCursor(snapshot.docs.last)
            : null,
        hasMore: snapshot.docs.length == pageSize,
        totalCount: totalCount,
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch vehicles', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<VehicleModel> createVehicle(VehicleModel vehicle) async {
    try {
      final docRef = _collection.doc();
      final data = vehicle.copyWith(
        id: docRef.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await docRef.set(data.toJson()..remove('id'));
      _logger.info('Vehicle created: ${docRef.id}');
      return data;
    } catch (e, stackTrace) {
      _logger.error('Failed to create vehicle', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<VehicleModel> updateVehicle(VehicleModel vehicle) async {
    try {
      if (vehicle.id == null) {
        throw Exception('Vehicle id is required for update');
      }
      final data = vehicle.copyWith(updatedAt: DateTime.now());
      await _collection.doc(vehicle.id).update(data.toJson()..remove('id'));
      _logger.info('Vehicle updated: ${vehicle.id}');
      return data;
    } catch (e, stackTrace) {
      _logger.error('Failed to update vehicle', e, stackTrace);
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
      _logger.info('Vehicle $id active status set to $isActive');
    } catch (e, stackTrace) {
      _logger.error('Failed to update vehicle status', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<VehicleModel>> getAllActive() async {
    try {
      final snapshot = await _collection
          .where('isActive', isEqualTo: true)
          .get();
      return snapshot.docs
          .map((doc) => VehicleModel.fromJson({'id': doc.id, ...doc.data()}))
          .toList();
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch all active vehicles', e, stackTrace);
      rethrow;
    }
  }
}
