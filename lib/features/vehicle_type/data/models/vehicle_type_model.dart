import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle_type_model.freezed.dart';
part 'vehicle_type_model.g.dart';

@freezed
class VehicleTypeModel with _$VehicleTypeModel {
  const factory VehicleTypeModel({
    String? id,
    required String name,
    String? imageUrl,
    @Default(0) int numberOfSessions,
    @Default(0) int sessionDurationMinutes,
    @Default(0) num pricePerSession,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _VehicleTypeModel;

  factory VehicleTypeModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleTypeModelFromJson(json);
}
