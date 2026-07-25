part of 'vehicle_type_cubit.dart';

@freezed
class VehicleTypeState with _$VehicleTypeState {
  const factory VehicleTypeState.initial() = VehicleTypeInitial;
  const factory VehicleTypeState.loading() = VehicleTypeLoading;
  const factory VehicleTypeState.loaded(List<VehicleTypeModel> vehicleTypes) =
      VehicleTypeLoaded;
  const factory VehicleTypeState.error(String message) = VehicleTypeError;
  const factory VehicleTypeState.saving() = VehicleTypeSaving;
  const factory VehicleTypeState.saved() = VehicleTypeSaved;
}
