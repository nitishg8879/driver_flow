import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../utils/constants/app_enums.dart';

part 'schedule_model.freezed.dart';
part 'schedule_model.g.dart';

@freezed
class ScheduleModel with _$ScheduleModel {
  const factory ScheduleModel({
    required String id,
    required String studentId,
    required String studentName,
    required String studentPermit,
    required String instructorId,
    required String instructorName,
    required String vehicleId,
    required String vehicleName,
    required DateTime startTime,
    required DateTime endTime,
    @Default(ScheduleStatus.scheduled) ScheduleStatus status,
    String? notes,
  }) = _ScheduleModel;

  factory ScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleModelFromJson(json);
}

class ScheduleInstructorOption {
  final String id;
  final String name;

  const ScheduleInstructorOption({required this.id, required this.name});

  @override
  bool operator ==(Object other) =>
      other is ScheduleInstructorOption && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class ScheduleStudentOption {
  final String id;
  final String name;
  final String permit;

  const ScheduleStudentOption({
    required this.id,
    required this.name,
    required this.permit,
  });

  @override
  bool operator ==(Object other) =>
      other is ScheduleStudentOption && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
