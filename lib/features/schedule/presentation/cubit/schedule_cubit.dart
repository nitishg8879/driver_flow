import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../utils/constants/app_enums.dart';
import '../../data/models/schedule_model.dart';
import '../../data/repositories/schedule_repository.dart';

part 'schedule_state.dart';
part 'schedule_cubit.freezed.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final ScheduleRepository _repository;

  ScheduleCubit({required this._repository})
    : super(const ScheduleState.initial());

  Future<void> loadAll() async {
    emit(const ScheduleState.loading());
    try {
      final allSchedules = await _repository.getSchedules();
      emit(
        ScheduleState.loaded(
          allSchedules: allSchedules,
          filtered: allSchedules,
        ),
      );
    } catch (e) {
      emit(ScheduleState.error(e.toString()));
    }
  }

  Future<void> applyFilters({
    String? instructorId,
    String? studentId,
    ScheduleStatus? status,
    DateTimeRange? dateRange,
  }) async {
    final current = state;
    final allSchedules = current is ScheduleLoaded
        ? current.allSchedules
        : <ScheduleModel>[];

    try {
      final filtered = await _repository.getSchedules(
        instructorId: instructorId,
        studentId: studentId,
        status: status,
        dateRange: dateRange,
      );
      emit(
        ScheduleState.loaded(
          allSchedules: allSchedules,
          filtered: filtered,
          instructorId: instructorId,
          studentId: studentId,
          status: status,
          dateRange: dateRange,
        ),
      );
    } catch (e) {
      emit(ScheduleState.error(e.toString()));
    }
  }

  Future<List<ScheduleInstructorOption>> getInstructors() =>
      _repository.getInstructors();

  Future<List<ScheduleStudentOption>> getStudents() =>
      _repository.getStudents();
}
