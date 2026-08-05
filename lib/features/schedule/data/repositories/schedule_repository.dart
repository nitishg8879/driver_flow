import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../utils/constants/app_enums.dart';
import '../models/schedule_model.dart';

abstract class ScheduleRepository {
  Future<List<ScheduleModel>> getSchedules({
    String? instructorId,
    String? studentId,
    ScheduleStatus? status,
    DateTimeRange? dateRange,
  });
}

class ScheduleRepositoryImpl implements ScheduleRepository {
  static final _now = DateTime.now();

  static DateTime _dt(int daysOffset, int hour, int minute) {
    final d = _now.add(Duration(days: daysOffset));
    return DateTime(d.year, d.month, d.day, hour, minute);
  }

  static final _mockSchedules = [
    ScheduleModel(
      id: 's1',
      studentId: 'st1',
      studentName: 'James Doe',
      instructorId: 'i1',
      vehicleId: 'v1',
      startTime: _dt(0, 9, 0),
      endTime: _dt(0, 11, 0),
      status: ScheduleStatus.scheduled,
    ),
    ScheduleModel(
      id: 's2',
      studentId: 'st2',
      studentName: 'Alice Smith',
      instructorId: 'i2',
      vehicleId: 'v2',
      startTime: _dt(0, 13, 30),
      endTime: _dt(0, 15, 30),
      status: ScheduleStatus.scheduled,
    ),
    ScheduleModel(
      id: 's3',
      studentId: 'st3',
      studentName: 'Emma Watson',
      instructorId: 'i3',
      vehicleId: 'v3',
      startTime: _dt(-1, 10, 0),
      endTime: _dt(-1, 12, 0),
      status: ScheduleStatus.cancelledByStudent,
    ),
    ScheduleModel(
      id: 's4',
      studentId: 'st4',
      studentName: 'Liam Neeson',
      instructorId: 'i1',
      vehicleId: 'v1',
      startTime: _dt(1, 14, 0),
      endTime: _dt(1, 16, 0),
      status: ScheduleStatus.scheduled,
    ),
    ScheduleModel(
      id: 's5',
      studentId: 'st5',
      studentName: 'Nina Patel',
      instructorId: 'i2',
      vehicleId: 'v2',
      startTime: _dt(2, 9, 0),
      endTime: _dt(2, 11, 0),
      status: ScheduleStatus.completed,
    ),
    ScheduleModel(
      id: 's6',
      studentId: 'st6',
      studentName: 'Carlos Rivera',
      instructorId: 'i3',
      vehicleId: 'v3',
      startTime: _dt(3, 11, 0),
      endTime: _dt(3, 13, 0),
      status: ScheduleStatus.scheduled,
    ),
    ScheduleModel(
      id: 's7',
      studentId: 'st7',
      studentName: 'Priya Mehta',
      instructorId: 'i1',
      vehicleId: 'v4',
      startTime: _dt(5, 8, 0),
      endTime: _dt(5, 10, 0),
      status: ScheduleStatus.adminCancelled,
    ),
    ScheduleModel(
      id: 's8',
      studentId: 'st2',
      studentName: 'Alice Smith',
      instructorId: 'i2',

      vehicleId: 'v2',

      startTime: _dt(6, 15, 0),
      endTime: _dt(6, 17, 0),
      status: ScheduleStatus.completed,
    ),
    ScheduleModel(
      id: 's9',
      studentId: 'st8',
      studentName: 'Tom Bradley',

      instructorId: 'i3',

      vehicleId: 'v1',

      startTime: _dt(7, 9, 30),
      endTime: _dt(7, 11, 30),
      status: ScheduleStatus.scheduled,
    ),
    ScheduleModel(
      id: 's10',
      studentId: 'st1',
      studentName: 'James Doe',
      instructorId: 'i2',

      vehicleId: 'v3',

      startTime: _dt(8, 14, 0),
      endTime: _dt(8, 16, 0),
      status: ScheduleStatus.cancelledByInstructor,
    ),
  ];

  @override
  Future<List<ScheduleModel>> getSchedules({
    String? instructorId,
    String? studentId,
    ScheduleStatus? status,
    DateTimeRange? dateRange,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockSchedules.where((s) {
      if (instructorId != null && s.instructorId != instructorId) return false;
      if (studentId != null && s.studentId != studentId) return false;
      if (status != null && s.status != status) return false;
      if (dateRange != null && s.startTime != null) {
        final start = DateTime(dateRange.start.year, dateRange.start.month, dateRange.start.day);
        final end = DateTime(dateRange.end.year, dateRange.end.month, dateRange.end.day, 23, 59, 59);
        if (s.startTime!.isBefore(start) || s.startTime!.isAfter(end)) return false;
      }
      return true;
    }).toList();
  }
}

final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  return ScheduleRepositoryImpl();
});
