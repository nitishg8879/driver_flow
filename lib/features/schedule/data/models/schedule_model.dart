import 'package:driver_flow_admin/core/models/date_time_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../utils/constants/app_enums.dart';

part 'schedule_model.freezed.dart';
part 'schedule_model.g.dart';

@freezed
class ScheduleModel with _$ScheduleModel {
  const factory ScheduleModel({
    String? id,
    String? studentId,
    String? instructorId,
    String? vehicleId,
    String? studentName,
    String? instructorName,
    @TimestampConverter() DateTime? startTime,
    @TimestampConverter() DateTime? endTime,
    @Default(ScheduleStatus.scheduled) ScheduleStatus status,
    String? notes,
  }) = _ScheduleModel;

  factory ScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleModelFromJson(json);
}
