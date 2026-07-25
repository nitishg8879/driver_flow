import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/helpers/app_logger.dart';
import '../models/vehicle_type_model.dart';

abstract class VehicleTypeRepository {
  Future<List<VehicleTypeModel>> getVehicleTypes({bool activeOnly = true});
  Future<VehicleTypeModel> createVehicleType(
    VehicleTypeModel vehicleType, {
    Uint8List? imageBytes,
    String? imageFileName,
  });
  Future<VehicleTypeModel> updateVehicleType(
    VehicleTypeModel vehicleType, {
    Uint8List? imageBytes,
    String? imageFileName,
  });
  Future<void> setActiveStatus(String id, bool isActive);
}

class VehicleTypeRepositoryImpl implements VehicleTypeRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final _logger = AppLogger('VehicleTypeRepository');
  final _uuid = const Uuid();

  VehicleTypeRepositoryImpl({required this._firestore, required this._storage});

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(AppConstants.vehicleTypesCollection);

  @override
  Future<List<VehicleTypeModel>> getVehicleTypes({
    bool activeOnly = true,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _collection;
      if (activeOnly) {
        query = query.where('isActive', isEqualTo: true);
      }
      final snapshot = await query.get();
      return snapshot.docs
          .map(
            (doc) => VehicleTypeModel.fromJson({'id': doc.id, ...doc.data()}),
          )
          .toList();
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch vehicle types', e, stackTrace);
      rethrow;
    }
  }

  Future<String> _uploadImage(Uint8List bytes, String fileName) async {
    final path = 'vehicle_types/${_uuid.v4()}-$fileName';
    final ref = _storage.ref(path);
    await ref.putData(bytes);
    return ref.getDownloadURL();
  }

  @override
  Future<VehicleTypeModel> createVehicleType(
    VehicleTypeModel vehicleType, {
    Uint8List? imageBytes,
    String? imageFileName,
  }) async {
    try {
      String? imageUrl;
      if (imageBytes != null && imageFileName != null) {
        imageUrl = await _uploadImage(imageBytes, imageFileName);
      }

      final docRef = _collection.doc();
      final data = vehicleType.copyWith(
        id: docRef.id,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await docRef.set(data.toJson()..remove('id'));
      _logger.info('Vehicle type created: ${docRef.id}');
      return data;
    } catch (e, stackTrace) {
      _logger.error('Failed to create vehicle type', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<VehicleTypeModel> updateVehicleType(
    VehicleTypeModel vehicleType, {
    Uint8List? imageBytes,
    String? imageFileName,
  }) async {
    try {
      if (vehicleType.id == null) {
        throw Exception('Vehicle type id is required for update');
      }

      String? imageUrl = vehicleType.imageUrl;
      if (imageBytes != null && imageFileName != null) {
        imageUrl = await _uploadImage(imageBytes, imageFileName);
      }

      final data = vehicleType.copyWith(
        imageUrl: imageUrl,
        updatedAt: DateTime.now(),
      );

      await _collection.doc(vehicleType.id).update(data.toJson()..remove('id'));
      _logger.info('Vehicle type updated: ${vehicleType.id}');
      return data;
    } catch (e, stackTrace) {
      _logger.error('Failed to update vehicle type', e, stackTrace);
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
      _logger.info('Vehicle type $id active status set to $isActive');
    } catch (e, stackTrace) {
      _logger.error('Failed to update vehicle type status', e, stackTrace);
      rethrow;
    }
  }
}
