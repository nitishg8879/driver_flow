import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../utils/constants/app_enums.dart';

part 'schedule_model.freezed.dart';
part 'schedule_model.g.dart';

@freezed
class ScheduleModel with _$ScheduleModel {
  const factory ScheduleModel({
    String? id,
    required String studentId,
    required String studentName,
    required String instructorId,
    required String instructorName,
    required String vehicleId,
    required String vehicleNumber,
    required DateTime date,
    required DateTime startTime,
    required DateTime endTime,
    @Default(ScheduleStatus.scheduled) ScheduleStatus status,
    String? reason,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ScheduleModel;

  factory ScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleModelFromJson(json);
}
