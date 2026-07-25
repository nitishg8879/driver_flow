part of 'schedule_cubit.dart';

@freezed
class ScheduleState with _$ScheduleState {
  const factory ScheduleState.initial() = ScheduleInitial;
  const factory ScheduleState.loading() = ScheduleLoading;
  const factory ScheduleState.loaded({
    required List<ScheduleModel> schedules,
    required DateTime date,
    String? instructorId,
    String? studentId,
  }) = ScheduleLoaded;
  const factory ScheduleState.error(String message) = ScheduleError;
}
