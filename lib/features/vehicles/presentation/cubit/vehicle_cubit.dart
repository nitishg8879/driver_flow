import '../../../../core/bloc/paginated_cubit.dart';
import '../../../../utils/helpers/app_logger.dart';
import '../../data/models/vehicle_model.dart';
import '../../data/repositories/vehicle_repository.dart';

/// Vehicle list cubit built on top of the generic [PaginatedCubit].
class VehicleCubit extends PaginatedCubit<VehicleModel> {
  final VehicleRepository _repository;
  final _logger = AppLogger('VehicleCubit');

  VehicleCubit({required VehicleRepository repository})
    : _repository = repository,
      super(repository: repository);

  Future<VehicleModel?> createVehicle(VehicleModel vehicle) async {
    try {
      final created = await _repository.createVehicle(vehicle);
      await refresh();
      return created;
    } catch (e, stackTrace) {
      _logger.error('Failed to create vehicle', e, stackTrace);
      return null;
    }
  }

  Future<VehicleModel?> updateVehicle(VehicleModel vehicle) async {
    try {
      final updated = await _repository.updateVehicle(vehicle);
      await refresh();
      return updated;
    } catch (e, stackTrace) {
      _logger.error('Failed to update vehicle', e, stackTrace);
      return null;
    }
  }

  Future<bool> setActiveStatus(String id, bool isActive) async {
    try {
      await _repository.setActiveStatus(id, isActive);
      await refresh();
      return true;
    } catch (e, stackTrace) {
      _logger.error('Failed to update vehicle status', e, stackTrace);
      return false;
    }
  }
}
