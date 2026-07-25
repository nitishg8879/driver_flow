import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../utils/helpers/app_logger.dart';
import '../../data/models/schedule_model.dart';
import '../../data/repositories/schedule_repository.dart';

part 'schedule_state.dart';
part 'schedule_cubit.freezed.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final ScheduleRepository _repository;
  final _logger = AppLogger('ScheduleCubit');

  ScheduleCubit({required ScheduleRepository repository})
    : _repository = repository,
      super(const ScheduleState.initial());

  Future<void> loadSchedules({
    required DateTime date,
    String? instructorId,
    String? studentId,
  }) async {
    emit(const ScheduleState.loading());
    try {
      final schedules = await _repository.getSchedulesForDate(
        date: date,
        instructorId: instructorId,
        studentId: studentId,
      );
      emit(
        ScheduleState.loaded(
          schedules: schedules,
          date: date,
          instructorId: instructorId,
          studentId: studentId,
        ),
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to load schedules', e, stackTrace);
      emit(ScheduleState.error(e.toString()));
    }
  }

  Future<void> _refresh() async {
    final currentState = state;
    if (currentState is! ScheduleLoaded) return;
    await loadSchedules(
      date: currentState.date,
      instructorId: currentState.instructorId,
      studentId: currentState.studentId,
    );
  }

  /// Returns null on success, or an error message on failure (e.g. a
  /// [ScheduleConflictException]) so the dialog can show it inline.
  Future<String?> createSchedule(ScheduleModel schedule) async {
    try {
      await _repository.createSchedule(schedule);
      await _refresh();
      return null;
    } catch (e, stackTrace) {
      _logger.error('Failed to create schedule', e, stackTrace);
      return e.toString();
    }
  }

  Future<String?> updateSchedule(ScheduleModel schedule) async {
    try {
      await _repository.updateSchedule(schedule);
      await _refresh();
      return null;
    } catch (e, stackTrace) {
      _logger.error('Failed to update schedule', e, stackTrace);
      return e.toString();
    }
  }

  Future<bool> cancelSchedule(String id, bool isActive) async {
    try {
      await _repository.setActiveStatus(id, isActive);
      await _refresh();
      return true;
    } catch (e, stackTrace) {
      _logger.error('Failed to update schedule status', e, stackTrace);
      return false;
    }
  }
}
