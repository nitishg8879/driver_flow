import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../utils/helpers/app_logger.dart';
import '../../data/models/vehicle_type_model.dart';
import '../../data/repositories/vehicle_type_repository.dart';

part 'vehicle_type_state.dart';
part 'vehicle_type_cubit.freezed.dart';

class VehicleTypeCubit extends Cubit<VehicleTypeState> {
  final VehicleTypeRepository _repository;
  final _logger = AppLogger('VehicleTypeCubit');

  VehicleTypeCubit({required this._repository})
    : super(const VehicleTypeState.initial());

  Future<void> loadVehicleTypes({bool activeOnly = true}) async {
    emit(const VehicleTypeState.loading());
    try {
      final vehicleTypes = await _repository.getVehicleTypes(
        activeOnly: activeOnly,
      );
      emit(VehicleTypeState.loaded(vehicleTypes));
    } catch (e, stackTrace) {
      _logger.error('Failed to load vehicle types', e, stackTrace);
      emit(VehicleTypeState.error(e.toString()));
    }
  }

  Future<bool> createVehicleType(
    VehicleTypeModel vehicleType, {
    Uint8List? imageBytes,
    String? imageFileName,
  }) async {
    try {
      await _repository.createVehicleType(
        vehicleType,
        imageBytes: imageBytes,
        imageFileName: imageFileName,
      );
      await loadVehicleTypes();
      return true;
    } catch (e, stackTrace) {
      _logger.error('Failed to create vehicle type', e, stackTrace);
      emit(VehicleTypeState.error(e.toString()));
      return false;
    }
  }

  Future<bool> updateVehicleType(
    VehicleTypeModel vehicleType, {
    Uint8List? imageBytes,
    String? imageFileName,
  }) async {
    try {
      await _repository.updateVehicleType(
        vehicleType,
        imageBytes: imageBytes,
        imageFileName: imageFileName,
      );
      await loadVehicleTypes();
      return true;
    } catch (e, stackTrace) {
      _logger.error('Failed to update vehicle type', e, stackTrace);
      emit(VehicleTypeState.error(e.toString()));
      return false;
    }
  }

  Future<bool> setActiveStatus(String id, bool isActive) async {
    try {
      await _repository.setActiveStatus(id, isActive);
      await loadVehicleTypes();
      return true;
    } catch (e, stackTrace) {
      _logger.error('Failed to update vehicle type status', e, stackTrace);
      emit(VehicleTypeState.error(e.toString()));
      return false;
    }
  }
}
