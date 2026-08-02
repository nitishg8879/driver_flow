part of 'schedule_cubit.dart';

@freezed
class ScheduleState with _$ScheduleState {
  const factory ScheduleState.initial() = ScheduleInitial;
  const factory ScheduleState.loading() = ScheduleLoading;
  const factory ScheduleState.loaded({
    required List<ScheduleModel> allSchedules,
    required List<ScheduleModel> filtered,
    String? instructorId,
    String? studentId,
    ScheduleStatus? status,
    DateTimeRange? dateRange,
  }) = ScheduleLoaded;
  const factory ScheduleState.error(String message) = ScheduleError;
}
